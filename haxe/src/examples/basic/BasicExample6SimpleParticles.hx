package examples.basic;
import com.genome2d.geom.GRectangle;
import com.genome2d.components.renderables.particles.GSimpleParticleSystem;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.textures.factories.GTextureAtlasFactory;
import com.genome2d.Genome2D;
import com.genome2d.context.GContextConfig;
import com.genome2d.textures.GTextureAtlas;
import com.genome2d.assets.GAssetManager;

class BasicExample6SimpleParticles
{

    static public function main() {
        var inst = new BasicExample5SimpleParticles();
    }

    /**
        Genome2D singleton instance
     **/
    private var genome:Genome2D;

    /**
        Asset manager instance for loading assets
     **/
    private var assetManager:GAssetManager;

    public function new() {
        initGenome();
    }

    /**
        Initialize Genome2D
     **/
    private function initGenome():Void {
        genome = Genome2D.getInstance();
        genome.onInitialized.add(genomeInitializedHandler);
        genome.init(new GContextConfig());
    }

    /**
        Genome2D initialized handler
     **/
    private function genomeInitializedHandler():Void {
        initAssets();
    }

    /**
        Initialize assets
     **/
    private function initAssets():Void {
        assetManager = new GAssetManager();
        assetManager.addUrl("atlas_gfx", "atlas.png");
        assetManager.addUrl("atlas_xml", "atlas.xml");
        assetManager.onAllLoaded.add(assetsInitializedHandler);
        assetManager.load();
    }

    /**
        Assets initialization handler dispatched after all assets were initialized
     **/
    private function assetsInitializedHandler():Void {
        initExample();
    }

    /**
        Initialize Example code
     **/
    private function initExample():Void {
        GTextureAtlasFactory.createFromAssets("atlas", cast assetManager.getAssetById("atlas_gfx"), cast assetManager.getAssetById("atlas_xml"));

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
