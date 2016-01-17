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
import com.genome2d.components.GCameraController;
import com.genome2d.components.renderable.GSprite;
import com.genome2d.context.GContextConfig;
import com.genome2d.debug.GDebug;
import com.genome2d.Genome2D;
import com.genome2d.macros.MGDebug;
import com.genome2d.node.GNode;
import com.genome2d.proto.GPrototypeFactory;
import com.genome2d.proto.GPrototypeHelper;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureManager;

class CameraRenderTexture
{
    static public function main() {
        var inst = new CameraRenderTexture();
    }

    /**
        Genome2D singleton instance
     **/
    private var genome:Genome2D;
	private var camera1:GCameraController;
	private var camera2:GCameraController;
	private var renderTexture:GTexture;
	private var container1:GNode;
	private var container2:GNode;

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
	}

    /**
        Initialize Example code
     **/
    private function initExample():Void {
		// Generate textures from all assets, their IDs will be the same as their asset ID
		GAssetManager.generateTextures();
		
		// Create render texture for out Camera 1 target
		renderTexture = GTextureManager.createRenderTexture("render", 800, 600);
		
		// Create Camera 1 which will render to a texture
		camera1 = GNode.createWithComponent(GCameraController);
		camera1.node.setPosition(400, 300);
		camera1.contextCamera.mask = 1;
		camera1.renderTarget = renderTexture;
		genome.root.addChild(camera1.node);
		
		// Create Camera 2 which will render to the backbuffer
		camera2 = GNode.createWithComponent(GCameraController);
		camera2.node.setPosition(400, 300);
		camera2.contextCamera.mask = 2;
		genome.root.addChild(camera2.node);
				
		// Create Container 1 this will contain all nodes we want to render with Camera 1 to a texture
		container1 = GNode.create();
		container1.cameraGroup = 1;
		genome.root.addChild(container1);
        
		var sprite:GSprite;
		for (i in 0...500) {
			createSprite(100+Math.random()*600, 100+Math.random()*400, "atlas_"+Std.int(Math.random()*7), container1);
		}
		
		// Create Container 2 which will containe stuff we want to render to a back buffer with Camera 2
		container2 = GNode.create();
		container2.cameraGroup = 2;
		genome.root.addChild(container2);
		// Create a sprite that will use the render texture rendered with Camera 1
		createSprite(400, 300, "render", container2);
    }

    /**
        Create a sprite helper function
     **/
    private function createSprite(p_x:Float, p_y:Float, p_textureId:String, p_parent:GNode):GSprite {
		// Create a node with sprite component
        var sprite:GSprite = GNode.createWithComponent(GSprite);
        sprite.texture = GTextureManager.getTexture(p_textureId);
        sprite.node.setPosition(p_x, p_y);
        p_parent.addChild(sprite.node);

        return sprite;
    }
}
