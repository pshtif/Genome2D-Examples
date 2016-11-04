/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.examples;

import com.genome2d.proto.GPrototypeFactory;
import com.genome2d.proto.parsers.GXmlPrototypeParser;
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
    override public function initExample():Void {
		title = "PARTICLES EXAMPLE";
		detail = "To achieve more complex particle systems Genome2D offers fully customizable particle systems using both spawn and update modules.";

		var xml:Xml = Xml.parse('<particle_emitter enableSph="false" useWorldSpace="true" emit="true" delay="0" delayVariance="0" duration="2" loop="true" durationVariance="0" texture="@assets/atlas.png_particle"><p:rate><GCurve path="50,1,0"/></p:rate><ParticleModule enabled="true" spawnModule="true" updateModule="true"/></particle_emitter>');
		var emitter:GParticleEmitter = GPrototypeFactory.createPrototype(GXmlPrototypeParser.fromXml(xml));
		/*
		var emitter:GParticleEmitter = new GParticleEmitter();
		emitter.texture = GTextureManager.getTexture("assets/atlas.png_particle");
		emitter.rate = new GCurve(50);
		emitter.duration = 10;
		emitter.loop = true;
		emitter.addModule(new ParticleModule());
		/**/
		trace(emitter.texture);
		
		// Create a node with simple particle system component
        var particleSystem:GParticleSystemComponent = GNode.createWithComponent(GParticleSystemComponent);
		particleSystem.addEmitter(emitter);
		particleSystem.node.setPosition(400, 300);
		container.addChild(particleSystem.node);

		trace(GXmlPrototypeParser.toXml(emitter.getPrototype()));
    }
}
