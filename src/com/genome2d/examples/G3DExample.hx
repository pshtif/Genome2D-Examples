package com.genome2d.examples;
import com.genome2d.context.webgl.renderers.G3DRenderer;
import com.genome2d.examples.AbstractExample;
import com.genome2d.textures.GTextureManager;

/**
 * @author Peter @sHTiF Stefcek
 */
class G3DExample extends AbstractExample
{
	static public function main() {
        var inst = new G3DExample();
    }
	
	private var renderer:G3DRenderer;

    /**
        Initialize Example code
     **/
    override private function initExample():Void {
		renderer = new G3DRenderer([100, 100, 0, 200, 100, 0, 100, 200, 0, 200, 200, 0], [0, 0, 1, 0, 0, 1, 1, 1], [0, 1, 2, 2, 1, 3]);
		renderer.texture = GTextureManager.getTexture("assets/texture");
		
		genome.onPostRender.add(postRender_handler);
	}
	
	private function postRender_handler():Void {
	
		genome.getContext().setRenderer(renderer);
		renderer.draw();
	}
}