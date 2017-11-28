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
import com.genome2d.textures.GTexture;
import com.genome2d.particles.modules.GSPHVelocityModule;
import com.genome2d.geom.GRectangle;
import com.genome2d.proto.parsers.GXmlPrototypeParser;
import com.genome2d.examples.custom.ParticleModule;
import com.genome2d.components.renderable.particles.GParticleSystemComponent;
import com.genome2d.geom.GCurve;
import com.genome2d.node.GNode;
import com.genome2d.particles.GParticleEmitter;
import com.genome2d.textures.GTextureManager;


class ParticlesExample extends AbstractExample
{

	private var emitter:GParticleEmitter;
	private var module:ParticleModule;

    static public function main() {
        var inst = new ParticlesExample();
    }

    /**
        Initialize Example code
     **/
    override public function initExample():Void {
		title = "PARTICLES EXAMPLE";
		detail = "To achieve more complex particle systems Genome2D offers fully customizable particle systems using both spawn and update modules.";
		/*
		var xml:Xml = Xml.parse('<particle_emitter enableSph="false" useWorldSpace="true" emit="true" delay="0" delayVariance="0" duration="2" loop="true" durationVariance="0" texture="@assets/atlas.png_particle"><p:rate><GCurve path="400"/></p:rate><ParticleModule enabled="true" spawnModule="true" updateModule="true"/></particle_emitter>');
		var emitter:GParticleEmitter = GPrototypeFactory.createPrototype(GXmlPrototypeParser.fromXml(xml));
		/**/
		emitter = new GParticleEmitter();
		emitter.texture = GTextureManager.getTexture("assets/atlas.png_particle");
		//emitter.rate = new GCurve(532);
		emitter.duration = 1;
		emitter.loop = true;
		emitter.enableSph = true;
		//module = new ParticleModule();
		//module.texture = GTextureManager.getTexture("assets/atlas.png_0");
		//emitter.addModule(module);
		emitter.addModule(new GSPHVelocityModule());

		/*
		// Create a node with simple particle system component
        var particleSystem:GParticleSystemComponent = GNode.createWithComponent(GParticleSystemComponent);
		particleSystem.particleSystem.enableSph = true;
		particleSystem.particleSystem.setupGrid(new GRectangle(0,0,800,600),20);
		particleSystem.particleSystem.addEmitter(emitter);
		particleSystem.node.setPosition(400, 300);
		particleSystem.node.name = "particleSystem";
		/**/
		var xml:Xml = Xml.parse('<GParticleSystemComponent><p:particleSystem><particle_system timeDilation="1" x="0" y="0" enableSph="true" enabled="true" scaleX="1" scaleY="1"><particle_emitter enableSph="true" useWorldSpace="true" emit="true" loop="true" delay="0" duration="1" durationVariance="0" burstDistribution="null" texture="@assets/atlas.png_particle" delayVariance="0"><p:rate><GCurve path="[500.0,1,250,1]"/></p:rate><ParticleModule enabled="true" spawnModule="true" updateModule="true"/><GSPHVelocityModule enabled="true" spawnModule="false" updateModule="true"/></particle_emitter></particle_system></p:particleSystem></GParticleSystemComponent>');
		var pn:GNode = new GNode();
		pn.addComponentPrototype(GXmlPrototypeParser.fromXml(xml));
		container.addChild(pn);

		//emitter.x = 400;
		//emitter.y = 300;
		//emitter.rate = new GCurve(500).line(250);
		//emitter.burst(module.getParticleCount());

		//trace(GXmlPrototypeParser.toXml(particleSystem.getPrototype()));
    }
}
