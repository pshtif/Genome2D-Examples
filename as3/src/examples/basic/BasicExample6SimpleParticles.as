/*
 * 	Genome2D - GPU 2D framework utilizing Molehill API
 * 	http://www.genome2d.com
 *
 *	Copyright 2011 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package examples.basic {
import com.genome2d.Genome2D;
import com.genome2d.assets.GAssetManager;
import com.genome2d.components.renderables.particles.GSimpleParticleSystem;
import com.genome2d.context.GContextConfig;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.textures.factories.GTextureAtlasFactory;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

[SWF(width="800", height="600", backgroundColor="#000000", frameRate="60")]
public class BasicExample6SimpleParticles extends Sprite
{
    /**
        Genome2D singleton instance
     **/
    private var genome:Genome2D;

    /**
        Asset manager instance for loading assets
     **/
    private var assetManager:GAssetManager;

    public function BasicExample6SimpleParticles() {
        if (stage != null) addedToStageHandler(null);
        else addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
    }

    private function addedToStageHandler(event:Event):void {
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

        initGenome();
    }

    /**
        Initialize Genome2D
     **/
    private function initGenome():void {
        // Get the Genome2D instance
        genome = Genome2D.getInstance();
        // Add a callback for Genome2D initialization
        genome.onInitialized.addOnce(genomeInitializedHandler);
        // Initialize Genome2D
        genome.init(new GContextConfig(stage));
    }

    /**
        Genome2D initialized handler
     **/
    private function genomeInitializedHandler():void {
        initAssets();
    }

    /**
        Initialize assets
     **/
    private function initAssets():void {
        assetManager = new GAssetManager();
        assetManager.addUrl("atlas_gfx", "atlas.png");
        assetManager.addUrl("atlas_xml", "atlas.xml");
        assetManager.onAllLoaded.add(assetsInitializedHandler);
        assetManager.load();
    }

    /**
        Assets initialization handler dispatched after all assets were initialized
     **/
    private function assetsInitializedHandler():void {
        initExample();
    }

    /**
        Initialize Example code
     **/
    private function initExample():void {
        trace("here");
        // Create our assets atlas
        GTextureAtlasFactory.createFromAssets("atlas", assetManager.getImageAssetById("atlas_gfx"), assetManager.getXmlAssetById("atlas_xml"));

        // Create our simple particle system
        var simpleParticleSystem:GSimpleParticleSystem = GNodeFactory.createNodeWithComponent(GSimpleParticleSystem) as GSimpleParticleSystem;
        // Specify texture id used for the particles
        simpleParticleSystem.textureId = "atlas_particle";
        // Specify emission of particles per seconds
        simpleParticleSystem.emission = 128;
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
