package examples.advanced;

import com.genome2d.assets.GAsset;
import com.genome2d.assets.GAssetManager;
import com.genome2d.context.filters.GDisplacementFilter;
import com.genome2d.context.GBlendMode;
import com.genome2d.context.GContextConfig;
import com.genome2d.context.IGContext;
import com.genome2d.context.stage3d.renderers.GFbxRenderer;
import com.genome2d.fbx.GFbxNode;
import com.genome2d.fbx.GFbxParser;
import com.genome2d.fbx.GFbxParserNode;
import com.genome2d.fbx.GFbxScene;
import com.genome2d.Genome2D;
import com.genome2d.geom.GFloat4;
import com.genome2d.geom.GMatrix3D;
import com.genome2d.geom.GRectangle;
import com.genome2d.input.GKeyboardInput;
import com.genome2d.input.GKeyboardInputType;
import com.genome2d.input.GMouseInput;
import com.genome2d.input.GMouseInputType;
import com.genome2d.macros.MGDebug;
import com.genome2d.postprocess.GBloomPP;
import com.genome2d.postprocess.GPostProcess;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureManager;
import com.genome2d.ui.element.GUIElement;
import flash.display.BitmapData;
import flash.events.Event;
import flash.geom.Matrix3D;
import flash.geom.Point;
import flash.geom.Vector3D;
import flash.net.URLLoader;
import flash.net.URLRequest;

class FbxExample {

    static public function main() {
        var inst = new FbxExample();
    }
	
	inline public static var CAMERA_ANGLE:Int = 120;
    public static var COMPENSATION_FACTOR:Float = Math.cos((180 - CAMERA_ANGLE) / 180 * Math.PI);

    private var _genome:Genome2D;

    private var _fbxScene:GFbxScene;

    private var _renderWater:Bool = true;
    private var _renderBackground:Bool = false;
	private var _renderNoise:Bool = false;
    private var _applyDisplacement:Bool = false;
    private var _displacement:WaterFilter;
    private var _postProcess:GPostProcess;
    private var _renderPass:Int = 1;

    private var _lightRotationX:Float = 0;
    private var _lightRotationZ:Float = 0;
    private var _lightMatrix:GMatrix3D;

    private var _modelScale:Float = .1;
    private var _modelRotation:Float = 0;

    private var _cameraMatrix:GMatrix3D;
    private var _reflectionMatrix:GMatrix3D;

    private var _omx:Float = 0;
    private var _omy:Float = 0;

    public function new() {
        initGenome();
    }
	
	private var _cameraX:Float = 0;
	private var _cameraScale:Float = 1;

    private function initGenome():Void {
        MGDebug.DUMP();

		trace(Std.parseInt("0x5b"));
		
        _cameraMatrix = new GMatrix3D();
        _cameraMatrix.appendRotation(CAMERA_ANGLE,Vector3D.X_AXIS);
        _cameraMatrix.appendTranslation(_cameraX, 0, 400);
		_cameraMatrix.appendScale(_cameraScale,_cameraScale,1);

        _reflectionMatrix = _cameraMatrix.clone();
        _reflectionMatrix.prependScale(1,1,-1);
        _lightMatrix = new GMatrix3D();

        var config:GContextConfig = new GContextConfig();
        config.enableDepthAndStencil = true;
        config.antiAliasing = 16;

        _genome = Genome2D.getInstance();
        _genome.onInitialized.add(genomeInitializedHandler);
        _genome.init(config);
    }

    private function genomeInitializedHandler():Void {
        MGDebug.DUMP();

        initAssets();
    }

    inline private function initAssets():Void {
        MGDebug.DUMP();

        GAssetManager.init();
        GAssetManager.addFromUrl("w_1.png");
		GAssetManager.addFromUrl("w_2.png");
		//GAssetManager.addFromUrl("Santa_Maria_Diff.png");
		//GAssetManager.addFromUrl("Santa_Maria_plachty_Diff.png");
        GAssetManager.onQueueFailed.add(assetsFailed_handler);
        GAssetManager.onQueueLoaded.addOnce(assetsInitialized_handler);
        GAssetManager.loadQueue();
    }

