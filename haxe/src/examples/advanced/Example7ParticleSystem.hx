package examples.advanced;
import com.genome2d.assets.GXmlAsset;
import com.genome2d.assets.GImageAsset;
import com.genome2d.context.stats.GStats;
import com.genome2d.geom.GRectangle;
import com.genome2d.signals.GMouseSignalType;
import com.genome2d.signals.GMouseSignal;
import com.genome2d.signals.GKeyboardSignal;
import examples.basic.custom.Initializer;
import examples.basic.custom.Affector;
import com.genome2d.particles.IGAffector;
import com.genome2d.geom.GCurve;
import com.genome2d.components.renderables.particles.GParticleSystem;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.textures.factories.GTextureAtlasFactory;
import com.genome2d.Genome2D;
import com.genome2d.context.GContextConfig;
import com.genome2d.textures.GTextureAtlas;
import com.genome2d.textures.GTexture;
import com.genome2d.assets.GAssetManager;

class Example7ParticleSystem {

    static function main() {
        var inst = new Example7ParticleSystem();
    }

    private var genome:Genome2D;
    private var assetManager:GAssetManager;
    private var texture:GTexture;
    private var atlas:GTextureAtlas;
    private var particleSystem:GParticleSystem;

    public function new() {
        initAssets();
    }

    private function initAssets():Void {
        trace("initAssets");
        assetManager = new GAssetManager();
        assetManager.add(new GImageAsset("texture_gfx", "textures.jpg"));
        assetManager.add(new GImageAsset("atlas_gfx", "atlas.png"));
        assetManager.add(new GXmlAsset("atlas_xml", "atlas.xml"));
        assetManager.onLoaded.add(assetsInitializedHandler);
        assetManager.load();
    }

    private function assetsInitializedHandler():Void {
        trace("assetsInitializedHandler");
        var contextConfig:GContextConfig = new GContextConfig(new GRectangle(0,0,800,600));
        GStats.visible = true;

        genome = Genome2D.getInstance();
        genome.onInitialized.add(genomeInitializedHandler);
        genome.init(contextConfig);
    }

    private function genomeInitializedHandler():Void {
        trace("genomeInitializedHandler2");

        GTextureAtlasFactory.createFromAssets("assets", cast assetManager.getAssetById("assets_gfx"), cast assetManager.getAssetById("assets_xml"));

        particleSystem = cast GNodeFactory.createNodeWithComponent(GParticleSystem);
        particleSystem.texture = GTexture.getTextureById("assets_g100");
        //particleSystem.emission = new GCurve(50000);
        particleSystem.emit = true;
        particleSystem.node.transform.setPosition(400,300);
        particleSystem.addInitializer(new Initializer());
        particleSystem.addAffector(new Affector());
        genome.root.addChild(particleSystem.node);

        genome.getContext().onKeyboardInteraction.add(keyboardHandler);
        genome.getContext().onMouseInteraction.add(mouseHandler);
    }

    private function keyboardHandler(p_keySignal:GKeyboardSignal):Void {
        switch (p_keySignal.keyCode) {
            case 32:
                particleSystem.burst(100);
        }
    }

    private function mouseHandler(p_mouseSignal:GMouseSignal):Void {
        switch (p_mouseSignal.type) {
            case GMouseSignalType.MOUSE_DOWN:
                particleSystem.node.transform.setPosition(p_mouseSignal.x, p_mouseSignal.y);
                particleSystem.burst(100);
        }
    }
}
