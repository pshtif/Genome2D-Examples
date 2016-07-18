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
	
	private var labelText:GText;
	
	public var label(default, set):String;
	
	private function set_label(p_value:String):String {
		labelText.text = p_value;
		return label = p_value;
	}

    public function new() {
        initGenome();
    }

    /**
        Initialize Genome2D
     **/
    private function initGenome():Void {
        genome = Genome2D.getInstance();
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
		
		initLabel();
		
		initExample();
	}
	
	private function initLabel():Void {
		labelText = GNode.createWithComponent(GText);
		labelText.renderer.textureFont = GFontManager.getFont("assets/font");
		labelText.node.setPosition(0, 500);
		labelText.width = 800;
		labelText.hAlign = GHAlignType.CENTER;
		info.addChild(labelText.node);
		labelText.text = "ABSTRACT";
	}
	
	private function initExample():Void {
		
	}
}
