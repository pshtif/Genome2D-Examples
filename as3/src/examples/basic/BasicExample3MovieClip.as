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
import com.genome2d.components.renderables.GMovieClip;
import com.genome2d.context.GContextConfig;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.textures.factories.GTextureAtlasFactory;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

[SWF(width="800", height="600", backgroundColor="#000000", frameRate="60")]
public class BasicExample3MovieClip extends Sprite
{
    /**
         Genome2D singleton instance
     **/
    private var genome:Genome2D;

    /**
        Asset manager instance for loading assets
     **/
    private var assetManager:GAssetManager;

    public function BasicExample3MovieClip() {
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

        var clip:GMovieClip;

        // Create top left movieclip without any transformation
        clip = createMovieClip(300, 200, ["atlas_1","atlas_2","atlas_3","atlas_4","atlas_5","atlas_6","atlas_7"]);

        // Create top right movieclip with scale
        clip = createMovieClip(500, 200, ["atlas_1","atlas_2","atlas_3","atlas_4","atlas_5","atlas_6","atlas_7"]);
        clip.node.transform.setScale(2,2);

        // Create bottom left movieclip with rotation
        clip = createMovieClip(300, 400, ["atlas_1","atlas_2","atlas_3","atlas_4","atlas_5","atlas_6","atlas_7"]);
        clip.node.transform.rotation = 0.753;

        // Create bottom right movieclip with scale and rotation
        clip = createMovieClip(500, 400, ["atlas_1","atlas_2","atlas_3","atlas_4","atlas_5","atlas_6","atlas_7"]);
        clip.node.transform.rotation = 0.754;
        clip.node.transform.setScale(2,2);

        // Create middle left movieclip with alpha
        clip = createMovieClip(300, 300, ["atlas_1","atlas_2","atlas_3","atlas_4","atlas_5","atlas_6","atlas_7"]);
        clip.node.transform.alpha = .5;

        // Create middle right movieclip with tint
        clip = createMovieClip(500, 300, ["atlas_1","atlas_2","atlas_3","atlas_4","atlas_5","atlas_6","atlas_7"]);
        clip.node.transform.color = 0x00FF00;
    }

    /**
        Create a movie clip helper function
    **/
    private function createMovieClip(p_x:int, p_y:int, p_frames:Array):GMovieClip {
        // Create a node with sprite component
        var clip:GMovieClip = GNodeFactory.createNodeWithComponent(GMovieClip) as GMovieClip;
        // Assign animation frames
        clip.frameTextureIds = p_frames;
        clip.frameRate = 10;
        // Set transform position for this node
        clip.node.transform.setPosition(p_x, p_y);
        // Add the node to root of the render graph
        genome.root.addChild(clip.node);

        return clip;
    }
}
}
