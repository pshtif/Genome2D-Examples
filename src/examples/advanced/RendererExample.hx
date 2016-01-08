package examples.advanced;
import com.genome2d.assets.GAsset;
import com.genome2d.assets.GAssetManager;
import com.genome2d.context.GContextConfig;
import com.genome2d.context.IGContext;
import com.genome2d.context.stage3d.GShaderCode;
import com.genome2d.context.stage3d.renderers.GBufferRenderer;
import com.genome2d.Genome2D;
import com.genome2d.geom.GMatrix3D;
import flash.geom.Vector3D;

/**
 * ...
 * @author Peter @sHTiF Stefcek
 */
class RendererExample
{
	static public function main() {
        var inst = new RendererExample();
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
		var config:GContextConfig = new GContextConfig();
		config.enableErrorChecking = true;
		
        genome = Genome2D.getInstance();
		genome.onFailed.addOnce(genomeFailed_handler);
        genome.onInitialized.addOnce(genomeInitialized_handler);
        genome.init(config);
    }

	/**
        Genome2D failed handler
     **/
    private function genomeFailed_handler(msg:String):Void {
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
		GAssetManager.addFromUrl("texture.png");
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
		initExample();
	}
	
	private var renderer:GBufferRenderer;
	private var modelMatrix:GMatrix3D;
	private var rotation:Float = 0;
	
	private function initExample():Void {
		modelMatrix = new GMatrix3D();
		
		renderer = new GBufferRenderer();
		renderer.setVertexProgram("m44 vt0, va0, vc4 \n m44 op, vt0, vc0");
		renderer.setFragmentProgram(GShaderCode.FRAGMENT_FINAL_CONSTANT_CODE);
		
		renderer.setIndexBuffer([0, 1, 2, 3, 0, 2]);
		renderer.setVertexBuffer([-50, -50, 50, -50, 50, 50, -50, 50], [2]);
		
		renderer.setFragmentConstant(0, [1, 1, 1, 1]);
		renderer.setVertexConstant(4, modelMatrix);
		
		genome.onPostRender.add(render_handler);
	}
	
	private function render_handler():Void {
		var context:IGContext = genome.getContext();
		context.setRenderer(renderer);
		
		rotation ++;

		modelMatrix.identity();
		modelMatrix.appendRotation(rotation, Vector3D.Y_AXIS);
		modelMatrix.appendRotation(rotation, Vector3D.X_AXIS);
		modelMatrix.appendTranslation(400, 300, 1000);
		
		renderer.draw();
	}	
	
}