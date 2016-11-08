/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.examples;

import com.genome2d.examples.custom.GEMoveGizmo;
import com.genome2d.examples.AbstractExample;
import com.genome2d.node.GNode;

class ShapeExample extends AbstractExample
{
    static public function main() {
        var inst = new ShapeExample();
    }

    private var length:Int = 50;
    private var width:Int = 2;
    private var size:Int = 12;

    /**
        Initialize Example code
     **/
    override public function initExample():Void {		
		title = "SPRITE EXAMPLE";
		detail = "Sprite component is the most basic renderable component to render static and animated sprites.";

        var gizmo:GEMoveGizmo = GNode.createWithComponent(GEMoveGizmo);
        gizmo.node.setPosition(400,300);
        genome.root.addChild(gizmo.node);
    }
}
