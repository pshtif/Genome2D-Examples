/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package examples;

import com.genome2d.animation.GFrameAnimation;
import com.genome2d.assets.GAsset;
import com.genome2d.assets.GAssetManager;
import com.genome2d.components.renderable.flash.GFlashText;
import com.genome2d.components.renderable.GSprite;
import com.genome2d.context.GContextConfig;
import com.genome2d.Genome2D;
import com.genome2d.node.GNode;
import com.genome2d.proto.GPrototypeFactory;
import com.genome2d.proto.GPrototypeHelper;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureManager;
import flash.display.BitmapData;
import flash.display3D.Context3DProfile;
import haxe.rtti.Rtti;

class Test
{
    static public function main() {
        var inst = new Test();
    }

    /**
        Genome2D singleton instance
     **/
    private var genome:Genome2D;

    public function new() {
        initGenome();
    }

    /**
        Initialize Genome2D
     **/
    private function initGenome():Void {
		var config:GContextConfig = new GContextConfig();
		config.profile = Context3DProfile.BASELINE_CONSTRAINED;
        genome = Genome2D.getInstance();
		genome.onFailed.addOnce(genomeFailed_handler);
        genome.onInitialized.addOnce(genomeInitialized_handler);
        genome.init(config);
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
		//GAssetManager.addFromUrl("atlas.png");
        //GAssetManager.addFromUrl("atlas.xml");
		//GAssetManager.addFromUrl("texture.png");
		GAssetManager.onQueueFailed.add(assetsFailed_handler);
        GAssetManager.onQueueLoaded.addOnce(assetsLoaded_handler);
        GAssetManager.loadQueue();
	}
	
	/**
	 * 	Asset loading failed
	 */
	private function assetsFailed_handler(p_asset:GAsset):Void {
		// Asset loading failed at p_asset
	}
	
	/**
	 * 	Asset loading completed
	 */
	private function assetsLoaded_handler():Void {
		initExample();
	}

    /**
        Initialize Example code
     **/
    private function initExample():Void {
		// Generate textures from all assets, their IDs will be the same as their asset ID
		GAssetManager.generateTextures();
		
		var texture:GTexture = GTextureManager.createTexture("test", new BitmapData(128, 100, false, 0xFF0000));
		texture.pivotX = -50;
		texture.pivotY = -50;
		trace(texture.height);
		
		var a:GFlashText;
		
        var sprite:GSprite = createSprite(100, 100, "test");
		
    }

    /**
        Create a sprite helper function
     **/
    private function createSprite(p_x:Int, p_y:Int, p_textureId:String):GSprite {
		// Create a node with sprite component
        var sprite:GSprite = GNode.createWithComponent(GSprite);
        sprite.texture = GTextureManager.getTexture(p_textureId);
        sprite.node.setPosition(p_x, p_y);
        genome.root.addChild(sprite.node);

        return sprite;
    }
}
