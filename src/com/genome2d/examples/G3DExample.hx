package com.genome2d.examples;
import com.genome2d.context.GDepthFunc;
import com.genome2d.context.renderers.G3DRenderer;
import com.genome2d.context.stats.GStats;
import com.genome2d.examples.AbstractExample;
import com.genome2d.g3d.G3DFactory;
import com.genome2d.g3d.G3DScene;
import com.genome2d.geom.GMatrix3D;
import com.genome2d.geom.GVector3D;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureManager;

/**
 * @author Peter @sHTiF Stefcek
 */
class G3DExample extends AbstractExample
{
	static public function main() {
        var inst = new G3DExample();
    }
	
	private var scene:G3DScene;
	private var cameraMatrix:GMatrix3D;

	private var renderTexture:GTexture;
	
    /**
        Initialize Example code
     **/
    override public function initExample():Void {
		title = "G3D EXAMPLE";
		detail = "Example showcasing 3D rendering capabilities inside Genome2D using custom overridable and extendable renderer.";
		
		scene = G3DFactory.createBox(100, 100, 100, GTextureManager.getTexture("assets/texture.png"));
		scene.invalidate();
		
		cameraMatrix = new GMatrix3D();
		
		genome.onPostRender.add(postRender_handler);
	}

	private var rotation:Float = 0;
	
	private function postRender_handler():Void {
		rotation++;
		
		scene.getSceneMatrix().identity();
		scene.getSceneMatrix().appendRotation(rotation, GVector3D.Y_AXIS);
		scene.getSceneMatrix().appendRotation(-rotation, GVector3D.X_AXIS);
		scene.getSceneMatrix().appendTranslation(400, 300, 100);
		
		scene.render(cameraMatrix, 0);
	}
	
	override public function dispose():Void {
		super.dispose();
		
		genome.onPostRender.remove(postRender_handler);
		
		scene.dispose();
	}
}