/**
 * Created by sHTiF on 4.12.2013.
 */
package examples {
import com.genome2d.Genome2D;
import com.genome2d.components.renderables.GMovieClip;
import com.genome2d.context.GContextConfig;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.textures.factories.GTextureAtlasFactory;

import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;

[SWF(width="800", height="600", backgroundColor="#000000", frameRate="60")]
public class MovieClipExample extends Sprite {

    [Embed(source = "../../assets/assets.png")]
    static private const AssetsPNG:Class;
    [Embed(source = "../../assets/assets.xml", mimeType = "application/octet-stream")]
    static public var AssetsXML:Class;

    private var genome:Genome2D;

    public function MovieClipExample() {
        if (stage != null) addedToStageHandler(null);
        else addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
    }

    private function addedToStageHandler(event:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

        // Create a context config that will be used to initialize the Genome2D
        var config:GContextConfig = new GContextConfig(stage, new Rectangle(0,0,stage.stageWidth,stage.stageHeight));
        config.enableStats = true;

        // Get the Genome2D instance
        genome = Genome2D.getInstance();
        // Add a callback for Genome2D initialization
        genome.onInitialized.addOnce(genomeInitializedHandler);
        // Initialize Genome2D
        genome.init(config);
    }

    private function genomeInitializedHandler():void {
        // Create a crate texture
        //GTextureAtlasFactory.createFromBitmapDataAndXml("assets", (new AssetsPNG as Bitmap).bitmapData, Xml.parse(new AssetsXML()));
        // Create our assets atlas
        GTextureAtlasFactory.createFromEmbedded("assets", AssetsPNG, AssetsXML);


        // Create top left movieclip without any transformation
        var clip:GMovieClip;

        clip = createMovieClip(300, 200, ["assets_g100","assets_g101","assets_g102","assets_g103","assets_g104","assets_g105"]);

        // Create top right movieclip with scale
        clip = createMovieClip(500, 200, ["assets_g100","assets_g101","assets_g102","assets_g103","assets_g104","assets_g105"]);
        clip.node.transform.setScale(2,2);

        // Create bottom left movieclip with rotation
        clip = createMovieClip(300, 400, ["assets_g100","assets_g101","assets_g102","assets_g103","assets_g104","assets_g105"]);
        clip.node.transform.rotation = 0.753;

        // Create bottom right movieclip with scale and rotation
        clip = createMovieClip(500, 400, ["assets_g100","assets_g101","assets_g102","assets_g103","assets_g104","assets_g105"]);
        clip.node.transform.rotation = 0.754;
        clip.node.transform.setScale(2,2);

        // Create middle left movieclip with alpha
        clip = createMovieClip(300, 300, ["assets_g100","assets_g101","assets_g102","assets_g103","assets_g104","assets_g105"]);
        clip.node.transform.alpha = .5;

        // Create middle right movieclip with tint
        clip = createMovieClip(500, 300, ["assets_g100","assets_g101","assets_g102","assets_g103","assets_g104","assets_g105"]);
        clip.node.transform.color = 0x00FF00;
    }

    // Create a movie clip helper function
    private function createMovieClip(p_x:int, p_y:int, p_frames:Array):GMovieClip {
        // Create a node with sprite component
        var clip:GMovieClip = GNodeFactory.createNodeWithComponent(GMovieClip) as GMovieClip;
        // Assign animation frames
        clip.setTextureFrameIds(p_frames);
        clip.frameRate = 10;
        // Set transform position for this node
        clip.node.transform.setPosition(p_x, p_y);
        // Add the node to root of the render graph
        genome.root.addChild(clip.node);

        return clip;
    }
}
}
