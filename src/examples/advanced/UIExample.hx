package examples.advanced;
import com.genome2d.assets.GAsset;
import com.genome2d.assets.GAssetManager;
import com.genome2d.components.renderable.text.GText;
import com.genome2d.components.renderable.ui.GUI;
import com.genome2d.context.GContextConfig;
import com.genome2d.Genome2D;
import com.genome2d.geom.GRectangle;
import com.genome2d.input.GKeyboardInput;
import com.genome2d.input.GKeyboardInputType;
import com.genome2d.node.GNode;
import com.genome2d.proto.GPrototypeFactory;
import com.genome2d.text.GFontManager;
import com.genome2d.textures.GTextureManager;
import com.genome2d.ui.element.GUIElement;
import com.genome2d.ui.skin.GUIFontSkin;
import com.genome2d.ui.skin.GUITextureSkin;
import com.genome2d.utils.GHAlignType;
import com.genome2d.utils.GVAlignType;

class UIExample
{
	static public function main() {
        var inst = new UIExample();
    }

    /**
        Genome2D singleton instance
     **/
    private var genome:Genome2D;

    public function new() {
		var expr = "var x = 4; var y=3; 1 + y * x";
		var parser = new hscript.Parser();
		var ast = parser.parseString(expr);
		var interp = new hscript.Interp();
		trace(interp.execute(ast));
		
        initGenome();
    }

    /**
        Initialize Genome2D
     **/
    private function initGenome():Void {
        genome = Genome2D.getInstance();
		genome.onFailed.addOnce(genomeFailed_handler);
        genome.onInitialized.addOnce(genomeInitialized_handler);
        genome.init(new GContextConfig());
    }

	/**
        Genome2D failed handler
     **/
    private function genomeFailed_handler(p_msg:String):Void {
        // Here we can check why Genome2D initialization failed
    }
	
    /**
        Genome2D initialized handler
     **/
    private function genomeInitialized_handler():Void {
        loadAssets();
    }
	
	/**	
	 * 	Asset loading
	 */
	private function loadAssets():Void {
		GAssetManager.addFromUrl("font.png");
        GAssetManager.addFromUrl("font.fnt");
		GAssetManager.onQueueFailed.add(assetsFailed_handler);
        GAssetManager.onQueueLoaded.addOnce(assetsLoaded_handler);
        GAssetManager.loadQueue();
	}
	
	/**
	 * 	Asset loading failed
	 */
	private function assetsFailed_handler(p_asset:GAsset):Void {
		// Asset loading failed at p_asset
	}

	/**
	 * 	Asset loading completed
	 */
	private function assetsLoaded_handler():Void {
		initExample();
	}

    /**
        Initialize Example code
     **/
	private var element:GUIElement;
	private var align:Int = 0;
    private function initExample():Void {
		GTextureManager.createTexture("font.png", GAssetManager.getImageAssetById("font.png"));
		
		GFontManager.createTextureFont("font", GTextureManager.getTexture("font.png"), GAssetManager.getXmlAssetById("font.fnt").xml);
		
		var skin:GUIFontSkin = new GUIFontSkin("font", GFontManager.getFont("font"), .8, true);
		
		var ui:GUI = GNode.createWithComponent(GUI);
		ui.setBounds(new GRectangle(0, 0, 800, 600));
		
		var xml:Xml = Xml.parse('<element anchorRight="1" anchorBottom="1"><element setAnchorAlign="5" setModel="test" anchorY="50" skin="@font"></element><element skin="@font"></element></element>').firstElement();
		
		element = cast GPrototypeFactory.createPrototype(xml);
		//element.getChildAt(0).setModel("Lorem ipsum.");// dolor sit amet and some other bullshit that comes here to inform you about this material.");
		element.getChildAt(1).setModel("Lorem ipsum.");// dolor sit amet and some other bullshit that comes here to inform you about this material.");
		var child:GUIElement = element.getChildAt(0);
		ui.root.addChild(element);
		
		genome.root.addChild(ui.node);
		
		genome.getContext().onKeyboardInput.add(key_handler);
    }
	
	private var s:Bool = false;
	private function key_handler(p_input:GKeyboardInput):Void {
		if (p_input.type == GKeyboardInputType.KEY_DOWN) {
			switch (p_input.keyCode) {
				case 32:
					if (!s) {
						element.setState("test");
					} else {
						element.setState("default");
					}
					s = !s;
			}
		}
	}
	
}