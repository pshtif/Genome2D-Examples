package;
import com.genome2d.context.GBlendMode;
import com.genome2d.geom.GCurve;
import com.genome2d.particles.GEmitter;
import com.genome2d.particles.GNewParticle;
import com.genome2d.particles.GNewParticlePool;
import com.genome2d.particles.modules.TestModule;
import com.genome2d.textures.GTextureManager;

/**
 * ...
 * @author ...
 */
class CustomParticle extends GNewParticle
{
	private var emitter:GEmitter;
	
	public function new(p_particlePool:GNewParticlePool) {
		super(p_particlePool);
		
		implementUpdate = true;
		
		emitter = new GEmitter();
		emitter.texture = GTextureManager.getTexture("atlas_particle");
		emitter.rate = new GCurve(50);
		emitter.duration = 1;
		emitter.loop = true;
		emitter.blendMode = GBlendMode.ADD;
		emitter.addModule(new TestModule(.3));		
	}
	
	override private function g2d_spawn(p_emitter:GEmitter):Void {
		super.g2d_spawn(p_emitter);
		
		scaleX = scaleY = 5;
		green = 0;
		blue = 0;

		if (emitter.getParticleSystem() == null) p_emitter.getParticleSystem().addEmitter(emitter);
	}
	
	override private function g2d_update(p_emitter:GEmitter, p_deltaTime:Float):Void {
		emitter.x = x;
		emitter.y = y;
	}
	
	override private function g2d_dispose():Void {
		emitter.emit = false;
	}	
}