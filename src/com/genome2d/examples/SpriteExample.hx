/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.examples;

import com.genome2d.debug.GDebug;
import com.genome2d.input.GMouseInput;
import com.genome2d.tween.GTween;
import com.genome2d.tween.GTweenStep;
import com.genome2d.animation.GFrameAnimation;
import com.genome2d.components.renderable.GSprite;
import com.genome2d.examples.AbstractExample;
import com.genome2d.node.GNode;
import com.genome2d.textures.GTextureManager;

class SpriteExample extends AbstractExample
{
    static public function main() {
        var inst = new SpriteExample();
    }

    /**
        Initialize Example code
     **/
    override public function initExample():Void {		
		title = "SPRITE EXAMPLE";
		detail = "Sprite component is the most basic renderable component to render static and animated sprites.";
		
        var sprite:GSprite;
		
		// Create a sprite
        sprite = createSprite(100, 200, "assets/atlas.png_0");

		// Create a sprite with scaling
        sprite = createSprite(300, 200, "assets/atlas.png_0");
        sprite.node.setScale(2,2);

		// Create a sprite with rotation
        sprite = createSprite(100, 400, "assets/atlas.png_0");
        sprite.node.rotation = 0.753;

		// Create a sprite with rotation and scaling
        sprite = createSprite(300, 400, "assets/atlas.png_0");
        sprite.node.rotation = 0.753;
        sprite.node.setScale(2,2);

		// Create a sprite with alpha
        sprite = createSprite(100, 300, "assets/atlas.png_0");
        sprite.node.alpha = .5;

		// Create a sprite with tint
        sprite = createSprite(300, 300, "assets/atlas.png_0");
        sprite.node.color = 0x00FF00;
		
		// Create an animated sprite
		sprite = createAnimatedSprite(500, 200);

		// Create an animated sprite with scaling
        sprite = createAnimatedSprite(700, 200);
        sprite.node.setScale(2,2);

		// Create an animated sprite with rotation
        sprite = createAnimatedSprite(500, 400);
        sprite.node.rotation = 0.753;

		// Create an animated sprite with rotation and scaling
        sprite = createAnimatedSprite(700, 400);
        sprite.node.rotation = 0.753;
        sprite.node.setScale(2,2);

		// Create an animated sprite with alpha
        sprite = createAnimatedSprite(500, 300);
        sprite.node.alpha = .5;

		// Create an animated sprite with tint
        sprite = createAnimatedSprite(700, 300);
        sprite.node.onMouseClick.add(mouseclick_handler);
        sprite.node.mouseEnabled = true;

        new GTweenTest();
    }

    private function mouseclick_handler(p_input:GMouseInput):Void {
        GDebug.info('click');
        GTween.abortAllTimelines();
        new GTweenTest();
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
	
	/**
        Create an animated sprite helper function
     **/
    private function createAnimatedSprite(p_x:Int, p_y:Int):GSprite {
		// To animate a sprite we need a frame animation instance with defined texture frames
		var animation:GFrameAnimation = new GFrameAnimation();
        animation.frameTextures = GTextureManager.getTextures(["assets/atlas.png_1", "assets/atlas.png_2", "assets/atlas.png_3", "assets/atlas.png_4", "assets/atlas.png_5", "assets/atlas.png_6", "assets/atlas.png_7"]);
		animation.frameRate = 10;
		
        var sprite:GSprite = GNode.createWithComponent(GSprite);
        sprite.frameAnimation = animation;
        sprite.node.setPosition(p_x, p_y);
        container.addChild(sprite.node);

        return sprite;
    }
}

class GTweenTest {

    public var x:Float = 0;
    public var y:Float= 0;

    public function new() {

        trace("GTween Test start");

        for (i in 0...1) {
            tween(i);
        }
    }

    private function tween(delay:Float):Void {

        trace("Tween start " + delay);

        var step:GTweenStep = GTween.create(this, true).delay(delay);
        step = step.propF("x", 10, 1, true).onComplete(onComplete, [delay]);

    }

    private function onComplete(id:Float):Void {

        trace("Tween on complete " + id);
    }
}