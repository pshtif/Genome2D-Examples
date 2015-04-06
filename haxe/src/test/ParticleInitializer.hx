package test;

import com.genome2d.particles.GParticle;
import com.genome2d.components.renderable.particles.GParticleSystem;
import com.genome2d.particles.IGInitializer;


class ParticleInitializer implements IGInitializer {
    public var angleOffset:Float = 0;
    public var streamSpread:Float = .2;
    public var streamCount:Int = 5;

    public function new() {

    }

    public function initialize(p_system:GParticleSystem, p_particle:GParticle):Void {
        var particle:ParticleIso = cast p_particle;

        var angle:Float = Math.random()*streamSpread;
        angle += 2*Math.PI/streamCount * particle.index%streamCount;
        angle += angleOffset;

        particle.ivx = Math.sin(angle)/5;
        particle.ivy = -.7-Math.random()*streamSpread/2;
        particle.ivz = Math.cos(angle)/5;
        particle.scale = Math.random()*.75+.5;
        particle.rotation = Math.random();
        particle.totalEnergy = 2000;
    }
}
