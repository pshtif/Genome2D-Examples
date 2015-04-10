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
import com.genome2d.components.renderables.GSprite;
import com.genome2d.context.GContextConfig;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.callbacks.GNodeMouseSignal;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.factories.GTextureAtlasFactory;

import flash.display.MovieClip;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

[SWF(width="800", height="600", backgroundColor="#000000", frameRate="60")]
public class BasicExample4Mouse extends MovieClip
{
    /**
        Genome2D singleton instance
     **/
    private var genome:Genome2D;

    /**
        Asset manager instance for loading assets
     **/
    private var assetManager:GAssetManager;

    public function BasicExample4Mouse() {
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
        assetManager.addUrl("atlas_gfx", "atlas.png");
        assetManager.addUrl("atlas_xml", "atlas.xml");
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
        GTextureAtlasFactory.createFromAssets("atlas", assetManager.getImageAssetById("atlas_gfx"), assetManager.getXmlAssetById("atlas_xml"));

        var sprite:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        sprite.texture = GTexture.getTextureById("atlas_0");
        sprite.node.transform.setPosition(400, 300);

        sprite.node.mouseEnabled = true;
        sprite.node.onMouseClick.add(mouseClickHandler);
        sprite.node.onMouseOver.add(mouseOverHandler);
        sprite.node.onMouseOut.add(mouseOutHandler);
        sprite.node.onMouseDown.add(mouseDownHandler);
        sprite.node.onMouseUp.add(mouseUpHandler);

        Genome2D.getInstance().root.addChild(sprite.node);
    }

    /**
        Mouse click handler
     **/
    private function mouseClickHandler(signal:GNodeMouseSignal):void {
        trace("CLICK", signal.dispatcher.name, signal.target.name);
    }

    /**
        Mouse over handler
     **/
    private function mouseOverHandler(signal:GNodeMouseSignal):void {
        trace("OVER", signal.dispatcher.name, signal.target.name);
    }

    /**
        Mouse out handler
     **/
    private function mouseOutHandler(signal:GNodeMouseSignal):void {
        trace("OUT", signal.dispatcher.name, signal.target.name);
    }

    /**
        Mouse down handler
     **/
    private function mouseDownHandler(signal:GNodeMouseSignal):void {
        trace("DOWN", signal.dispatcher.name, signal.target.name);
    }

    /**
        Mouse up handler
     **/
    private function mouseUpHandler(signal:GNodeMouseSignal):void {
        trace("UP", signal.dispatcher.name, signal.target.name);
    }
}
}
