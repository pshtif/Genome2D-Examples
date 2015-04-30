/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package examples.basic;

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

    /**
        Asset manager instance for loading assets
     **/
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
        GAssetManager.addFromUrl("font.png");
        GAssetManager.addFromUrl("font.fnt");
        GAssetManager.onQueueLoaded.addOnce(assetsInitializedHandler);
        GAssetManager.loadQueue();
    }

    /**
        Assets initialization handler dispatched after all assets were initialized
     **/
    private function assetsInitializedHandler():Void {
        initExample();
    }

    /**
        Initialize Example code
     **/
    private function initExample():Void {
		GTextureManager.createTexture("font.png", GAssetManager.getImageAssetById("font.png"));
		
		var sprite:GSprite = GNode.createWithComponent(GSprite);
		sprite.texture = GTextureManager.getTexture("font.png");
		sprite.node.setPosition(400, 300);
		//genome.root.addChild(sprite.node);
		
		GFontManager.createTextureFont("font", GTextureManager.getTexture("font.png"), GAssetManager.getXmlAssetById("font.fnt").xml);
		
		createText(100, 100, "Hello", GVAlignType.TOP, GHAlignType.LEFT);
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
