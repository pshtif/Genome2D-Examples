/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.examples;

import com.genome2d.components.renderable.ui.GUI;
import com.genome2d.macros.MGDebug;
import com.genome2d.node.GNode;
import com.genome2d.text.GFontManager;
import com.genome2d.textures.GTextureManager;
import com.genome2d.ui.element.GUIElement;
import com.genome2d.ui.skin.GUIFontSkin;
import com.genome2d.ui.skin.GUITextureSkin;


class UIExample extends AbstractExample
{

    static public function main() {
        var inst = new UIExample();
    }

    /**
        Initialize Example code
     **/
    override private function initExample():Void {		
		var gui:GUI = GNode.createWithComponent(GUI);
		genome.root.addChild(gui.node);

		var textureSkin:GUITextureSkin = new GUITextureSkin("texture", GTextureManager.getTexture("assets/button"));
		textureSkin.sliceLeft = 10;
		textureSkin.sliceRight = 35;
		textureSkin.sliceTop = 10;
		textureSkin.sliceBottom = 35;
		
		var textureElement:GUIElement = new GUIElement(textureSkin);
		textureElement.anchorLeft = 0.1;
		textureElement.anchorRight = .9;
		textureElement.pivotY = .5;
		textureElement.anchorTop = .5;
		textureElement.anchorBottom = .5;
		
		gui.root.addChild(textureElement);
		
		var fontSkin:GUIFontSkin = new GUIFontSkin("font", GFontManager.getFont("assets/font"));
		fontSkin.color = 0x000000;
		fontSkin.autoSize = true;
		
		var fontElement:GUIElement = new GUIElement(fontSkin);
		fontElement.setModel("JUST UI LABEL");
		fontElement.setAlign(5);
		fontElement.anchorY = 4;
		textureElement.addChild(fontElement);
    }
}
