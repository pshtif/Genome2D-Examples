/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.examples;

import com.genome2d.assets.GAsset;
import com.genome2d.assets.GAssetManager;
import com.genome2d.assets.GStaticAssetManager;
import com.genome2d.components.GCameraController;
import com.genome2d.components.renderable.text.GText;
import com.genome2d.context.GContextConfig;
import com.genome2d.Genome2D;
import com.genome2d.macros.MGDebug;
import com.genome2d.node.GNode;
import com.genome2d.text.GFontManager;
import com.genome2d.utils.GHAlignType;

class AbstractExample
{
    /**
        Genome2D singleton instance
     **/
    private var genome:Genome2D;
	
	private var container:GNode;
	private var containerCamera:GCameraController;
	
	private var info:GNode;
	
	private var titleText:GText;
	
	public var title(default, set):String;
	
	private function set_title(p_value:String):String {
		if (titleText != null) titleText.text = p_value;
		return title = p_value;
	}
	
	private var detailText:GText;
	
	public var detail(default, set):String;
	
	private function set_detail(p_value:String):String {
		if (detailText != null) {
			detailText.text = p_value;
			detailText.renderer.invalidate();
		}
		return detail = p_value;
	}

    public function new(?p_init:Int = 0) {
		genome = Genome2D.getInstance();
		
		switch (p_init) {
			case 0:
				initGenome();
			case 1:
				loadAssets();
			case 2:
				init();
		}
    }

    /**
        Initialize Genome2D
     **/
    private function initGenome():Void {
		genome.onFailed.addOnce(genomeFailed_handler);
		genome.onInitialized.addOnce(genomeInitialized_handler);

		var config:GContextConfig = new GContextConfig();
		config.profile = "baseline";
		config.useRightClick = true;
		genome.init(config);
    }

	/**
        Genome2D failed handler
     **/
    private function genomeFailed_handler(p_msg:String):Void {
        trace("Genome2D initialization failed", p_msg);
    }
	
    /**
        Genome2D initialized handler
     **/
    private function genomeInitialized_handler():Void {
		MGDebug.INFO();
        loadAssets();
    }
	
	/**	
	 * 	Asset loading
	 */
	private function loadAssets():Void {		
		MGDebug.INFO();
		//Spine
		GStaticAssetManager.addFromUrl("assets/spine/spineboy/spineboy-old.atlas");
		GStaticAssetManager.addFromUrl("assets/spine/spineboy/spineboy-old.json");
		GStaticAssetManager.addFromUrl("assets/spine/spineboy/spineboy-old.png", "spineboy");
		
		
		GStaticAssetManager.addFromUrl("assets/logo_white.png");
		GStaticAssetManager.addFromUrl("assets/atlas.png");
        GStaticAssetManager.addFromUrl("assets/atlas.xml");
		GStaticAssetManager.addFromUrl("assets/texture.png");
		GStaticAssetManager.addFromUrl("assets/font.png");
        GStaticAssetManager.addFromUrl("assets/font.fnt");
		GStaticAssetManager.addFromUrl("assets/button.png");
		GStaticAssetManager.addFromUrl("assets/white.png");
		GStaticAssetManager.addFromUrl("assets/water.png");
		GStaticAssetManager.addFromUrl("assets/script.hxs");
        GStaticAssetManager.loadQueue(assetsLoaded_handler, assetsFailed_handler);
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
		MGDebug.INFO();
		
		GStaticAssetManager.generate();
		
		init();
	}
	
	private function init():Void {
		
		container = new GNode();
		container.cameraGroup = 1;
		genome.root.addChild(container);
		
		info = new GNode();
		info.cameraGroup = 128;
		genome.root.addChild(info);
		
		containerCamera = GNode.createWithComponent(GCameraController);
		containerCamera.node.setPosition(400, 300);
		containerCamera.contextCamera.group = 1;
		genome.root.addChild(containerCamera.node);
		
		var infoCamera:GCameraController = GNode.createWithComponent(GCameraController);
		infoCamera.node.setPosition(400, 300);
		infoCamera.contextCamera.group = 128;
		genome.root.addChild(infoCamera.node);
		
		//initInfo();
		
		initExample();
	}

	private function initInfo():Void {
		/*
		var text:GText = GNode.createWithComponent(GText);
		text.renderer.textureFont = GFontManager.getFont("assets/font");
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
		genome.root.disposeChildren();
	}
}
