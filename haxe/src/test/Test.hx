package test;

import com.genome2d.context.GBlendMode;
import com.genome2d.signals.GKeyboardSignalType;
import com.genome2d.signals.GKeyboardSignal;
import com.genome2d.particles.GParticlePool;
import com.genome2d.geom.GCurve;
import com.genome2d.components.renderable.particles.GParticleSystem;
import com.genome2d.textures.GTextureManager;
import com.genome2d.node.GNode;
import com.genome2d.components.renderable.GSprite;
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
        GAssetManager.addFromUrl("particle.png");
        GAssetManager.addFromUrl("fire.png");
        GAssetManager.addFromUrl("fire.xml");
        GAssetManager.onQueueLoaded.addOnce(assetsLoaded_handler);
        GAssetManager.loadQueue();
    }

    private var type:Int = 3;
    private var count:Int = 400000;

    private function assetsLoaded_handler():Void {
        GAssetManager.generateTextures();

        ParticleIso.mirror = true;

        genome.onPostRender.add(postRender_handler);
        genome.getContext().onKeyboardSignal.add(key_handler);
    }

    private function createParticleSystem():Void {
        particleSystem = cast GNode.createWithComponent(GParticleSystem);
        particleSystem.particlePool = new GParticlePool(ParticleIso);
        particleSystem.texture = GTextureManager.getTextureById("fire.png_slice01_01");
        particleSystem.emission = new GCurve(100);
        particleSystem.blendMode = GBlendMode.SCREEN;
        particleSystem.emit = true;
        particleSystem.node.setPosition(400,300);
        particleSystem.addInitializer(new ParticleInitializer());
        particleAffector = new ParticleAffector();
        particleAffector.textures = [GTextureManager.getTextureById("fire.png_1"),GTextureManager.getTextureById("fire.png_2"),GTextureManager.getTextureById("fire.png_3"),GTextureManager.getTextureById("fire.png_4"),GTextureManager.getTextureById("fire.png_5"),GTextureManager.getTextureById("fire.png_6"),GTextureManager.getTextureById("fire.png_7"),GTextureManager.getTextureById("fire.png_8"),GTextureManager.getTextureById("fire.png_9"),GTextureManager.getTextureById("fire.png_10"),GTextureManager.getTextureById("fire.png_11")];
        particleSystem.addAffector(particleAffector);
        particleSystem.node.visible = false;
        genome.root.addChild(particleSystem.node);
    }

    private function postRender_handler():Void {
        particleAffector.rotation += .01;
        particleSystem.render(Genome2D.getInstance().getContext().getActiveCamera(),false);
    }

    private function key_handler(signal:GKeyboardSignal):Void {
        if (signal.type != GKeyboardSignalType.KEY_DOWN) return;
        switch (signal.keyCode) {
            case 32:
                particleSystem.emit = !particleSystem.emit;
                particleAffector.pause = !particleAffector.pause;
        }
    }
}
