package com.genome2d.examples.custom;
import com.genome2d.context.GBlendMode;
import com.genome2d.particles.GParticle;
import com.genome2d.particles.GParticleEmitter;
import com.genome2d.particles.GParticleEmitterModule;
import com.genome2d.particles.GParticleSystem;
import com.genome2d.textures.GTexture;

/**
 * ...
 * @author Peter @sHTiF Stefcek
 */
class ParticleModule extends GParticleEmitterModule
{
	private var g2d_gravity:Float;
	
	public function new(p_gravity:Float = 0) {
		super();
		
		g2d_gravity = p_gravity;
		
		spawnModule = true;
		updateModule = true;
	}
	
	override public function spawn(p_emitter:GParticleEmitter, p_particle:GParticle):Void {
		p_particle.x += Math.random() * 16;
		p_particle.y += Math.random() * 16;
		p_particle.scaleX = p_particle.scaleY = Math.random() * 2 + 2;
		p_particle.green = p_particle.blue = 0.2;
		p_particle.blendMode = GBlendMode.ADD;
		
		p_particle.velocityX = Math.random() * 4 - 2;
		p_particle.velocityY = Math.random() * 40 + 10; 
		
		p_particle.totalEnergy = 2000;
	}
	
	override public function update(p_emitter:GParticleEmitter, p_particle:GParticle, p_deltaTime:Float):Void {
		p_particle.x += p_particle.velocityX * p_deltaTime / 1000;
		p_particle.y -= p_particle.velocityY * p_deltaTime / 1000;
		
		p_particle.accumulatedEnergy += p_deltaTime;
		
		p_particle.scaleX -= p_deltaTime / 1000;
		p_particle.scaleY -= p_deltaTime / 1000;
		p_particle.alpha = 1 - p_particle.accumulatedEnergy/p_particle.totalEnergy;
		if (p_particle.accumulatedEnergy >= p_particle.totalEnergy) p_particle.die = true;
	}
}