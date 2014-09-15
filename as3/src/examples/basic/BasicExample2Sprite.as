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
import com.genome2d.textures.factories.GTextureAtlasFactory;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.geom.Rectangle;

[SWF(width="800", height="600", backgroundColor="#000000", frameRate="60")]
public class BasicExample2Sprite extends Sprite
{
    /**
        Genome2D singleton instance
     **/
    private var genome:Genome2D;

    /**
        Asset manager instance for loading assets
     **/
    private var assetManager:GAssetManager;

    public function BasicExample2Sprite() {
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

        // Create top left sprite without any transformation
        var sprite:GSprite;

        sprite = createSprite(300, 200, "atlas_0");

        // Create top right sprite with scale
        sprite = createSprite(500, 200, "atlas_0");
        sprite.node.transform.setScale(2,2);

        // Create bottom left sprite with rotation
        sprite = createSprite(300, 400, "atlas_0");
        sprite.node.transform.rotation = 0.753;

        // Create bottom right sprite with scale and rotation
        sprite = createSprite(500, 400, "atlas_0");
        sprite.node.transform.rotation = 0.753;
        sprite.node.transform.setScale(2,2);

        // Create middle left sprite with alpha
        sprite = createSprite(300, 300, "atlas_0");
        sprite.node.transform.alpha = .5;

        // Create middle right sprite with color tint
        sprite = createSprite(500, 300, "atlas_0");
        sprite.node.transform.color = 0x00FF00;

        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.addEventListener(Event.RESIZE, stageResizeHandler);
    }

    private function stageResizeHandler(event:Event):void {
        trace("resize");
        genome.getContext().resize(new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight));
    }

    /**
        Create a sprite helper function
     **/
    private function createSprite(p_x:int, p_y:int, p_textureId:String):GSprite {
        // Create a node with sprite component
        var sprite:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        // Assign a texture to the sprite based on the texture ID
        sprite.textureId = p_textureId;
        // Set transform position for this node
        sprite.node.transform.setPosition(p_x, p_y);
        // Add the node to root of the render graph
        genome.root.addChild(sprite.node);

        return sprite;
    }
}
}
