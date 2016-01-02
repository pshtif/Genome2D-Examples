package examples.advanced.custom;
import com.genome2d.components.GComponent;
import com.genome2d.components.renderable.particles.GParticleSystem;
import com.genome2d.components.renderable.particles.GSimpleParticleSystem;
import com.genome2d.geom.GCurve;
import com.genome2d.node.GNode;
import com.genome2d.textures.GTextureManager;
import flash.display.BitmapData;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import motion.Actuate;
import motion.easing.Linear;

/**
 * ...
 * @author Peter @sHTiF Stefcek
 */
class Shell extends GComponent
{
	static public function create(p_parent:GNode, p_startX:Float, p_endX:Float, p_endY:Float, p_char:String, p_delay:Float, p_scale:Float):Void {
		var shell:Shell = GNode.createWithComponent(Shell);
		p_parent.addChild(shell.node);
		shell._char = p_char;
		shell._scale = p_scale;
		shell.setup(p_startX, p_endX, p_endY, p_delay);
	}
	
	private var _particleSystem:GSimpleParticleSystem;
	private var _endX:Float;
	private var _endY:Float;
	private var _char:String;
	private var _scale:Float;
	private var _type:Int = 1;
	
	override public function init():Void {
		// Create a node with simple particle system component
        _particleSystem = GNode.createWithComponent(GSimpleParticleSystem);
        _particleSystem.texture = GTextureManager.getTexture("atlas_particle");
        _particleSystem.emission = 64;
        _particleSystem.emit = true;
        _particleSystem.dispersionAngleVariance = .2;
		_particleSystem.dispersionAngle = Math.PI/2-.3;
        _particleSystem.energy = 1;
        _particleSystem.initialVelocity = 40;
        _particleSystem.initialVelocityVariance = 80;
        _particleSystem.endAlpha = 0;
        _particleSystem.initialScale = .8;
		_particleSystem.initialScaleVariance = .6;
        _particleSystem.endScale = .2;
		_particleSystem.initialColor = 0xFFCC00;
		_particleSystem.endColor = 0xFFFFFFF;
        _particleSystem.node.setPosition(100, 500);
		_particleSystem.useWorldSpace = true;
		_particleSystem.node.visible = false;
		node.addChild(_particleSystem.node);
	}
	
	public function setup(p_startX:Float, p_endX:Float, p_endY:Float, p_delay:Float):Void {
		_endX = p_endX;
		_endY = p_endY;
		_particleSystem.node.setPosition(p_startX, 600);
		
		Actuate.timer(p_delay).onComplete(fire);			
	}
	
	private function fire():Void {
		_particleSystem.node.visible = true;
		Actuate.tween(_particleSystem.node, 2, { x:_endX, y:_endY } ).ease(Linear.easeNone).onComplete(explode);
		Actuate.tween(_particleSystem, .25, { dispersionAngle:Math.PI / 2 + .2 } ).repeat().reflect().ease(Linear.easeNone);
	}
	
	private function explode():Void {
		_particleSystem.node.visible = false;
		
		if (_type == 2) {
			createAdvanced(_endX, _endY, _char);
		} else {
			createSimple(_endX, _endY);
		}
	}
	
	private function createSimple(p_x:Float, p_y:Float):Void {
		var system:GSimpleParticleSystem = GNode.createWithComponent(GSimpleParticleSystem);
        system.texture = GTextureManager.getTexture("atlas_particle");
        system.emission = 128;
        system.emit = false;
        system.dispersionAngleVariance = Math.PI*2;
        system.energy = 1;
        system.initialVelocity = 60;
        system.initialVelocityVariance = 60;
        system.endAlpha = 0;
        system.initialScale = .8;
		system.initialScaleVariance = .8;
        system.endScale = .6;
		system.initialColor = Std.int(0xFFFFFF * Math.random());
		system.endColor = 0xFFFFFFF;
        system.node.setPosition(p_x, p_y);
		system.useWorldSpace = true;
		node.addChild(system.node);
		
		var system2:GSimpleParticleSystem = GNode.createWithComponent(GSimpleParticleSystem);
        system2.texture = GTextureManager.getTexture("atlas_particle");
        system2.emission = 128;
        system2.emit = false;
        system2.dispersionAngleVariance = Math.PI*2;
        system2.energy = 2;
        system2.initialVelocity = 0;
        system2.initialVelocityVariance = 100;
        system2.endAlpha = 0;
        system2.initialScale = .8;
		system2.initialScaleVariance = .6;
        system2.endScale = .2;
		system2.initialColor = 0xFFFFFF;
		system2.endColor = 0xFFFF00;
        system2.node.setPosition(p_x, p_y);
		system2.useWorldSpace = true;
		node.addChild(system2.node);

		system.forceBurst();
		system2.forceBurst();
	}
	
	private function createAdvanced(p_x:Float, p_y:Float, p_char:String):Void {
		var explodeSystem:GParticleSystem = GNode.createWithComponent(GParticleSystem);
		explodeSystem.addInitializer(new BitmapSourceParticleInitializer(text(p_char), 1, .9, .5, _scale));
		explodeSystem.addAffector(new BitmapSourceParticleAffector());
		explodeSystem.emission = new GCurve(500);
		explodeSystem.node.setPosition(p_x, p_y);
        explodeSystem.texture = GTextureManager.getTexture("atlas_particle");
		Actuate.timer(.3).onComplete(disable, [explodeSystem]);
		node.addChild(explodeSystem.node);
	}
	
	private function disable(p_system:GParticleSystem):Void {
		p_system.emit = false;
	}
	
	private function text(p_char:String):BitmapData {
		var dtf:TextFormat = new TextFormat("Arial", 48, 0xFFFFFF);
		var tf:TextField = new TextField();
		tf.defaultTextFormat = dtf;
		tf.selectable = false;
		tf.autoSize = TextFieldAutoSize.LEFT;
		tf.text = p_char;
		
		var bd:BitmapData = new BitmapData(Std.int(tf.textWidth), Std.int(tf.textHeight), true, 0x0);
		bd.draw(tf);
		
		return bd;
	}
}