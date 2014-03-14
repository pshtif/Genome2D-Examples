/**
 * Created by sHTiF on 4.12.2013.
 */
package examples {
import com.adobe.utils.AGALMiniAssembler;
import com.genome2d.Genome2D;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.context.GContextConfig;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.textures.factories.GTextureAtlasFactory;

import flash.display.BitmapData;

import flash.display.GraphicsBitmapFill;

import flash.display.MovieClip;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.display3D.Context3D;
import flash.events.Event;
import flash.geom.Rectangle;

[SWF(width="800", height="600", backgroundColor="#000000", frameRate="60")]
public class Example2Sprite extends MovieClip {

    [Embed(source = "../../assets/atlas.png")]
    static private const AssetsPNG:Class;
    [Embed(source = "../../assets/atlas.xml", mimeType = "application/octet-stream")]
    static public var AssetsXML:Class;

    private var genome:Genome2D;

    public function Example2Sprite() {
        if (stage != null) addedToStageHandler(null);
        else addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
    }

    private function addedToStageHandler(event:Event):void {
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

        // Create a context config that will be used to initialize the Genome2D
        var config:GContextConfig = new GContextConfig(new Rectangle(0,0,stage.stageWidth,stage.stageHeight), stage);
        config.enableDepthAndStencil = false;

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

        // Create top left sprite without any transformation
        var sprite:GSprite = createSprite(300, 200, "assets_g100");

        // Create top right sprite with scale
        sprite = createSprite(500, 200, "assets_g100");
        sprite.node.transform.setScale(2,2);

        // Create bottom left sprite with rotation
        sprite = createSprite(300, 400, "assets_g100");
        sprite.node.transform.rotation = 0.753;

        // Create bottom right sprite with scale and rotation
        sprite = createSprite(500, 400, "assets_g100");
        sprite.node.transform.rotation = 0.753;
        sprite.node.transform.setScale(2,2);

        // Create middle left sprite with alpha
        sprite = createSprite(300, 300, "assets_g100");
        sprite.node.transform.alpha = .5;

        // Create middle right sprite with tint
        sprite = createSprite(500, 300, "assets_g100");
        sprite.node.transform.color = 0x00FF00;
    }

    // Create a sprite helper function
    private function createSprite(p_x:int, p_y:int, p_textureId:String):GSprite {
        // Create a node with sprite component
        var sprite:GSprite = GNodeFactory.createNodeWithComponent(GSprite) as GSprite;
        // Assign a texture to the sprite based on the texture ID
        sprite.textureId = p_textureId;
        // Set transform position for this node
        sprite.node.transform.setPosition(p_x, p_y);
        // Add the node to root of the render graph
        genome.root.addChild(sprite.node);

        return sprite;
    }
}
}
