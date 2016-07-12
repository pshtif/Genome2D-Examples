/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.examples;

import com.genome2d.assets.GAsset;
import com.genome2d.assets.GAssetManager;
import com.genome2d.context.GContextConfig;
import com.genome2d.Genome2D;
import com.genome2d.macros.MGDebug;

class AbstractExample
{
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
		GAssetManager.addFromUrl("texture.png");
		
		GAssetManager.addFromUrl("assets/logo_white.png");
		GAssetManager.addFromUrl("assets/atlas.png");
        GAssetManager.addFromUrl("assets/atlas.xml");
		GAssetManager.addFromUrl("assets/texture.png");
		GAssetManager.addFromUrl("assets/font.png");
        GAssetManager.addFromUrl("assets/font.fnt");
		GAssetManager.addFromUrl("assets/button.png");
		GAssetManager.onQueueFailed.add(assetsFailed_handler);
        GAssetManager.onQueueLoaded.addOnce(assetsLoaded_handler);
        GAssetManager.loadQueue();
	}
	
	/**
	 * 	Asset loading failed
	 */
	private function assetsFailed_handler(p_asset:GAsset):Void {
		MGDebug.ERROR();
	}
	
	/**
	 * 	Asset loading completed
	 */
	private function assetsLoaded_handler():Void {
		MGDebug.INFO();
		
		GAssetManager.generate();
		
		initExample();
	}
	
	private function initExample():Void {
		
	}
}
