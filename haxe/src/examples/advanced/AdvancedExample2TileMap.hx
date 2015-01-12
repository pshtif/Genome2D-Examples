/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package examples.advanced;

import com.genome2d.signals.GNodeMouseSignal;
import flash.display.BitmapData;
import com.genome2d.textures.factories.GTextureFactory;
import com.genome2d.signals.GMouseSignal;
import com.genome2d.components.GCameraController;
import com.genome2d.textures.GTexture;
import com.genome2d.tilemap.GTile;
import com.genome2d.components.renderables.tilemap.GTileMap;
import com.genome2d.textures.factories.GTextureAtlasFactory;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.Genome2D;
import com.genome2d.context.GContextConfig;
import com.genome2d.assets.GAssetManager;

class AdvancedExample2TileMap
{
    static public function main() {
        var inst = new AdvancedExample2TileMap();
    }

    /**
        Genome2D singleton instance
     **/
    private var genome:Genome2D;
    private var camera:GCameraController;

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
        GTextureAtlasFactory.createFromAssets("atlas", cast assetManager.getAssetById("atlas_gfx"), cast assetManager.getAssetById("atlas_xml"));
        GTextureFactory.createFromBitmapData("rect", new BitmapData(118,118,false,0xFF0000));

        var mapWidth:Int = 10;
        var mapHeight:Int = 10;
        var tiles:Array<GTile> = new Array<GTile>();
        for(i in 0...Std.int(mapWidth*mapHeight)) tiles.push(null);
        for (j in 0...mapHeight>>1) {
            for (i in 0...mapWidth>>1) {
                var tile:GTile = new GTile(2,2,i*2,j*2);
                tile.textureId = "rect";// [GTexture.getTextureById("atlas_1"),GTexture.getTextureById("atlas_2"),GTexture.getTextureById("atlas_3"),GTexture.getTextureById("atlas_4"),GTexture.getTextureById("atlas_5"),GTexture.getTextureById("atlas_6"),GTexture.getTextureById("atlas_7")];
                tile.reversed = true;
                tile.repeatable = true;
                tile.gotoAndPlayFrame(6);
                tiles[i*2+j*2*mapWidth] = tile;
            }
        }

        var tileMap:GTileMap = cast GNodeFactory.createNodeWithComponent(GTileMap);
        tileMap.setTiles(mapWidth,mapHeight,60,60,tiles);
        tileMap.node.mouseEnabled = true;
        tileMap.node.onMouseMove.add(mouseMoveHandler);
        genome.root.addChild(tileMap.node);

        camera = cast GNodeFactory.createNodeWithComponent(GCameraController);
        genome.root.addChild(camera.node);

        genome.getContext().onMouseSignal.add(mouseHandler);
    }

    private function mouseMoveHandler(signal:GNodeMouseSignal):Void {

    }

    private var omx:Float = -1;
    private var omy:Float = -1;
    private function mouseHandler(signal:GMouseSignal):Void {
        if (!signal.buttonDown) {
            omx = -1;
            omy = -1;
        } else {
            if (omx != -1) {
                var tx:Float = camera.node.transform.x - (signal.x-omx);
                var ty:Float = camera.node.transform.y - (signal.y-omy);
                camera.node.transform.setPosition(tx, ty);
            }
            omx = signal.x;
            omy = signal.y;
        }
    }
}
