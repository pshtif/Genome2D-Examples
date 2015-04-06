package test;
import com.genome2d.textures.GTexture;
import com.genome2d.particles.GParticle;
import com.genome2d.components.renderable.particles.GParticleSystem;
import com.genome2d.particles.IGAffector;

class ParticleAffector implements IGAffector {
    public var rotation:Float = 0;
    public var pause:Bool = false;
    public var textures:Array<GTexture>;
    public var dilation:Float = .5;

    public function new() {
    }

    public function update(p_system:GParticleSystem, p_particle:GParticle, p_deltaTime:Float):Void {
        if (pause) p_deltaTime = 0;

        var particle:ParticleIso = cast p_particle;

        particle.accumulatedEnergy+=p_deltaTime;
        if (particle.accumulatedEnergy>=particle.totalEnergy || particle.accumulatedEnergy<0) {
            particle.die = true;
        } else {
            particle.ix+=p_deltaTime*particle.ivx;
            particle.iz+=p_deltaTime*particle.ivz;

            var tix:Float = (particle.ix-768)*Math.cos(rotation) - (particle.iz-256)*Math.sin(rotation) + 768;
            var tiz:Float = (particle.ix-768)*Math.sin(rotation) + (particle.iz-256)*Math.cos(rotation) + 256;

            particle.iy+=p_deltaTime*particle.ivy;
            particle.ivy += p_deltaTime*.002;
            if (particle.iy>=0) {
                if (p_deltaTime>0 && particle.ivy<.01) {
                    particle.die = true;
                } else {
                    if (p_deltaTime>0) {
                        particle.ivy = -particle.ivy*.75;
                    } else {
                        particle.ivy = -particle.ivy/.75;
                        if (particle.ivy>.8) particle.ivy=.8;
                    }
                }
            }

            particle.alpha = 1-particle.accumulatedEnergy/particle.totalEnergy;

            particle.x = tix - tiz;
            particle.y = (tix + tiz)/2;
        }
    }
}
