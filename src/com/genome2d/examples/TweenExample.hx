/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.examples;

import com.genome2d.tween.easing.GLinear;
import com.genome2d.tween.GTween;
import com.genome2d.components.renderable.GSprite;
import com.genome2d.examples.AbstractExample;
import com.genome2d.node.GNode;
import com.genome2d.textures.GTextureManager;

#if cs @:nativeGen #end
class TweenExample extends AbstractExample
{
    #if !cs
    static public function main() {
        var inst = new TweenExample();
    }
    #end

    private var sprite:GSprite = null;

    /**
        Initialize Example code
     **/
    override public function initExample():Void {		
		title = "TWEEN EXAMPLE";
		detail = "Genome2D contains robust tweening library for animations.";

        sprite = createSprite(100, 200, "assets/texture.png");

        GTween.create(sprite.node).delay(1 - .5).ease(GLinear.none).propF("alpha", 0, .5, false).onComplete(remove);
    }

    private function remove():Void {
        sprite.node.parent.removeChild(sprite.node);
        sprite = null;
    }

    /**
        Create a sprite helper function
     **/
    private function createSprite(p_x:Int, p_y:Int, p_textureId:String):GSprite {
		// Create a node with sprite component
        var sprite:GSprite = GNode.createWithComponent(GSprite);
        sprite.texture = GTextureManager.getTexture(p_textureId);
        sprite.node.setPosition(p_x, p_y);
        container.addChild(sprite.node);

        return sprite;
    }
}
