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
import com.genome2d.components.GCameraController;
import com.genome2d.components.renderable.GSprite;
import com.genome2d.examples.AbstractExample;
import com.genome2d.node.GNode;
import com.genome2d.textures.GTextureManager;

class CameraExample extends AbstractExample
{
    static public function main() {
        var inst = new CameraExample();
    }

    /**
        Initialize Example code
     **/
    override private function initExample():Void {		
		/**/
		var camera1:GCameraController = GNode.createWithComponent(GCameraController);
		camera1.node.setPosition(200, 300);
		camera1.setView(0, 0, .5, 1);
		genome.root.addChild(camera1.node);
		
		var camera2:GCameraController = GNode.createWithComponent(GCameraController);
		camera2.node.setPosition(200, 300);
		camera2.setView(0.5, 0, .5, 1);
		camera2.zoom = 2;
		genome.root.addChild(camera2.node);
		/**/
        var sprite:GSprite;
		
		// Create a sprite
        sprite = createSprite(100, 200, "assets/atlas_0");

		// Create a sprite with scaling
        sprite = createSprite(300, 200, "assets/atlas_0");
        sprite.node.setScale(2,2);

		// Create a sprite with rotation
        sprite = createSprite(100, 400, "assets/atlas_0");
        sprite.node.rotation = 0.753;

		// Create a sprite with rotation and scaling
        sprite = createSprite(300, 400, "assets/atlas_0");
        sprite.node.rotation = 0.753;
        sprite.node.setScale(2,2);

		// Create a sprite with alpha
        sprite = createSprite(100, 300, "assets/atlas_0");
        sprite.node.alpha = .5;

		// Create a sprite with tint
        sprite = createSprite(300, 300, "assets/atlas_0");
        sprite.node.color = 0x00FF00;
    }

    /**
        Create a sprite helper function
     **/
    private function createSprite(p_x:Int, p_y:Int, p_textureId:String):GSprite {
		// Create a node with sprite component
        var sprite:GSprite = GNode.createWithComponent(GSprite);
        sprite.texture = GTextureManager.getTexture(p_textureId);
        sprite.node.setPosition(p_x, p_y);
        genome.root.addChild(sprite.node);

        return sprite;
    }
}
