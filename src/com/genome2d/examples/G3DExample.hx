package com.genome2d.examples;
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
    override private function initExample():Void {
		GStats.visible = true;
		
		scene = G3DFactory.createBox(100, 100, 100, GTextureManager.getTexture("texture"));
		scene.invalidate();
		
		cameraMatrix = new GMatrix3D();
		
		renderTexture = GTextureManager.createRenderTexture("renderTexture", 256, 256);
		
		genome.onPostRender.add(postRender_handler);
	}

	private var rotation:Float = 1;
	
	private function postRender_handler():Void {
		genome.getContext().draw(GTextureManager.getTexture("assets/logo_white"), 400, 300);
		
		genome.getContext().setRenderTarget(renderTexture);
		
		rotation++;
		
		scene.getSceneMatrix().identity();
		scene.getSceneMatrix().appendRotation(rotation, GVector3D.Y_AXIS);
		scene.getSceneMatrix().appendRotation(-rotation, GVector3D.X_AXIS);
		scene.getSceneMatrix().appendScale(1.5, 1.5, 1.5);
		scene.getSceneMatrix().appendTranslation(128, 128, 100);
		
		scene.render(cameraMatrix, 0, GTextureManager.getTexture("texture"));
		
		genome.getContext().setRenderTarget(null);
		
		for (i in 0...6) {
			scene.getSceneMatrix().identity();
			scene.getSceneMatrix().appendRotation(rotation, GVector3D.Y_AXIS);
			scene.getSceneMatrix().appendRotation(rotation, GVector3D.X_AXIS);
			scene.getSceneMatrix().appendScale(1.5, 1.5, 1.5);
			scene.getSceneMatrix().appendTranslation(128+256 * (i % 3), 148 + 306 * Std.int(i / 3), 100);
			
			scene.render(cameraMatrix, 0, renderTexture);
		}
	}
}