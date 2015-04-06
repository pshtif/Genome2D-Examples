package test;

import com.genome2d.context.filters.GDesaturateFilter;
import com.genome2d.context.filters.GPixelateFilter;
import com.genome2d.geom.GCurve;
import com.genome2d.particles.GParticlePool;
import com.genome2d.components.renderable.particles.GParticleSystem;
import com.genome2d.node.GNode;
import com.genome2d.macros.MGProfiler;
import com.genome2d.debug.IGDebuggable;
import com.genome2d.postprocess.GPostProcess;
import com.genome2d.postprocess.GHDRPP;
import com.genome2d.geom.GFloat4;
import com.genome2d.macros.MGDebug;
import com.genome2d.debug.GDebug;
import fbx.FbxParser;
import fbx.FbxNode;
import com.genome2d.context.filters.GDisplacementFilter;
import com.genome2d.textures.GTextureFilteringType;
import com.genome2d.postprocess.GBloomPP;
import com.genome2d.geom.GRectangle;
import flash.Vector;
import fbx.GFbxScene;
import com.genome2d.signals.GMouseSignal;
import flash.events.Event;
import flash.net.URLRequest;
import flash.net.URLLoader;
import com.genome2d.signals.GKeyboardSignal;
import com.genome2d.signals.GKeyboardSignalType;
import com.genome2d.signals.GMouseSignalType;
import com.genome2d.signals.GMouseSignal;
import com.genome2d.context.GBlendMode;
import flash.geom.Vector3D;
import com.genome2d.geom.GMatrix3D;
import flash.display.BitmapData;
import com.genome2d.textures.GTextureManager;
import com.genome2d.context.IContext;
import com.genome2d.assets.GAsset;
import com.genome2d.textures.GTexture;
import com.genome2d.Genome2D;
import com.genome2d.context.GContextConfig;
import com.genome2d.assets.GAssetManager;

class ShowcaseFbx {

    static public function main() {
        var inst = new ShowcaseFbx();
    }

    private var _genome:Genome2D;

    private var _fbxModel:GFbxScene;

    private var _renderWater:Bool = false;
    private var _renderBackground:Bool = false;
    private var _applyDisplacement:Bool = false;
    private var _displacement:GDisplacementFilter;
    private var _postProcess:GPostProcess;
    private var _renderPass:Int = 1;

    private var _lightRotationX:Float = 0;
    private var _lightRotationZ:Float = 0;
    private var _lightMatrix:GMatrix3D;

    private var _modelScale:Float = 1.5;
    private var _modelRotation:Float = 0;

    private var _cameraMatrix:GMatrix3D;
    private var _reflectionMatrix:GMatrix3D;

    private var _omx:Float = 0;
    private var _omy:Float = 0;

    public function new() {
        initGenome();
    }

    private function initGenome():Void {
        MGDebug.DUMP();

        _cameraMatrix = new GMatrix3D();
        _cameraMatrix.appendRotation(135,Vector3D.X_AXIS);
        _cameraMatrix.appendTranslation(512,512,400);

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
        GAssetManager.addFromUrl("fire.png");
        GAssetManager.addFromUrl("fire.xml");
        GAssetManager.addFromUrl("water.png");
        GAssetManager.addFromUrl("logo.png");
        GAssetManager.addFromUrl("floor2.png");
        GAssetManager.addFromUrl("skel_base_col.png");
        GAssetManager.addFromUrl("skel_warrior1.png");
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

        loadFBX("test.fbx");
    }

    private function createDisplacement():Void {
        var perlinData:BitmapData = new BitmapData(256, 256, false);
        perlinData.perlinNoise(10, 2, 2, 5, true, true, 0, true);
        GTextureManager.createTextureFromBitmapData("map",perlinData,1,true);

        _displacement = new GDisplacementFilter();
        _displacement.displacementMap = GTextureManager.getTextureById("map");
        _displacement.alphaMap = GTextureManager.getTextureById("water.png");
    }

    private function loadFBX(p_url:String):Void {
        var loader:URLLoader = new URLLoader();
        loader.addEventListener(Event.COMPLETE, fbxLoadComplete_handler);
        loader.load(new URLRequest(p_url));
    }

    private function fbxLoadComplete_handler(event:Event):Void {
        MGDebug.DUMP();

        var fbxNode:FbxNode = FbxParser.parse(event.target.data);
        _fbxModel = new GFbxScene();
        _fbxModel.init(fbxNode);
        _fbxModel.ambientColor = new GFloat4(.5,.5,.5,1);
        _fbxModel.lightColor = new GFloat4(1,.75,.5,1);

        initExample();
    }

    private function initExample():Void {
        MGDebug.DUMP();

        _genome.getContext().setBackgroundColor(0x0,1);
        _genome.getContext().onKeyboardSignal.add(key_handler);
        _genome.getContext().onMouseSignal.add(mouse_handler);
        _genome.onPostRender.add(postRender_handler);
    }

