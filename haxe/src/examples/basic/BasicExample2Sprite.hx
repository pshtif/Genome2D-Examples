package examples.basic;

import com.genome2d.textures.factories.GTextureAtlasFactory;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.Genome2D;
import com.genome2d.context.GContextConfig;
import com.genome2d.assets.GAssetManager;

class BasicExample2Sprite
{
    static public function main() {
        var inst = new BasicExample2Sprite();
    }

    /**
        Genome2D singleton instance
     **/
    private var genome:Genome2D;

    /**
        Asset manager instance for loading assets
     **/
    private var assetManager:GAssetManager;

    public function new() {
        initGenome();
    }

    /**
        Initialize Genome2D
     **/
    private function initGenome():Void {
        genome = Genome2D.getInstance();
        genome.onInitialized.add(genomeInitializedHandler);
        genome.init(new GContextConfig());
    }

    /**
        Genome2D initialized handler
     **/
    private function genomeInitializedHandler():Void {
        initAssets();
    }

    /**
        Initialize assets
     **/
    private function initAssets():Void {
        assetManager = new GAssetManager();
        assetManager.addUrl("atlas_gfx", "atlas.png");
        assetManager.addUrl("atlas_xml", "atlas.xml");
        assetManager.onAllLoaded.add(assetsInitializedHandler);
        assetManager.load();
    }

    /**
        Assets initialization handler dispatched after all assets were initialized
     **/
    private function assetsInitializedHandler():Void {
        initExample();
    }

    /**
        Initialize Example code
     **/
    private function initExample():Void {
        GTextureAtlasFactory.createFromAssets("atlas", cast assetManager.getAssetById("atlas_gfx"), cast assetManager.getAssetById("atlas_xml"));

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

    /**
        Create a sprite helper function
     **/
    private function createSprite(p_x:Int, p_y:Int, p_textureId:String):GSprite {
        var sprite:GSprite = cast GNodeFactory.createNodeWithComponent(GSprite);
        sprite.textureId = p_textureId;
        sprite.node.transform.setPosition(p_x, p_y);
        genome.root.addChild(sprite.node);

        return sprite;
    }
}
