/**
 * Created by sHTiF on 4.12.2013.
 */
package examples {
import com.genome2d.Genome2D;
import com.genome2d.assets.GAssetManager;
import com.genome2d.assets.GImageAsset;
import com.genome2d.assets.GXmlAsset;
import com.genome2d.components.renderables.GMovieClip;
import com.genome2d.context.GContextConfig;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.textures.factories.GTextureAtlasFactory;

import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;

[SWF(width="800", height="600", backgroundColor="#000000", frameRate="60")]
public class Example7AssetManager extends Sprite {

    private var genome:Genome2D;
    private var assetManager:GAssetManager;

    public function Example7AssetManager() {
        if (stage != null) addedToStageHandler(null);
        else addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
    }

    private function addedToStageHandler(event:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

        // Create an asset manager instance
        assetManager = new GAssetManager();
        // Add xml asset with id and url
        assetManager.add(new GXmlAsset("atlas_xml", "atlas.xml"));
        // Add image asset with id and url
        assetManager.add(new GImageAsset("atlas_gfx", "atlas.png"));
        // Add callback when all assets are loaded and initialized
        assetManager.onLoaded.add(assetsInitializedHandler);
        // Load assets in the queue
        assetManager.load();
    }

    private function assetsInitializedHandler():void {
        // Create a context config that will be used to initialize the Genome2D
        var config:GContextConfig = new GContextConfig(new Rectangle(0,0,stage.stageWidth,stage.stageHeight), stage);
        config.enableDepthAndStencil = true;

        // Get the Genome2D instance
        genome = Genome2D.getInstance();
        // Add a callback for Genome2D initialization
        genome.onInitialized.addOnce(genomeInitializedHandler);
        // Initialize Genome2D
        genome.init(config);
    }

    private function genomeInitializedHandler():void {
        // Create our assets atlas from assets
        GTextureAtlasFactory.createFromAssets("assets", assetManager.getImageAssetById("assets_gfx") as GImageAsset, assetManager.getXmlAssetById("assets_xml"));

        var clip:GMovieClip = createMovieClip(400, 300, ["assets_g100","assets_g101","assets_g102","assets_g103","assets_g104","assets_g105"]);
    }

    // Create a movie clip helper function
    private function createMovieClip(p_x:int, p_y:int, p_frames:Array):GMovieClip {
        // Create a node with sprite component
        var clip:GMovieClip = GNodeFactory.createNodeWithComponent(GMovieClip) as GMovieClip;
        // Assign animation frames
        clip.frameTextureIds = p_frames;
        clip.frameRate = 10;
        // Set transform position for this node
        clip.node.transform.setPosition(p_x, p_y);
        // Add the node to root of the render graph
        genome.root.addChild(clip.node);

        return clip;
    }
}
}
