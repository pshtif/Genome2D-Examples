package com.genome2d.examples.custom;
import com.genome2d.geom.GCurve;
import com.genome2d.particles.modules.GParticleEmitterModule;
import com.genome2d.context.GBlendMode;
import com.genome2d.particles.GParticle;
import com.genome2d.particles.GParticleEmitter;
import com.genome2d.particles.GParticleSystem;
import com.genome2d.textures.GTexture;

/**
 * ...
 * @author Peter @sHTiF Stefcek
 */
class ParticleModule extends GParticleEmitterModule
{
	private var g2d_offset:Float = 0;
	private var g2d_curveX:GCurve;
	private var g2d_curveY:GCurve;

	public var distribution:Float = .1;

	public function new(p_curveX:GCurve, p_curveY:GCurve) {
		super();

		g2d_curveX = p_curveX;
		g2d_curveY = p_curveY;

		spawnModule = true;
		//updateModule = true;
	}
	
	override public function spawn(p_emitter:GParticleEmitter, p_particle:GParticle):Void {
		p_particle.x = g2d_curveX.calculate(g2d_offset);
		p_particle.y = g2d_curveY.calculate(g2d_offset);

		g2d_offset += distribution;
		g2d_offset %= 1;
	}
	
	override public function update(p_emitter:GParticleEmitter, p_particle:GParticle, p_deltaTime:Float):Void {

	}
}