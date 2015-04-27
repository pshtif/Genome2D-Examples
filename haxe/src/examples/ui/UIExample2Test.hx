/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package examples.ui;

import com.genome2d.assets.GAsset;
import com.genome2d.components.renderable.ui.GUI;
import com.genome2d.input.GMouseInput;
import com.genome2d.node.GNode;
import com.genome2d.textures.GTextureFilteringType;
import com.genome2d.textures.GTextureManager;
import com.genome2d.ui.element.GUIElement;
import com.genome2d.ui.element.GUIInputField;
import com.genome2d.ui.skin.GUIFontSkin;
import com.genome2d.ui.skin.GUITextureSkin;
import com.genome2d.utils.GVAlignType;
import com.genome2d.utils.GHAlignType;
import com.genome2d.assets.GAssetManager;
import flash.events.Event;
import flash.display.StageScaleMode;
import flash.Lib;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureAtlas;
import com.genome2d.geom.GRectangle;
import com.genome2d.textures.GTextureSourceType;
import com.genome2d.textures.GTextureAtlas;
import flash.display.BitmapData;
import com.genome2d.components.GComponent;
import com.genome2d.Genome2D;
import com.genome2d.context.GContextConfig;

class UIExample2Test
{
    static public function main() {
        var inst = new UIExample2Test();
    }

    /**
        Genome2D singleton instance
     **/
    private var genome:Genome2D;
    private var assetManager:GAssetManager;

    public function new() {
        initGenome();
    }

	/**
        Initialize Genome2D
     **/
    private function initGenome():Void {
        genome = Genome2D.getInstance();
        genome.onInitialized.add(genomeInitializedHandler);
        genome.init(new GContextConfig());
    }

	/**
        Genome2D initialized handler
     **/
    private function genomeInitializedHandler():Void {
        initAssets();
    }

	/**
        Initialize assets
     **/
    private function initAssets():Void {
        GAssetManager.addFromUrl("Untitled.png");
		GAssetManager.addFromUrl("font_black\\font.png");
        GAssetManager.addFromUrl("font_black\\font.fnt");
		GAssetManager.addFromUrl("font_white\\font.png");
        GAssetManager.addFromUrl("font_white\\font.fnt");
		GAssetManager.addFromUrl("font.png");
        GAssetManager.addFromUrl("font.fnt");
		GAssetManager.onQueueFailed.add(assetsFailed_handler);
        GAssetManager.onQueueLoaded.add(assetsInitialized_handler);
        GAssetManager.loadQueue();
    }
	
	private function assetsFailed_handler(asset:GAsset):Void {
		trace(asset.url);
	}

    private function assetsInitialized_handler():Void {
        initExample();
    }

    /**
        Genome2D initialized handler
     **/
    private function initExample():Void {
		GTextureManager.defaultFilteringType = GTextureFilteringType.NEAREST;
		GAssetManager.generateTextures();
		
		var cursor:GTexture = GTextureManager.createTextureFromBitmapData("background", new BitmapData(4, 4, false, 0xAAAAAA));		
		
		var backgroundSkin:GUITextureSkin = new GUITextureSkin("background", "background");
		var fontSkin:GUIFontSkin = new GUIFontSkin("font", "font_black\\font.png", 1, false);
		
		var gui:GUI = cast GNode.createWithComponent(GUI);
		gui.node.mouseEnabled = true;
		
		var background:GUIElement = new GUIElement(backgroundSkin);
		background.anchorLeft = 0;
		background.anchorRight = 1;
		background.g2d_pivotY = background.g2d_pivotX = 0;
		background.anchorTop = 0;
		background.top = 380;
		background.anchorBottom = 1;
		gui.root.addChild(background);
		
		var element:GUIInputField = new GUIInputField(fontSkin);
		element.anchorLeft = 0;
		element.anchorRight = 1;
		element.setValue("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer maximus pellentesque lectus, at interdum diam semper et. Morbi eget mi blandit, sollicitudin mi non, cursus tellus.");
		element.g2d_pivotY = element.g2d_pivotX = 0;
		element.anchorTop = 0;
		element.top = 5;
		element.left = element.right = 5;
		element.anchorBottom = 1;
		element.onMouseUp.add(mouseUp_handler);
		background.addChild(element);
		
		genome.root.addChild(gui.node);
    }
	
	private function mouseUp_handler(input:GMouseInput):Void {
		
	}
}
