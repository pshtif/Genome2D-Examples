/**
 * Created by sHTiF on 4.12.2013.
 */
package examples {
import com.genome2d.Genome2D;
import com.genome2d.components.GCameraController;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.context.GContextConfig;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.textures.factories.GTextureAtlasFactory;

import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;

[SWF(width="800", height="600", backgroundColor="#000000", frameRate="60")]
public class Example5Cameras extends Sprite {

    [Embed(source = "../../assets/assets.png")]
    static private const AssetsPNG:Class;
    [Embed(source = "../../assets/assets.xml", mimeType = "application/octet-stream")]
    static public var AssetsXML:Class;

    private var genome:Genome2D;

    public function Example5Cameras() {
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

        // Create some sprites so the cameras have something to look at
        for (var i:int = 0; i<50; ++i) {
            createSprite(300+Math.random()*200, 200+Math.random()*200, "assets_g100");
        }

        // Create top left camera
        var camera:GCameraController = GNodeFactory.createNodeWithComponent(GCameraController) as GCameraController;
        // Set the normalized viewport of this camera to top left quarter of the screen
        camera.setView(0,0,.5,.5);
        // Set the camera position to the center of the stage
        camera.node.transform.setPosition(400,300);
        // Add camera to the render graph
        genome.root.addChild(camera.node);

        // Create top right camera
        camera = GNodeFactory.createNodeWithComponent(GCameraController) as GCameraController;
        camera.setView(.5,0,.5,.5);
        camera.zoom = .5;
        camera.node.transform.setPosition(400,300);
        genome.root.addChild(camera.node);

        // Create bottom left camera
        camera = GNodeFactory.createNodeWithComponent(GCameraController) as GCameraController;
        camera.setView(0,.5,.5,.5);
        camera.node.transform.rotation = 0.753;
        camera.node.transform.setPosition(400,300);
        genome.root.addChild(camera.node);

        // Create bottom right camera
        camera = GNodeFactory.createNodeWithComponent(GCameraController) as GCameraController;
        camera.setView(.5,.5,.5,.5);
        camera.node.transform.rotation = 0.753;
        camera.zoom = .5;
        camera.node.transform.setPosition(400,300);
        genome.root.addChild(camera.node);
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
