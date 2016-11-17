package com.genome2d.examples.custom;
import flash.geom.Point;
import flash.display.BitmapData;
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
	private var g2d_bitmapData:BitmapData;
	private var g2d_texture:GTexture;
	public var texture(default,set):GTexture;
	public function set_texture(p_value:GTexture):GTexture {
		g2d_texture = p_value;
		if (Std.is(g2d_texture.getSource(),BitmapData)) g2d_bitmapData = cast g2d_texture.getSource();
		if (Std.is(g2d_texture.getSource(),GTexture)) {
			g2d_bitmapData = new BitmapData(Std.int(g2d_texture.region.width), Std.int(g2d_texture.region.height),true,0x0);
			g2d_bitmapData.copyPixels(cast (g2d_texture.getSource(),GTexture).getSource(), g2d_texture.region.toNative(), new Point());
		}
		return g2d_texture;
	}

	private var g2d_offset:Int = 0;
	public var treshold:Float = 0;
	public var gridSize:Int = 4;
	public var fixed:Bool = true;

	public function new() {
		super();

		spawnModule = true;
		updateModule = true;
	}

	public function getParticleCount():Int {
		var count:Int = 0;
		while (Std.int((g2d_offset*gridSize)/g2d_bitmapData.width)*gridSize < g2d_bitmapData.height) {
			var color:UInt = g2d_bitmapData.getPixel32(Std.int(g2d_offset*gridSize)%g2d_bitmapData.width,Std.int(Std.int((g2d_offset*gridSize)/g2d_bitmapData.width)*gridSize));
			var alpha:Float = (color >> 24 & 0xFF) / 0xFF;
			if (alpha>treshold) count++;

			g2d_offset++;
		}

		return count;
	}
	
	override public function spawn(p_emitter:GParticleEmitter, p_particle:GParticle):Void {
		var color:UInt = g2d_bitmapData.getPixel32(Std.int(g2d_offset*gridSize)%g2d_bitmapData.width,Std.int(Std.int((g2d_offset*gridSize)/g2d_bitmapData.width)*gridSize));
		var alpha:Float = (color >> 24 & 0xFF) / 0xFF;

		while (alpha<=treshold) {
			g2d_offset++;
			if (Std.int((g2d_offset*gridSize)/g2d_bitmapData.width)*gridSize > g2d_bitmapData.height) g2d_offset = 0;
			color = g2d_bitmapData.getPixel32(Std.int(g2d_offset*gridSize)%g2d_bitmapData.width,Std.int(Std.int((g2d_offset*gridSize)/g2d_bitmapData.width)*gridSize));
			alpha = (color >> 24 & 0xFF) / 0xFF;
		}

		p_particle.x = p_emitter.x + (g2d_offset*gridSize)%g2d_bitmapData.width - g2d_bitmapData.width/2;
		p_particle.y = p_emitter.y + Std.int((g2d_offset*gridSize)/g2d_bitmapData.width)*gridSize - g2d_bitmapData.height/2;
		p_particle.fixed = fixed;

		g2d_offset++;
		if (Std.int((g2d_offset*gridSize)/g2d_bitmapData.width)*gridSize > g2d_bitmapData.height) g2d_offset = 0;
	}
	
	override public function update(p_emitter:GParticleEmitter, p_particle:GParticle, p_deltaTime:Float):Void {
		p_particle.x += p_deltaTime/1000*p_particle.velocityX;
		p_particle.y += p_deltaTime/1000*p_particle.velocityY;

		if (!p_particle.fixed) p_particle.velocityY += 9;

		p_particle.accumulatedTime += p_deltaTime;
		if (p_particle.accumulatedTime > 15000) p_particle.die = true;
	}
}