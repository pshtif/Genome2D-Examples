package com.genome2d.examples;
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
class ExampleWrapper
{
	static public function main() {
        var inst = new ExampleWrapper();
    }
	
	private var example:AbstractExample;
	private var exampleClasses:Array<Class<AbstractExample>>;
	private var exampleIndex:Int = 0;
	private var genome:Genome2D;

	public function new() {
		genome = Genome2D.getInstance();
		genome.onFailed.addOnce(genomeFailed_handler);
		genome.onInitialized.addOnce(genomeInitialized_handler);
		genome.init(new GContextConfig());
	}
	
	private function genomeInitialized_handler():Void {
		initExamples();
	}
	
	private function genomeFailed_handler(p_msg:String):Void {
		
	}
	
	private function initExamples():Void {
		exampleClasses = new Array<Class<AbstractExample>>();
		exampleClasses.push(SpriteExample);
		exampleClasses.push(MouseExample);
		exampleClasses.push(TextureTextExample);
		exampleClasses.push(SimpleParticlesExample);
		exampleClasses.push(ParticlesExample);
		exampleClasses.push(CameraExample);
		exampleClasses.push(UIExample);
		exampleClasses.push(G3DExample);
		
		example = Type.createInstance(exampleClasses[0], [1]);
		
		genome = Genome2D.getInstance();
		genome.onKeyboardInput.add(key_handler);
		genome.getContext().onMouseInput.add(mouse_handler);
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