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
import com.genome2d.proto.GPrototypeFactory;
import com.genome2d.proto.parsers.GXmlPrototypeParser;
import com.genome2d.text.GFontManager;
import com.genome2d.textures.GTextureManager;
import com.genome2d.ui.element.GUIElement;
import com.genome2d.ui.layout.GUIHorizontalLayout;
import com.genome2d.ui.skin.GUIFontSkin;
import com.genome2d.ui.skin.GUISkinManager;
import com.genome2d.ui.skin.GUITextureSkin;


class UIExample extends AbstractExample
{

    static public function main() {
        var inst = new UIExample();
    }
	
	private var prototype:String = '<element anchorLeft="0" anchorRight="1" anchorTop="0" anchorBottom="1">
										<element skin="@textureSkin" setAlign="2" anchorY="100" preferredWidth="200">
											<element skin="@fontSkin" setModel="TITLE" setAlign="5"/>
										</element>
										<element skin="@textureSkin" color="0xBBBBBB" setAlign="2" anchorY="180" preferredWidth="512" preferredHeight="100">
											<element skin="@fontSkin" setModel="LAYOUT" setAlign="2" anchorY="5"/>
											<element anchorY="40" setAlign="2">
												<p:layout><horizontal gap="5"/></p:layout>
												<element skin="@textureSkin" color="0xFFBBBB" preferredWidth="140">
													<element skin="@fontSkin" setModel="BUTTON" setAlign="2" anchorY="5"/>
												</element>
												<element skin="@textureSkin" color="0xBBFFBB" preferredWidth="140">
													<element skin="@fontSkin" setModel="BUTTON" setAlign="2" anchorY="5"/>
												</element>
												<element skin="@textureSkin" color="0xDDDDFF" preferredWidth="140">
													<element skin="@fontSkin" setModel="BUTTON" setAlign="2" anchorY="5"/>
												</element>
											</element>
										</element>
										<element skin="@textureSkin" setAlign="2" anchorY="320" preferredWidth="300">
											<element skin="@fontSkin" setModel="SETTINGS" setAlign="5"/>
										</element>
									</element>';

    /**
        Initialize Example code
     **/
    override public function initExample():Void {		
		title = "UI EXAMPLE";
		detail = "Example showcasing UI elements, layouts and skinning.";
		
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
	
	override public function dispose():Void {
		super.dispose();
		
		GUISkinManager.getSkin("textureSkin").dispose();
		GUISkinManager.getSkin("fontSkin").dispose();
	}
}
