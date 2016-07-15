package com.genome2d.examples.custom;
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
	private var g2d_count:Int = 0;
	private var g2d_texture:GTexture;
	
	public function new(p_gravity:Float = 0) {
		super();
		
		g2d_gravity = p_gravity;
		
		spawnModule = true;
	}
	
	override public function spawn(p_emitter:GParticleEmitter, p_particle:GParticle):Void {
		g2d_count = (++g2d_count) % 25;
		p_particle.x += -10 + ((g2d_count % 5) % 10) * 6;
		p_particle.y += -10 + (Std.int(g2d_count / 5) % 10) * 6;
		//p_particle.vy += g2d_gravity * 10;
		
		p_particle.totalEnergy = 1000000;
	}
}