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
import com.genome2d.assets.GStaticAssetManager;
import com.genome2d.components.renderable.GSprite;
import com.genome2d.components.renderable.GSpine;
import com.genome2d.examples.AbstractExample;
import com.genome2d.node.GNode;
import com.genome2d.textures.GTextureManager;

class SpineExample extends AbstractExample
{
    static public function main() {
        var inst = new SpineExample();
    }

    /**
        Initialize Example code
     **/
    override public function initExample():Void {		
		title = "SPINE EXAMPLE";
		detail = "Spine component enables you to render skeletal animations from Spine software.";

		var spine:GSpine = GNode.createWithComponent(GSpine);
		spine.setup(GStaticAssetManager.getTextAssetById("assets/spine/spineboy/spineboy-old.atlas").text, GTextureManager.getTexture("spineboy"));
        spine.addSkeleton("default", GStaticAssetManager.getTextAssetById("assets/spine/spineboy/spineboy-old.json").text);
		spine.setActiveSkeleton("default", "walk");
		spine.node.setPosition(400, 400);
		getGenome().root.addChild(spine.node);
    }
}