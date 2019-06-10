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
import com.genome2d.components.renderable.GSpineComponent;
import com.genome2d.examples.AbstractExample;
import com.genome2d.node.GNode;
import com.genome2d.textures.GTextureManager;

#if cs @:nativeGen #end
class SpineExample extends AbstractExample
{
    #if !cs
    static public function main() {
        var inst = new SpineExample();
    }
    #end

    /**
        Initialize Example code
     **/
    override public function initExample():Void {		
		title = "SPINE EXAMPLE";
		detail = "Spine component enables you to render skeletal animations from Spine software.";

		var spine:GSpineComponent = GNode.createWithComponent(GSpineComponent);
		spine.setup(GStaticAssetManager.getTextAssetById("assets/spine/spineboy/spineboy-old.atlas").text, GTextureManager.getTexture("spineboy"));
        spine.getSpine().addSkeleton("default", GStaticAssetManager.getTextAssetById("assets/spine/spineboy/spineboy-old.json").text);
		spine.getSpine().setActiveSkeleton("default");
		spine.getSpine().setAnimation(0, "walk", true);
		spine.node.setPosition(400, 400);
		getGenome().root.addChild(spine.node);
    }
}