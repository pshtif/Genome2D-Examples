package examples;

import com.genome2d.context.stats.GStats;
import com.genome2d.textures.factories.GTextureAtlasFactory;
import com.genome2d.Genome2D;
import com.genome2d.Genome2D;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.node.GNode;
import com.genome2d.Genome2D;
import com.genome2d.context.GContextConfig;
import com.genome2d.assets.GAssetManager;

class Test {
    static public function main() {
        var inst = new Test();
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

        GStats.visible = true;

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

        for (j in 0...1) {
            for (i in 0...400) {
                createSprite(16+32*i%25, 16+32*Std.int(i/25), (i>200) ? "atlas_particle" : "atlas_0");
            }
        }
    }

    private function createSprite(p_x:Int, p_y:Int, p_textureId:String):GSprite {
        var sprite:GSprite = cast GNodeFactory.createNodeWithComponent(GSprite);
        sprite.textureId = p_textureId;
        sprite.node.transform.setPosition(p_x, p_y);
        sprite.node.transform.alpha = .5;
        Genome2D.getInstance().root.addChild(sprite.node);

        return sprite;
    }
}
