package test;

import com.genome2d.textures.GTextureFilteringType;
import com.genome2d.postprocess.GBloomPP;
import com.genome2d.context.filters.GPixelateFilter;
import com.genome2d.geom.GRectangle;
import com.genome2d.context.filters.GBloomPassFilter;
import com.genome2d.postprocess.GHDRPP;
import haxe.ds.HashMap;
import flash.utils.Dictionary;
import flash.Vector;
import com.genome2d.context.filters.GDesaturateFilter;
import com.genome2d.components.renderable.GSprite;
import com.genome2d.geom.GVector2;
import test.fbx.GFBXImporter;
import hxd.fmt.fbx.FbxTools;
import flash.events.MouseEvent;
import com.genome2d.signals.GMouseSignal;
import hxd.fmt.fbx.FbxNode;
import hxd.fmt.fbx.FbxTools;
import flash.events.Event;
import flash.net.URLRequest;
import flash.net.URLLoader;
import hxd.fmt.fbx.Parser;
import com.genome2d.tilemap.GTile;
import com.genome2d.signals.GKeyboardSignal;
import com.genome2d.signals.GKeyboardSignalType;
import com.genome2d.signals.GMouseSignalType;
import com.genome2d.signals.GMouseSignal;
import com.genome2d.context.GBlendMode;
import com.genome2d.tilemap.GTile;
import com.genome2d.components.renderable.tilemap.GTileMap;
import flash.geom.Vector3D;
import com.genome2d.geom.GMatrix3D;
import flash.display.BitmapData;
import com.genome2d.textures.GTextureManager;
import com.genome2d.context.IContext;
import com.genome2d.context.stage3d.renderers.GCustomRenderer;
import Xml;
import com.genome2d.ui.layout.GUIHorizontalLayout;
import com.genome2d.ui.layout.GUIVerticalLayout;
import com.genome2d.ui.layout.GUILayoutType;
import com.genome2d.components.renderable.ui.GUI;
import com.genome2d.ui.layout.GUILayout;
import com.genome2d.ui.skin.GUIFontSkin;
import com.genome2d.ui.skin.GUITextureSkin;
import com.genome2d.components.GCameraController;
import com.genome2d.signals.GUIMouseSignal;
import com.genome2d.assets.GAsset;
import flash.Lib;
import com.genome2d.ui.skin.GUISkin;
import com.genome2d.ui.element.GUIElement;
import Xml;
import com.genome2d.proto.GPrototypeFactory;
import com.genome2d.proto.IGPrototypable;
import com.genome2d.textures.GTexture;
import com.genome2d.context.stats.GStats;
import com.genome2d.Genome2D;
import com.genome2d.Genome2D;
import com.genome2d.node.GNode;
import com.genome2d.Genome2D;
import com.genome2d.context.GContextConfig;
import com.genome2d.assets.GAssetManager;

class Showcase {

    static public function main() {
        var inst = new Showcase();
    }

    private var genome:Genome2D;
    private var cameraRotationX:Float = 0;
    private var cameraRotationY:Float = 0;
    private var lightRotationX:Float = 0;
    private var lightRotationY:Float = 0;
    private var lightMatrix:GMatrix3D;
    private var displacement:GDisplacementFilter;
    static public var lightVector:Vector3D;
    private var _modelId:Int = 0;
    private var _hdrPostProcess:GBloomPP;

    private var _cameraMatrix:GMatrix3D;
    private var _reflectionMatrix:GMatrix3D;

    private var _shipModelIds:Array<String> = ["test.fbx"];

    private var _fbxModels:Map<String,GFBXImporter>;
    private var _fbxLoading:String;
    private var _fbxQueue:Array<String>;

    public function new() {
        initGenome();
    }

    private function initGenome():Void {
        trace("initGenome");

        _cameraMatrix = new GMatrix3D();
        _cameraMatrix.appendRotation(135,Vector3D.X_AXIS);
        _cameraMatrix.appendTranslation(512,512,400);

        _reflectionMatrix = _cameraMatrix.clone();
        _reflectionMatrix.prependScale(1,1,-1);
        //cameraMatrix.rawData = Vector.ofArray([-0.6418397426605225,-0.5560987591743469,0.5280225276947021,0,-0.7578688859939575,0.5650461316108704,-0.32614144682884216,0,-0.11698978394269943,-0.6094995141029358,-0.7841157913208008,0,0,0,0,1]);
        lightMatrix = new GMatrix3D();

        var config:GContextConfig = new GContextConfig();
        config.enableDepthAndStencil = true;
        config.antiAliasing = 16;

        genome = Genome2D.getInstance();
        genome.onInitialized.add(genomeInitializedHandler);
        genome.init(config);
    }

