/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.examples;

import com.genome2d.geom.GMatrix;
import com.genome2d.context.GBlendMode;
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
		
        getGenome().onPostRender.add(postRender_handler);
    }

    private function postRender_handler():Void {
		var texture:GTexture = GTextureManager.getTexture("assets/texture.png");

		//getGenome().getContext().draw(texture, GBlendMode.NORMAL, 100, 100);

		var matrix:GMatrix = new GMatrix();
		matrix.translate(100,250);
		//getGenome().getContext().drawMatrix(texture, GBlendMode.NORMAL, matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty);
		
		var polyVerticles = [0, 0, 50, 0, 0, 50.0];
		var polyUvcs = [0, 0, 1, 0, 0, 1.0];
		
		getGenome().getContext().drawPoly(texture, GBlendMode.NORMAL, polyVerticles, polyUvcs, 300, 100);
	}
}
