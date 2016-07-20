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

class MouseExample extends AbstractExample
{

    static public function main() {
        var inst = new MouseExample();
    }

    /**
        Initialize Example code
     **/
    override public function initExample():Void {
		title = "MOUSE EXAMPLE";
		detail = "Example showcasing mouse interaction with Genome2D elements.";
		
		var sprite:GSprite = GNode.createWithComponent(GSprite);
        sprite.texture = GTextureManager.getTexture("assets/atlas_1");
        sprite.node.setPosition(400, 300);
        sprite.node.mouseEnabled = true;
        sprite.node.onMouseClick.add(mouseClickHandler);
        sprite.node.onMouseOver.add(mouseOverHandler);
        sprite.node.onMouseOut.add(mouseOutHandler);
        sprite.node.onMouseDown.add(mouseDownHandler);
        sprite.node.onMouseUp.add(mouseUpHandler);

        container.addChild(sprite.node);
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
		var node:GNode = cast signal.target;
		node.setScale(2, 2);
		node.rotation = Math.PI / 4;
		node.color = 0x00FF00;
		MGDebug.INFO();
    }

    /**
        Mouse out handler
     **/
    private function mouseOutHandler(signal:GMouseInput):Void {
		var node:GNode = cast signal.target;
		node.setScale(1, 1);
		node.rotation = 0;
		node.color = 0xFFFFFF;
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
