/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package examples.basic;

import com.genome2d.assets.GAsset;
import com.genome2d.assets.GAssetManager;
import com.genome2d.components.renderable.GSprite;
import com.genome2d.components.renderable.text.GText;
import com.genome2d.context.GContextConfig;
import com.genome2d.Genome2D;
import com.genome2d.node.GNode;
import com.genome2d.text.GFontManager;
import com.genome2d.text.GTextureTextRenderer;
import com.genome2d.textures.GTextureManager;
import com.genome2d.utils.GHAlignType;
import com.genome2d.utils.GVAlignType;
import flash.display.BitmapData;


class BasicExample5TextureText
{

    static public function main() {
        var inst = new BasicExample5TextureText();
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
		GAssetManager.addFromUrl("font2.png");
        GAssetManager.addFromUrl("font2.fnt");
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
		GTextureManager.createTexture("font2.png", GAssetManager.getImageAssetById("font2.png"));
		
		GFontManager.createTextureFont("font", GTextureManager.getTexture("font2.png"), GAssetManager.getXmlAssetById("font2.fnt").xml);
		
		createText(250, 150, "Hello world.\ntest", GVAlignType.MIDDLE, GHAlignType.CENTER);
    }
	
    private function createText(p_x:Float, p_y:Float, p_text:String, p_vAlign:Int, p_hAlign:Int, p_tracking:Int = 0, p_lineSpace:Int = 0):GText {
        var text:GText = cast GNode.createWithComponent(GText);
		
        text.renderer.textureFont = GFontManager.getFont("font");
        text.width = 300;
        text.height = 300;
        text.text = p_text;
        text.tracking = p_tracking;
        text.lineSpace = p_lineSpace;
        text.vAlign = p_vAlign;
        text.hAlign = p_hAlign;
        text.node.setPosition(p_x, p_y);
		
        genome.root.addChild(text.node);

        return text;
    }
}
