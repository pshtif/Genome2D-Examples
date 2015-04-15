/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package examples.ui;

import com.genome2d.components.renderable.ui.GUI;
import com.genome2d.input.GMouseInput;
import com.genome2d.node.GNode;
import com.genome2d.ui.element.GUIElement;
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
        GAssetManager.onQueueLoaded.add(assetsInitializedHandler);
        GAssetManager.loadQueue();
    }

    private function assetsInitializedHandler():Void {
        initExample();
    }

    /**
        Genome2D initialized handler
     **/
    private function initExample():Void {
		GAssetManager.generateTextures();
		
		var skin:GUITextureSkin = new GUITextureSkin("logo","Untitled.png");
		
		var gui:GUI = cast GNode.createWithComponent(GUI);
		gui.node.mouseEnabled = true;
		
		var element:GUIElement = new GUIElement(skin);
		element.anchorLeft = element.anchorRight = .5;
		element.g2d_pivotY = element.g2d_pivotX = element.anchorTop = element.anchorBottom = .5;
		element.onMouseUp.add(mouseUp_handler);
		gui.root.addChild(element);
		
		genome.root.addChild(gui.node);
    }
	
	private function mouseUp_handler(input:GMouseInput):Void {
		trace("here");
	}
}
