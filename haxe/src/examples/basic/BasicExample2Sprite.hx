/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package examples.basic;

import com.genome2d.context.stats.GStats;
import com.genome2d.node.GNode;
import com.genome2d.textures.GTextureManager;
import com.genome2d.components.renderable.GSprite;
import com.genome2d.assets.GAssetManager;
import com.genome2d.Genome2D;
import com.genome2d.context.GContextConfig;
import com.genome2d.assets.GAssetManager;

class BasicExample2Sprite
{
    static public function main() {
        var inst = new BasicExample2Sprite();
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
        GStats.visible = true;

        genome = Genome2D.getInstance();
        genome.onInitialized.addOnce(genomeInitializedHandler);
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
        GAssetManager.onQueueLoaded.addOnce(assetsLoadedHandler);
        GAssetManager.loadQueue();
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

        var sprite:GSprite;

        sprite = createSprite(300, 200, "atlas_0");

        sprite = createSprite(500, 200, "atlas_0");
        sprite.node.setScale(2,2);

        sprite = createSprite(300, 400, "atlas_0");
        sprite.node.rotation = 0.753;

        sprite = createSprite(500, 400, "atlas_0");
        sprite.node.rotation = 0.753;
        sprite.node.setScale(2,2);

        sprite = createSprite(300, 300, "atlas_0");
        sprite.node.alpha = .5;

        sprite = createSprite(500, 300, "atlas_0");
        sprite.node.color = 0x00FF00;
    }

    /**
        Create a sprite helper function
     **/
    private function createSprite(p_x:Int, p_y:Int, p_textureId:String):GSprite {
		var n:GNode = GNode.create();
        var sprite:GSprite = n.addComponent(GSprite);//GNode.createWithComponent(GSprite);
        sprite.texture = GTextureManager.getTextureById(p_textureId);
        sprite.node.setPosition(p_x, p_y);
        genome.root.addChild(sprite.node);

        return sprite;
    }
}
