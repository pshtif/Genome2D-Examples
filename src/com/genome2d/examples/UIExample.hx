/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.examples;

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
												<element skin="@textureSkin" preferredWidth="140" color.default-mouseOut="0x0" color.mouseOver="0xFFFFFF">
													<element skin="@fontSkin" setModel="BUTTON" setAlign="2" anchorY="5"/>
												</element>
											</element>
										</element>
										<element skin="@textureSkin" setAlign="2" anchorY="320" preferredWidth="300">
											<element skin="@fontSkin" setModel="SETTINGS" setAlign="5"/>
										</element>
									</element>';

	private var camera:GCameraController;
	private var gui:GUI;

    /**
        Initialize Example code
     **/
    override public function initExample():Void {
		var greenTexture:GTexture = GTextureManager.createTexture("greenTexture", new BitmapData(50, 50, true, 0xff00ff00));
		var redTexture:GTexture = GTextureManager.createTexture("redTexture", new BitmapData(50, 50, true, 0xffff0000));
		var blueTexture:GTexture = GTextureManager.createTexture("blueTexture", new BitmapData(50, 50, true, 0xff0000ff));
		var camera:GCameraController = GNode.createWithComponent(GCameraController);

		var gui:GUI = GNode.createWithComponent(GUI);
		var green:GUIElement = new GUIElement(new GUITextureSkin("green", greenTexture));
		var red:GUIElement = new GUIElement(new GUITextureSkin("red", redTexture));
		var blue:GUIElement = new GUIElement(new GUITextureSkin("blue", blueTexture));
		gui.root.addChild(red);
		red.addChild(green);
		green.addChild(blue);
		gui.root.mouseEnabled = true;
		gui.root.mouseChildren = true;

		red.anchorX = red.anchorY = 0;
		green.anchorX = 25;
		blue.anchorY = 25;
		green.preferredWidth = red.preferredWidth = blue.preferredWidth = 100;
		green.preferredHeight = red.preferredHeight = blue.preferredHeight = 100;

		camera.contextCamera.group = gui.node.cameraGroup = 8;

		Genome2D.getInstance().root.addChild(camera.node);
		Genome2D.getInstance().root.addChild(gui.node);

//        camera.setViewport(100, 100);
//        camera.viewport.vAlign = GVAlignType.TOP;
//        camera.viewport.hAlign = GHAlignType.LEFT;

		// INTERACTION
		red.onMouseOver.add(function (input:GMouseInput):Void {
//            if(input.dispatcher != green) return;
			trace("OVER", cast (input.dispatcher,GUIElement).skin.id);
		});
		red.onMouseOut.add(function (input:GMouseInput):Void {
//            if(input.dispatcher != green) return;
			trace("OUT", cast (input.dispatcher,GUIElement).skin.id);
		});
		red.onMouseDown.add(function (input:GMouseInput):Void {
//            if(input.dispatcher != green) return;
			trace("DOWN", cast (input.dispatcher,GUIElement).skin.id);
		});
		red.onMouseUp.add(function (input:GMouseInput):Void {
//            if(input.dispatcher != green) return;
			trace("UP", cast (input.dispatcher,GUIElement).skin.id);
		});
		red.onMouseClick.add(function (input:GMouseInput):Void {
//            if(input.dispatcher != green) return;
			trace("CLICK", cast (input.dispatcher,GUIElement).skin.id);
		});
		gui.node.mouseEnabled = true;
		gui.node.mouseChildren = true;

		red.mouseEnabled = true;   red.mouseCapture = true; red.mouseChildren = true;
		green.mouseEnabled = true; green.mouseCapture = false; green.mouseChildren = true;
		blue.mouseEnabled = true;  blue.mouseCapture = false; blue.mouseChildren = true;

		return;
		title = "UI EXAMPLE";
		detail = "\nExample showcasing UI\n\n elements, layouts and skinning.\n";
		var a:CustomComponent;

		var textureSkin:GUITextureSkin = new GUITextureSkin("textureSkin", GTextureManager.getTexture("assets/button.png"));
		textureSkin.sliceLeft = 10;
		textureSkin.sliceRight = 35;
		textureSkin.sliceTop = 10;
		textureSkin.sliceBottom = 35;

		var fontSkin:GUIFontSkin = new GUIFontSkin("fontSkin", GFontManager.getFont("assets/font.fnt"));
		fontSkin.color = 0x0;
		fontSkin.autoSize = true;


		gui = GNode.createWithComponent(GUI);
		gui.node.mouseEnabled = true;
		gui.node.cameraGroup = 2;
		gui.setBounds(new GRectangle(0,0,800,600));
		genome.root.addChild(gui.node);

		var textureElement:GUIElement = cast GXmlPrototypeParser.createPrototypeFromXmlString(prototype);
		gui.root.addChild(textureElement);

		camera = GNode.createWithComponent(GCameraController);
		camera.setViewport(2048,1536);
		camera.contextCamera.group = 2;
		genome.root.addChild(camera.node);

		genome.getContext().getNativeStage().scaleMode = StageScaleMode.NO_SCALE;
		genome.getContext().getNativeStage().addEventListener(Event.RESIZE, resize_handler);
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
