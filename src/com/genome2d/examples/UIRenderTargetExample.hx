/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.examples;

import com.genome2d.components.GCameraController;
import com.genome2d.components.renderable.GSprite;
import com.genome2d.components.renderable.ui.GUI;
import com.genome2d.context.stats.GStats;
import com.genome2d.debug.GDebug;
import com.genome2d.geom.GRectangle;
import com.genome2d.input.GKeyboardInput;
import com.genome2d.input.GKeyboardInputType;
import com.genome2d.input.GMouseInput;
import com.genome2d.node.GNode;
import com.genome2d.proto.parsers.GXmlPrototypeParser;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureManager;
import com.genome2d.tween.easing.GBack;
import com.genome2d.tween.GTween;
import com.genome2d.tween.GTweenSequence;
import com.genome2d.ui.element.GUIElement;
import com.genome2d.ui.skin.GUISkin;
import com.genome2d.ui.skin.GUISkinManager;

class UIRenderTargetExample extends AbstractExample
{
	static public function main() {
		var inst = new UIRenderTargetExample();
	}

	private	var skinPrototype:String = '<skinSheet>
											<textureSkin id="textureSkin2" texture="@assets/atlas.png_1" sliceLeft="4" sliceTop="4" sliceRight="12" sliceBottom="12"/>
											<textureSkin id="textureSkin" texture="@assets/button.png" sliceLeft="10" sliceTop="10" sliceRight="35" sliceBottom="35"/>
											<fontSkin id="fontSkin" font="@assets/font.fnt" color="0x0" autoSize="true"/>
										</skinSheet>';

	private var elementPrototype:String = '<element name="A1" anchorLeft="0" anchorRight="1" anchorTop="0" anchorBottom="1">
										<element name="P1" skin="@particles1" anchorAlign="TOP_CENTER" pivotAlign="TOP_CENTER" anchorY="100"/>
										<element name="A2" skin="@textureSkin" anchorAlign="TOP_CENTER" pivotAlign="TOP_CENTER" anchorY="100" preferredWidth="200">
											<element skin="@fontSkin" model="TITLE" anchorAlign="MIDDLE_CENTER" pivotAlign="MIDDLE_CENTER"/>
										</element>
										<element name="P2" skin="@particles2" anchorAlign="TOP_CENTER" pivotAlign="TOP_CENTER" anchorY="180"/>
										<element name="B2" skin="@textureSkin" anchorAlign="TOP_CENTER" pivotAlign="TOP_CENTER" anchorY="180" preferredWidth="512" preferredHeight="150">
											<element name="A3" skin="@fontSkin" model="LAYOUT" anchorAlign="TOP_CENTER" pivotAlign="TOP_CENTER" anchorY="5"/>
											<element name="B3" anchorY="90" anchorAlign="TOP_CENTER" pivotAlign="TOP_CENTER">
												<p:layout><horizontal gap="5"/></p:layout>
												<element name="A4" skin="@textureSkin" color="0xFFBBBB" preferredWidth="140">
													<element name="A5" skin="@fontSkin" model="BUTTON" anchorAlign="TOP_CENTER" pivotAlign="TOP_CENTER" anchorY="5"/>
												</element>
												<element name="B4" skin="@textureSkin" color="0xBBFFBB" preferredWidth="140">
													<element name="B5" skin="@fontSkin" model="BUTTON" anchorAlign="TOP_CENTER" pivotAlign="TOP_CENTER" anchorY="5"/>
												</element>/>
												<element name="C4" skin="@textureSkin" preferredWidth="140" mouseDown="test" color.default-mouseOut="0xFFFFFF" color.mouseOver="0xFF0000">
													<element name="C5" skin="@fontSkin" model="BUTTON" anchorAlign="TOP_CENTER" pivotAlign="TOP_CENTER" anchorY="5"/>
												</element>
											</element>
										</element>
										<element name="P3" skin="@particles3" anchorAlign="TOP_CENTER" pivotAlign="TOP_CENTER" anchorY="365"/>
										<element name="C2" skin="@textureSkin" anchorAlign="TOP_CENTER" pivotAlign="TOP_CENTER" anchorY="360" preferredWidth="300">
											<element name="C3" skin="@fontSkin" model="SETTINGS" anchorAlign="MIDDLE_CENTER" pivotAlign="MIDDLE_CENTER"/>
										</element>
									</element>';

	private var camera:GCameraController;
	private var renderTarget:GTexture;
	private var gui:GUI;
	private var sequence:GTweenSequence;

    /**
        Initialize Example code
     **/
    override public function initExample():Void {
		GStats.visible = true;

		title = "UI RENDER TARGET EXAMPLE";
		detail = "Example showcasing UI elements through .\n";

		GXmlPrototypeParser.createPrototypeFromXmlString(skinPrototype);

		gui = GNode.createWithComponent(GUI);
		gui.node.cameraGroup = 4;
		gui.node.mouseEnabled = true;
		gui.setBounds(new GRectangle(0,0,800,600));
		getGenome().root.addChild(gui.node);

		var textureElement:GUIElement = cast GXmlPrototypeParser.createPrototypeFromXmlString(elementPrototype);
		textureElement.setController(this);
		gui.root.addChild(textureElement);

		renderTarget = GTextureManager.createRenderTexture("renderTarget", 800, 600, 1);

		camera = GNode.createWithComponent(GCameraController);
		camera.node.setPosition(400,300);
		camera.renderTarget = renderTarget;
		camera.contextCamera.group = 4;
		getGenome().root.addChild(camera.node);

		var sprite:GSprite = GNode.createWithComponent(GSprite);
		sprite.texture = renderTarget;
		sprite.node.setPosition(400,300);
		container.addChild(sprite.node);

		Genome2D.getInstance().onKeyboardInput.add(keyboardInput_handler);


		GTween.create(sprite.node).propF("y",800,0,false).id("start").extend().propF("y",300,.3,false).propF("scaleX",.25,.2,false).propF("scaleY",.25,.2,false).ease(GBack.easeIn, true).extend().propF("scaleX",1,.2,false).propF("scaleY",1,.2,false).ease(GBack.easeOut, true).delay(2).propF("y",800,.2,false).propF("scaleX",.25,.2,false).propF("scaleY",.25,.2,false).goto("start",100000);
    }

	private function keyboardInput_handler(p_input:GKeyboardInput):Void {
		if (p_input.type == GKeyboardInputType.KEY_DOWN) {
			switch (p_input.keyCode) {
				case 219:
					GDebug.debugDrawCall--;
					if (GDebug.debugDrawCall < 0) GDebug.debugDrawCall = 0;
				case 221:
					GDebug.debugDrawCall++;

			}
		}
	}

	public function test(p_input:GMouseInput):Void {
		trace(p_input.dispatcher);
		sequence.reset();
		sequence.run();
	}
	
	override public function dispose():Void {
		super.dispose();
		
		cast (GUISkinManager.getSkin("textureSkin"),GUISkin).dispose();
		cast (GUISkinManager.getSkin("fontSkin"),GUISkin).dispose();
	}
}
