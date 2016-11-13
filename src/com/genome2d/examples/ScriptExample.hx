/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.examples;

import com.genome2d.components.GScriptComponent;
import com.genome2d.animation.GFrameAnimation;
import com.genome2d.components.renderable.GSprite;
import com.genome2d.examples.AbstractExample;
import com.genome2d.node.GNode;
import com.genome2d.textures.GTextureManager;

class ScriptExample extends AbstractExample
{
    static public function main() {
        var inst = new ScriptExample();
    }

    /**
        Initialize Example code
     **/
    override public function initExample():Void {		
		title = "SCRIPT EXAMPLE";
		detail = "Script component is run by h-script scripting language interpreted at runtime.";
		
        var sc:GScriptComponent = GNode.createWithComponent(GScriptComponent);
		container.addChild(sc.node);

    }
}
