/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.examples;

import com.genome2d.deprecated.components.renderable.particles.GSimpleParticleSystemD;
import com.genome2d.animation.GFrameAnimation;
import com.genome2d.components.GCameraController;
import com.genome2d.components.renderable.GSprite;
import com.genome2d.components.renderable.particles.GParticleSystemComponent;
import com.genome2d.examples.AbstractExample;
import com.genome2d.examples.custom.ParticleModule;
import com.genome2d.geom.GCurve;
import com.genome2d.node.GNode;
import com.genome2d.particles.GParticleEmitter;
import com.genome2d.textures.GTextureManager;

class CameraExample extends AbstractExample
{
    static public function main() {
        var inst = new CameraExample();
    }

    /**
        Initialize Example code
     **/
    override public function initExample():Void {		
		title = "MULTI CAMERA EXAMPLE";
		detail = "Example showcasing multiple instanced cameras with different viewports while rendering the same scene. Cameras can be used with different position, scaling, rotation, viewports to suit your needs. Commonly used  to render split screen or UI elements while maintaining aspect ratios across different devices. Using cameras for scene transformations is in most cases the most optimal solution since it doesn't involve invalidation and is directly updated within projection matrix in shader.";
		
		/**/
		var camera1:GCameraController = GNode.createWithComponent(GCameraController);
		camera1.node.setPosition(400, 300);
		camera1.setView(0, 0, .5, 1);
		camera1.contextCamera.group = 3;
		getGenome().root.addChild(camera1.node);
		
		var camera2:GCameraController = GNode.createWithComponent(GCameraController);
		camera2.node.setPosition(400, 300);
		camera2.setView(0.5, 0, .5, 1);
		camera2.zoom = 4;
		camera2.contextCamera.group = 3;
		getGenome().root.addChild(camera2.node);

		// Create a node with simple particle system component
		var particleSystem:GSimpleParticleSystemD = GNode.createWithComponent(GSimpleParticleSystemD);
		particleSystem.texture = GTextureManager.getTexture("assets/atlas.png_particle");
		particleSystem.emission = 128;
		particleSystem.emissionTime = 1;
		particleSystem.emit = true;
		particleSystem.energy = 5;
		particleSystem.dispersionAngleVariance = Math.PI*2;
		particleSystem.initialVelocity = 20;
		particleSystem.initialVelocityVariance = 40;
		particleSystem.initialAngleVariance = 5;
		particleSystem.endAlpha = 0;
		particleSystem.initialScale = 2;
		particleSystem.endScale = .2;
		particleSystem.useWorldSpace = true;
		particleSystem.node.setPosition(400, 300);
		particleSystem.node.cameraGroup = 2;
		container.addChild(particleSystem.node);

		var emitter:GParticleEmitter = new GParticleEmitter();
		emitter.texture = GTextureManager.getTexture("assets/atlas.png_particle");
		emitter.rate = new GCurve(50);
		emitter.duration = 10;
		emitter.loop = true;
		emitter.addModule(new ParticleModule());
		
		// Create a node with simple particle system component
        var particleSystem:GParticleSystemComponent = GNode.createWithComponent(GParticleSystemComponent);
		particleSystem.particleSystem.addEmitter(emitter);
		particleSystem.node.setPosition(400, 300);
		particleSystem.node.cameraGroup = 2;
		container.addChild(particleSystem.node);
    }
}
