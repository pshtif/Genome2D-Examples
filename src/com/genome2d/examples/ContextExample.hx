/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.examples;

import com.genome2d.context.GBlendMode;
import com.genome2d.examples.AbstractExample;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureManager;

class ContextExample extends AbstractExample
{
    static public function main() {
        var inst = new ContextExample();
    }

    /**
        Initialize Example code
     **/
    override public function initExample():Void {		
		title = "CONTEXT EXAMPLE";
		detail = "Genome2D offers low level access to direct context draw calls without the usage of the high level node/component framework.";

		getGenome().onPreRender.add(preRender_handler);
        getGenome().onPostRender.add(postRender_handler);
    }

	// Pre render callback is called right after rendering begins and backbuffer is cleared, before the Genome2D nodegraph gets rendered
	private function preRender_handler():Void {
		var rt:GTexture = GTextureManager.getTexture("rt");
		if (rt != null) rt.dispose();
		rt = GTextureManager.createRenderTexture("rt", 800, 600);
		var texture:GTexture = GTextureManager.getTexture("assets/texture.png");

		getGenome().getContext().setRenderTarget(rt);

		for (i in 0...100) {
			getGenome().getContext().draw(texture, GBlendMode.NORMAL, Math.random()*800-32, Math.random()*600-32);
		}

		getGenome().getContext().setRenderTarget(null);

		getGenome().onPreRender.remove(preRender_handler);
	}

	// Post render is called after Genome2D nodegraph has been rendered and before stats render and present is called
    private function postRender_handler():Void {
		var texture:GTexture = GTextureManager.getTexture("rt");

		getGenome().getContext().draw(texture, GBlendMode.NORMAL, 400, 300);
		getGenome().autoUpdateAndRender = false;
	}
}
