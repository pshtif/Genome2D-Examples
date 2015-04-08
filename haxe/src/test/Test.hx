package test;

import com.genome2d.components.renderable.GFlipBook;
import com.genome2d.context.GBlendMode;
import com.genome2d.signals.GKeyboardSignalType;
import com.genome2d.signals.GKeyboardSignal;
import com.genome2d.particles.GParticlePool;
import com.genome2d.geom.GCurve;
import com.genome2d.components.renderable.particles.GParticleSystem;
import com.genome2d.textures.GTextureManager;
import com.genome2d.node.GNode;
import com.genome2d.assets.GAssetManager;
import com.genome2d.context.GContextConfig;
import com.genome2d.Genome2D;
import com.genome2d.context.stats.GStats;

class Test {
    static function main() {
        new Test();
    }

    private var genome:Genome2D;
    private var particleSystem:GParticleSystem;
    private var particleAffector:ParticleAffector;


    public function new() {
        initGenome();
    }

    private function initGenome():Void {
        genome = Genome2D.getInstance();
        genome.onInitialized.addOnce(genomeInitializedHandler);
        genome.init(new GContextConfig());
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

        for (i in 0...10000) {
            var sprite:GFlipBook = cast GNode.createWithComponent(GFlipBook);
            sprite.texture = GTextureManager.getTextureById("bunny.png");
            sprite.node.setPosition(Math.random()*800, Math.random()*600);
            genome.root.addChild(sprite.node);
        }
    }
}
