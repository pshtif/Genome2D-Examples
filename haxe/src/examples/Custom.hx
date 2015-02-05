package examples;

import com.genome2d.tilemap.GTile;
import com.genome2d.signals.GKeyboardSignal;
import com.genome2d.signals.GKeyboardSignalType;
import com.genome2d.signals.GMouseSignalType;
import com.genome2d.signals.GMouseSignal;
import com.genome2d.context.GBlendMode;
import com.genome2d.tilemap.GTile;
import com.genome2d.components.renderable.tilemap.GTileMap;
import flash.geom.Vector3D;
import com.genome2d.geom.GMatrix3D;
import flash.display.BitmapData;
import com.genome2d.textures.GTextureManager;
import com.genome2d.context.IContext;
import com.genome2d.context.stage3d.renderers.GCustomRenderer;
import Xml;
import com.genome2d.ui.layout.GUIHorizontalLayout;
import com.genome2d.ui.layout.GUIVerticalLayout;
import com.genome2d.ui.layout.GUILayoutType;
import com.genome2d.components.renderable.ui.GUI;
import com.genome2d.ui.layout.GUILayout;
import com.genome2d.ui.skin.GUIFontSkin;
import com.genome2d.ui.skin.GUITextureSkin;
import com.genome2d.components.GCameraController;
import com.genome2d.signals.GUIMouseSignal;
import com.genome2d.assets.GAsset;
import flash.Lib;
import com.genome2d.ui.skin.GUISkin;
import com.genome2d.ui.element.GUIElement;
import Xml;
import com.genome2d.proto.GPrototypeFactory;
import com.genome2d.proto.IGPrototypable;
import com.genome2d.textures.GTexture;
import com.genome2d.context.stats.GStats;
import com.genome2d.Genome2D;
import com.genome2d.Genome2D;
import com.genome2d.node.GNode;
import com.genome2d.Genome2D;
import com.genome2d.context.GContextConfig;
import com.genome2d.assets.GAssetManager;

class Custom {

    static public function main() {
        var inst = new Custom();
    }

    private var genome:Genome2D;

    public function new() {
        initGenome();
    }

    private function initGenome():Void {
        trace("initGenome");

        var config:GContextConfig = new GContextConfig();
        config.enableDepthAndStencil = true;

        genome = Genome2D.getInstance();
        genome.onInitialized.add(genomeInitializedHandler);
        genome.init(config);
    }

    private function genomeInitializedHandler():Void {
        trace("genomeInitializedHandler");

        GStats.visible = true;

        initAssets();
    }

    private function initAssets():Void {
        trace("initAssets");

        GAssetManager.init();
        GAssetManager.addFromUrl("terrain\\0.png");
        GAssetManager.addFromUrl("terrain\\01.png");
        GAssetManager.addFromUrl("terrain\\02.png");
        GAssetManager.addFromUrl("terrain\\03.png");
        GAssetManager.addFromUrl("terrain\\04.png");
        GAssetManager.addFromUrl("terrain\\10.png");
        GAssetManager.addFromUrl("terrain\\1t.png");
        GAssetManager.addFromUrl("terrain\\1l.png");
        GAssetManager.addFromUrl("terrain\\1b.png");
        GAssetManager.addFromUrl("terrain\\1r.png");
        GAssetManager.addFromUrl("terrain\\2t.png");
        GAssetManager.addFromUrl("terrain\\2l.png");
        GAssetManager.addFromUrl("terrain\\2b.png");
        GAssetManager.addFromUrl("terrain\\2r.png");
        GAssetManager.addFromUrl("terrain\\31.png");
        GAssetManager.addFromUrl("terrain\\32.png");
        GAssetManager.addFromUrl("terrain\\33.png");
        GAssetManager.addFromUrl("terrain\\34.png");
        GAssetManager.addFromUrl("uniformclouds.jpg");
        GAssetManager.addFromUrl("Untitled.png");
        GAssetManager.addFromUrl("ui.png");
        GAssetManager.addFromUrl("ui.xml");
        GAssetManager.addFromUrl("font_ui.png");
        GAssetManager.addFromUrl("font_ui.fnt");
        GAssetManager.onQueueLoaded.addOnce(assetsInitializedHandler);
        GAssetManager.loadQueue();
    }

    private function assetsInitializedHandler():Void {
        trace("assetsInitializedHandler");

        initExample();
    }

    public function test(signal:GUIMouseSignal):Void {
        trace("here");
    }

