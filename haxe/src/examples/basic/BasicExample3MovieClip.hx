/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package examples.basic;

import com.genome2d.node.GNode;
import com.genome2d.textures.GTextureManager;
import com.genome2d.components.renderable.GMovieClip;
import com.genome2d.Genome2D;
import com.genome2d.context.GContextConfig;
import com.genome2d.textures.GTextureAtlas;
import com.genome2d.assets.GAssetManager;

class BasicExample3MovieClip
{
    static public function main() {
        var inst = new BasicExample3MovieClip();
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
        GAssetManager.addFromUrl("atlas.png");
        GAssetManager.addFromUrl("atlas.xml");
        GAssetManager.loadQueue(assetsLoadedHandler);
    }

    /**
         Assets initialization handler dispatched after all assets were initialized
     **/
    private function assetsLoadedHandler():Void {
        initExample();
    }

    /**
         Initialize Example code
     **/
    private function initExample():Void {
        GTextureManager.createAtlasFromAssetIds("atlas", "atlas.png", "atlas.xml");

        var clip:GMovieClip;

        clip = createMovieClip(300,200, ["atlas_1","atlas_2","atlas_3","atlas_4","atlas_5","atlas_6","atlas_7"]);

        clip = createMovieClip(500,200, ["atlas_1","atlas_2","atlas_3","atlas_4","atlas_5","atlas_6","atlas_7"]);
        clip.node.transform.setScale(2,2);

        clip = createMovieClip(300,400, ["atlas_1","atlas_2","atlas_3","atlas_4","atlas_5","atlas_6","atlas_7"]);
        clip.node.transform.rotation = 0.753;

        clip = createMovieClip(500,400, ["atlas_1","atlas_2","atlas_3","atlas_4","atlas_5","atlas_6","atlas_7"]);
        clip.node.transform.rotation = 0.753;
        clip.node.transform.setScale(2,2);

        clip = createMovieClip(300,300, ["atlas_1","atlas_2","atlas_3","atlas_4","atlas_5","atlas_6","atlas_7"]);
        clip.node.transform.alpha = .5;

        clip = createMovieClip(500,300, ["atlas_1","atlas_2","atlas_3","atlas_4","atlas_5","atlas_6","atlas_7"]);
        clip.node.transform.color = 0x00FF00;
    }

    private function createMovieClip(p_x:Float, p_y:Float, p_frames:Array<String>):GMovieClip {
        var clip:GMovieClip = cast GNode.createNodeWithComponent(GMovieClip);
        clip.frameRate = 10;
        clip.frameTextureIds = p_frames;
        clip.node.transform.setPosition(p_x, p_y);
        genome.root.addChild(clip.node);
        return clip;
    }
}
