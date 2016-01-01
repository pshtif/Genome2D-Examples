/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package examples.basic;

import com.genome2d.assets.GAsset;
import com.genome2d.components.renderable.particles.GSimpleParticleSystem;
import com.genome2d.context.stats.GStats;
import com.genome2d.input.GKeyboardInput;
import com.genome2d.input.GKeyboardInputType;
import com.genome2d.node.GNode;
import com.genome2d.Genome2D;
import com.genome2d.context.GContextConfig;
import com.genome2d.assets.GAssetManager;
import com.genome2d.textures.GTextureManager;
import motion.Actuate;
import motion.easing.Linear;

class BasicExample6Particles
{

    static public function main() {
        var inst = new BasicExample6Particles();
    }

    /**
        Genome2D singleton instance
     **/
    private var genome:Genome2D;
	
	private var particleSystem:GSimpleParticleSystem;

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
        GAssetManager.generateTextures();

		// Create a node with simple particle system component
        particleSystem = GNode.createWithComponent(GSimpleParticleSystem);
        particleSystem.texture = GTextureManager.getTexture("atlas_particle");
        particleSystem.emission = 128;
        particleSystem.emit = true;
        particleSystem.dispersionAngleVariance = Math.PI*2;
        particleSystem.energy = 5;
        particleSystem.initialVelocity = 20;
        particleSystem.initialVelocityVariance = 40;
        particleSystem.initialAngleVariance = 5;
        particleSystem.endAlpha = 0;
        particleSystem.initialScale = 2;
        particleSystem.endScale = .2;
        particleSystem.node.setPosition(100, 300);
		particleSystem.useWorldSpace = true;
		Genome2D.getInstance().root.addChild(particleSystem.node);
    }
}
