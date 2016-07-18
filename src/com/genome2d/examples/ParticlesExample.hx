/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.examples;

import com.genome2d.examples.custom.ParticleModule;
import com.genome2d.assets.GAssetManager;
import com.genome2d.components.renderable.particles.GParticleSystemComponent;
import com.genome2d.deprecated.components.renderable.particles.GSimpleParticleSystemD;
import com.genome2d.geom.GCurve;
import com.genome2d.input.GMouseInput;
import com.genome2d.input.GMouseInputType;
import com.genome2d.node.GNode;
import com.genome2d.particles.GParticleEmitter;
import com.genome2d.textures.GTextureManager;

class ParticlesExample extends AbstractExample
{

    static public function main() {
        var inst = new ParticlesExample();
    }

    /**
        Initialize Example code
     **/
    override private function initExample():Void {
		label = "PARTICLES EXAMPLE";
		
		var emitter:GParticleEmitter = new GParticleEmitter();
		emitter.texture = GTextureManager.getTexture("assets/atlas_particle");
		emitter.rate = new GCurve(50);
		emitter.duration = 10;
		emitter.loop = true;
		emitter.addModule(new ParticleModule());
		
		// Create a node with simple particle system component
        var particleSystem:GParticleSystemComponent = GNode.createWithComponent(GParticleSystemComponent);
		particleSystem.addEmitter(emitter);
		particleSystem.node.setPosition(400, 300);
		container.addChild(particleSystem.node);
    }
}
