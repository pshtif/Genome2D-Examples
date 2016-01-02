package examples.advanced.custom;
import com.genome2d.components.renderable.particles.GParticleSystem;
import com.genome2d.particles.GParticle;
import com.genome2d.particles.IGInitializer;
import flash.display.BitmapData;

/**
 * ...
 * @author Peter @sHTiF Stefcek
 */
class BitmapSourceParticleInitializer implements IGInitializer
{
	public var source:BitmapData;
	public var scale:Float = .1;
	public var red:Float = 1;
	public var green:Float = 1;
	public var blue:Float = 1;
	
	public function new(p_source:BitmapData, p_red:Float, p_green:Float, p_blue:Float, p_scale:Float):Void {
		source = p_source;
		red = p_red;
		green = p_green;
		blue = p_blue;
		scale = p_scale;
	}
	
	public function initialize(p_system:GParticleSystem, p_particle:GParticle):Void {
		var tx :Float;
		var ty :Float;
		var a:UInt;
		do {
			tx = Std.int(Math.random() * source.width);
			ty = Std.int(Math.random() * source.height);
			a = source.getPixel32(Std.int(tx), Std.int(ty));
		} while (a == 0);
		
		tx *= scale;
		ty *= scale;
		
		p_particle.x = p_system.node.x + tx;
		p_particle.y = p_system.node.y + ty;
		p_particle.red = red;
		p_particle.green = green;
		p_particle.blue = blue;
		p_particle.scaleX = p_particle.scaleY = Math.random() + .5;
		
		p_particle.velocityX = tx - source.width * scale / 2;
		p_particle.velocityY = ty - source.height * scale / 2;
	}
	
}