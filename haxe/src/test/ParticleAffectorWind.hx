package test;
import com.genome2d.textures.GTexture;
import com.genome2d.particles.GParticle;
import com.genome2d.components.renderable.particles.GParticleSystem;
import com.genome2d.particles.IGAffector;

class ParticleAffectorWind implements IGAffector {
    public var pause:Bool = false;
    public var enabled:Bool = false;


    public var mx:Float = 0;
    public var my:Float = 0;

    public function new() {
    }

    public function update(p_system:GParticleSystem, p_particle:GParticle, p_deltaTime:Float):Void {
        if (!enabled) return;
        if (pause) p_deltaTime = 0;

        var imx:Float = mx/2 + my;
        var imz:Float = -mx/2 + my;

        var particle:ParticleIso = cast p_particle;

        particle.ivx += p_deltaTime*(768-imx)/100000;
        particle.ivz += p_deltaTime*(256-imz)/100000;

        //particle.ix +=p_deltaTime*particle.ivx/1000;
        //particle.iz +=p_deltaTime*particle.ivz/1000;
    }
}
