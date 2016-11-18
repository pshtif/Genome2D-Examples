/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.examples;

import com.genome2d.components.renderable.GSprite;
import com.genome2d.components.GCameraController;
import com.genome2d.textures.GTexture;
import com.genome2d.input.GKeyboardInputType;
import com.genome2d.input.GKeyboardInput;
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
		module = new ParticleModule();
		module.texture = GTextureManager.getTexture("assets/atlas.png_0");
		emitter.addModule(module);
		emitter.addModule(new GSPHVelocityModule());

		var renderTarget:GTexture = GTextureManager.createRenderTexture("render",800,600);
		renderTarget.pivotX = -400;
		renderTarget.pivotY = -300;

		var particleCamera:GCameraController = GNode.createWithComponent(GCameraController);
		particleCamera.contextCamera.group = 513;
		container.addChild(particleCamera.node);

		// Create a node with simple particle system component
        var particleSystem:GParticleSystemComponent = GNode.createWithComponent(GParticleSystemComponent);
		particleSystem.getParticleSystem().enableSph = true;
		particleSystem.getParticleSystem().setupGrid(new GRectangle(0,0,800,600),20);
		particleSystem.addEmitter(emitter);
		particleSystem.node.setPosition(400, 300);
		particleSystem.node.cameraGroup = 512;
		particleSystem.node.name = "particleSystem";
		container.addChild(particleSystem.node);

		var sprite:GSprite = GNode.createWithComponent(GSprite);
		sprite.texture = renderTarget;
		container.addChild(sprite.node);

		particleCamera.renderTarget = renderTarget;

		emitter.x = 400;
		emitter.y = 300;
		emitter.rate = new GCurve(500).line(250);
		//emitter.burst(module.getParticleCount());

		//container.postProcess = cast GXmlPrototypeParser.createPrototypeFromXmlString('<GBlurPP blurY="8" blurX="8"><p:bounds><GRectangle width="800" x="0" height="600" y="0"/></p:bounds></GBlurPP>');
		//container.postProcess = new GBlurPP();
		//container.postProcess.setBounds(new GRectangle(0,0,800,600));

		trace(GXmlPrototypeParser.toXml(container.getPrototype()));
		genome.onUpdate.add(update_handler);
		genome.onKeyboardInput.add(keyboard_handler);
    }

	private function keyboard_handler(p_input:GKeyboardInput):Void {
		if (p_input.type == GKeyboardInputType.KEY_DOWN) {
			switch (p_input.keyCode) {
				case 32:
					module.upVelocity += 200;
				case _:
			}
		}
	}

	private function update_handler(p_deltaTime:Float):Void {
		emitter.y -= module.upVelocity * p_deltaTime/1000;
		emitter.y += module.gravity * p_deltaTime/1000;
		module.upVelocity *= .98;
		Delta.step(p_deltaTime);
	}
}
