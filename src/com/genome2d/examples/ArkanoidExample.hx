/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.examples;
#if nape
import com.genome2d.input.GMouseInputType;
import com.genome2d.input.GMouseInput;
import spinehaxe.Polygon;
import com.genome2d.context.GBlendMode;
import com.genome2d.components.renderable.GSprite;
import com.genome2d.examples.AbstractExample;
import com.genome2d.node.GNode;
import com.genome2d.textures.GTextureManager;

import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.phys.Material;
import nape.space.Space;
import nape.util.BitmapDebug;
import nape.util.Debug;

#if cs @:nativeGen #end
class ArkanoidExample extends AbstractExample
{
	#if !cs
    static public function main() {
        var inst = new ArkanoidExample();
    }
	#end
	private var space:Space;
	private var walls:Body;
	
	private var objects:Array<GNode>;
	private var accumulatedTime:Float = 0;
	private var player:GNode;
	
    /**
        Initialize Example code
     **/
    override public function initExample():Void {		
		title = "PHYSICS EXAMPLE";
		detail = "Sprite component is the most basic renderable component to render static and animated sprites.";
		

		space = new Space(Vec2.weak(0, 0));
		space.worldLinearDrag = 0;
		
		walls = new Body(BodyType.STATIC);
		var poly:Polygon = new Polygon(Polygon.rect(0, 600, 800, 1));
		poly.material = new Material(1,0,0);
		walls.shapes.add(poly);
		poly = new Polygon(Polygon.rect(0, 0, 800, 1));
		poly.material = new Material(1,0,0);
		walls.shapes.add(poly);
		poly = new Polygon(Polygon.rect(0, 0, 1, 600));
		poly.material = new Material(1,0,0);
		walls.shapes.add(poly);
		poly = new Polygon(Polygon.rect(800, 0, 1, 600));
		poly.material = new Material(1,0,0);
		walls.shapes.add(poly);
		walls.space = space;
		
		objects = new Array<GNode>();
		/**/
        var sprite:GSprite;
		
		for (i in 0...5) {
			// Create a sprite
			sprite = createSprite(Math.random()*500+100, Math.random()*300+50, "assets/ball.png");
		}

		createPlayer();
		
		getGenome().onUpdate.add(update_handler);
		getGenome().onMouseInput.add(mouseInput_handler);
    }

	private function mouseInput_handler(p_input:GMouseInput):Void {
		if (p_input.type == GMouseInputType.MOUSE_MOVE) {
			cast (player.userData, Body).position.x = p_input.contextX;
		}
	}

	private function update_handler(p_deltaTime:Float):Void {
		if (p_deltaTime > 0) space.step(p_deltaTime / 1000);
		accumulatedTime+= p_deltaTime;
		if (accumulatedTime > 1500) {
			accumulatedTime = 0;
		}
		
		
		for (node in objects) {
			var body:Body = cast node.userData;
			node.setPosition(body.position.x, body.position.y);
			node.rotation = body.rotation;
		}

		var playerBody:Body = cast player.userData;
		player.setPosition(playerBody.position.x, playerBody.position.y);
	}

    /**
        Create a sprite helper function
     **/
    private function createSprite(p_x:Float, p_y:Float, p_textureId:String):GSprite {
		// Create a node with sprite component
        var sprite:GSprite = GNode.createWithComponent(GSprite);
        sprite.texture = GTextureManager.getTexture(p_textureId);
        sprite.node.setPosition(p_x, p_y);
		sprite.blendMode = GBlendMode.ADD;
        container.addChild(sprite.node);
		var body:Body = new Body(BodyType.DYNAMIC);
		body.allowRotation = false;
		//body.shapes.add(new Polygon(Polygon.box(32, 32)));
		var circle:Circle = new Circle(9);
		circle.material = new Material(1,0,0);
		body.shapes.add(circle);
		body.position.setxy(p_x, p_y);
		body.space = space;
		body.applyImpulse(Vec2.get(100*Math.random(),100*Math.random()), body.position);
		sprite.node.userData = body;
		
		objects.push(sprite.node);

        return sprite;
    }

	private function createPlayer():Void {
		// Create a node with sprite component
		var sprite:GSprite = GNode.createWithComponent(GSprite);
		sprite.texture = GTextureManager.getTexture("assets/atlas.png_0");
		sprite.node.setPosition(400, 550);
		sprite.blendMode = GBlendMode.ADD;
		player = sprite.node;
		container.addChild(player);
		var body:Body = new Body(BodyType.KINEMATIC);
		body.allowRotation = false;
		var poly:Polygon = new Polygon(Polygon.box(32, 32));
		poly.material = new Material(1,0,0);
		body.shapes.add(poly);
		body.position.setxy(400, 550);
		body.space = space;
		player.userData = body;
	}
	
	override public function dispose():Void {
		for (node in objects) {
			var body:Body = cast node.userData;
			body.space = null;
		}
		
		walls.space = null;
		space.clear();
		
		super.dispose();
	}
}
#end