    private function genomeInitializedHandler():Void {
        trace("genomeInitializedHandler");

        //GStats.visible = true;
        _fbxModels = new Map<String, GFBXImporter>();
        _hdrPostProcess = new GBloomPP();
        _hdrPostProcess.setBounds(new GRectangle(0,0,1024,1024));

        initAssets();
    }

    private function initAssets():Void {
        trace("initAssets");

        GAssetManager.init();
        GAssetManager.addFromUrl("water.png");
        GAssetManager.addFromUrl("test_box_dif.png");
        GAssetManager.addFromUrl("logo.png");
        GAssetManager.addFromUrl("voda_test_fixed6.png");
        GAssetManager.addFromUrl("floor2.png");
        GAssetManager.addFromUrl("skel_base_col.png");
        GAssetManager.addFromUrl("skel_warrior1.png");
        GAssetManager.onQueueFailed.add(assetsFailedHandler);
        GAssetManager.onQueueLoaded.addOnce(assetsInitializedHandler);
        GAssetManager.loadQueue();
    }

    private function assetsFailedHandler(p_asset:GAsset):Void {
        trace(p_asset.url);
    }

    private function assetsInitializedHandler():Void {
        trace("assetsInitializedHandler");
        GTextureManager.defaultFilteringType = GTextureFilteringType.LINEAR;
        GAssetManager.generateTextures();

        GTextureManager.createRenderTexture("reflectionTarget", 1024, 1024);
        GTextureManager.createRenderTexture("shadowTarget", 1024, 1024);
        GTextureManager.createRenderTexture("waterTarget", 1024, 1024);
        GTextureManager.createRenderTexture("finalTarget", 1024, 1024);

        var scale:Int = 1;
        var width:Int = 256;
        var height:Int = 256;
        var perlinData:BitmapData = new BitmapData(width * scale, height * scale, false);
        perlinData.perlinNoise(10*scale, 2*scale, 2, 5, true, true, 0, true);
        GTextureManager.createTextureFromBitmapData("map",perlinData,1,true);

        displacement = new GDisplacementFilter();
        displacement.displacementMap = GTextureManager.getTextureById("map");
        displacement.alphaMap = GTextureManager.getTextureById("water.png");

        _fbxQueue = ["test.fbx"];
        loadFBX(_fbxQueue.shift());
    }

    private function loadFBX(p_url:String):Void {
        _fbxLoading = p_url;
        var loader:URLLoader = new URLLoader();
        loader.addEventListener(Event.COMPLETE, fbxLoadCompleteHandler);
        loader.load(new URLRequest(p_url));
    }

    private function fbxLoadCompleteHandler(event:Event):Void {
        //trace(event.target.data);
        var fbxNode:FbxNode = Parser.parse(event.target.data);
        var fbxImporter:GFBXImporter = new GFBXImporter();
        fbxImporter.init(fbxNode);
        _fbxModels.set(_fbxLoading,fbxImporter);
        if (_fbxQueue.length>0) {
            loadFBX(_fbxQueue.shift());
        } else {
            initExample();
        }
    }

    public function test(signal:GUIMouseSignal):Void {
        trace("here");
    }

    private var renderers:Array<GCustomRenderer>;
    private var texture:GTexture;

    private function initExample():Void {
        trace("initExample");

        genome.getContext().setBackgroundColor(0x0,1);
        genome.getContext().onKeyboardSignal.add(keyHandler);
        genome.getContext().onMouseSignal.add(mouseHandler);
        genome.onPostRender.add(postRenderHandler);
    }

    private var omx:Float = 0;
    private var omy:Float = 0;
    private var shipX:Float = 0;
    private var shipY:Float = 0;

    private function mouseHandler(signal:GMouseSignal):Void {
        if (signal.buttonDown && signal.type == GMouseSignalType.MOUSE_MOVE) {
            if (signal.ctrlKey) {
                lightRotationY -= signal.x-omx;
                //lightRotationX += signal.y-omy;
            } else if (signal.shiftKey) {
                shipX = signal.x-512;
                shipY = signal.y-512;
            } else {
                rotation -= signal.x-omx;
            }
            omx = signal.x;
            omy = signal.y;
        } else if (signal.type == GMouseSignalType.MOUSE_DOWN) {
            omx = signal.x;
            omy = signal.y;
        } else if (signal.type == GMouseSignalType.MOUSE_WHEEL) {
            //fbxLod.scale+=signal.delta/100;
        }
    }

    private var renderPass:Int = 0;

