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
import com.genome2d.proto.parsers.GXmlPrototypeParser;
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
	
	private var prototype:String = '<element anchorLeft="0" anchorRight="1" anchorTop="0" anchorBottom="1">
									<element skin="@textureSkin" setAlign="2" anchorY="100" preferredWidth="400"><element skin="@fontSkin" setModel="MENU1" setAlign="5"/></element>
									<element skin="@textureSkin" setAlign="2" anchorY="200" preferredWidth="400"><element skin="@fontSkin" setModel="MENU2" setAlign="5"/></element>
									<element skin="@textureSkin" setAlign="2" anchorY="300" preferredWidth="400"><element skin="@fontSkin" setModel="MENU3" setAlign="5"/></element>
									</element>';

    /**
        Initialize Example code
     **/
    override private function initExample():Void {		
		title = "UI EXAMPLE";
		detail = "Example showcasing UI elements and skinning.";
		
		var gui:GUI = GNode.createWithComponent(GUI);
		genome.root.addChild(gui.node);

		var textureSkin:GUITextureSkin = new GUITextureSkin("textureSkin", GTextureManager.getTexture("assets/button"));
		textureSkin.sliceLeft = 10;
		textureSkin.sliceRight = 35;
		textureSkin.sliceTop = 10;
		textureSkin.sliceBottom = 35;
		
		var fontSkin:GUIFontSkin = new GUIFontSkin("fontSkin", GFontManager.getFont("assets/font"));
		fontSkin.color = 0x0;
		fontSkin.autoSize = true;
		
		var textureElement:GUIElement = cast GXmlPrototypeParser.createPrototypeFromXmlString(prototype);
		gui.root.addChild(textureElement);
    }
}
