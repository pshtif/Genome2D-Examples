package test;

import com.genome2d.assets.GAssetManager;
import com.genome2d.components.renderable.flash.GFlashText;
import com.genome2d.context.GContextConfig;
import com.genome2d.Genome2D;
import com.genome2d.node.GNode;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureManager;
import flash.display.BitmapData;

class Test {
    static function main() {
        new Test();
    }

    private var genome:Genome2D;
    private var texture:GTexture;
    private var background:GTexture;


    public function new() {
        initGenome();
    }

    private function initGenome():Void {
        var config:GContextConfig = new GContextConfig();
        config.profile = "baselineConstrained";
        genome = Genome2D.getInstance();
        genome.onInitialized.addOnce(genomeInitializedHandler);
        genome.init(config);
    }

    private function genomeInitializedHandler():Void {
        initAssets();
    }

    private function initAssets():Void {
		trace("aaaaa");
        GAssetManager.addFromUrl("bunny.png");
        GAssetManager.onQueueLoaded.addOnce(assetsLoaded_handler);
        GAssetManager.loadQueue();
    }

    private function assetsLoaded_handler():Void {
        GAssetManager.generateTextures();
		genome.getContext().setBackgroundColor(0x222222);
	
        var text:GFlashText = cast GNode.createWithComponent(GFlashText);
		text.textField.text = "Hello world";
		text.textField.background = true;
		text.textField.backgroundColor = 0xFFFFFF;
		text.blendMode = 0;
		
		text.node.setPosition(400, 300);
		genome.root.addChild(text.node);
    }
}
