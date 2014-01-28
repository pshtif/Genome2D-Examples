/**
 * Created by sHTiF on 4.12.2013.
 */
package examples {
import com.genome2d.Genome2D;
import com.genome2d.components.renderables.GTextureText;
import com.genome2d.components.renderables.GTextureTextAlignType;
import com.genome2d.context.GContextConfig;
import com.genome2d.geom.GIntRectangle;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.textures.factories.GTextureAtlasFactory;

import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextFormat;

[SWF(width="800", height="600", backgroundColor="#000000", frameRate="60")]
public class TextureTextExample extends Sprite {

    [Embed(source = "../../assets/assets.png")]
    static private const AssetsPNG:Class;
    [Embed(source = "../../assets/assets.xml", mimeType = "application/octet-stream")]
    static public var AssetsXML:Class;

    private var genome:Genome2D;

    public function TextureTextExample() {
        if (stage != null) addedToStageHandler(null);
        else addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
    }

    private function addedToStageHandler(event:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

        // Create a context config that will be used to initialize the Genome2D
        var config:GContextConfig = new GContextConfig(stage, new GIntRectangle(0,0,stage.stageWidth,stage.stageHeight));
        config.enableStats = true;

        // Get the Genome2D instance
        genome = Genome2D.getInstance();
        // Add a callback for Genome2D initialization
        genome.onInitialized.addOnce(genomeInitializedHandler);
        // Initialize Genome2D
        genome.init(config);
    }

    private function genomeInitializedHandler():void {
        // Create our font atlas
        GTextureAtlasFactory.createFromFont("Arial", new TextFormat("Arial", 18, 0xFFFFFF), "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz2 .", false);

        createText(200, 300, "Arial", "Hello Genome2D world.", GTextureTextAlignType.MIDDLE, -4);

        var text:GTextureText = createText(600, 300, "Arial", "Hello Genome2D\nin awesome\nmultiline text.", GTextureTextAlignType.MIDDLE, -4, -4);
        text.node.transform.rotation = 0.753;
    }

    private function createText(p_x:Number, p_y:Number, p_textureAtlasId:String, p_text:String, p_align:int, p_tracking:int = 0, p_lineSpace:int = 0):GTextureText {
        // Create our texture text component
        var text:GTextureText = GNodeFactory.createNodeWithComponent(GTextureText) as GTextureText;
        // Specify the atlas where the font textures are
        text.textureAtlasId = p_textureAtlasId;
        // Specify the text being rendered
        text.text = p_text;
        // Specify character tracking
        text.tracking = p_tracking;
        // Specify line spacing
        text.lineSpace = p_lineSpace;
        // Specify the alignment of the text
        text.align = p_align;
        // Set the position of our component
        text.node.transform.setPosition(p_x, p_y);
        // Add it to the render list
        Genome2D.getInstance().root.addChild(text.node);
        return text;
    }
}
}
