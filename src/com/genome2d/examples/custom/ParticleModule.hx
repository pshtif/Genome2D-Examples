package com.genome2d.examples.custom;

import com.genome2d.particles.modules.GParticleEmitterModule;
import com.genome2d.particles.GParticle;
import com.genome2d.particles.GParticleEmitter;

class ParticleModule extends GParticleEmitterModule
{
	public function new() {
		super();

		spawnParticleModule = true;
		updateParticleModule = true;
	}
	
	override public function spawnParticle(p_emitter:GParticleEmitter, p_particle:GParticle):Void {

	}

	override public function updateParticle(p_emitter:GParticleEmitter, p_particle:GParticle, p_deltaTime:Float):Void {

	}
}