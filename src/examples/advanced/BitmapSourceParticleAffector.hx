package examples.advanced;
import com.genome2d.components.renderable.particles.GParticleSystem;
import com.genome2d.particles.GParticle;
import com.genome2d.particles.IGAffector;

/**
 * ...
 * @author Peter @sHTiF Stefcek
 */
class BitmapSourceParticleAffector implements IGAffector
{
	public function new() {
		
	}

	public function update(p_system:GParticleSystem, p_particle:GParticle, p_deltaTime:Float):Void {
		p_particle.x += p_particle.velocityX * p_deltaTime / 10;
		p_particle.y += p_particle.velocityY * p_deltaTime / 10;
		p_particle.velocityX *= .95;
		p_particle.velocityY *= .95;
		p_particle.velocityY += .01;
		p_particle.accumulatedEnergy += p_deltaTime;
		p_particle.alpha = Math.random();// 1 - (p_particle.accumulatedEnergy / 5000);
		p_particle.scaleX = p_particle.scaleY = Math.random();
		if (p_particle.accumulatedEnergy > 5000) p_particle.die = true;
	}
	
}