    private function assetsFailed_handler(p_asset:GAsset):Void {
        MGDebug.ERROR(p_asset.url);
    }

    private function assetsInitialized_handler():Void {
        MGDebug.DUMP();

        GAssetManager.generateTextures();

        createDisplacement();

        // Create render targets
        GTextureManager.createRenderTexture("reflectionTarget", 1024, 1024);
        GTextureManager.createRenderTexture("shadowTarget", 1024, 1024);
        GTextureManager.createRenderTexture("waterCompositionTarget", 1024, 1024);
        GTextureManager.createRenderTexture("finalCompositionTarget", 1024, 1024);

        // Create some postprocess to show
        _postProcess = new GBloomPP();
        _postProcess.setBounds(new GRectangle(0,0,1024,1024));

        //loadFBX("box.fbx");
		//loadFBX("Santa_Maria_XL.FBX");
		initExample();
    }

	private var perlinData1:BitmapData;
	private var perlinData2:BitmapData;
	private var perlinOffset:Float = 0;
    private function createDisplacement():Void {
        perlinData1 = new BitmapData(256, 256, false);
		perlinData2 = new BitmapData(256, 256, false);
        GTextureManager.createTexture("map1", perlinData1, 1, true);
		GTextureManager.createTexture("map2", perlinData2, 1, true);

        _displacement = new WaterFilter(.04,.02);
        _displacement.displacementMap = GTextureManager.getTexture("w_2");
		_displacement.alphaMap1 = GTextureManager.getTexture("map1");
		_displacement.alphaMap2 = GTextureManager.getTexture("map2");
    }
	
	private function updateDisplacement():Void {
		perlinOffset += .1;
		var texture:GTexture;
		texture = GTextureManager.getTexture("map1");
		perlinData1.perlinNoise(30, 20, 2, 1, true, true, 0, true, [new Point(3*perlinOffset/4, 3*perlinOffset/4),  new Point(-perlinOffset, perlinOffset)]);
		texture.invalidateNativeTexture(false);
		
		texture = GTextureManager.getTexture("map2");
		perlinData2.perlinNoise(30, 20, 2, 10, true, true, 0, true, [new Point(3*perlinOffset/4, 3*perlinOffset/4),  new Point(-perlinOffset, perlinOffset)]);
		texture.invalidateNativeTexture(false);
	}

    private function loadFBX(p_url:String):Void {
        var loader:URLLoader = new URLLoader();
        loader.addEventListener(Event.COMPLETE, fbxLoadComplete_handler);
        loader.load(new URLRequest(p_url));
    }

    private function fbxLoadComplete_handler(event:Event):Void {
        MGDebug.DUMP();

        var fbxNode:GFbxParserNode = GFbxParser.parse(event.target.data);
        _fbxScene = new GFbxScene();
        _fbxScene.init(fbxNode);
        _fbxScene.ambientColor = new GFloat4(.5,.5,.5,1);
        _fbxScene.lightColor = new GFloat4(0, .75, .5, 1);
		
		//_fbxScene.getModelByName("Model::Object002").visible = false;

        initExample();
    }

    private function initExample():Void {
        MGDebug.DUMP();

        _genome.getContext().setBackgroundColor(0x0,1);
        _genome.getContext().onKeyboardInput.add(key_handler);
        _genome.getContext().onMouseInput.add(mouse_handler);
        _genome.onPostRender.add(postRender_handler);
    }

