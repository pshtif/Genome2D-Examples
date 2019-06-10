/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.examples;

import com.genome2d.textures.GTextureManager;
import com.genome2d.components.renderable.GShape;
import com.genome2d.examples.custom.GEMoveGizmo;
import com.genome2d.examples.AbstractExample;
import com.genome2d.node.GNode;

#if cs @:nativeGen #end
class ShapeExample extends AbstractExample
{
    #if !cs
    static public function main() {
        var inst = new ShapeExample();
    }
    #end

    private var length:Int = 50;
    private var width:Int = 2;
    private var size:Int = 12;

    /**
        Initialize Example code
     **/
    override public function initExample():Void {		
		title = "SHAPE EXAMPLE";
		detail = "Sprite component is the most basic renderable component to render static and animated sprites.";

        var shape:GShape = GNode.createWithComponent(GShape);
        shape.setup([0,0, 50, 0, 0, 50, 0, 50, 50, 0, 50, 50],[0,0,1,0,0,1,0,1,1,0,1,1]);
        shape.texture = GTextureManager.getTexture("assets/texture.png");
        shape.node.setPosition(400,300);
        getGenome().root.addChild(shape.node);
    }
}