    private var renderer:GCustomRenderer;
    private var texture:GTexture;
    private var buildings:Array<Float>;
    private var map:GTileMap;
    private var mapIds:Array<Int> = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,13,0,1,1,1,1,1,1,1,1,1,1,1,1,13,0,0,1,1,1,1,1,1,1,1,1,1,1,1,13,0,0,1,1,1,1,1,1,1,1,1,1,1,13,0,0,0,1,1,1,1,1,1,1,1,1,1,1,13,0,0,0,1,1,1,1,1,1,1,1,1,1,13,0,0,0,0,1,1,1,1,1,1,1,1,1,1,13,0,0,0,0,1,1,1,1,1,1,1,1,1,13,0,0,0,0,0,1,1,1,1,1,1,1,1,1,13,0,0,0,0,0,1,1,1,1,1,1,1,1,13,0,0,0,0,0,0,1,1,1,1,1,1,1,1,13,0,0,0,0,0,0,1,1,1,1,1,1,1,13,0,0,0,0,0,0,0,1,1,1,1,1,1,1,13,0,0,0,0,0,0,0,1,1,1,1,1,1,13,0,0,0,0,0,0,0,0,1,1,1,1,1,1,13,0,0,0,0,0,0,0,0,0,1,1,1,1,13,0,0,0,0,0,0,0,0,0,0,1,1,1,1,13,0,0,0,0,0,0,0,0,0,0,1,1,1,13,0,0,0,0,0,0,0,0,0,0,0,1,1,1,13,0,0,0,0,0,0,0,0,0,0,0,1,1,13,0,0,0,0,0,0,0,0,0,0,0,0,1,1,13,0,0,0,0,0,0,0,0,0,0,0,0,1,13,0,0,0,0,0,0,0,0,0,0,0,0,1,1,13,0,0,0,0,0,0,0,0,0,0,0,0,0,13,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    private var textureId:String = "terrain\\0.png";

    private function initExample():Void {
    trace(mapIds.length);
        trace("initExample");
        GAssetManager.generateTextures();

        var w:Int = 15;
        var h:Int = 40;
        var tiles:Array<GTile> = new Array<GTile>();
        for (i in 0...w*h) {
            var tile:GTile = new GTile();
            setTile(tile, mapIds[i]);//"terrain\\10.png";
            tiles.push(tile);
        }

        map = cast GNode.createWithComponent(GTileMap);
        map.setTiles(w,h,64,34,tiles,true);
        map.node.x = 400;
        map.node.y = 250;
        map.verticalMargin = 6;
        genome.root.addChild(map.node);

        texture = GTextureManager.getTextureById("Untitled.png");

        var w:Float = 40;
        var h:Float = 20;
        var d:Float = 20;

        buildings = new Array<Float>();

        //renderer = new GCustomRenderer([-w,-h,-d,w,-h,-d,-w,h,-d, -w, h, -d, w, -h, -d, w,h,-d],[0,0,1,0,0,1,1,0,0,1,1,1]);//,[0,1,2,2,1,3]);
        renderer = new GCustomRenderer([-w,-h,-d,w,-h,-d,-w,h,-d, w,h,-d,-w,-h,d,w,-h,d,-w,h,d,w,h,d], [0,0,1,0,0,1,1,1,1,0,0,0,1,1,0,1], [0,1,2,2,1,3,5,4,7,7,4,6,3,1,7,7,1,5,2,3,6,6,3,7,0,2,4,4,2,6,1,0,5,5,0,4], false);

        genome.onPostRender.add(postRenderHandler);
        genome.getContext().onMouseSignal.add(mouseSignalHandler);
        genome.getContext().onKeyboardSignal.add(keyboardSignalHandler);
    }

    private function keyboardSignalHandler(signal:GKeyboardSignal):Void {
        trace(signal.keyCode);
        if (signal.type != GKeyboardSignalType.KEY_DOWN) return;
        switch (signal.keyCode) {
            case 84:
                traceMap();
            case 48:
                textureId = "terrain\\10.png";
            case 49:
                textureId = "terrain\\0.png";
            case 50:
                textureId = "terrain\\31.png";
            case 51:
                textureId = "terrain\\32.png";
            case 52:
                textureId = "terrain\\33.png";
            case 53:
                textureId = "terrain\\34.png";
        }
    }

    private var mouseDown:Bool = false;
    private var overTile:GTile;

