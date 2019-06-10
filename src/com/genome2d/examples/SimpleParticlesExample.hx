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

#if cs @:nativeGen #end
class SimpleParticlesExample extends AbstractExample
{
    #if !cs
    static public function main() {
        var inst = new SimpleParticlesExample();
    }
    #end

	private var _particleSystem:GSimpleParticleSystemD;

    /**
        Initialize Example code
     **/
    override public function initExample():Void {
		title = "SIMPLE PARTICLES EXAMPLE";
		detail = "Simple particle systems offer the most common functionality used for particle systems to achieve best performance.";
		
		// Create a node with simple particle system component
        _particleSystem = GNode.createWithComponent(GSimpleParticleSystemD);
        _particleSystem.texture = GTextureManager.getTexture("assets/atlas.png_particle");
        _particleSystem.emission = 128;
		_particleSystem.emissionTime = 1;
        _particleSystem.emit = true;
        _particleSystem.energy = 5;
        _particleSystem.initialColor = 0xff8800;
        _particleSystem.blendMode = GBlendMode.ADD;
		_particleSystem.dispersionAngleVariance = Math.PI*2;
        _particleSystem.initialVelocity = 20;
        _particleSystem.initialVelocityVariance = 40;
        _particleSystem.initialAngleVariance = 5;
        _particleSystem.initialScaleVariance = 10;
        _particleSystem.endAlpha = 0;
        _particleSystem.endColor = 0x550000;
        _particleSystem.initialScale = 5;
        _particleSystem.endScale = 3;
        _particleSystem.endScaleVariance = 3;
		_particleSystem.useWorldSpace = true;
		_particleSystem.node.setPosition(200, 100);
		container.addChild(_particleSystem.node);

        var sprite:GSprite = GNode.createWithComponent(GSprite);
        sprite.texture = GTextureManager.getTexture("assets/logo_white.png");
        sprite.node.blue = 0;
        sprite.node.green = 0;
        sprite.node.red = 0;
        sprite.node.setPosition(200,100);
        container.addChild(sprite.node);
    }
}