    private function renderModel(p_x:Float, p_y:Float, p_rotation:Float, p_renderType:Int):Void {
        _fbxModel.getModelMatrix().identity();
        _fbxModel.getModelMatrix().appendScale(_modelScale, _modelScale, _modelScale);
        _fbxModel.getModelMatrix().appendRotation(p_rotation, Vector3D.Z_AXIS);
        _fbxModel.getModelMatrix().appendTranslation(p_x,-p_y,0);

        _fbxModel.render((p_renderType==2) ? _reflectionMatrix : _cameraMatrix, p_renderType);
    }

    private function postRender_handler():Void {
        var context:IContext = _genome.getContext();

        var r:Float = _fbxModel.ambientColor.x+_fbxModel.lightColor.x/2;
        var g:Float = _fbxModel.ambientColor.y+_fbxModel.lightColor.y/2;
        var b:Float = _fbxModel.ambientColor.z+_fbxModel.lightColor.z/2;

        // Update light direction
        _lightMatrix.identity();
        //_lightMatrix.appendRotation(_lightRotationX, Vector3D.X_AXIS);
        _lightMatrix.appendRotation(_lightRotationZ, Vector3D.Z_AXIS);
        _lightRotationX = _lightRotationZ = 0;
        _fbxModel.lightDirection = _lightMatrix.transformVector(_fbxModel.lightDirection);

        // Render reflections
        if (_renderPass==0 || _renderPass == 2) {
            context.setRenderTarget(GTextureManager.getTextureById("reflectionTarget"));
            renderModel(0, 0, _modelRotation, 2);
        }
        // Render shadows
        if (_renderPass==0 || _renderPass == 3) {
            context.setRenderTarget(GTextureManager.getTextureById("shadowTarget"));
            renderModel(0, 0, _modelRotation, 3);
        }

        // Render water
        context.setRenderTarget(GTextureManager.getTextureById("waterCompositionTarget"));
        //_postProcess.render(GTextureManager.getTextureById("water.png"),512,512);
        context.draw(GTextureManager.getTextureById("water.png"),512,512,1,1,0,r,g,b,1,GBlendMode.NORMAL);
        if (_renderPass==0 || _renderPass == 2) context.draw(GTextureManager.getTextureById("reflectionTarget"),512,512,1,1,0,r,g,b,.35,GBlendMode.NORMAL);

        context.setRenderTarget(GTextureManager.getTextureById("finalCompositionTarget"));

        if (_renderBackground) {
            context.draw(GTextureManager.getTextureById("floor2.png"),512,512,1,1,0,r,g,b,1,GBlendMode.NORMAL);
            if (_renderWater) {
                if (_applyDisplacement) {
                    context.draw(GTextureManager.getTextureById("waterCompositionTarget"),510,508,1,1,0,1,1,1,1,GBlendMode.NORMAL, _displacement);
                } else {
                    context.draw(GTextureManager.getTextureById("waterCompositionTarget"),512,512,1,1,0,1,1,1,1,GBlendMode.NORMAL, null);
                }
            }
        }

        if (_renderPass==0 || _renderPass == 3) context.draw(GTextureManager.getTextureById("shadowTarget"),512,512,1,1,0,1,1,1,.35,GBlendMode.NORMAL);

        if (_renderPass==0 || _renderPass == 1) renderModel(0, 0, _modelRotation, 1);

        context.setRenderTarget(null);

        //_postProcess.render(GTextureManager.getTextureById("finalCompositionTarget"),400,300);
        context.draw(GTextureManager.getTextureById("finalCompositionTarget"),400,300,1,1,0,1,1,1,1,GBlendMode.NORMAL);

        context.draw(GTextureManager.getTextureById("logo.png"),408,550,1,1,0,1,1,1,1,GBlendMode.NORMAL);
    }

    private function mouse_handler(signal:GMouseSignal):Void {
        if (signal.buttonDown && signal.type == GMouseSignalType.MOUSE_MOVE) {
            if (signal.ctrlKey) {
                _lightRotationX += signal.y-_omy;
                _lightRotationZ -= signal.x-_omx;
            } else {
                _modelRotation -= signal.x-_omx;
            }
            _omx = signal.x;
            _omy = signal.y;
        } else if (signal.type == GMouseSignalType.MOUSE_DOWN) {
            _omx = signal.x;
            _omy = signal.y;
        } else if (signal.type == GMouseSignalType.MOUSE_WHEEL) {
            _modelScale += signal.delta/100;
        }
    }

    private function key_handler(signal:GKeyboardSignal):Void {
        if (signal.type != GKeyboardSignalType.KEY_DOWN) return;

        switch (signal.keyCode) {
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
            case 66:
                _renderBackground = !_renderBackground;
            case 68:
                _applyDisplacement = !_applyDisplacement;
            case 87:
                _renderWater = !_renderWater;
            case 76:
                _fbxModel.lightColor = new GFloat4(Math.random(), Math.random(), Math.random(), 1);
            case 38:
                _fbxModel.ambientColor.x = _fbxModel.ambientColor.y = _fbxModel.ambientColor.z += .02;
            case 40:
                _fbxModel.ambientColor.x = _fbxModel.ambientColor.y = _fbxModel.ambientColor.z -= .02;
            case _:
                //MGDebug.INFO(signal.keyCode);
        }
    }
}
