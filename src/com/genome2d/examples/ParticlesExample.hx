/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.examples;

import tween.Delta;
import com.genome2d.particles.modules.GSPHVelocityModule;
import com.genome2d.scripts.GScriptManager;
import com.genome2d.scripts.GScript;
import com.genome2d.geom.GRectangle;
import com.genome2d.postprocess.GBlurPP;
import com.genome2d.assets.GStaticAssetManager;
import com.genome2d.particles.modules.GScriptModule;
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

	private var emitter:GParticleEmitter;

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
		var module:ParticleModule = new ParticleModule();
		module.texture = GTextureManager.getTexture("assets/atlas.png_0");
		emitter.burstDistribution = [.5, module.getParticleCount()];
		emitter.addModule(module);
		emitter.addModule(new GSPHVelocityModule());

		// Create a node with simple particle system component
        var particleSystem:GParticleSystemComponent = GNode.createWithComponent(GParticleSystemComponent);
		particleSystem.getParticleSystem().enableSph = true;
		particleSystem.getParticleSystem().setupGrid(new GRectangle(0,0,800,600),20);
		particleSystem.addEmitter(emitter);
		particleSystem.node.setPosition(400, 300);
		container.addChild(particleSystem.node);

		Delta.tween(null).wait(.5).onComplete(onComplete_handler);

		//container.postProcess = cast GXmlPrototypeParser.createPrototypeFromXmlString('<GBlurPP blurY="8" blurX="8"><p:bounds><GRectangle width="800" x="0" height="600" y="0"/></p:bounds></GBlurPP>');
		//container.postProcess = new GBlurPP();
		//container.postProcess.setBounds(new GRectangle(0,0,800,600));

		//trace(GXmlPrototypeParser.toXml(container.getPrototype()));
		genome.onUpdate.add(update_handler);
    }

	private function update_handler(p_deltaTime:Float):Void {
		Delta.step(p_deltaTime);
	}

	private function onComplete_handler():Void {
		cast (emitter.getModules()[0],ParticleModule).fixed = Math.random()>.4;
		emitter.x = Math.random()*800;
		emitter.y = Math.random()*600;

		Delta.tween(null).wait(.9).onComplete(onComplete_handler);
	}
}
