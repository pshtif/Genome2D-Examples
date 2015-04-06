package test;
import com.genome2d.context.GCamera;
import com.genome2d.Genome2D;
import com.genome2d.components.renderable.particles.GParticleSystem;
import com.genome2d.particles.GParticle;

class ParticleIso extends GParticle {
    static public var mirror:Bool = false;

    public var ix:Float;
    public var iy:Float;
    public var iz:Float;

    public var ivx:Float;
    public var ivy:Float;
    public var ivz:Float;

    public var scale:Float;
    public var isoScale:Float = .005;

    override public function init(p_particleSystem:GParticleSystem):Void {
        super.init(p_particleSystem);

        x+=Math.random()*10-5;
        y+=Math.random()*10-5;

        overrideRender = true;

        scale = 1;

        ix = x/2 + y;
        iy = 0;
        iz = -x/2 + y;

        ivx = ivy = ivz = 0;
    }

    override public function render(p_camera:GCamera, p_particleSystem:GParticleSystem):Void {
        var ts:Float = scale*(1-accumulatedEnergy/totalEnergy)+(y*2-1024)*isoScale;
        if (ts<0) ts = 0;
        if (mirror) {
            Genome2D.getInstance().getContext().draw(texture, x, y-iy, ts, ts, rotation, red, green, blue, alpha, p_particleSystem.blendMode);
        } else {
            Genome2D.getInstance().getContext().draw(texture, x, y+iy, ts, ts, rotation, red, green, blue, alpha, p_particleSystem.blendMode);
        }
    }
}
