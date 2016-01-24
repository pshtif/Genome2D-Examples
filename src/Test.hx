package;
import com.genome2d.assets.GAsset;
import com.genome2d.assets.GAssetManager;
import com.genome2d.context.GBlendMode;
import com.genome2d.context.GContextConfig;
import com.genome2d.context.stats.GStats;
import com.genome2d.Genome2D;
import com.genome2d.geom.GCurve;
import com.genome2d.particles.GEmitter;
import com.genome2d.particles.GNewParticle;
import com.genome2d.particles.GNewParticlePool;
import com.genome2d.particles.GParticleSystem;
import com.genome2d.particles.modules.TestModule;
import com.genome2d.textures.GTextureManager;
import flash.display.Sprite;


class Test
{
	static public function main() {
        var inst = new Test();
    }

    /**
        Genome2D singleton instance
     **/
    private var genome:Genome2D;

    public function new() {
        initGenome();
    }

    /**
        Initialize Genome2D
     **/
    private function initGenome():Void {
		GStats.visible = true;
		
        genome = Genome2D.getInstance();
		genome.onFailed.addOnce(genomeFailed_handler);
        genome.onInitialized.addOnce(genomeInitialized_handler);
        genome.init(new GContextConfig());
    }

	/**
        Genome2D failed handler
     **/
    private function genomeFailed_handler(p_msg:String):Void {
        // Here we can check why Genome2D initialization failed
    }
	
    /**
        Genome2D initialized handler
     **/
    private function genomeInitialized_handler():Void {
        loadAssets();
    }
	
	/**	
	 * 	Asset loading
	 */
	private function loadAssets():Void {
		GAssetManager.addFromUrl("assets\\atlas.png");
        GAssetManager.addFromUrl("assets\\atlas.xml");
		GAssetManager.addFromUrl("assets\\texture.png");
		GAssetManager.onQueueFailed.add(assetsFailed_handler);
        GAssetManager.onQueueLoaded.addOnce(assetsLoaded_handler);
        GAssetManager.loadQueue();
	}
	
	/**
	 * 	Asset loading failed
	 */
	private function assetsFailed_handler(p_asset:GAsset):Void {
		// Asset loading failed at p_asset
	}
	
	/**
	 * 	Asset loading completed
	 */
	private function assetsLoaded_handler():Void {
		GAssetManager.generateTextures();
		
		// Loading of assets was succesfull so we can do our stuff
		initExample();
	}
	
	private var particleSystem:GParticleSystem;
	
	private function initExample():Void {
		particleSystem = new GParticleSystem();
		
		var particlePool:GNewParticlePool = new GNewParticlePool(CustomParticle);
		
		var emitter:GEmitter = new GEmitter(particlePool);
		emitter.texture = GTextureManager.getTexture("atlas_particle");
		emitter.rate = new GCurve(5);
		emitter.duration = 1;
		emitter.x = 400;
		emitter.y = 300;
		emitter.blendMode = GBlendMode.ADD;
		emitter.loop = true;
		emitter.addModule(new TestModule(5));
		particleSystem.addEmitter(emitter);
		
		genome.onUpdate.add(update_handler);
		genome.onPostRender.add(postRender_handler);
	}
	
	private function update_handler(p_deltaTime:Float):Void {
		particleSystem.update(p_deltaTime);
	}
	
	private function postRender_handler():Void {
		particleSystem.render(genome.getContext(), 0, 0, 1, 1, 1, 1, 1, 1);
	}
}