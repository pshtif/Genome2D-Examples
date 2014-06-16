package examples.basic;
import com.genome2d.Genome2D;
import com.genome2d.signals.GNodeMouseSignal;
import com.genome2d.node.GNode;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.textures.factories.GTextureAtlasFactory;
import com.genome2d.Genome2D;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.context.GContextConfig;
import com.genome2d.textures.GTextureAtlas;
import com.genome2d.textures.GTexture;
import com.genome2d.assets.GAssetManager;

class BasicExample3Mouse {

    static public function main() {
        var inst = new BasicExample3Mouse();
    }

    private var _assetManager:GAssetManager;

    public function new() {
        initGenome();
    }

    private function initGenome():Void {
        trace("initGenome");

        Genome2D.getInstance().onInitialized.add(genomeInitializedHandler);
        Genome2D.getInstance().init(new GContextConfig());
    }

    private function genomeInitializedHandler():Void {
        trace("genomeInitializedHandler");

        initAssets();
    }

    private function initAssets():Void {
        trace("initAssets");

        _assetManager = new GAssetManager();
        _assetManager.addUrl("atlas_gfx", "atlas.png");
        _assetManager.addUrl("atlas_xml", "atlas.xml");
        _assetManager.onAllLoaded.add(assetsInitializedHandler);
        _assetManager.load();
    }

    private function assetsInitializedHandler():Void {
        trace("assetsInitializedHandler");

        initExample();
    }

    private function initExample():Void {
        trace("initExample");

        GTextureAtlasFactory.createFromAssets("atlas", cast _assetManager.getAssetById("atlas_gfx"), cast _assetManager.getAssetById("atlas_xml"));

        var sprite:GSprite = createSprite(400, 300, "atlas_0");
    }

    private function createSprite(p_x:Float, p_y:Float, p_textureId:String):GSprite {
        var sprite:GSprite = cast GNodeFactory.createNodeWithComponent(GSprite);
        sprite.texture = GTexture.getTextureById(p_textureId);
        sprite.node.transform.setPosition(p_x, p_y);
        sprite.node.mouseEnabled = true;
        sprite.node.onMouseClick.add(mouseClickHandler);

        Genome2D.getInstance().root.addChild(sprite.node);
        return sprite;
    }

    private function mouseClickHandler(signal:GNodeMouseSignal):Void {
        trace(signal.dispatcher.name, signal.target.name);
    }
}
