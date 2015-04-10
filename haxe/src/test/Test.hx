package test;

import com.genome2d.context.stage3d.GStage3DContext;
import com.genome2d.Genome2D;
import com.genome2d.context.bitmap.GBitmapContext;
import com.genome2d.context.GBlendMode;
import com.genome2d.input.GKeyboardInputType;
import com.genome2d.particles.GParticlePool;
import com.genome2d.geom.GCurve;
import com.genome2d.components.renderable.particles.GParticleSystem;
import com.genome2d.textures.GTextureManager;
import com.genome2d.textures.GTexture;
import com.genome2d.node.GNode;
import com.genome2d.assets.GAssetManager;
import com.genome2d.context.GContextConfig;
import com.genome2d.Genome2D;
import com.genome2d.context.stats.GStats;
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
        GAssetManager.addFromUrl("bunny.png");
        GAssetManager.onQueueLoaded.addOnce(assetsLoaded_handler);
        GAssetManager.loadQueue();
    }

    private function assetsLoaded_handler():Void {
        GAssetManager.generateTextures();

        texture = GTextureManager.createTextureFromBitmapData("red", new BitmapData(32,128,false,0xFF0000), 1);
        background = GTextureManager.createTextureFromBitmapData("background", new BitmapData(800,600,false,0x222222), 1);

        genome.onPostRender.add(postRender_handler);
    }

    private var moveX:Float=0;
    private var SPEED:Float=5;
    private var inc:Float= 5.0;

    private function postRender_handler():Void {
        genome.getContext().draw(background, 400, 300);
        if(moveX>800)inc=-SPEED;
        if(moveX<0)inc=SPEED;
        genome.getContext().draw(texture, moveX+=inc,150);
    }
}
