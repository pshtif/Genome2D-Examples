/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.examples;

import com.genome2d.components.renderable.GSprite;
import com.genome2d.input.GMouseInput;
import com.genome2d.macros.MGDebug;
import com.genome2d.node.GNode;
import com.genome2d.textures.GTextureManager;

class Mouse extends AbstractExample
{

    static public function main() {
        var inst = new Mouse();
    }

    /**
        Initialize Example code
     **/
    override private function initExample():Void {
		var sprite:GSprite = GNode.createWithComponent(GSprite);
        sprite.texture = GTextureManager.getTexture("assets/atlas_0");
        sprite.node.setPosition(400, 300);
        sprite.node.mouseEnabled = true;
        sprite.node.onMouseClick.add(mouseClickHandler);
        sprite.node.onMouseOver.add(mouseOverHandler);
        sprite.node.onMouseOut.add(mouseOutHandler);
        sprite.node.onMouseDown.add(mouseDownHandler);
        sprite.node.onMouseUp.add(mouseUpHandler);

        genome.root.addChild(sprite.node);
    }

    /**
        Mouse click handler
     **/
    private function mouseClickHandler(signal:GMouseInput):Void {
		MGDebug.INFO();
    }

    /**
        Mouse over handler
     **/
    private function mouseOverHandler(signal:GMouseInput):Void {
		MGDebug.INFO();
    }

    /**
        Mouse out handler
     **/
    private function mouseOutHandler(signal:GMouseInput):Void {
		MGDebug.INFO();
    }

    /**
        Mouse down handler
     **/
    private function mouseDownHandler(signal:GMouseInput):Void {
		MGDebug.INFO();
    }

    /**
        Mouse up handler
     **/
    private function mouseUpHandler(signal:GMouseInput):Void {
        MGDebug.INFO();
    }
}