    private function renderScene(p_x:Float, p_y:Float, p_rotation:Float, p_renderType:Int):Void {
        _fbxScene.getModelMatrix().identity();
        _fbxScene.getModelMatrix().appendScale(_modelScale, _modelScale, _modelScale);
        _fbxScene.getModelMatrix().appendRotation(p_rotation, Vector3D.Z_AXIS);
        _fbxScene.getModelMatrix().appendTranslation(p_x,-p_y,0);

        _fbxScene.render((p_renderType==2) ? _reflectionMatrix : _cameraMatrix, p_renderType);
    }

    private function postRender_handler():Void {
        var context:IGContext = _genome.getContext();

        // Update light direction
        _lightMatrix.identity();
        //_lightMatrix.appendRotation(_lightRotationX, Vector3D.X_AXIS);
        _lightMatrix.appendRotation(_lightRotationZ, Vector3D.Z_AXIS);
        _lightRotationX = _lightRotationZ = 0;
        //_fbxScene.lightDirection = _lightMatrix.transformVector(_fbxScene.lightDirection);
		/*
        // Render reflections
        if (_renderPass==0 || _renderPass == 2) {
            context.setRenderTarget(GTextureManager.getTexture("reflectionTarget"));
            renderModel(0, 0, _modelRotation, 2);
        }
        // Render shadows
        if (_renderPass==0 || _renderPass == 3) {
            context.setRenderTarget(GTextureManager.getTexture("shadowTarget"));
            renderModel(0, 0, _modelRotation, 3);
        }

        // Render water
        context.setRenderTarget(GTextureManager.getTexture("waterCompositionTarget"));
        //context.draw(GTextureManager.getTextureById("water.png"),512,512,1,1,0,r,g,b,1,GBlendMode.NORMAL);
        if (_renderPass==0 || _renderPass == 2) context.draw(GTextureManager.getTexture("reflectionTarget"),512,512,1,1,0,r,g,b,.35,GBlendMode.NORMAL);

        context.setRenderTarget(GTextureManager.getTexture("finalCompositionTarget"));

        if (_renderBackground) {
            context.draw(GTextureManager.getTexture("untitled.png"),512,512,1,1,0,r,g,b,1,GBlendMode.NORMAL);
            if (_renderWater) {
                if (_applyDisplacement) {
                    context.draw(GTextureManager.getTexture("waterCompositionTarget"),510,508,1,1,0,1,1,1,1,GBlendMode.NORMAL, _displacement);
                } else {
                    context.draw(GTextureManager.getTexture("waterCompositionTarget"),512,512,1,1,0,1,1,1,1,GBlendMode.NORMAL, null);
                }
            }
        }

        if (_renderPass==0 || _renderPass == 3) context.draw(GTextureManager.getTexture("shadowTarget"),512,512,1,1,0,1,1,1,.35,GBlendMode.NORMAL);
		/**/
		updateDisplacement();
		
		context.draw(GTextureManager.getTexture("w_1"), 400, 300, 1, 1, 0, 1, 1, 1, 1, 1, _displacement);
		
		if (_renderNoise) {
			context.draw(GTextureManager.getTexture("map1"), 128, 128, 1, 1, 0, 1, 1, 1, 1, 1, null);
			
			context.draw(GTextureManager.getTexture("map2"), 512 - 128, 128, 1, 1, 0, 1, 1, 1, 1, 1, null);
		}
		
        //if (_renderPass==0 || _renderPass == 1) renderScene(400, 300, _modelRotation, 1);

        //context.setRenderTarget(null);

        //context.draw(GTextureManager.getTexture("finalCompositionTarget"),400,300,1,1,0,1,1,1,1,GBlendMode.NORMAL);
    }

