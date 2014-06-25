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
import com.genome2d.context.GContextConfig;
import com.genome2d.components.renderables.GTextureText;
import com.genome2d.components.renderables.GTextureText;
import com.genome2d.components.renderables.GTextureTextAlignType;
import com.genome2d.components.renderables.GTextureText;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.textures.factories.GTextureAtlasFactory;
import com.genome2d.Genome2D;
import com.genome2d.context.GContextConfig;
import com.genome2d.textures.GTextureAtlas;

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
        assetManager = new GAssetManager();
        assetManager.addUrl("font_gfx", "font.png");
        assetManager.addUrl("font_xml", "font.fnt");
        assetManager.onAllLoaded.add(assetsInitializedHandler);
        assetManager.load();
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
        GTextureAtlasFactory.createFontFromAssets("font", assetManager.getImageAssetById("font_gfx"), assetManager.getXmlAssetById("font_xml"));

        var text:GTextureText;

        //text = createText(200, 300, "font", "Hello Genome2D world.", GTextureTextAlignType.MIDDLE, 0);
        text = createText(200, 300, "font", "in", GTextureTextAlignType.MIDDLE, 0);

        text = createText(600, 300, "font", "Hello Genome2D\nin awesome\nmultiline text.", GTextureTextAlignType.MIDDLE, 0, 0);
        text.node.transform.rotation = 0.753;
    }

    private function createText(p_x:Float, p_y:Float, p_textureAtlasId:String, p_text:String, p_align:Int, p_tracking:Int = 0, p_lineSpace:Int = 0):GTextureText {
        var text:GTextureText = cast GNodeFactory.createNodeWithComponent(GTextureText);
        text.textureAtlasId = p_textureAtlasId;
        text.text = p_text;
        text.tracking = p_tracking;
        text.lineSpace = p_lineSpace;
        text.align = p_align;
        text.node.transform.setPosition(p_x, p_y);
        genome.root.addChild(text.node);
        return text;
    }
}
