/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package examples.basic;

import com.genome2d.animation.GFrameAnimation;
import com.genome2d.context.stats.GStats;
import com.genome2d.geom.GRectangle;
import com.genome2d.node.GNode;
import com.genome2d.textures.GTexture;
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
		GAssetManager.addFromUrl("Untitled.png");
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
        //GTextureManager.createAtlasFromAssetIds("atlas", "atlas.png", "atlas.xml");
		var atlas:GTexture = GTextureManager.createTextureFromAssetId("Untitled", "Untitled.png");
		var texture:GTexture = new GTexture("test", atlas);
		texture.region = new GRectangle(0, 0, 32, 32);

        var sprite:GSprite;

        sprite = createSprite(100, 200, "Untitled");

        sprite = createSprite(300, 200, "test");
        sprite.node.setScale(2,2);

        sprite = createSprite(100, 400, "atlas_0");
        sprite.node.rotation = 0.753;

        sprite = createSprite(300, 400, "atlas_0");
        sprite.node.rotation = 0.753;
        sprite.node.setScale(2,2);

        sprite = createSprite(100, 300, "atlas_0");
        sprite.node.alpha = .5;

        sprite = createSprite(300, 300, "atlas_0");
        sprite.node.color = 0x00FF00;
		
		sprite = createAnimatedSprite(500, 200);

        sprite = createAnimatedSprite(700, 200);
        sprite.node.setScale(2,2);

        sprite = createAnimatedSprite(500, 400);
        sprite.node.rotation = 0.753;

        sprite = createAnimatedSprite(700, 400);
        sprite.node.rotation = 0.753;
        sprite.node.setScale(2,2);

        sprite = createAnimatedSprite(500, 300);
        sprite.node.alpha = .5;

        sprite = createAnimatedSprite(700, 300);
        sprite.node.color = 0x00FF00;
    }

    /**
        Create a sprite helper function
     **/
    private function createSprite(p_x:Int, p_y:Int, p_textureId:String):GSprite {
        var sprite:GSprite = GNode.createWithComponent(GSprite);
        sprite.texture = GTextureManager.getTextureById(p_textureId);
        sprite.node.setPosition(p_x, p_y);
        genome.root.addChild(sprite.node);

        return sprite;
    }
	
	/**
        Create an animated sprite helper function
     **/
    private function createAnimatedSprite(p_x:Int, p_y:Int):GSprite {
		var animation:GFrameAnimation = new GFrameAnimation(GTextureManager.getTexturesByIds(["atlas_1", "atlas_2", "atlas_3", "atlas_4", "atlas_5", "atlas_6", "atlas_7"]));
		animation.frameRate = 10;
        var sprite:GSprite = GNode.createWithComponent(GSprite);
        sprite.frameAnimation = animation;
        sprite.node.setPosition(p_x, p_y);
        genome.root.addChild(sprite.node);

        return sprite;
    }
}
