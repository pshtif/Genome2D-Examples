/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package examples.basic {

import com.genome2d.Genome2D;
import com.genome2d.assets.GAssetManager;
import com.genome2d.components.renderables.text.GTextureText;
import com.genome2d.context.GContextConfig;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.textures.factories.GTextureAtlasFactory;
import com.genome2d.utils.GHAlignType;
import com.genome2d.utils.GVAlignType;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

[SWF(width="800", height="600", backgroundColor="#000000", frameRate="60")]
public class BasicExample5TextureText extends Sprite
{
    /**
        Genome2D singleton instance
     **/
    private var genome:Genome2D;

    /**
        Asset manager instance for loading assets
     **/
    private var assetManager:GAssetManager;

    public function BasicExample5TextureText() {
        if (stage != null) addedToStageHandler(null);
        else addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
    }

    private function addedToStageHandler(event:Event):void {
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

        initGenome();
    }

    /**
        Initialize Genome2D
     **/
    private function initGenome():void {
        // Get the Genome2D instance
        genome = Genome2D.getInstance();
        // Add a callback for Genome2D initialization
        genome.onInitialized.addOnce(genomeInitializedHandler);
        // Initialize Genome2D
        genome.init(new GContextConfig(stage));
    }

    /**
        Genome2D initialized handler
     **/
    private function genomeInitializedHandler():void {
        initAssets();
    }

    /**
        Initialize assets
     **/
    private function initAssets():void {
        assetManager = new GAssetManager();
        assetManager.addUrl("font_gfx", "font.png");
        assetManager.addUrl("font_xml", "font.fnt");
        assetManager.onAllLoaded.add(assetsInitializedHandler);
        assetManager.load();
    }

    /**
        Assets initialization handler dispatched after all assets were initialized
     **/
    private function assetsInitializedHandler():void {
        initExample();
    }

    /**
        Initialize Example code
     **/
    private function initExample():void {
        // Create our assets atlas
        GTextureAtlasFactory.createFontFromAssets("font", assetManager.getImageAssetById("font_gfx"), assetManager.getXmlAssetById("font_xml"));

        var text:GTextureText;

        text = createText(150, 200, "font", "Hello Genome2D world.", GVAlignType.MIDDLE, GHAlignType.LEFT, 0);

        text = createText(550, 200, "font", "Hello Genome2D\nin awesome\nmultiline text.", GVAlignType.MIDDLE, GHAlignType.CENTER, 0, 0);
        text.node.transform.rotation = 0.753;
    }

    private function createText(p_x:Number, p_y:Number, p_textureAtlasId:String, p_text:String, p_vAlign:int, p_hAlign:int, p_tracking:int = 0, p_lineSpace:int = 0):GTextureText {
        // Create our textures text components
        var text:GTextureText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
        // Specify the atlas where the font textures are
        text.textureAtlasId = p_textureAtlasId;
        // Specify the text width
        text.width = 200;
        // Specify the text height
        text.height = 200;
        // Specify the text being rendered
        text.text = p_text;
        // Specify character tracking
        text.tracking = p_tracking;
        // Specify line spacing
        text.lineSpace = p_lineSpace;
        // Specify the vertical alignment of the text
        text.vAlign = p_vAlign;
        // Specify the horizontal alignment of the text
        text.hAlign = p_hAlign;
        // Set the position of our components
        text.node.transform.setPosition(p_x, p_y);
        // Add it to the render list
        Genome2D.getInstance().root.addChild(text.node);
        return text;
    }
}
}
