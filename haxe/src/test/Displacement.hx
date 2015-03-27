package test;

import test.GDisplacementFilter;
import com.genome2d.node.GNode;
import com.genome2d.components.renderable.GSprite;
import com.genome2d.textures.GTextureManager;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.geom.Point;
import flash.Lib;
import flash.display.Bitmap;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureAtlas;
import com.genome2d.assets.GAssetManager;
import com.genome2d.context.GContextConfig;
import com.genome2d.Genome2D;

class Displacement
{

    static public function main() {
        var inst = new Displacement();
    }

    private var genome:Genome2D;
    private var assetManager:GAssetManager;

    public function new() {
        initGenome();
    }

    private function initGenome():Void {
        genome = Genome2D.getInstance();
        genome.onInitialized.add(genomeInitializedHandler);
        genome.init(new GContextConfig());
    }

    private function genomeInitializedHandler():Void {
        initAssets();
    }

    private function initAssets():Void {
        GAssetManager.init();
        GAssetManager.addFromUrl("displacement.jpg");
        GAssetManager.onQueueLoaded.addOnce(assetsInitializedHandler);
        GAssetManager.loadQueue();
    }

    private function assetsInitializedHandler():Void {
        initExample();
    }

    private function initExample():Void {
        var bitmap:Bitmap;
        var scale:Int = 1;
        var width:Int = 256;
        var height:Int = 256;

        var perlinData:BitmapData = new BitmapData(width * scale, height * scale, false);
        perlinData.perlinNoise(20*scale, 2*scale, 2, 5, true, true, 0, true);
        GTextureManager.createTextureFromBitmapData("map",perlinData,1,true);
        bitmap = new Bitmap(perlinData);
        Lib.current.addChild(bitmap);

        GTextureManager.createTextureFromAssetId("source","displacement.jpg");

        var sprite:GSprite = cast GNode.createWithComponent(GSprite);
        sprite.textureId = "source";
        sprite.node.setPosition(640,128);

        var filter:GDisplacementFilter = new GDisplacementFilter();
        filter.displacementMap = GTextureManager.getTextureById("map");
        sprite.filter = filter;

        genome.root.addChild(sprite.node);
    }
}
