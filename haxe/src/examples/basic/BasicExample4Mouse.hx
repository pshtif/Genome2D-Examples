/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package examples.basic;

import com.genome2d.animation.GFrameAnimation;
import com.genome2d.components.renderable.GSprite;
import com.genome2d.input.GMouseInput;
import com.genome2d.textures.GTextureManager;
import com.genome2d.Genome2D;
import com.genome2d.node.GNode;
import com.genome2d.components.renderable.GSprite;
import com.genome2d.context.GContextConfig;
import com.genome2d.textures.GTexture;
import com.genome2d.assets.GAssetManager;

class BasicExample4Mouse
{

    static public function main() {
        var inst = new BasicExample4Mouse();
    }

    /**
        Genome2D singleton instance
     **/
    private var genome:Genome2D;

    /**
        Asset manager instance for loading assets
     **/
    private var assetManager:GAssetManager;

    public function new() {
        initGenome();
    }

    /**
        Initialize Genome2D
     **/
    private function initGenome():Void {
        genome = Genome2D.getInstance();
        genome.onInitialized.addOnce(genomeInitializedHandler);
        genome.init(new GContextConfig());
    }

    /**
        Genome2D initialized handler
     **/
    private function genomeInitializedHandler():Void {
        initAssets();
    }

    /**
        Initialize assets
     **/
    private function initAssets():Void {
        GAssetManager.addFromUrl("atlas.png");
        GAssetManager.addFromUrl("atlas.xml");
        GAssetManager.onQueueLoaded.addOnce(assetsLoadedHandler);
        GAssetManager.loadQueue();
    }

    /**
        Assets initialization handler dispatched after all assets were initialized
     **/
    private function assetsLoadedHandler():Void {
        initExample();
    }

    /**
        Initialize Example code
     **/
    private function initExample():Void {
        trace("initExample");
        GAssetManager.generateTextures();

        var sprite:GSprite = createAnimatedSprite(400, 300);

        sprite.node.mouseEnabled = true;
        sprite.node.onMouseClick.add(mouseClickHandler);
        sprite.node.onMouseOver.add(mouseOverHandler);
        sprite.node.onMouseOut.add(mouseOutHandler);
        sprite.node.onMouseDown.add(mouseDownHandler);
        sprite.node.onMouseUp.add(mouseUpHandler);

        genome.root.addChild(sprite.node);
		
		genome.getContext().onMouseInput.add(contextMouse);
    }
	
	private function contextMouse(input:GMouseInput):Void {
		trace(input.localX, input.localY, input.contextX, input.contextY);
	}

    /**
        Mouse click handler
     **/
    private function mouseClickHandler(signal:GMouseInput):Void {
        trace("CLICK");
    }

    /**
        Mouse over handler
     **/
    private function mouseOverHandler(signal:GMouseInput):Void {
        trace("OVER");
    }

    /**
        Mouse out handler
     **/
    private function mouseOutHandler(signal:GMouseInput):Void {
        trace("OUT");
    }

    /**
        Mouse down handler
     **/
    private function mouseDownHandler(signal:GMouseInput):Void {
        trace("DOWN");
    }

    /**
        Mouse up handler
     **/
    private function mouseUpHandler(signal:GMouseInput):Void {
        trace("UP");
    }
	
	/**
        Create an animated sprite helper function
     **/
    private function createAnimatedSprite(p_x:Int, p_y:Int):GSprite {
		var animation:GFrameAnimation = new GFrameAnimation(GTextureManager.getTexturesByIds(["atlas.png_1", "atlas.png_2", "atlas.png_3", "atlas.png_4", "atlas.png_5", "atlas.png_6", "atlas_7"]));
		animation.frameRate = 10;
        var sprite:GSprite = GNode.createWithComponent(GSprite);
        sprite.frameAnimation = animation;
        sprite.node.setPosition(p_x, p_y);
        genome.root.addChild(sprite.node);

        return sprite;
    }
}
