package com.genome2d.examples;
import com.genome2d.textures.GTextureManager;
import com.genome2d.project.GProjectConfig;
import com.genome2d.project.GProject;
import com.genome2d.Genome2D;
import com.genome2d.context.GContextConfig;
import com.genome2d.examples.AbstractExample;
import com.genome2d.examples.SpriteExample;
import com.genome2d.input.GKeyboardInput;
import com.genome2d.input.GKeyboardInputType;
import com.genome2d.input.GMouseInput;
import com.genome2d.input.GMouseInputType;

/**
 * @author Peter @sHTiF Stefcek
 */
class ExampleWrapper extends GProject
{
	static public function main() {
        var inst = new ExampleWrapper(new GProjectConfig());
    }
	
	private var example:AbstractExample;
	private var exampleClasses:Array<Class<AbstractExample>>;
	private var exampleIndex:Int = 0;
	
	override private function init():Void {
		exampleClasses = new Array<Class<AbstractExample>>();
		exampleClasses.push(G3DExample);
		exampleClasses.push(SpriteExample);
		exampleClasses.push(MouseExample);
		exampleClasses.push(TextureTextExample);
		exampleClasses.push(SimpleParticlesExample);
		//exampleClasses.push(ParticlesExample);
		exampleClasses.push(CameraExample);
		exampleClasses.push(UIExample);
		exampleClasses.push(SpineExample);
		exampleClasses.push(PhysicsExample);
		
		example = Type.createInstance(exampleClasses[0], [1]);

		getGenome().onKeyboardInput.add(key_handler);
		getGenome().getContext().onMouseInput.add(mouse_handler);
	}
	
	private function nextExample():Void {
		example.dispose();
		exampleIndex = (exampleIndex + 1) % exampleClasses.length;
		example = Type.createInstance(exampleClasses[exampleIndex], [2]);
	}
	
	private function key_handler(p_input:GKeyboardInput):Void {
		if (p_input.type == GKeyboardInputType.KEY_UP) {
			nextExample();
		}
	}
	
	private function mouse_handler(p_input:GMouseInput):Void {
		if (p_input.type == GMouseInputType.MOUSE_UP) {
			nextExample();
		}
	}
}