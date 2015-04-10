/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package examples.advanced;

import com.genome2d.input.GKeyboardInputType;
import com.genome2d.signals.GKeyboardInput;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.Lib;
import flash.text.TextField;
import com.genome2d.postprocesses.GBlurPP;
import com.genome2d.context.filters.GPixelateFilter;
import flash.display.BitmapData;
import com.genome2d.postprocesses.GBloomPP;
import com.genome2d.textures.GTextureFilteringType;
import com.genome2d.textures.GTexture;
import com.genome2d.context.filters.GDesaturateFilter;
import com.genome2d.postprocesses.GFilterPP;
import com.genome2d.geom.GRectangle;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.factories.GTextureFactory;
import com.genome2d.context.stage3d.GStage3DContext;
import com.genome2d.context.filters.GBlurPassFilter;
import com.genome2d.postprocesses.GBlurPP;
import com.genome2d.node.GNode;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.input.GMouseInput;
import com.genome2d.components.GCameraController;
import com.genome2d.textures.GTexture;
import com.genome2d.tilemap.GTile;
import com.genome2d.components.renderables.tilemap.GTileMap;
import com.genome2d.textures.factories.GTextureAtlasFactory;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.Genome2D;
import com.genome2d.context.GContextConfig;
import com.genome2d.assets.GAssetManager;

class AdvancedExample3PostProcess
{
    static public function main() {
        var inst = new AdvancedExample3PostProcess();
    }

    /**
        Genome2D singleton instance
     **/
    private var genome:Genome2D;
    private var container:GNode;
    private var blurPP:GBlurPP;
    private var sprite1:GSprite;
    private var pix1PP:GFilterPP;
    private var sprite2:GSprite;
    private var pix2PP:GFilterPP;
    private var sprite3:GSprite;
    private var pix3PP:GFilterPP;

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
        var dtf:TextFormat = new TextFormat("Arial",12,0xFFFFFF);
        var tf:TextField = new TextField();
        tf.defaultTextFormat = dtf;
        tf.autoSize = TextFieldAutoSize.LEFT;
        tf.text =
        "Genome2D HIERARCHICAL POSTPROCESSING DEMO\n" +
        "Press 1 to ENABLE/DISABLE parent postprocess\n" +
        "Press 2/3/4 to ENABLE/DISABLE specific child postprocess";
        Lib.current.addChild(tf);

        genome = Genome2D.getInstance();
        genome.onInitialized.add(genomeInitializedHandler);
        genome.init(new GContextConfig());
    }

    /**
        Genome2D initialized handler
     **/
    private function genomeInitializedHandler():Void {
        //initAssets();
        initExample();
    }

    /**
        Initialize assets
     **/
    private function initAssets():Void {
        assetManager = new GAssetManager();
        assetManager.addUrl("atlas_gfx", "atlas.png");
        assetManager.addUrl("atlas_xml", "atlas.xml");
        assetManager.onAllLoaded.add(assetsInitializedHandler);
        assetManager.load();
    }

    /**
        Assets initialization handler dispatched after all assets were initialized
     **/
    private function assetsInitializedHandler():Void {
        initExample();
    }

    /**
        Initialize Example code
     **/
    private function initExample():Void {
        //GTextureAtlasFactory.createFromAssets("atlas", cast assetManager.getAssetById("atlas_gfx"), cast assetManager.getAssetById("atlas_xml"));

        GTextureFactory.createFromBitmapData("red",new BitmapData(32,32,false,0xFF0000));
        GTextureFactory.createFromBitmapData("green",new BitmapData(32,32,false,0x00FF00));
        GTextureFactory.createFromBitmapData("blue",new BitmapData(32,32,false,0x0000FF));

        blurPP = new GBlurPP(32,0,2);
        container = GNodeFactory.createNode();
        container.transform.setPosition(400,300);
        container.postProcess = blurPP;
        genome.root.addChild(container);

        pix1PP = new GFilterPP([new GPixelateFilter(4)]);
        sprite1 = createSprite(0, -100, "red");
        sprite1.node.postProcess = pix1PP;

        pix2PP = new GFilterPP([new GPixelateFilter(7)]);
        sprite2 = createSprite(0, 0, "green");
        sprite2.node.postProcess = pix2PP;

        pix3PP = new GFilterPP([new GPixelateFilter(10)]);
        sprite3 = createSprite(0, 100, "blue");
        sprite3.node.postProcess = pix3PP;

        genome.onUpdate.add(updateHandler);
        genome.onKeySignal.add(keyHandler);
    }

    private function keyHandler(p_signal:GKeyboardInput):Void {
        if (p_signal.type != GKeyboardInputType.KEY_DOWN) return;
        switch (p_signal.keyCode) {
            case 49:
                container.postProcess = container.postProcess == null ? blurPP : null;
            case 50:
                sprite1.node.postProcess = sprite1.node.postProcess == null ? pix1PP : null;
            case 51:
                sprite2.node.postProcess = sprite2.node.postProcess == null ? pix2PP : null;
            case 52:
                sprite3.node.postProcess = sprite3.node.postProcess == null ? pix3PP : null;

        }
    }

    private function updateHandler(p_deltaTime:Float):Void {
        container.transform.rotation+=.001*p_deltaTime;
    }

    /**
        Create a sprite helper function
     **/
    private function createSprite(p_x:Int, p_y:Int, p_textureId:String):GSprite {
        var sprite:GSprite = cast GNodeFactory.createNodeWithComponent(GSprite);
        sprite.textureId = p_textureId;
        sprite.node.transform.setPosition(p_x, p_y);
        container.addChild(sprite.node);

        return sprite;
    }
}
