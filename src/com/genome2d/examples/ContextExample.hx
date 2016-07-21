/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.examples;

import com.genome2d.animation.GFrameAnimation;
import com.genome2d.components.renderable.GSprite;
import com.genome2d.examples.AbstractExample;
import com.genome2d.node.GNode;
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
		
        genome.onPostRender.add(postRender_handler);
    }

    private function postRender_handler():Void {
		var texture:GTexture = GTextureManager.getTexture("assets/texture");
		
		genome.getContext().draw(texture, 100, 100);
		
		var polyVerticles = [0, 21.33333333333337, 59.40000000000009, 37.83333333333337, 34.40000000000009, 68.83333333333337];
		var polyUvcs = [0, 0.3333333333333333, 0.3177083333333333, 0.3333333333333333, 0.3177083333333333, 0.6666666666666666];
		
		genome.getContext().drawPoly(texture, polyVerticles, polyUvcs, 300, 100);
		
		var polyVerticles = [0, 21.33333333333337, 34.40000000000009, 68.83333333333337, -25, 52.33333333333337];
		var polyUvcs = [0, 0.3333333333333333, 0.3177083333333333, 0.6666666666666666, 0, 0.6666666666666666];
		
		genome.getContext().drawPoly(texture, polyVerticles, polyUvcs, 300, 100);
	}
}
