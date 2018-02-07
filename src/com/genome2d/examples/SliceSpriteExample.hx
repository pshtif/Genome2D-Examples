/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.examples;

import com.genome2d.components.renderable.GSliceSprite;
import com.genome2d.debug.GDebug;
import com.genome2d.input.GMouseInput;
import com.genome2d.tween.GTween;
import com.genome2d.tween.GTweenStep;
import com.genome2d.animation.GFrameAnimation;
import com.genome2d.components.renderable.GSprite;
import com.genome2d.examples.AbstractExample;
import com.genome2d.node.GNode;
import com.genome2d.textures.GTextureManager;

class SliceSpriteExample extends AbstractExample
{
    static public function main() {
        var inst = new SliceSpriteExample();
    }

    /**
        Initialize Example code
     **/
    override public function initExample():Void {		
		title = "SLICE SPRITE EXAMPLE";
		detail = "Sliced sprite component is an advanced sprite component to render up to 9-slice scaled images.";
		
        var sprite:GSliceSprite;
		
		// Create a sprite
        sprite = createSliceSprite(100, 200, 44, 84, 44, 84, "assets/texture.png");
        sprite.width = 256;
        sprite.height = 256;
        sprite.node.setScale(2,2);
    }

    private function mouseclick_handler(p_input:GMouseInput):Void {
        GDebug.info('click');
    }

    /**
        Create a sprite helper function
     **/
    private function createSliceSprite(p_x:Int, p_y:Int, p_left:Int, p_right:Int, p_top:Int, p_bottom:Int, p_textureId:String):GSliceSprite {
		// Create a node with sprite component
        var sprite:GSliceSprite = GNode.createWithComponent(GSliceSprite);
        sprite.sliceLeft = p_left;
        sprite.sliceRight = p_right;
        sprite.sliceTop = p_top;
        sprite.sliceBottom = p_bottom;
        sprite.texture = GTextureManager.getTexture(p_textureId);
        sprite.node.setPosition(p_x, p_y);
        container.addChild(sprite.node);

        return sprite;
    }
}