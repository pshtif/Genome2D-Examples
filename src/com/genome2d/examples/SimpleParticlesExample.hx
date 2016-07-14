/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.examples;

import com.genome2d.assets.GAssetManager;
import com.genome2d.deprecated.components.renderable.particles.GSimpleParticleSystemD;
import com.genome2d.input.GMouseInput;
import com.genome2d.input.GMouseInputType;
import com.genome2d.node.GNode;
import com.genome2d.textures.GTextureManager;

class SimpleParticlesExample extends AbstractExample
{

    static public function main() {
        var inst = new SimpleParticlesExample();
    }
	
	private var particleSystem:GSimpleParticleSystemD;

    /**
        Initialize Example code
     **/
    override private function initExample():Void {
		// Create a node with simple particle system component
        particleSystem = GNode.createWithComponent(GSimpleParticleSystemD);
        particleSystem.texture = GTextureManager.getTexture("assets/atlas_particle");
        particleSystem.emission = 128;
		particleSystem.emissionTime = 1;
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
		particleSystem.node.setPosition(400, 300);
		genome.root.addChild(particleSystem.node);
    }
}
