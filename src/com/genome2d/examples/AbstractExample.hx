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
	
	private var info:GNode;
	
	private var titleText:GText;
	
	public var title(default, set):String;
	
	private function set_title(p_value:String):String {
		titleText.text = p_value;
		return title = p_value;
	}
	
	private var detailText:GText;
	
	public var detail(default, set):String;
	
	private function set_detail(p_value:String):String {
		detailText.text = p_value;
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
		genome.init(new GContextConfig());
    }

	/**
        Genome2D failed handler
     **/
    private function genomeFailed_handler(p_msg:String):Void {
        // Here we can check why Genome2D initialization failed
    }
	
    /**
        Genome2D initialized handler
     **/
    private function genomeInitialized_handler():Void {
        loadAssets();
    }
	
	/**	
	 * 	Asset loading
	 */
	private function loadAssets():Void {		
		GAssetManager.addFromUrl("assets/logo_white.png");
		GAssetManager.addFromUrl("assets/atlas.png");
        GAssetManager.addFromUrl("assets/atlas.xml");
		GAssetManager.addFromUrl("assets/texture.png");
		GAssetManager.addFromUrl("assets/font.png");
        GAssetManager.addFromUrl("assets/font.fnt");
		GAssetManager.addFromUrl("assets/button.png");
		GAssetManager.onQueueFailed.add(assetsFailed_handler);
        GAssetManager.onQueueLoaded.addOnce(assetsLoaded_handler);
        GAssetManager.loadQueue();
	}
	
	/**
	 * 	Asset loading failed
	 */
	private function assetsFailed_handler(p_asset:GAsset):Void {
		MGDebug.ERROR();
	}
	
	/**
	 * 	Asset loading completed
	 */
	private function assetsLoaded_handler():Void {
		MGDebug.INFO();
		
		GAssetManager.generate();
		
		init();
	}
	
	private function init():Void {
		
		container = GNode.create();
		container.cameraGroup = 1;
		genome.root.addChild(container);
		
		info = GNode.create();
		info.cameraGroup = 128;
		genome.root.addChild(info);
		
		var containerCamera:GCameraController = GNode.createWithComponent(GCameraController);
		containerCamera.node.setPosition(400, 300);
		containerCamera.contextCamera.mask = 1;
		genome.root.addChild(containerCamera.node);
		
		var infoCamera:GCameraController = GNode.createWithComponent(GCameraController);
		infoCamera.node.setPosition(400, 300);
		infoCamera.contextCamera.mask = 128;
		genome.root.addChild(infoCamera.node);
		
		initInfo();
		
		initExample();
	}
	
	private function initInfo():Void {
		titleText = GNode.createWithComponent(GText);
		titleText.renderer.textureFont = GFontManager.getFont("assets/font");
		titleText.node.setPosition(5, 450);
		titleText.width = 790;
		titleText.hAlign = GHAlignType.LEFT;
		info.addChild(titleText.node);
		titleText.text = "ABSTRACT";
		
		detailText = GNode.createWithComponent(GText);
		detailText.renderer.textureFont = GFontManager.getFont("assets/font");
		detailText.renderer.fontScale = .5;
		detailText.node.setPosition(5, 480);
		detailText.width = 790;
		detailText.hAlign = GHAlignType.LEFT;
		info.addChild(detailText.node);
		detailText.text = "ABSTRACT";
	}
	
	public function initExample():Void {
		
	}
	
	public function dispose():Void {
		genome.root.disposeChildren();
	}
}
