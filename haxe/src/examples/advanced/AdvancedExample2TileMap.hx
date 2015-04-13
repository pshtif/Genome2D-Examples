/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package examples.advanced;

import com.genome2d.callbacks.GNodeMouseInput;
import com.genome2d.components.renderable.tilemap.GTileMap;
import com.genome2d.node.GNode;
import flash.display.BitmapData;
import com.genome2d.input.GMouseInput;
import com.genome2d.components.GCameraController;
import com.genome2d.textures.GTexture;
import com.genome2d.tilemap.GTile;
import com.genome2d.Genome2D;
import com.genome2d.context.GContextConfig;
import com.genome2d.assets.GAssetManager;
import com.genome2d.textures.GTextureManager;

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
        GAssetManager.addFromUrl("atlas.png");
        GAssetManager.addFromUrl("atlas.xml");
        GAssetManager.onQueueLoaded.add(assetsInitializedHandler);
        GAssetManager.loadQueue();
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
        GTextureManager.createAtlasFromAssetIds("atlas", "atlas.png", "atlas.xml");
        var texture:GTexture = GTextureManager.createTextureFromBitmapData("rect", new BitmapData(120,120,false,0xFF0000));

        var mapWidth:Int = 10;
        var mapHeight:Int = 10;
        var tiles:Array<GTile> = new Array<GTile>();
        for (i in 0...Std.int(mapWidth * mapHeight)) tiles.push(null);
		var tileMap:GTileMap = cast GNode.createWithComponent(GTileMap);
        tileMap.setTiles(mapWidth,mapHeight,60,60,tiles);
        tileMap.node.mouseEnabled = true;
        tileMap.node.onMouseMove.add(mouseMoveHandler);
		
        for (j in 0...mapHeight>>1) {
            for (i in 0...mapWidth>>1) {
                var tile:GTile = new GTile(2,2,i*2,j*2);
                //tile.frameTextures = [GTextureManager.getTextureById("atlas_1"),GTextureManager.getTextureById("atlas_2"),GTextureManager.getTextureById("atlas_3"),GTextureManager.getTextureById("atlas_4"),GTextureManager.getTextureById("atlas_5"),GTextureManager.getTextureById("atlas_6"),GTextureManager.getTextureById("atlas_7")];
				tile.texture = GTextureManager.getTextureById("rect");
                tile.reversed = true;
                tile.repeatable = true;
                tile.gotoAndPlayFrame(6);
                tileMap.setTile(i * 2 + j * 2 * mapWidth, tile);
            }
        }

        genome.root.addChild(tileMap.node);

        camera = cast GNode.createWithComponent(GCameraController);
        genome.root.addChild(camera.node);

        genome.getContext().onMouseInput.add(mouseHandler);
    }

    private function mouseMoveHandler(input:GNodeMouseInput):Void {

    }

    private var omx:Float = -1;
    private var omy:Float = -1;
    private function mouseHandler(signal:GMouseInput):Void {
        if (!signal.buttonDown) {
            omx = -1;
            omy = -1;
        } else {
            if (omx != -1) {
                var tx:Float = camera.node.x - (signal.x-omx);
                var ty:Float = camera.node.y - (signal.y-omy);
                camera.node.setPosition(tx, ty);
            }
            omx = signal.x;
            omy = signal.y;
        }
    }
}
