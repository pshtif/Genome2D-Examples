package examples.basic;
import com.genome2d.Genome2D;
import com.genome2d.signals.GNodeMouseSignal;
import com.genome2d.node.GNode;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.textures.factories.GTextureAtlasFactory;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.context.GContextConfig;
import com.genome2d.textures.GTexture;
import com.genome2d.assets.GAssetManager;

class BasicExample4Mouse
{

    static public function main() {
        var inst = new BasicExample4Mouse();
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

        var sprite:GSprite = cast GNodeFactory.createNodeWithComponent(GSprite);
        sprite.texture = GTexture.getTextureById(p_textureId);
        sprite.node.transform.setPosition(p_x, p_y);

        sprite.node.mouseEnabled = true;
        sprite.node.onMouseClick.add(mouseClickHandler);
        sprite.node.onMouseOver.add(mouseOverHandler);
        sprite.node.onMouseOut.add(mouseOutHandler);
        sprite.node.onMouseDown.add(mouseDownHandler);
        sprite.node.onMouseUp.add(mouseUpHandler);

        genome.root.addChild(sprite.node);
        return sprite;
    }

    /**
        Mouse click handler
     **/
    private function mouseClickHandler(signal:GNodeMouseSignal):void {
        trace("CLICK", signal.dispatcher.name, signal.target.name);
    }

    /**
        Mouse over handler
     **/
    private function mouseOverHandler(signal:GNodeMouseSignal):void {
        trace("OVER", signal.dispatcher.name, signal.target.name);
    }

    /**
        Mouse out handler
     **/
    private function mouseOutHandler(signal:GNodeMouseSignal):void {
        trace("OUT", signal.dispatcher.name, signal.target.name);
    }

    /**
        Mouse down handler
     **/
    private function mouseDownHandler(signal:GNodeMouseSignal):void {
        trace("DOWN", signal.dispatcher.name, signal.target.name);
    }

    /**
        Mouse up handler
     **/
    private function mouseUpHandler(signal:GNodeMouseSignal):void {
        trace("UP", signal.dispatcher.name, signal.target.name);
    }
}