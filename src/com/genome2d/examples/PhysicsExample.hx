/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.examples;

import com.genome2d.animation.GFrameAnimation;
import com.genome2d.components.renderable.GSprite;
import com.genome2d.examples.AbstractExample;
import com.genome2d.node.GNode;
import com.genome2d.textures.GTextureManager;

#if nape
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.space.Space;
import nape.util.BitmapDebug;
import nape.util.Debug;
#elseif box2d
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2World;
import box2D.collision.shapes.B2PolygonShape;
import box2D.common.math.B2Transform;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.B2FixtureDef;
#end

class PhysicsExample extends AbstractExample
{
    static public function main() {
        var inst = new PhysicsExample();
    }
	
	#if nape
	private var space:Space;
	private var walls:Body;
	#elseif box2d
	private var world:B2World;
	private var floor:B2Body;
	private var physScale:Float = 30;
	#end
	
	private var objects:Array<GNode>;
	private var accumulatedTime:Float = 0;
	
    /**
        Initialize Example code
     **/
    override public function initExample():Void {		
		title = "PHYSICS EXAMPLE";
		detail = "Sprite component is the most basic renderable component to render static and animated sprites.";
		
		
		#if nape
		space = new Space(Vec2.weak(800, 600));
		
		walls = new Body(BodyType.STATIC);
		walls.shapes.add(new Polygon(Polygon.rect(0, 450, 800, 1)));
		walls.shapes.add(new Polygon(Polygon.rect(0, 0, 800, 1)));
		walls.shapes.add(new Polygon(Polygon.rect(0, 0, 1, 450)));
		walls.shapes.add(new Polygon(Polygon.rect(800, 0, 1, 450)));
		walls.space = space;
		#elseif box2d
		var gravity:B2Vec2 = new B2Vec2(0.0, 60.0);
		world = new B2World(gravity, true);
		world.setWarmStarting(true);
		
		var floorDef:B2BodyDef = new B2BodyDef();
		floorDef.position.set(400 / physScale, 475 / physScale);
		var floorFix:B2PolygonShape = new B2PolygonShape();
		floorFix.setAsBox(350 / physScale, 25 / physScale);
		
		walls = world.createBody(floorDef);
		walls.createFixture2(floorFix);
		#end
		
		objects = new Array<GNode>();
		/**/
        var sprite:GSprite;
		
		for (i in 0...50) {
			// Create a sprite
			sprite = createSprite(Math.random()*500+100, Math.random()*300+50, "assets/atlas.png_"+Std.int(Math.random()*9));
		}
		
		getGenome().onUpdate.add(update_handler);
    }
	
	#if nape
	private function update_handler(p_deltaTime:Float):Void {
		if (p_deltaTime > 0) space.step(p_deltaTime / 1000);
		accumulatedTime+= p_deltaTime;
		if (accumulatedTime > 1500) {
			accumulatedTime = 0;
			space.gravity.x = -space.gravity.x;
			space.gravity.y = -space.gravity.y;
		}
		
		
		for (node in objects) {
			var body:Body = cast node.userData;
			node.setPosition(body.position.x, body.position.y);
			node.rotation = body.rotation;
		}
	}
	#elseif box2d
	private function update_handler(p_deltaTime:Float):Void {
		world.step(p_deltaTime/1000, 10, 10);
		world.clearForces();
		
		for (node in objects) {
			var body:B2Body = cast node.userData;

			var pos:B2Vec2 = body.getPosition();
			node.setPosition(pos.x * physScale, pos.y * physScale);
			node.rotation = body.getAngle();
		}
	}
	#end

    /**
        Create a sprite helper function
     **/
    private function createSprite(p_x:Float, p_y:Float, p_textureId:String):GSprite {
		// Create a node with sprite component
        var sprite:GSprite = GNode.createWithComponent(GSprite);
        sprite.texture = GTextureManager.getTexture(p_textureId);
        sprite.node.setPosition(p_x, p_y);
        container.addChild(sprite.node);
		
		#if nape
		var body:Body = new Body(BodyType.DYNAMIC);
		body.shapes.add(new Polygon(Polygon.box(32, 32)));
		body.position.setxy(p_x, p_y);
		body.space = space;
		#elseif box2d
		var bodyDef:B2BodyDef = new B2BodyDef();
		bodyDef.position.set(p_x/physScale, p_y/physScale);
		bodyDef.type = DYNAMIC_BODY;

		var box:B2PolygonShape = new B2PolygonShape();
		box.setAsBox(16/physScale, 16/physScale);
		
		var fixtureDef:B2FixtureDef = new B2FixtureDef();
		fixtureDef.density = 1;
		fixtureDef.friction = .5;
		fixtureDef.restitution = .1;
		fixtureDef.shape = box;

		var body:B2Body = world.createBody(bodyDef);
		body.createFixture(fixtureDef);
		#end
		
		sprite.node.userData = body;
		
		objects.push(sprite.node);

        return sprite;
    }
	
	override public function dispose():Void {
		#if nape
		for (node in objects) {
			var body:Body = cast node.userData;
			body.space = null;
		}
		
		walls.space = null;
		space.clear();	
		#elseif box2d
		// TODO dispose box2d stuff
		#end
		
		super.dispose();
	}
}
