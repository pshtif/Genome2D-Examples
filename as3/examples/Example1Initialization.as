/**
 * Created by sHTiF on 19.2.2014.
 */
package examples {
import com.genome2d.Genome2D;
import com.genome2d.context.GContextConfig;

import flash.display.MovieClip;

import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;

public class Example1Initialization extends MovieClip {
    private var genome:Genome2D;

    public function Example1Initialization() {
        if (stage != null) addedToStageHandler(null);
        else addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
    }

    private function addedToStageHandler(event:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

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
        // Here we can do any Genome2D related code as its initialized)
    }
}
}
