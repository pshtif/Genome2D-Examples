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
import com.genome2d.input.GMouseInput;
import com.genome2d.input.GMouseInputType;
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
		particleSystem.emissionTime = 1;
		particleSystem.emissionDelay = 1;
        particleSystem.emit = true;
        particleSystem.energy = 5;
		particleSystem.dispersionAngleVariance = Math.PI*2;
        particleSystem.initialVelocity = 20;
        particleSystem.initialVelocityVariance = 40;
        particleSystem.initialAngleVariance = 5;
        particleSystem.endAlpha = 0;
        particleSystem.initialScale = 2;
        particleSystem.endScale = .2;
		particleSystem.useWorldSpace = true;
		particleSystem.node.setPosition(200, 300);
		genome.root.addChild(particleSystem.node);
		
		particleSystem2 = GNode.createWithComponent(GSimpleParticleSystem);
        particleSystem2.texture = GTextureManager.getTexture("atlas_particle");
        particleSystem2.emission = 1128;
        //particleSystem.emit = true;
        particleSystem2.energy = 5;
		particleSystem2.dispersionAngleVariance = Math.PI*2;
        particleSystem2.initialVelocity = 20;
        particleSystem2.initialVelocityVariance = 40;
        particleSystem2.initialAngleVariance = 5;
        particleSystem2.endAlpha = 0;
        particleSystem2.initialScale = 2;
        particleSystem2.endScale = .2;
		
		particleSystem2.useWorldSpace = true;
		particleSystem2.node.setPosition(600, 300);
		genome.root.addChild(particleSystem2.node);
		
		//particleSystem2.initialRed = 1;
		//particleSystem2.initialGreen = 0;
		//particleSystem2.initialBlue = 0;
		particleSystem2.initialColor = 0xFF0000;
		
		genome.getContext().onMouseInput.add(mouse_handler);
    }
	
	private var particleSystem2:GSimpleParticleSystem;
	
	private function mouse_handler(input:GMouseInput):Void {
		if (input.type == GMouseInputType.MOUSE_DOWN) {
			particleSystem2.forceBurst();
		} else if (input.type == GMouseInputType.MOUSE_MOVE) {
			particleSystem.node.setPosition(input.contextX, input.contextY);
		}
	}
}
