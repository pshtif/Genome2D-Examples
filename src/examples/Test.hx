/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package examples;

import com.genome2d.assets.GAsset;
import com.genome2d.assets.GAssetManager;
import com.genome2d.components.renderable.flash.GFlashText;
import com.genome2d.components.renderable.GSprite;
import com.genome2d.context.GContextConfig;
import com.genome2d.context.stage3d.GShaderCode;
import com.genome2d.context.stage3d.renderers.GBufferRenderer;
import com.genome2d.context.stats.GStats;
import com.genome2d.Genome2D;
import com.genome2d.node.GNode;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureManager;
import flash.display.BitmapData;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.display3D.Context3DProfile;
import flash.Lib;
import flash.Vector;

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
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		
        initGenome();
    }

    /**
        Initialize Genome2D
     **/
    private function initGenome():Void {
		GStats.visible = true;
		
		GStats.customStats = [Std.string(Lib.current.stage.stageWidth), Std.string(Lib.current.stage.stageHeight)];
		var config:GContextConfig = new GContextConfig();
		//config.profile = Context3DProfile.BASELINE_CONSTRAINED;
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
	private var renderer:GBufferRenderer;
    private function initExample():Void {
		// Generate textures from all assets, their IDs will be the same as their asset ID
		GAssetManager.generateTextures();
		
		renderer = new GBufferRenderer(genome.getContext());
		renderer.setFragmentProgram(GShaderCode.FRAGMENT_FINAL_VARYING_CODE);
		renderer.setVertexProgram(GShaderCode.VERTEX_COLOR_CODE);
		var indices:Vector<UInt> = new Vector<UInt>();
		indices.push(0);
		indices.push(1);
		indices.push(2);
		renderer.setIndexBuffer(indices);
		renderer.setVertexBuffer(Vector.ofArray([100, 100.0, 0, 0, 1, 1, 200, 100, 0, 1, 0, 1, 100, 200, 1, 0, 0, 1]), [2, 4]);
		
		genome.onPostRender.add(postRender_handler);
    }
	
	private function postRender_handler():Void {
		genome.getContext().bindRenderer(renderer);
	}
}
