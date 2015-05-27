/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package examples.advanced;
import com.genome2d.animation.GFrameAnimation;
import com.genome2d.assets.GAsset;
import com.genome2d.assets.GAssetManager;
import com.genome2d.components.renderable.GSprite;
import com.genome2d.context.filters.GBlurPassFilter;
import com.genome2d.context.filters.GOutlineFilter;
import com.genome2d.context.GContextConfig;
import com.genome2d.debug.GDebug;
import com.genome2d.Genome2D;
import com.genome2d.macros.MGDebug;
import com.genome2d.node.GNode;
import com.genome2d.postprocess.GBlurPP;
import com.genome2d.postprocess.GFilterPP;
import com.genome2d.proto.GPrototypeFactory;
import com.genome2d.proto.GPrototypeHelper;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureManager;
import haxe.rtti.Rtti;

class PostprocessExample
{
    static public function main() {
        var inst = new PostprocessExample();
    }

    /**
        Genome2D singleton instance
     **/
    private var genome:Genome2D;
	private var sprite:GSprite;

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
		GAssetManager.addFromUrl("atlas.png");
        GAssetManager.addFromUrl("atlas.xml");
		GAssetManager.addFromUrl("texture.png");
		GAssetManager.onQueueFailed.add(assetsFailed_handler);
        GAssetManager.onQueueLoaded.addOnce(assetsLoaded_handler);
        GAssetManager.loadQueue();
	}
	
	/**
	 * 	Asset loading failed
	 */
	private function assetsFailed_handler(p_asset:GAsset):Void {
		// Asset loading failed at p_asset
		GDebug.trace("Can't load assets " + p_asset.url);
	}
	
	/**
	 * 	Asset loading completed
	 */
	private function assetsLoaded_handler():Void {
		initExample();
		
		genome.getContext().setBackgroundColor(0xFFFFFF);
	}

    /**
        Initialize Example code
     **/
    private function initExample():Void {
		// Generate textures from all assets, their IDs will be the same as their asset ID
		GAssetManager.generateTextures();

		// Create an animated sprite with rotation and scaling
		sprite = createAnimatedSprite(700, 400);
		sprite.node.name = "test";
        //sprite.node.rotation = 0.753;
        sprite.node.setScale(2,2);
		var filterPP:GFilterPP =  new GFilterPP([new GOutlineFilter(1)]);
		filterPP.setMargins(5, 5, 5, 5);
		sprite.node.postProcess = filterPP;
		
		genome.onUpdate.add(update_handler);
    }
	
	private function update_handler(p_deltaTime:Float):Void {
	//	sprite.node.rotation += .005;
	}

	/**
        Create an animated sprite helper function
     **/
    private function createAnimatedSprite(p_x:Int, p_y:Int):GSprite {
		// To animate a sprite we need a frame animation instance with defined texture frames
		var animation:GFrameAnimation = new GFrameAnimation(GTextureManager.getTextures(["atlas_1", "atlas_2", "atlas_3", "atlas_4", "atlas_5", "atlas_6", "atlas_7"]));
		animation.frameRate = 10;
		
        var sprite:GSprite = GNode.createWithComponent(GSprite);
        sprite.frameAnimation = animation;
        sprite.node.setPosition(p_x, p_y);
		//sprite.node.color = 0x0;
        genome.root.addChild(sprite.node);

        return sprite;
    }
}
