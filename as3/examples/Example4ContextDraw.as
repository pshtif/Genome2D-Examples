/**
 * Created by sHTiF on 9.1.2014.
 */
package examples {
import com.genome2d.Genome2D;
import com.genome2d.context.GContextConfig;
import com.genome2d.context.IContext;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.factories.GTextureAtlasFactory;

import flash.display.MovieClip;
import flash.events.Event;
import flash.geom.Rectangle;

[SWF(width="700", height="410", backgroundColor="#000000", frameRate="60")]
public class Example4ContextDraw extends MovieClip {
    [Embed(source = "../../assets/atlas.png")]
    static private const AssetsPNG:Class;
    [Embed(source = "../../assets/atlas.xml", mimeType = "application/octet-stream")]
    static public var AssetsXML:Class;

    private var genome:Genome2D;
    private var texture:GTexture;

    public function Example4ContextDraw() {
        if (stage != null) addedToStageHandler(null);
        else addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
    }

    private function addedToStageHandler(event:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

        // Create a context config that will be used to initialize the Genome2D
        var config:GContextConfig = new GContextConfig(new Rectangle(0,0,stage.stageWidth,stage.stageHeight), stage);

        // Get the Genome2D instance
        genome = Genome2D.getInstance();
        // Add a callback for Genome2D initialization
        genome.onInitialized.addOnce(genomeInitializedHandler);
        // Initialize Genome2D
        genome.init(config);
    }

    private function genomeInitializedHandler():void {
        // Create our assets atlas
        GTextureAtlasFactory.createFromEmbedded("assets", AssetsPNG, AssetsXML);

        texture = GTexture.getTextureById("assets_g100");

        Genome2D.getInstance().onPreRender.add(preRenderHandler);
    }

    private function preRenderHandler():void {
        var context:IContext = Genome2D.getInstance().getContext();
        // Draw using coordinates
        context.draw(texture, 200, 200);

        // Draw using matrix
        context.drawMatrix(texture, -1, 1, 0, 1, 300, 200);
    }
}
}
