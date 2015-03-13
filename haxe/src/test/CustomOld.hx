package test;

import hxd.fmt.fbx.FbxNode;
import hxd.fmt.fbx.FbxNode;
import hxd.fmt.fbx.FbxTools;
import hxd.fmt.fbx.FbxNode;
import flash.events.Event;
import flash.net.URLRequest;
import flash.net.URLLoader;
import hxd.fmt.fbx.Parser;
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
    private var object:FbxNode;

    public function new() {
        initGenome();

        var a:Parser;
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

        //GStats.visible = true;

        initAssets();
    }

    private function initAssets():Void {
        trace("initAssets");

        GAssetManager.init();
        GAssetManager.addFromUrl("Untitled.png");
        GAssetManager.addFromUrl("logo.png");
        GAssetManager.addFromUrl("ships.png");
        GAssetManager.addFromUrl("ships.xml");
        GAssetManager.addFromUrl("font_ui.png");
        GAssetManager.addFromUrl("font_ui.fnt");
        GAssetManager.onQueueLoaded.addOnce(assetsInitializedHandler);
        GAssetManager.loadQueue();
    }

    private function assetsInitializedHandler():Void {
        trace("assetsInitializedHandler");

        //loadFBX("test_box_resetUVs.fbx");
        //loadFBX("test_plachtyResetXform.FBX");
        loadFBX("test_lod.FBX");
        //initExample();
    }

    private function loadFBX(p_url:String):Void {
        var loader:URLLoader = new URLLoader();
        loader.addEventListener(Event.COMPLETE, fbxLoadCompleteHandler);
        loader.load(new URLRequest(p_url));
    }

    private function fbxLoadCompleteHandler(event:Event):Void {
        //trace(event.target.data);
        object = Parser.parse(event.target.data);

        initExample();
    }

    public function test(signal:GUIMouseSignal):Void {
        trace("here");
    }

    private var renderer:GCustomRenderer;
    private var texture:GTexture;
    private var buildings:Array<Float> = [699,106,447.73588325083256,515,302,473.9247104097158,655,468,377.34177895076573,228,381,160.4119959603995];
    private var map:GTileMap;
    private var mapIds:Array<Int> = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,15,15,15,1,15,15,15,14,1,0,1,1,15,15,15,15,15,15,15,15,15,15,14,1,13,0,1,15,15,15,15,15,15,15,15,15,14,1,13,0,0,1,1,15,15,15,15,15,15,15,15,14,1,13,0,0,1,15,15,15,15,15,15,15,15,14,1,13,0,0,17,1,1,15,15,15,15,15,15,15,14,1,13,0,0,17,1,15,15,15,15,15,15,15,14,1,13,0,0,17,16,1,15,15,15,15,15,15,15,14,1,13,0,0,17,16,1,15,15,15,15,15,15,14,1,13,0,0,17,16,16,1,15,15,15,15,15,15,14,1,13,0,0,17,16,16,1,15,15,15,15,15,14,1,13,0,0,17,16,16,16,1,1,15,15,15,15,14,1,13,0,0,17,16,16,16,1,15,15,15,15,14,1,13,0,0,17,16,16,16,16,1,1,15,15,15,14,1,13,0,0,17,16,16,16,16,1,15,15,15,14,1,13,0,0,17,16,16,16,16,16,1,1,15,15,14,1,13,0,0,17,16,16,16,16,16,0,15,15,14,1,13,0,0,17,16,16,16,16,16,16,0,1,15,14,1,13,0,0,17,16,16,16,16,16,16,0,15,14,1,13,0,0,17,16,16,16,16,16,16,16,0,1,14,1,13,0,0,17,16,16,16,16,16,16,16,0,14,1,13,0,0,17,16,16,16,16,16,16,16,16,0,1,1,13,0,0,17,16,16,16,16,16,16,16,16,0,1,13,0,0,17,16,16,16,16,16,16,16,16,16,1,1,13,0,0,17,16,16,16,16,16,16,16,16,16,16,13,0,0,17,16,16,16,16,16,16,16,16,16,16,16,0,0,0,17,16,16,16,16,16,16,16,16,16,16,16,0,0,17,16,16,16,16,16,16,16,16,16,16,16,16,0,0,17,16,16,16,16,16,16,16,16,16,16,16,16,0,17,16,16,16,16,16,16,16,16,16,16,16,16,16,0,17,16,16,16,16,16,16,16,16,16,16,16,16,16,17,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16];
    private var textureId:String = "ships.png_0";
    private var clouds:Array<Float>;

    private function initExample():Void {
        trace("initExample");
        GAssetManager.generateTextures();

        var w:Int = 15;
        var h:Int = 40;
        var tiles:Array<GTile> = new Array<GTile>();
        for (i in 0...w*h) {
            var tile:GTile = new GTile();
            setTile(tile, mapIds[i]);//"ships.png_10.png";
            tiles.push(tile);
        }

        map = cast GNode.createWithComponent(GTileMap);
        map.setTiles(w,h,64,34,tiles,true);
        map.node.x = 400;
        map.node.y = 250;
        map.verticalMargin = 6;
        genome.root.addChild(map.node);

        clouds = new Array<Float>();
        for (i in 0...40) {
            clouds.push(Math.random()*940-120);
            clouds.push(Math.random()*1240-620);
            clouds.push(Std.int(Math.random()*3)+1);
            clouds.push(Math.random()+.5);
        }

        texture = GTextureManager.getTextureById("Untitled.png");

        /*
        var w:Float = 40;
        var h:Float = 20;
        var d:Float = 20;

        //renderer = new GCustomRenderer([-w,-h,-d,w,-h,-d,-w,h,-d, -w, h, -d, w, -h, -d, w,h,-d],[0,0,1,0,0,1,1,0,0,1,1,1]);//,[0,1,2,2,1,3]);
        renderer = new GCustomRenderer([-w,-h,-d,w,-h,-d,-w,h,-d, w,h,-d,-w,-h,d,w,-h,d,-w,h,d,w,h,d], [0,0,1,0,0,1,1,1,1,0,0,0,1,1,0,1], [0,1,2,2,1,3,5,4,7,7,4,6,3,1,7,7,1,5,2,3,6,6,3,7,0,2,4,4,2,6,1,0,5,5,0,4], false);
        /**/

        initFBX();

        genome.onPostRender.add(postRenderHandler);
        genome.getContext().onMouseSignal.add(mouseSignalHandler);
        genome.getContext().onKeyboardSignal.add(keyboardSignalHandler);
    }

    private function initFBX():Void {
        var vertexNodes:Array<FbxNode> = FbxTools.getAll(object,"Objects.Geometry.Vertices");
        var vertexIndexNodes:Array<FbxNode> = FbxTools.getAll(object,"Objects.Geometry.PolygonVertexIndex");

        var uvNodes:Array<FbxNode> = FbxTools.getAll(object,"Objects.Geometry.LayerElementUV.UV");
        var uvIndexNodes:Array<FbxNode> = FbxTools.getAll(object,"Objects.Geometry.LayerElementUV.UVIndex");

        if (vertexNodes.length != uvNodes.length) throw "Invalid number of UV sets and polygons";

        var vertices:Array<Float> = new Array<Float>();
        var vertexIndices:Array<UInt> = new Array<UInt>();
        var uvs:Array<Float> = new Array<Float>();
        var indexOffset:Int = 0;
        for (i in 0...vertexNodes.length) {
            var currentVertices:Array<Float> = FbxTools.getFloats(vertexNodes[i]);
            var currentVertexIndices:Array<Int> = FbxTools.getInts(vertexIndexNodes[i]);
            var currentUVs:Array<Float> = FbxTools.getFloats(uvNodes[i]);
            var currentUVIndices:Array<Int> = FbxTools.getInts(uvIndexNodes[i]);
            if (currentUVIndices.length != currentVertexIndices.length) throw "Not same number of vertex and UV indices!";
            // Store vertices
            vertices = vertices.concat(currentVertices);
            // Create array for our reindexed UVs
            var reindexedUVs:Array<Float> = new Array<Float>();
            for (j in 0...currentUVs.length) {
                reindexedUVs.push(0);
            }

            // Reindex UV coordinates to correspond to vertex indices
            for (j in 0...currentUVIndices.length) {
                var vertexIndex:Int = currentVertexIndices[j];
                if (vertexIndex < 0) vertexIndex = -vertexIndex-1;
                vertexIndices.push(vertexIndex+indexOffset);
                var uvIndex:Int = currentUVIndices[j];

                reindexedUVs[vertexIndex*2] = currentUVs[uvIndex*2]<.01 ? 0 : currentUVs[uvIndex*2];
                reindexedUVs[vertexIndex*2+1] = currentUVs[uvIndex*2+1]<.01 ? 0 : currentUVs[uvIndex*2+1];
            }
            uvs = uvs.concat(reindexedUVs);

            indexOffset+=Std.int(currentVertices.length/3);
        }

        trace("Vertices", vertices.length, vertices);
        trace("UVs", uvs.length, uvs);
        trace("Indices", vertexIndices.length, vertexIndices);

        renderer = new GCustomRenderer(vertices, uvs, vertexIndices, false);
        /**/
    }

    private function keyboardSignalHandler(signal:GKeyboardSignal):Void {
        trace(signal.keyCode);
        if (signal.type != GKeyboardSignalType.KEY_DOWN) return;
        switch (signal.keyCode) {
            case 84:
                traceMap();
                //traceBuildings();
            case 48:
                textureId = "ships.png_10";
            case 49:
                textureId = "ships.png_0";
            case 50:
                textureId = "ships.png_gb";
            case 51:
                textureId = "ships.png_deep";
            case 52:
                textureId = "ships.png_33";
            case 53:
                textureId = "ships.png_34";
        }
    }

    private var mouseDown:Bool = false;
    private var overTile:GTile;

    private function mouseSignalHandler(signal:GMouseSignal):Void {
        switch (signal.type) {
            case GMouseSignalType.MOUSE_DOWN:
            /*
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

        if (renderer != null) {
            context.bindRenderer(renderer);
            for (i in 0...Std.int(buildings.length/3)) {
                buildings[i*3+2]+=1;
                renderer.transformMatrix.identity();
                renderer.transformMatrix.prependTranslation(0,0,200);
                renderer.transformMatrix.prependRotation(32,Vector3D.X_AXIS);
                renderer.transformMatrix.prependRotation(0,Vector3D.Z_AXIS);
                renderer.transformMatrix.prependRotation(45+buildings[i*3+2],Vector3D.X_AXIS);
                renderer.transformMatrix.prependScale(.1,.1,.1);
                renderer.transformMatrix.appendTranslation(buildings[i*3],buildings[i*3+1]+Math.sin(buildings[i*3+2]/20)*10,0);
                renderer.draw(texture,2);
                /*
                renderer.transformMatrix.identity();
                renderer.transformMatrix.prependTranslation(0,0,250);
                renderer.transformMatrix.prependRotation(32,Vector3D.X_AXIS);
                renderer.transformMatrix.prependRotation(180,Vector3D.Z_AXIS);
                renderer.transformMatrix.prependRotation(45+buildings[i*3+2],Vector3D.Y_AXIS);
                renderer.transformMatrix.prependScale(.1,-.1,.1);
                renderer.transformMatrix.appendTranslation(buildings[i*3],buildings[i*3+1]+60-Math.sin(buildings[i*3+2]/20)*10,0);
                renderer.draw(texture,2);
                /**/
            }
        }

        for (i in 0...Std.int(clouds.length/4)) {
            clouds[i*4]-=.3*clouds[i*4+3];
            clouds[i*4+1]+=.2*clouds[i*4+3];
            if (clouds[i*4]<-120) clouds[i*4]=940;
            if (clouds[i*4+1]>1240) clouds[i*4+1]=-620;
            context.draw(GTextureManager.getTextureById("ships.png_cloud"+clouds[i*4+2]),clouds[i*4],clouds[i*4+1]+500,1,-1,0,1,1,1,.05,GBlendMode.NORMAL);
        }

        for (i in 0...Std.int(clouds.length/4)) {
            context.draw(GTextureManager.getTextureById("ships.png_cloud"+clouds[i*4+2]),clouds[i*4],clouds[i*4+1],1,1,0,1,1,1,.8,GBlendMode.NORMAL);
        }

        context.draw(GTextureManager.getTextureById("logo.png"),695,565,1,1,0,1,1,1,1,GBlendMode.NORMAL);
    }

    private function traceMap():Void {
        var tiles:Array<GTile> = map.getTiles();
        var s:String = "";
        for (i in 0...tiles.length) {
            s+=getTile(tiles[i])+",";
        }
        trace(s);
    }

    private function traceBuildings():Void {
        var s:String = "";
        for (i in 0...buildings.length) {
            s+=buildings[i]+",";
        }
        trace(s);
    }

    private function getTile(p_tile:GTile):Int {
        var id:String = p_tile.textureId;
        switch (id) {
            case "ships.png_0":
                return 0;
            case "ships.png_10":
                return 1;
            case "ships.png_1t":
                return 2;
            case "ships.png_1b":
                return 3;
            case "ships.png_1l":
                return 4;
            case "ships.png_1r":
                return 5;
            case "ships.png_2t":
                return 6;
            case "ships.png_2b":
                return 7;
            case "ships.png_2l":
                return 8;
            case "ships.png_2r":
                return 9;
            case "ships.png_31":
                return 10;
            case "ships.png_32":
                return 11;
            case "ships.png_33":
                return 12;
            case "ships.png_34":
                return 13;
            case "ships.png_gb":
                return 14;
            case "ships.png_g1":
                return 15;
            case "ships.png_deep":
                return 16;
            case "ships.png_sd":
                return 17;
        }

        return -1;
    }

    private function setTile(p_tile:GTile, p_value:Int):Void {
        switch (p_value) {
            case 0:
                p_tile.textureId = "ships.png_0";
                //p_tile.frameTextureIds = ["ships.png_01","ships.png_02","ships.png_03","ships.png_04"];
            case 1:
                p_tile.textureId = "ships.png_10";
            case 2:
                p_tile.textureId = "ships.png_1t";
            case 3:
                p_tile.textureId = "ships.png_1b";
            case 4:
                p_tile.textureId = "ships.png_1l";
            case 5:
                p_tile.textureId = "ships.png_1r";
            case 6:
                p_tile.textureId = "ships.png_2t";
            case 7:
                p_tile.textureId = "ships.png_2b";
            case 8:
                p_tile.textureId = "ships.png_2l";
            case 9:
                p_tile.textureId = "ships.png_2r";
            case 10:
                p_tile.textureId = "ships.png_31";
            case 11:
                p_tile.textureId = "ships.png_32";
            case 12:
                p_tile.textureId = "ships.png_33";
            case 13:
                p_tile.textureId = "ships.png_34";
            case 14:
                p_tile.textureId = "ships.png_gb";
            case 15:
                p_tile.textureId = "ships.png_g1";//+(Std.int(Math.random()*4)+1)+"";
            case 16:
                p_tile.textureId = "ships.png_deep";
            case 17:
                p_tile.textureId = "ships.png_sd";
        }
    }
}
