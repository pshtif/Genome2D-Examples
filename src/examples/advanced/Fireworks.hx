package examples.advanced;
import com.genome2d.assets.GAsset;
import com.genome2d.assets.GAssetManager;
import com.genome2d.components.renderable.particles.GParticleSystem;
import com.genome2d.components.renderable.particles.GSimpleParticleSystem;
import com.genome2d.context.GContextConfig;
import com.genome2d.context.stats.GStats;
import com.genome2d.Genome2D;
import com.genome2d.geom.GCurve;
import com.genome2d.node.GNode;
import com.genome2d.textures.GTextureManager;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import motion.Actuate;
import motion.easing.Linear;

/**
 * ...
 * @author Peter @sHTiF Stefcek
 */
class Fireworks
{
	static public function main() {
        var inst = new Fireworks();
    }
	
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
		GAssetManager.addFromUrl("atlas.png");
        GAssetManager.addFromUrl("atlas.xml");
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
		
		initExample();
	}
	
	private function initExample():Void {
		createSimple();
		return;
		
		var scale:Float = .1;
		var offset:Float = 0;
		Shell.create(genome.root, 100, 100, 100, "P", 0, scale);
		Shell.create(genome.root, 200, 200, 100, "F", .2, scale);
		Shell.create(genome.root, 300, 300, 100, "2", .4, scale);
		Shell.create(genome.root, 400, 400, 100, "0", .6, scale);
		Shell.create(genome.root, 500, 500, 100, "1", .8, scale);
		Shell.create(genome.root, 600, 600, 100, "6", 1, scale);
		
		Shell.create(genome.root, 160, 160, 250, "P", 0, scale);
		Shell.create(genome.root, 260, 260, 250, "I", .2, scale);
		Shell.create(genome.root, 360, 360, 250, "X", .4, scale);
		Shell.create(genome.root, 460, 460, 250, "E", .6, scale);
		Shell.create(genome.root, 560, 560, 250, "L", .8, scale);
		
		scale = .06;
		offset = 70;
		Shell.create(genome.root, 50+offset, 50+offset, 400, "F", 0, scale);
		Shell.create(genome.root, 110+offset, 110+offset, 400, "E", .2, scale);
		Shell.create(genome.root, 170+offset, 170+offset, 400, "D", .4, scale);
		Shell.create(genome.root, 230+offset, 230+offset, 400, "E", .6, scale);
		Shell.create(genome.root, 290+offset, 290+offset, 400, "R", .8, scale);
		Shell.create(genome.root, 350+offset, 350+offset, 400, "A", 1, scale);
		Shell.create(genome.root, 410+offset, 410+offset, 400, "T", 1.2, scale);
		Shell.create(genome.root, 470+offset, 470+offset, 400, "I", 1.4, scale);
		Shell.create(genome.root, 530+offset, 530+offset, 400, "O", 1.6, scale);
		Shell.create(genome.root, 590+offset, 590+offset, 400, "N", 1.8, scale);
	}
	
	private function createSimple():Void {
		var tx:Float = Math.random() * 800;
		var ty:Float = Math.random() * 400 + 200;
		Shell.create(genome.root, tx + Math.random() * 100 - 50, tx, ty, "", 0, 1);
		Actuate.timer(Math.random() + .5).onComplete(createSimple);
	}
	
}