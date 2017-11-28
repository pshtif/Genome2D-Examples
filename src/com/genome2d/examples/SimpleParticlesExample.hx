/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.examples;

import com.genome2d.context.GBlendMode;
import com.genome2d.components.renderable.GSprite;
import com.genome2d.assets.GAssetManager;
import com.genome2d.deprecated.components.renderable.particles.GSimpleParticleSystemD;
import com.genome2d.input.GMouseInput;
import com.genome2d.input.GMouseInputType;
import com.genome2d.node.GNode;
import com.genome2d.textures.GTextureManager;

@:expose
class SimpleParticlesExample extends AbstractExample
{
/*
    static public function main() {
        var inst = new SimpleParticlesExample();
    }
/**/
	private var particleSystem:GSimpleParticleSystemD;

    /**
        Initialize Example code
     **/
    override public function initExample():Void {
		title = "SIMPLE PARTICLES EXAMPLE";
		detail = "Simple particle systems offer the most common functionality used for particle systems to achieve best performance.";
		
		// Create a node with simple particle system component
        particleSystem = GNode.createWithComponent(GSimpleParticleSystemD);
        particleSystem.texture = GTextureManager.getTexture("assets/atlas.png_particle");
        particleSystem.emission = 128;
		particleSystem.emissionTime = 1;
        particleSystem.emit = true;
        particleSystem.energy = 5;
        particleSystem.initialColor = 0xff8800;
        particleSystem.blendMode = GBlendMode.ADD;
		particleSystem.dispersionAngleVariance = Math.PI*2;
        particleSystem.initialVelocity = 20;
        particleSystem.initialVelocityVariance = 40;
        particleSystem.initialAngleVariance = 5;
        particleSystem.initialScaleVariance = 10;
        particleSystem.endAlpha = 0;
        particleSystem.endColor = 0x550000;
        particleSystem.initialScale = 5;
        particleSystem.endScale = 3;
        particleSystem.endScaleVariance = 3;
		particleSystem.useWorldSpace = true;
		particleSystem.node.setPosition(200, 100);
		container.addChild(particleSystem.node);

        var sprite:GSprite = GNode.createWithComponent(GSprite);
        sprite.texture = GTextureManager.getTexture("assets/logo_white.png");
        sprite.node.blue = 0;
        sprite.node.green = 0;
        sprite.node.red = 0;
        sprite.node.setPosition(200,100);
        container.addChild(sprite.node);
    }
}
