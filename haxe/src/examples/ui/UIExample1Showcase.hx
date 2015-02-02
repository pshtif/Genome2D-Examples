/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package examples.ui;

import com.genome2d.utils.GVAlignType;
import com.genome2d.utils.GHAlignType;
import com.genome2d.assets.GAssetManager;
import flash.events.Event;
import flash.display.StageScaleMode;
import flash.Lib;
import com.genome2d.textures.GTexture;
import com.genome2d.components.ui.GUI;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureAtlas;
import com.genome2d.geom.GRectangle;
import com.genome2d.textures.GTextureSourceType;
import com.genome2d.textures.GTextureAtlas;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.ui.GUIButton;
import flash.display.BitmapData;
import com.genome2d.textures.factories.GTextureFactory;
import com.genome2d.components.GComponent;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.ui.controls.GUIContainer;
import com.genome2d.Genome2D;
import com.genome2d.context.GContextConfig;

class UIExample1Showcase
{
    static public function main() {
        var inst = new UIExample1Showcase();
    }

    /**
        Genome2D singleton instance
     **/
    private var genome:Genome2D;
    private var assetManager:GAssetManager;

    public function new() {
        initGenome();
    }

/**
        Initialize Genome2D
     **/
    private function initGenome():Void {
        genome = Genome2D.getInstance();
        genome.onInitialized.add(genomeInitializedHandler);
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
        assetManager = new GAssetManager();
        assetManager.addUrl("sd_gfx", "x1\\Logo.png");
        assetManager.addUrl("hd_gfx", "x2\\Logo.png");
        assetManager.onAllLoaded.add(assetsInitializedHandler);
        assetManager.load();
    }

    private function assetsInitializedHandler():Void {
        initExample();
    }

    private var screen1:GSprite;
    private var screen2:GSprite;
    private var screen3:GSprite;
    private var screen4:GSprite;
    private var stage1:GSprite;
    private var stage2:GSprite;
    private var stage3:GSprite;
    private var stage4:GSprite;

    /**
        Genome2D initialized handler
     **/
    private function initExample():Void {
        trace("here");
        Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;

        var sd:GTexture = GTextureFactory.createFromAsset("logo",assetManager.getImageAssetById("sd_gfx"),2);
        GTextureFactory.createFromBitmapData("stage", new BitmapData(32,32,false,0x00FF00));

        screen1 = cast GNodeFactory.createNodeWithComponent(GSprite);
        screen1.textureId = "logo";
        genome.root.addChild(screen1.node);
        screen2 = cast GNodeFactory.createNodeWithComponent(GSprite);
        screen2.textureId = "logo";
        genome.root.addChild(screen2.node);
        screen3 = cast GNodeFactory.createNodeWithComponent(GSprite);
        screen3.textureId = "logo";
        genome.root.addChild(screen3.node);
        screen4 = cast GNodeFactory.createNodeWithComponent(GSprite);
        screen4.textureId = "logo";
        genome.root.addChild(screen4.node);

        stage1 = cast GNodeFactory.createNodeWithComponent(GSprite);
        stage1.textureId = "stage";
        genome.root.addChild(stage1.node);
        stage2 = cast GNodeFactory.createNodeWithComponent(GSprite);
        stage2.textureId = "stage";
        genome.root.addChild(stage2.node);
        stage3 = cast GNodeFactory.createNodeWithComponent(GSprite);
        stage3.textureId = "stage";
        genome.root.addChild(stage3.node);
        stage4 = cast GNodeFactory.createNodeWithComponent(GSprite);
        stage4.textureId = "stage";
        genome.root.addChild(stage4.node);
    }
}