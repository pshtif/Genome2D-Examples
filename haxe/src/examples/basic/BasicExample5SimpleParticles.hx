package examples.basic;
import com.genome2d.geom.GRectangle;
import com.genome2d.components.renderables.particles.GSimpleParticleSystem;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.textures.factories.GTextureAtlasFactory;
import com.genome2d.Genome2D;
import com.genome2d.context.GContextConfig;
import com.genome2d.textures.GTextureAtlas;
import com.genome2d.assets.GAssetManager;

class BasicExample5SimpleParticles {

    static public function main() {
        var inst = new BasicExample5SimpleParticles();
    }

    private var _assetManager:GAssetManager;

    public function new() {
        initGenome();
    }

    private function initGenome():Void {
        trace("initGenome");

        Genome2D.getInstance().onInitialized.add(genomeInitializedHandler);
        Genome2D.getInstance().init(new GContextConfig());
    }

    private function genomeInitializedHandler():Void {
        trace("genomeInitializedHandler");

        initAssets();
    }

    private function initAssets():Void {
        trace("initAssets");

        _assetManager = new GAssetManager();
        _assetManager.addUrl("atlas_gfx", "atlas.png");
        _assetManager.addUrl("atlas_xml", "atlas.xml");
        _assetManager.onAllLoaded.add(assetsInitializedHandler);
        _assetManager.load();
    }

    private function assetsInitializedHandler():Void {
        trace("assetsInitializedHandler");

        initExample();
    }

    private function initExample():Void {
        trace("initExample");

        GTextureAtlasFactory.createFromAssets("atlas", cast _assetManager.getAssetById("atlas_gfx"), cast _assetManager.getAssetById("atlas_xml"));

        var emitter:GSimpleParticleSystem = cast GNodeFactory.createNodeWithComponent(GSimpleParticleSystem);
        emitter.textureId = "atlas_particle";
        emitter.emission = 128;
        emitter.emit = true;
        emitter.dispersionAngleVariance = Math.PI*2;
        emitter.energy = 1;
        emitter.initialVelocity = 50;
        emitter.initialVelocityVariance = 100;
        emitter.initialAngleVariance = 5;
        emitter.endAlpha = 0;
        emitter.initialScale = 2;
        emitter.endScale = .2;
        emitter.node.transform.setPosition(400,300);
        Genome2D.getInstance().root.addChild(emitter.node);
    }
}
