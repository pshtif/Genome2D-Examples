package com.genome2d.examples;
import com.genome2d.context.renderers.G3DRenderer;
import com.genome2d.examples.AbstractExample;
import com.genome2d.g3d.G3DFactory;
import com.genome2d.g3d.G3DScene;
import com.genome2d.geom.GMatrix3D;
import com.genome2d.geom.GVector3D;
import com.genome2d.textures.GTextureManager;

/**
 * @author Peter @sHTiF Stefcek
 */
class G3DExample extends AbstractExample
{
	static public function main() {
        var inst = new G3DExample();
    }
	
	//private var renderer:G3DRenderer;
	private var scene:G3DScene;
	private var cameraMatrix:GMatrix3D;

    /**
        Initialize Example code
     **/
    override private function initExample():Void {
		//renderer = new G3DRenderer([100, 100, 0, 200, 100, 0, 100, 200, 0, 200, 200, 0], [0, 0, 1, 0, 0, 1, 1, 1], [0, 1, 2, 2, 1, 3], null);
		//renderer.texture = GTextureManager.getTexture("assets/texture");
		scene = G3DFactory.createBox(200, 50, 100, GTextureManager.getTexture("texture"));
		scene.invalidate();
		
		cameraMatrix = new GMatrix3D();
		
		genome.onPostRender.add(postRender_handler);
	}

	private var rotation:Float = 1;
	
	private function postRender_handler():Void {
		scene.getSceneMatrix().identity();
		scene.getSceneMatrix().appendRotation(rotation++, GVector3D.Y_AXIS);
		scene.getSceneMatrix().appendRotation(rotation++, GVector3D.X_AXIS);
		scene.getSceneMatrix().appendTranslation(200, 200, 100);
		
		//renderer.modelMatrix.appendRotation(1, GVector3D.Y_AXIS);
		//genome.getContext().setRenderer(renderer);
		//renderer.draw(0, 0);
		scene.render(cameraMatrix, 0);
	}
}