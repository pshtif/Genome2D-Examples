/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.examples;

import com.genome2d.ui.skin.GUISkinSheet;
import tween.Delta;
import flash.display.BitmapData;
import com.genome2d.textures.GTexture;
import com.genome2d.input.GMouseInput;
import com.genome2d.examples.custom.CustomComponent;
import com.genome2d.utils.GHAlignType;
import com.genome2d.ui.skin.GUISkin;
import com.genome2d.geom.GRectangle;
import flash.display.StageScaleMode;
import flash.events.Event;
import com.genome2d.components.GCameraController;
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
import motion.Actuate;


class UIExample extends AbstractExample
{

    static public function main() {
        var inst = new UIExample();
    }

	private	var skinPrototype:String = '<skinSheet>
											<textureSkin id="textureSkin" texture="@assets/button.png" sliceLeft="10" sliceTop="10" sliceRight="35" sliceBottom="35"/>
											<fontSkin id="fontSkin" font="@assets/font.fnt" color="0x0" autoSize="true"/>
										</skinSheet>';

	private var elementPrototype:String = '<element name="A1" anchorLeft="0" anchorRight="1" anchorTop="0" anchorBottom="1">
										<element name="A2" skin="@textureSkin" setAlign="2" anchorY="100" preferredWidth="200">
											<element skin="@fontSkin" setModel="TITLE" setAlign="5"/>
										</element>
										<element name="B2" skin="@textureSkin" color="0xBBBBBB" setAlign="2" anchorY="180" preferredWidth="512" preferredHeight="100">
											<element name="A3" skin="@fontSkin" setModel="LAYOUT" setAlign="2" anchorY="5"/>
											<element name="B3" anchorY="40" setAlign="2">
												<p:layout><horizontal gap="5"/></p:layout>
												<element name="A4" skin="@textureSkin" color="0xFFBBBB" preferredWidth="140">
													<element name="A5" skin="@fontSkin" setModel="BUTTON" setAlign="2" anchorY="5"/>
												</element>
												<element name="B4" skin="@textureSkin" color="0xBBFFBB" preferredWidth="140">
													<element name="B5" skin="@fontSkin" setModel="BUTTON" setAlign="2" anchorY="5"/>
												</element>
												<element name="C4" skin="@textureSkin" preferredWidth="140" color.default-mouseOut="0xFF0000" color.mouseOver="0xFFFFFF">
													<element name="C5" skin="@fontSkin" setModel="BUTTON" setAlign="2" anchorY="5"/>
												</element>
											</element>
										</element>
										<element name="C2" skin="@textureSkin" setAlign="2" anchorY="320" preferredWidth="300">
											<element name="C3" skin="@fontSkin" setModel="SETTINGS" setAlign="5"/>
										</element>
									</element>';

	private var camera:GCameraController;
	private var gui:GUI;

    /**
        Initialize Example code
     **/
    override public function initExample():Void {
		title = "UI EXAMPLE";
		detail = "\nExample showcasing UI\n\n elements, layouts and skinning.\n";
		var a:CustomComponent;

		var skinSheet:GUISkinSheet;
		GXmlPrototypeParser.createPrototypeFromXmlString(skinPrototype);

		gui = GNode.createWithComponent(GUI);
		gui.node.mouseEnabled = true;
		gui.setBounds(new GRectangle(0,0,800,600));
		container.addChild(gui.node);

		var textureElement:GUIElement = cast GXmlPrototypeParser.createPrototypeFromXmlString(elementPrototype);
		textureElement.getChildByName("C4",true).onMouseClick.add(mouseClick_handler);
		textureElement.getChildByName("C4",true).onRightMouseClick.add(mouseClick_handler);
		gui.root.addChild(textureElement);

		genome.getContext().getNativeStage().scaleMode = StageScaleMode.NO_SCALE;
		genome.getContext().getNativeStage().addEventListener(Event.RESIZE, resize_handler);
    }

	private function mouseClick_handler(p_input:GMouseInput):Void {
		trace(p_input.dispatcher);
	}

	private function resize_handler(event:Event):Void {
		genome.getContext().resize(new GRectangle(0,0,genome.getContext().getNativeStage().stageWidth, genome.getContext().getNativeStage().stageHeight));
	}
	
	override public function dispose():Void {
		super.dispose();
		
		cast (GUISkinManager.getSkin("textureSkin"),GUISkin).dispose();
		cast (GUISkinManager.getSkin("fontSkin"),GUISkin).dispose();
	}
}
