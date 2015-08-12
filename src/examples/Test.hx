/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package examples;

import com.genome2d.assets.GAsset;
import com.genome2d.assets.GAssetManager;
import com.genome2d.components.renderable.flash.GFlashText;
import com.genome2d.components.renderable.GSprite;
import com.genome2d.components.renderable.ui.GUI;
import com.genome2d.context.GContextConfig;
import com.genome2d.context.stage3d.GShaderCode;
import com.genome2d.context.stage3d.renderers.GBufferRenderer;
import com.genome2d.context.stats.GStats;
import com.genome2d.Genome2D;
import com.genome2d.geom.GRectangle;
import com.genome2d.node.GNode;
import com.genome2d.proto.GPrototype;
import com.genome2d.proto.GPrototypeFactory;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureManager;
import com.genome2d.ui.element.GUIElement;
import com.genome2d.ui.layout.GUIHorizontalLayout;
import com.genome2d.ui.skin.GUITextureSkin;
import flash.display.BitmapData;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.display3D.Context3DProfile;
import flash.Lib;
import flash.Vector;

class Test
{
    static public function main() {
        var inst = new Test();
    }

    /**
        Genome2D singleton instance
     **/
    private var genome:Genome2D;

    public function new() {
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		
        initGenome();
    }

    /**
        Initialize Genome2D
     **/
    private function initGenome():Void {
		GStats.visible = true;
		
		GStats.customStats = [Std.string(Lib.current.stage.stageWidth), Std.string(Lib.current.stage.stageHeight)];
		var config:GContextConfig = new GContextConfig();
		//config.profile = Context3DProfile.BASELINE_CONSTRAINED;
        genome = Genome2D.getInstance();
		genome.onFailed.addOnce(genomeFailed_handler);
        genome.onInitialized.addOnce(genomeInitialized_handler);
        genome.init(config);
    }

	/**
        Genome2D failed handler
     **/
    private function genomeFailed_handler(p_msg:String):Void {
        // Here we can check why Genome2D initialization failed
    }
	
    /**
        Genome2D initialized handler
     **/
    private function genomeInitialized_handler():Void {
        loadAssets();
    }
	
	/**	
	 * 	Asset loading
	 */
	private function loadAssets():Void {
		GAssetManager.addFromUrl("atlas.png");
        GAssetManager.addFromUrl("atlas.xml");
		GAssetManager.addFromUrl("texture.png");
		GAssetManager.onQueueFailed.add(assetsFailed_handler);
        GAssetManager.onQueueLoaded.addOnce(assetsLoaded_handler);
        GAssetManager.loadQueue();
	}
	
	/**
	 * 	Asset loading failed
	 */
	private function assetsFailed_handler(p_asset:GAsset):Void {
		// Asset loading failed at p_asset
	}
	
	/**
	 * 	Asset loading completed
	 */
	private function assetsLoaded_handler():Void {
		initExample();
	}

    /**
        Initialize Example code
     **/
	private var renderer:GBufferRenderer;
    private function initExample():Void {
		// Generate textures from all assets, their IDs will be the same as their asset ID
		GAssetManager.generateTextures();
		
		testElement();
	}
	
	private function testElement():Void {
		var ui:GUI = GNode.createWithComponent(GUI);
		ui.setBounds(new GRectangle(0, 0, 800, 600));
		genome.root.addChild(ui.node);
		
		var skin:GUITextureSkin = new GUITextureSkin("texture", GTextureManager.getTexture("texture"));
		trace(skin.getPrototype().toXml());
		var skin2:GUITextureSkin = cast GPrototypeFactory.createPrototype(GPrototype.fromXml(Xml.parse('<textureSkin texture="@texture" id="test"/>').firstElement()));
		trace(skin2.id, skin2.toReference());
		
		var element:GUIElement = new GUIElement();
		element.skin = skin2;
		trace(element.skin.id, element.skin.toReference());
		ui.root.addChild(element);
		
		trace(element.getPrototype().toXml());

		
		/*
		var prototype:GPrototype = element.getPrototype();
		var prototypeXml:Xml = prototype.toXml();
		
		trace(prototypeXml);

		element = cast GPrototypeFactory.createPrototype(prototype);
		
		trace(element.getPrototype().toXml());
		
		prototype = GPrototype.fromXml(prototypeXml);
		
		element = cast GPrototypeFactory.createPrototype(prototype);
		
		trace(element.getPrototype().toXml());
		/**/
	}		

	private function testNode():Void {
		var sprite:GSprite = GNode.createWithComponent(GSprite);
		sprite.texture = GTextureManager.getTexture("atlas_0");
		var prototype:GPrototype = sprite.node.getPrototype();
		var prototypeXml:Xml = prototype.toXml();
		
		trace(prototypeXml);
		
		var prototypeNode:GNode = GNode.createFromPrototype(prototype);
		
		trace(prototypeNode.getPrototype().toXml());
		
		prototype = GPrototype.fromXml(prototypeXml);
		
		var xmlNode:GNode = GNode.createFromPrototype(prototype);
		
		trace(xmlNode.getPrototype().toXml());
	}
}
