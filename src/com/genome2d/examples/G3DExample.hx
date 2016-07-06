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
	
	private var scene:G3DScene;
	private var cameraMatrix:GMatrix3D;

    /**
        Initialize Example code
     **/
    override private function initExample():Void {
		scene = G3DFactory.createBox(100, 100, 100, GTextureManager.getTexture("texture"));
		scene.invalidate();
		
		cameraMatrix = new GMatrix3D();
		
		genome.onPostRender.add(postRender_handler);
	}

	private var rotation:Float = 1;
	
	private function postRender_handler():Void {
		scene.getSceneMatrix().identity();
		scene.getSceneMatrix().appendRotation(rotation++, GVector3D.Y_AXIS);
		scene.getSceneMatrix().appendRotation(rotation++, GVector3D.X_AXIS);
		scene.getSceneMatrix().appendTranslation(400, 300, 100);
		
		scene.render(cameraMatrix, 0);
	}
}