    private function mouseSignalHandler(signal:GMouseSignal):Void {
        switch (signal.type) {
            case GMouseSignalType.MOUSE_DOWN:
                buildings.push(signal.x);
                buildings.push(signal.y);
                buildings.push(Math.random()*180);
            /*
                mouseDown = true;
                var tile:GTile = map.getTileAt(signal.x, signal.y);
                if (tile != null) tile.textureId = textureId;
                /**/
            case GMouseSignalType.MOUSE_MOVE:
                /*
                if (overTile != null) overTile.blue = 1;
                overTile = map.getTileAt(signal.x, signal.y);
                overTile.blue = 0;

                if (mouseDown) {
                    if (overTile!=null) overTile.textureId = textureId;
                }
                /**/
            case GMouseSignalType.MOUSE_UP:
                mouseDown = false;
        }
    }

    private function postRenderHandler():Void {
        var context:IContext = genome.getContext();

        context.bindRenderer(renderer);
        for (i in 0...Std.int(buildings.length/3)) {
            buildings[i*3+2]+=1;
            renderer.transformMatrix.identity();
            renderer.transformMatrix.prependTranslation(0,0,50);
            renderer.transformMatrix.prependRotation(32,Vector3D.X_AXIS);
            renderer.transformMatrix.prependRotation(45+buildings[i*3+2],Vector3D.Y_AXIS);
            renderer.transformMatrix.appendTranslation(buildings[i*3],buildings[i*3+1]+Math.sin(buildings[i*3+2]/20)*10,0);
            renderer.draw(texture,1);

            renderer.transformMatrix.identity();
            renderer.transformMatrix.prependTranslation(0,0,50);
            renderer.transformMatrix.prependRotation(32,Vector3D.X_AXIS);
            renderer.transformMatrix.prependRotation(45+buildings[i*3+2],Vector3D.Y_AXIS);
            renderer.transformMatrix.prependScale(1,-1,1);
            renderer.transformMatrix.appendTranslation(buildings[i*3],buildings[i*3+1]+60-Math.sin(buildings[i*3+2]/20)*10,0);
            renderer.draw(texture,2);
        }

        //context.draw(GTextureManager.getTextureById("uniformclouds.jpg"),400,300,1,1,0,1,1,1,.7,GBlendMode.SCREEN);
    }

    private function traceMap():Void {
        var tiles:Array<GTile> = map.getTiles();
        var s:String = "";
        for (i in 0...tiles.length) {
            s+=getTile(tiles[i])+",";
        }
        trace(s);
    }

    private function getTile(p_tile:GTile):Int {
        var id:String = p_tile.textureId;
        switch (id) {
            case "terrain\\0.png":
                return 0;
            case "terrain\\10.png":
                return 1;
            case "terrain\\1t.png":
                return 2;
            case "terrain\\1b.png":
                return 3;
            case "terrain\\1l.png":
                return 4;
            case "terrain\\1r.png":
                return 5;
            case "terrain\\2t.png":
                return 6;
            case "terrain\\2b.png":
                return 7;
            case "terrain\\2l.png":
                return 8;
            case "terrain\\2r.png":
                return 9;
            case "terrain\\31.png":
                return 10;
            case "terrain\\32.png":
                return 11;
            case "terrain\\33.png":
                return 12;
            case "terrain\\34.png":
                return 13;
        }

        return -1;
    }

    private function setTile(p_tile:GTile, p_value:Int):Void {
        switch (p_value) {
            case 0:
                p_tile.textureId = "terrain\\0.png";
                //p_tile.frameTextureIds = ["terrain\\01.png","terrain\\02.png","terrain\\03.png","terrain\\04.png"];
            case 1:
                p_tile.textureId = "terrain\\10.png";
            case 2:
                p_tile.textureId = "terrain\\1t.png";
            case 3:
                p_tile.textureId = "terrain\\1b.png";
            case 4:
                p_tile.textureId = "terrain\\1l.png";
            case 5:
                p_tile.textureId = "terrain\\1r.png";
            case 6:
                p_tile.textureId = "terrain\\2t.png";
            case 7:
                p_tile.textureId = "terrain\\2b.png";
            case 8:
                p_tile.textureId = "terrain\\2l.png";
            case 9:
                p_tile.textureId = "terrain\\2r.png";
            case 10:
                p_tile.textureId = "terrain\\31.png";
            case 11:
                p_tile.textureId = "terrain\\32.png";
            case 12:
                p_tile.textureId = "terrain\\33.png";
            case 13:
                p_tile.textureId = "terrain\\34.png";
        }
    }
}
