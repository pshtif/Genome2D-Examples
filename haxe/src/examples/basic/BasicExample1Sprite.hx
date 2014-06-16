package examples.basic;

import com.genome2d.textures.factories.GTextureAtlasFactory;
import com.genome2d.Genome2D;
import com.genome2d.Genome2D;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.node.GNode;
import com.genome2d.Genome2D;
import com.genome2d.context.GContextConfig;
import com.genome2d.assets.GAssetManager;

class BasicExample1Sprite {
    static public function main() {
        var inst = new BasicExample1Sprite();
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

        var sprite:GSprite;

        sprite = createSprite(300, 200, "atlas_0");

        sprite = createSprite(500, 200, "atlas_0");
        sprite.node.transform.setScale(2,2);

        sprite = createSprite(300, 400, "atlas_0");
        sprite.node.transform.rotation = 0.753;

        sprite = createSprite(500, 400, "atlas_0");
        sprite.node.transform.rotation = 0.753;
        sprite.node.transform.setScale(2,2);

        sprite = createSprite(300, 300, "atlas_0");
        sprite.node.transform.alpha = .5;

        sprite = createSprite(500, 300, "atlas_0");
        sprite.node.transform.color = 0x00FF00;
    }

    private function createSprite(p_x:Int, p_y:Int, p_textureId:String):GSprite {
        var sprite:GSprite = cast GNodeFactory.createNodeWithComponent(GSprite);
        sprite.textureId = p_textureId;
        sprite.node.transform.setPosition(p_x, p_y);
        Genome2D.getInstance().root.addChild(sprite.node);

        return sprite;
    }
}
