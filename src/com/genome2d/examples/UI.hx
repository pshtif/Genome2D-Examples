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
import com.genome2d.components.renderable.GSprite;
import com.genome2d.components.renderable.text.GText;
import com.genome2d.components.renderable.ui.GUI;
import com.genome2d.context.GContextConfig;
import com.genome2d.Genome2D;
import com.genome2d.node.GNode;
import com.genome2d.text.GFontManager;
import com.genome2d.text.GTextFormat;
import com.genome2d.text.GTextureTextRenderer;
import com.genome2d.textures.GTextureManager;
import com.genome2d.ui.element.GUIElement;
import com.genome2d.ui.skin.GUIFontSkin;
import com.genome2d.ui.skin.GUITextureSkin;
import com.genome2d.utils.GHAlignType;
import com.genome2d.utils.GVAlignType;


class UI
{

    static public function main() {
        var inst = new UI();
    }

    /**
        Genome2D singleton instance
     **/
    private var genome:Genome2D;

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
		// Asset loading failed at p_asset
	}

	/**
	 * 	Asset loading completed
	 */
	private function assetsLoaded_handler():Void {
		initExample();
	}

    /**
        Initialize Example code
     **/
    private function initExample():Void {
		GAssetManager.generateTextures();		
		
		var gui:GUI = GNode.createWithComponent(GUI);
		genome.root.addChild(gui.node);
		
		var textureSkin:GUITextureSkin = new GUITextureSkin("texture", GTextureManager.getTexture("assets/button"));
		textureSkin.sliceLeft = 10;
		textureSkin.sliceRight = 35;
		textureSkin.sliceTop = 10;
		textureSkin.sliceBottom = 35;
		
		var textureElement:GUIElement = new GUIElement(textureSkin);
		textureElement.anchorLeft = 0;
		textureElement.anchorRight = 1;
		gui.root.addChild(textureElement);
		
		var fontSkin:GUIFontSkin = new GUIFontSkin("font", GFontManager.getFont("assets/font"));
		fontSkin.color = 0xFF0000;
		fontSkin.autoSize = true;
		
		var fontElement:GUIElement = new GUIElement(fontSkin);
		fontElement.setModel("HELLO WORLD");
		fontElement.setAlign(5);
		textureElement.addChild(fontElement);
		
    }
}