    private function keyHandler(signal:GKeyboardSignal):Void {
        if (signal.type != GKeyboardSignalType.KEY_DOWN) return;

        switch (signal.keyCode) {
            case 48:
                renderPass = 0;
            case 49:
                renderPass = 1;
            case 50:
                renderPass = 2;
            case 51:
                renderPass = 3;
            case 52:
                renderPass = 4;
            case 53:
                renderPass = 5;
            case 67:
                _modelId++;
            case 65: // A
                rotation-=1;
            case 68: // D
                rotation+=1;
            case 87: // W
            case 83: // S
            case 32:
                trace(_cameraMatrix.rawData);
            case _:
                //trace(signal.keyCode);
        }
    }
    private var rotation:Float = 0;

    static public var updatedLight:Vector3D;
    static public var ambientLightRed:Float = .2;
    static public var ambientLightGreen:Float = .2;
    static public var ambientLightBlue:Float = .2;
    private var g2d_waveX:Float = 1.01;
    private var g2d_waveY:Float = .01;

    private function postRenderHandler():Void {
        var context:IContext = genome.getContext();

        _cameraMatrix.appendRotation(cameraRotationX, Vector3D.X_AXIS);
        _cameraMatrix.appendRotation(cameraRotationY, Vector3D.Y_AXIS);
        cameraRotationX = cameraRotationY = 0;

        lightMatrix.appendRotation(lightRotationX, Vector3D.X_AXIS);
        lightMatrix.appendRotation(lightRotationY, Vector3D.Z_AXIS);
        //lightMatrix.appendTranslation(200,0,0);
        lightRotationX = lightRotationY = 0;

        //if (lightVector == null) lightVector = new Vector3D(0.3746070861816406, -0.9271845817565918, 1);//-1,1,1);
        if (lightVector == null) lightVector = new Vector3D(-1,1,1);
        updatedLight = lightMatrix.transformVector(lightVector);

        g2d_waveX+=.01;
        g2d_waveY+=.02;
        //ambientLightRed = ambientLightGreen = ambientLightBlue = .35;

        /**/
        // Render reflections
        if (renderPass==0 || renderPass == 2) {
            context.setRenderTarget(GTextureManager.getTextureById("reflectionTarget"));
            renderLod(0, 0, 0, rotation, 2);
        }
        // Render shadows
        if (renderPass==0 || renderPass == 3) {
            context.setRenderTarget(GTextureManager.getTextureById("shadowTarget"));
            renderLod(0, 0, 0, rotation, 3);
        }
        context.setRenderTarget(GTextureManager.getTextureById("waterTarget"));
        context.draw(GTextureManager.getTextureById("water.png"),512,512,1,1,0,1,1,1,1,GBlendMode.NORMAL);
        if (renderPass==0 || renderPass == 2) context.draw(GTextureManager.getTextureById("reflectionTarget"),512,512,1,1,0,1,1,1,.35,GBlendMode.NORMAL);
        //if (renderPass==0 || renderPass == 3) context.draw(GTextureManager.getTextureById("shadowTarget"),512,512,1,1,0,1,1,1,.15,GBlendMode.NORMAL);
        context.setRenderTarget(GTextureManager.getTextureById("finalTarget"));

        context.draw(GTextureManager.getTextureById("floor2.png"),512,512,1,1,0,1,1,1,1,GBlendMode.NORMAL);
        context.draw(GTextureManager.getTextureById("waterTarget"),512,512,1,1,0,1,1,1,1,GBlendMode.NORMAL,displacement);
        if (renderPass==0 || renderPass == 3) context.draw(GTextureManager.getTextureById("shadowTarget"),512,512,1,1,0,1,1,1,.35,GBlendMode.NORMAL);
        //context.draw(GTextureManager.getTextureById("light3.png",512,512,1,1,0,1,1,1,1,GBlendMode.NORMAL);
        /**/
        if (renderPass==0 || renderPass == 1) renderLod(0, 0, 0, rotation, 1);
        /**/
        context.setRenderTarget(null);

        //_hdrPostProcess.render(GTextureManager.getTextureById("finalTarget"),512,512);
        context.draw(GTextureManager.getTextureById("finalTarget"),400,300,1,1,0,1,1,1,1,GBlendMode.NORMAL);

        context.draw(GTextureManager.getTextureById("logo.png"),408,550,1,1,0,1,1,1,1,GBlendMode.NORMAL);
    }

    private function renderLod(p_modelIndex:Float, p_x:Float, p_y:Float, p_rotation:Float, p_renderType:Int):Void {
        var modelId:String = _shipModelIds[Std.int(p_modelIndex)];

        var model:GFBXImporter = _fbxModels.get(modelId);
        model.getModelMatrix().identity();
        model.getModelMatrix().appendScale(1.5,1.5,1.5);
        model.getModelMatrix().appendRotation(p_rotation, Vector3D.Z_AXIS);
        model.getModelMatrix().appendTranslation(p_x,-p_y,0);

        model.render((p_renderType==2)?_reflectionMatrix:_cameraMatrix, p_renderType);
    }
}
