package test;

import com.genome2d.context.filters.GPixelateFilter;
import com.genome2d.postprocess.GBlurPP;
import com.genome2d.context.stats.GStats;
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
import com.genome2d.macros.MGDebug;
import com.genome2d.macros.MGDebug;
import com.genome2d.macros.MGDebug;
import com.genome2d.macros.MGDebug;
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

class ShowcaseParticles {

    static public function main() {
        var inst = new ShowcaseParticles();
    }

    private var _genome:Genome2D;

    private var _displacement:GDisplacementFilter;
    private var _postProcess:GPostProcess;
    private var _pixelateFilter:GPixelateFilter;

    private var _renderPass:Int = 1;

    private var _particleSystem:GParticleSystem;
    private var _particleAffector:ParticleAffector;
    private var _particleAffectorWind:ParticleAffectorWind;
    private var _particleInitializer:ParticleInitializer;

    private var _omx:Float = 0;
    private var _omy:Float = 0;

    private var _angleAddition:Float = 0;

    public function new() {
        initGenome();
    }

    private function initGenome():Void {
        MGDebug.DUMP();

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
        GAssetManager.addFromUrl("particle.png");
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
        createParticleSystem();

        // Create render targets
        GTextureManager.createRenderTexture("reflectionTarget", 1024, 1024);
        GTextureManager.createRenderTexture("shadowTarget", 1024, 1024);
        GTextureManager.createRenderTexture("waterCompositionTarget", 1024, 1024);
        GTextureManager.createRenderTexture("finalCompositionTarget", 1024, 1024);

        // Create some postprocess to show
        _postProcess = new GBlurPP(8,8,2);
        _postProcess.setBounds(new GRectangle(0,0,1024,1024));

        _pixelateFilter = new GPixelateFilter(4);

        initExample();
    }

    private function createDisplacement():Void {
        var perlinData:BitmapData = new BitmapData(256, 256, false);
        perlinData.perlinNoise(10, 2, 2, 5, true, true, 0, true);
        GTextureManager.createTextureFromBitmapData("map",perlinData,1,true);

        _displacement = new GDisplacementFilter();
        _displacement.displacementMap = GTextureManager.getTextureById("map");
        _displacement.alphaMap = GTextureManager.getTextureById("water.png");

        //GStats.visible = true;
    }

    private function createParticleSystem():Void {
        _particleSystem = cast GNode.createWithComponent(GParticleSystem);
        // Custom particles
        _particleSystem.particlePool = new GParticlePool(ParticleIso);

        _particleSystem.texture = GTextureManager.getTextureById("particle.png");
        _particleSystem.emission = new GCurve(500);
        _particleSystem.blendMode = GBlendMode.SCREEN;
        _particleSystem.emit = true;
        _particleSystem.node.setPosition(512,512);

        // Initializer
        _particleInitializer = new ParticleInitializer();
        _particleSystem.addInitializer(_particleInitializer);

        // Affector
        _particleAffectorWind = new ParticleAffectorWind();
        _particleAffector = new ParticleAffector();

        //_particleSystem.addAffector(_particleAffectorWind);
        _particleSystem.addAffector(_particleAffector);
        _particleSystem.node.visible = false;
        _particleSystem.timeDilation = .3;
        _genome.root.addChild(_particleSystem.node);
    }

    private function initExample():Void {
        MGDebug.DUMP();

        _genome.getContext().setBackgroundColor(0x0,1);
        _genome.getContext().onKeyboardSignal.add(key_handler);
        _genome.getContext().onMouseSignal.add(mouse_handler);
        _genome.onPostRender.add(postRender_handler);
    }

    private function postRender_handler():Void {
        var context:IContext = _genome.getContext();

        var r:Float = 1;
        var g:Float = .7;
        var b:Float = .5;

        _particleInitializer.angleOffset += Genome2D.getInstance().getCurrentFrameDeltaTime()*_particleSystem.timeDilation*_angleAddition;

        // Render reflections
        if (_renderPass==0 || _renderPass == 2) {
            context.setRenderTarget(GTextureManager.getTextureById("reflectionTarget"));
            ParticleIso.mirror = true;
            _particleSystem.render(context.getActiveCamera(),false);
        }

        // Render water
        context.setRenderTarget(GTextureManager.getTextureById("waterCompositionTarget"));
        context.draw(GTextureManager.getTextureById("water.png"),512,512,1,1,0,r,g,b,1,GBlendMode.NORMAL);
        if (_renderPass==0 || _renderPass == 2) context.draw(GTextureManager.getTextureById("reflectionTarget"),512,512,1,1,0,r,g,b,.35,GBlendMode.NORMAL);
        context.setRenderTarget(GTextureManager.getTextureById("finalCompositionTarget"));

        context.draw(GTextureManager.getTextureById("floor2.png"),512,512,1,1,0,r,g,b,1,GBlendMode.NORMAL);
        if (_renderPass==0 || _renderPass == 2) context.draw(GTextureManager.getTextureById("waterCompositionTarget"),510,508,1,1,0,1,1,1,1,GBlendMode.NORMAL, _displacement);

        if (_renderPass==0 || _renderPass == 1) {
            ParticleIso.mirror = false;
            _particleSystem.render(context.getActiveCamera(),false);
        }

        context.setRenderTarget(null);

        //_postProcess.render(GTextureManager.getTextureById("finalCompositionTarget"),400,300);
        context.draw(GTextureManager.getTextureById("finalCompositionTarget"),400,300,1,1,0,1,1,1,1,GBlendMode.NORMAL);

        context.draw(GTextureManager.getTextureById("logo.png"),408,550,1,1,0,1,1,1,1,GBlendMode.NORMAL);
    }

    private function mouse_handler(signal:GMouseSignal):Void {
        _particleAffectorWind.mx = signal.x;
        _particleAffectorWind.my = signal.y;
        if (signal.buttonDown && signal.type == GMouseSignalType.MOUSE_MOVE) {
            if (signal.ctrlKey) {
                _particleInitializer.angleOffset += (signal.x-_omx)/100;
            } else {
                _particleAffector.rotation += (signal.x-_omx)/100;
            }
            _omx = signal.x;
            _omy = signal.y;
        } else if (signal.type == GMouseSignalType.MOUSE_DOWN) {
            _particleAffectorWind.enabled = true;
            _omx = signal.x;
            _omy = signal.y;
        } else if (signal.type == GMouseSignalType.MOUSE_UP) {
            _particleAffectorWind.enabled = false;
        } else if (signal.type == GMouseSignalType.MOUSE_WHEEL) {
            _particleSystem.timeDilation += signal.delta/100;
        }
    }

    private function key_handler(signal:GKeyboardSignal):Void {
        if (signal.type != GKeyboardSignalType.KEY_DOWN) return;

        switch (signal.keyCode) {
            case 32:
                _particleAffector.pause = !_particleAffector.pause;
                _particleAffectorWind.pause = !_particleAffectorWind.pause;
                _particleSystem.emit = !_particleSystem.emit;
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
            case 39:
                _angleAddition += .0001;
            case 37:
                _angleAddition -= .0001;
            case _:
                MGDebug.INFO(signal.keyCode);
        }
    }
}
