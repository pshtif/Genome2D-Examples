package examples.advanced;
import com.genome2d.components.renderables.particles.GSimpleParticleSystem;
import com.genome2d.assets.GXmlAsset;
import com.genome2d.geom.GRectangle;
import com.genome2d.signals.GNodeMouseSignal;
import com.genome2d.components.GCameraController;
import com.genome2d.components.renderables.GMovieClip;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.textures.factories.GTextureAtlasFactory;
import com.genome2d.textures.factories.GTextureFactory;
import com.genome2d.Genome2D;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.context.GContextConfig;
import com.genome2d.assets.GImageAsset;
import com.genome2d.textures.GTextureAtlas;
import com.genome2d.textures.GTexture;
import com.genome2d.assets.GAssetManager;
class Example5Cameras {
    static function main() {
        var inst = new Example5Cameras();
    }

    private var assetManager:GAssetManager;
    private var genome:Genome2D;

    public function new() {
        initAssets();
    }

    private function initAssets():Void {
        trace("initAssets");
        assetManager = new GAssetManager();
        assetManager.add(new GImageAsset("texture_gfx", "textures.jpg"));
        assetManager.add(new GXmlAsset("atlas_xml", "atlas.xml"));
        assetManager.add(new GImageAsset("atlas_gfx", "atlas.png"));
        assetManager.onLoaded.add(assetsInitializedHandler);
        assetManager.load();
    }

    private function assetsInitializedHandler():Void {
        trace("assetsInitializedHandler");
        var contextConfig:GContextConfig = new GContextConfig(new GRectangle(0,0,800,600));

        genome = Genome2D.getInstance();
        genome.onInitialized.add(genomeInitializedHandler);
        genome.init(contextConfig);
    }

    private function genomeInitializedHandler():Void {
        trace("genomeInitializedHandler");

        GTextureFactory.createFromAsset("textures", cast assetManager.getAssetById("texture_gfx"));
        GTextureAtlasFactory.createFromAssets("atlas", cast assetManager.getAssetById("atlas_gfx"), cast assetManager.getAssetById("atlas_xml"));

        for (i in 0...50) {
            //createSprite(300+Math.random()*200, 200+Math.random()*200, "assets_g100");
            //createSprite(400, 300, "assets_g100");
        }
        createSimpleParticleSystem();

        var camera:GCameraController = cast GNodeFactory.createNodeWithComponent(GCameraController);
        camera.setView(0,0,.5,1);
        //camera.zoom = .5;
        camera.node.transform.setPosition(400,300);
        camera.node.transform.rotation = 0.753;
        genome.root.addChild(camera.node);

        camera = cast GNodeFactory.createNodeWithComponent(GCameraController);
        camera.setView(.5,0,.5,1);
        camera.zoom = .5;
        camera.node.transform.setPosition(400,300);
        genome.root.addChild(camera.node);
    }

    private function createSimpleParticleSystem():Void {
        var emitter:GSimpleParticleSystem = cast GNodeFactory.createNodeWithComponent(GSimpleParticleSystem);
        emitter.textureId = "atlas_g100";
        emitter.emission = 10;
        emitter.emit = true;
        emitter.dispersionAngleVariance = Math.PI*2;
        emitter.energy = 1;
        emitter.initialVelocity = 50;
        emitter.initialVelocityVariance = 100;
        emitter.initialAngleVariance = 5;
        emitter.endAlpha = 0;
        emitter.endScale = .2;
        emitter.node.transform.setPosition(400,300);
        Genome2D.getInstance().root.addChild(emitter.node);
    }

    private function createSprite(p_x:Float, p_y:Float, p_textureId:String):GSprite {
        var sprite:GSprite = cast GNodeFactory.createNodeWithComponent(GSprite);
        sprite.texture = GTexture.getTextureById(p_textureId);
        sprite.node.transform.setPosition(p_x, p_y);
        Genome2D.getInstance().root.addChild(sprite.node);
        return sprite;
    }

    private function createMovieClip(p_x:Float, p_y:Float, p_frames:Array<String>):Void {
        var clip:GMovieClip = cast GNodeFactory.createNodeWithComponent(GMovieClip);
        clip.frameTextureIds = p_frames;
        clip.node.transform.setPosition(p_x, p_y);
        Genome2D.getInstance().root.addChild(clip.node);
    }

    private function mouseOverHandler(signal:GNodeMouseSignal):Void {
        trace("over");
    }
}
