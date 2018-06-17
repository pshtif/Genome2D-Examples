/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.examples;

import com.genome2d.assets.GStaticAssetManager;
import com.genome2d.textures.GTextureManager;
import com.genome2d.project.GProjectConfig;
import com.genome2d.project.GProject;
import com.genome2d.assets.GAsset;
import com.genome2d.assets.GAssetManager;
import com.genome2d.components.GCameraController;
import com.genome2d.components.renderable.text.GText;
import com.genome2d.context.GContextConfig;
import com.genome2d.Genome2D;
import com.genome2d.macros.MGDebug;
import com.genome2d.node.GNode;
import com.genome2d.text.GFontManager;
import com.genome2d.utils.GHAlignType;

class AbstractExample extends GProject
{
	private var initType:Int = 0;
	private var container:GNode;
	private var containerCamera:GCameraController;
	private var info:GNode;
	private var titleText:GText;
	private var detailText:GText;

	public var title(default, set):String;
	private function set_title(p_value:String):String {
		if (titleText != null) titleText.text = p_value;
		return title = p_value;
	}

	public var detail(default, set):String;
	private function set_detail(p_value:String):String {
		if (detailText != null) {
			detailText.text = p_value;
			detailText.renderer.invalidate();
		}
		return detail = p_value;
	}

    public function new(?p_init:Int = 0) {
		initType = p_init;
		var contextConfig:GContextConfig = new GContextConfig(null);
		var config:GProjectConfig = new GProjectConfig(contextConfig);
		config.initGenome = initType == 0;
		super(config);
    }

	override private function init():Void {
		if (initType != 2) {
			GStaticAssetManager.addFromUrl("assets/spine/spineboy/spineboy-old.atlas");
			GStaticAssetManager.addFromUrl("assets/spine/spineboy/spineboy-old.json");
			GStaticAssetManager.addFromUrl("assets/spine/spineboy/spineboy-old.png", "spineboy");

			GStaticAssetManager.addFromUrl("assets/logo_white.png");
			GStaticAssetManager.addFromUrl("assets/atlas.png");
			GStaticAssetManager.addFromUrl("assets/atlas.xml");
			GStaticAssetManager.addFromUrl("assets/texture.png");
			GStaticAssetManager.addFromUrl("assets/ball.png");
			GStaticAssetManager.addFromUrl("assets/font.png");
			GStaticAssetManager.addFromUrl("assets/font.fnt");
			GStaticAssetManager.addFromUrl("assets/button.png");
			GStaticAssetManager.addFromUrl("assets/white.png");
			GStaticAssetManager.addFromUrl("assets/water.png");
			GStaticAssetManager.addFromUrl("assets/script.hxs");
			GStaticAssetManager.loadQueue(assetsLoaded_handler, assetsFailed_handler);
		} else {
			initWrapper();
		}
	}

	/**
	 * 	Asset loading failed
	 */
	private function assetsFailed_handler(p_asset:GAsset):Void {
		MGDebug.ERROR(p_asset.id);
	}

	/**
	 * 	Asset loading completed
	 */
	private function assetsLoaded_handler():Void {
		GStaticAssetManager.generate();

		initWrapper();
	}

	private function initWrapper():Void {
		var root:GNode = getGenome().root;

		container = new GNode();
		container.cameraGroup = 1;
		root.addChild(container);

		info = new GNode();
		info.cameraGroup = 128;
		root.addChild(info);

		containerCamera = GNode.createWithComponent(GCameraController);
		containerCamera.node.setPosition(400, 300);
		containerCamera.contextCamera.group = 1;
		root.addChild(containerCamera.node);

		var infoCamera:GCameraController = GNode.createWithComponent(GCameraController);
		infoCamera.node.setPosition(400, 300);
		infoCamera.contextCamera.group = 128;
		root.addChild(infoCamera.node);

		//initInfo();

		initExample();
	}

	private function initInfo():Void {
		var text:GText = GNode.createWithComponent(GText);
		text.renderer.textureFont = cast GFontManager.getFont("assets/font");
		text.renderer.fontScale = .5;
		text.node.color = 0xBBBBBB;
		text.width = 400;
		text.hAlign = GHAlignType.LEFT;
		text.node.setPosition(5, 5);
		info.addChild(text.node);
		text.text = "PRESS MOUSE OR ANY KEY FOR NEXT EXAMPLE";
		/**/
		titleText = GNode.createWithComponent(GText);
		titleText.renderer.textureFont = cast GFontManager.getFont("assets/font.fnt");
		titleText.node.setPosition(5, 450);
		titleText.node.color = 0xFFFF00;
		titleText.width = 790;
		titleText.hAlign = GHAlignType.LEFT;
		info.addChild(titleText.node);
		titleText.text = "ABSTRACT";

		detailText = GNode.createWithComponent(GText);
		detailText.renderer.textureFont = cast GFontManager.getFont("assets/font.fnt");
		detailText.renderer.fontScale = .5;
		detailText.node.setPosition(5, 480);
		detailText.width = 790;
		//detailText.hAlign = GHAlignType.LEFT;
		detailText.autoSize = true;
		info.addChild(detailText.node);
		detailText.text = "ABSTRACT";
	}

	public function initExample():Void {

	}

	public function dispose():Void {
		getGenome().root.disposeChildren();
	}
}