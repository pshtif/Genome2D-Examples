/**
 * Created by sHTiF on 4.12.2013.
 */
package examples {
import com.genome2d.Genome2D;
import com.genome2d.components.renderables.particles.GSimpleParticleSystem;
import com.genome2d.context.GContextConfig;
import com.genome2d.geom.GIntRectangle;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.textures.factories.GTextureAtlasFactory;

import flash.display.Sprite;
import flash.events.Event;

[SWF(width="800", height="600", backgroundColor="#000000", frameRate="60")]
public class SimpleParticleSystemExample extends Sprite {

    [Embed(source = "../../assets/assets.png")]
    static private const AssetsPNG:Class;
    [Embed(source = "../../assets/assets.xml", mimeType = "application/octet-stream")]
    static public var AssetsXML:Class;

    private var genome:Genome2D;

    public function SimpleParticleSystemExample() {
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
        // Create our assets atlas
        GTextureAtlasFactory.createFromEmbedded("assets", AssetsPNG, AssetsXML);

        // Create our simple particle system
        var simpleParticleSystem:GSimpleParticleSystem = GNodeFactory.createNodeWithComponent(GSimpleParticleSystem) as GSimpleParticleSystem;
        // Specify texture id used for the particles
        simpleParticleSystem.textureId = "assets_g100";
        // Specify emission of particles per seconds
        simpleParticleSystem.emission = 10;
        // Enable emitting of particles
        simpleParticleSystem.emit = true;
        // Specify the angle particles will emit from
        simpleParticleSystem.dispersionAngleVariance = Math.PI*2;
        // Specify energy of particles 1 means they will live for 1 second
        simpleParticleSystem.energy = 1;
        // Specify initial velocity of particles
        simpleParticleSystem.initialVelocity = 50;
        // Specify random variance of initial velocity
        simpleParticleSystem.initialVelocityVariance = 100;
        // Specify random variance of particle angle
        simpleParticleSystem.initialAngleVariance = 5;
        // Specify end alpha
        simpleParticleSystem.endAlpha = 0;
        // Specify end scale
        simpleParticleSystem.endScale = .2;
        // Set the position of the particle system
        simpleParticleSystem.node.transform.setPosition(400,300);
        // Add the particle system to our display graph
        Genome2D.getInstance().root.addChild(simpleParticleSystem.node);
    }
}
}