    private function mouse_handler(input:GMouseInput):Void {
        if (input.buttonDown && input.type == GMouseInputType.MOUSE_MOVE) {
            if (input.ctrlKey) {
                //_lightRotationX += (input.localX-_omy)/100;
                _lightRotationZ -= (input.contextX-_omx);
            } else {
                _modelRotation -= input.localX-_omx;
            }
            _omx = input.localX;
            _omy = input.localY;
        } else if (input.type == GMouseInputType.MOUSE_DOWN) {
			if (input.ctrlKey) {
				trace(input.contextY, input.contextY / COMPENSATION_FACTOR);
				var rayOrigin:Vector3D = new Vector3D((input.contextX/_cameraScale-_cameraX), -input.contextY/_cameraScale / COMPENSATION_FACTOR, 0);
				trace(rayOrigin);
				var rayDirection:Vector3D = new Vector3D(0, 0, 1);
				var matrix:Matrix3D = new Matrix3D();
				matrix.appendRotation(CAMERA_ANGLE, Vector3D.X_AXIS);
				rayDirection = matrix.transformVector(rayDirection);
				rayDirection = rayDirection.add(rayOrigin);
				trace(checkLineAndBox(rayOrigin, rayDirection, new Vector3D( -10, -10, 0), new Vector3D(10, 10, 20), _fbxScene.getModelMatrix(), _modelScale));
			}
            _omx = input.localX;
            _omy = input.localY;
        } else if (input.type == GMouseInputType.MOUSE_WHEEL) {
            _modelScale += input.delta/100;
        }
    }

    private function key_handler(input:GKeyboardInput):Void {
        if (input.type != GKeyboardInputType.KEY_DOWN) return;

        switch (input.keyCode) {
            case 48:
                _renderPass = 0;
            case 49:
                _renderPass = 1;
            case 50:
                _renderPass = 2;
            case 51:
                _renderPass = 3;
            case 52:
                _renderPass = 4;
            case 53:
                _renderPass = 5;
			case 78:
				_renderNoise = !_renderNoise;
            case 66:
                _renderBackground = !_renderBackground;
            case 68:
                _applyDisplacement = !_applyDisplacement;
            case 87:
                _renderWater = !_renderWater;
            case 76:
                _fbxScene.lightColor = new GFloat4(Math.random(), Math.random(), Math.random(), 1);
            case 38:
                _fbxScene.ambientColor.x = _fbxScene.ambientColor.y = _fbxScene.ambientColor.z += .02;
            case 40:
                _fbxScene.ambientColor.x = _fbxScene.ambientColor.y = _fbxScene.ambientColor.z -= .02;
            case _:
                MGDebug.INFO(input.keyCode);
        }
    }
	
	private function checkLineAndBox(p_l1:Vector3D, p_l2:Vector3D, p_bl:Vector3D, p_bh:Vector3D, p_modelMatrix:Matrix3D, p_modelScale:Float):Bool {
        var bext:Vector3D = p_bh.subtract(p_bl);
        bext.scaleBy(0.5);

        var invMatrix:Matrix3D = p_modelMatrix.clone();
        invMatrix.appendTranslation(p_modelScale * (p_bh.x + p_bl.x) * 0.5, p_modelScale * (p_bh.y + p_bl.y) * 0.5, -p_modelScale*(p_bh.z + p_bl.z) * 0.5);
        invMatrix.invert();
        var lb1:Vector3D = invMatrix.transformVector(p_l1);
        var lb2:Vector3D = invMatrix.transformVector(p_l2);

        var lmid:Vector3D = lb1.add(lb2);
        lmid.scaleBy(0.5);
        var l:Vector3D = lb1.subtract(lmid);
        var lext:Vector3D = new Vector3D(Math.abs(l.x), Math.abs(l.y), Math.abs(l.z));

        if ( Math.abs(lmid.y * l.z - lmid.z * l.y)  >  (bext.y * lext.z + bext.z * lext.y) ) return false;
        if ( Math.abs(lmid.x * l.z - lmid.z * l.x)  >  (bext.x * lext.z + bext.z * lext.x) ) return false;
        if ( Math.abs(lmid.x * l.y - lmid.y * l.x)  >  (bext.x * lext.y + bext.y * lext.x) ) return false;

        return true;
    }
}
