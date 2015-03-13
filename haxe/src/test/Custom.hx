package test;

import hxd.fmt.fbx.FbxTools;
import flash.events.MouseEvent;
import com.genome2d.signals.GMouseSignal;
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
    private var rotationX:Float = 0;
    private var rotationY:Float = 0;
    private var scale:Float = .1;

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
        GAssetManager.addFromUrl("pokus_plachty01.png");
        GAssetManager.addFromUrl("pokus_trup01.png");
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
        loadFBX("test_lod_ResetXform3.FBX");
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

    private var renderers:Array<GCustomRenderer>;
    private var texture:GTexture;

    private function initExample():Void {
        trace("initExample");
        GAssetManager.generateTextures();

        texture = GTextureManager.getTextureById("pokus_plachty01.png");
        //texture = GTextureManager.getTextureById("pokus_trup01.png");
        renderers = new Array<GCustomRenderer>();

        /*
        var w:Float = 40;
        var h:Float = 20;
        var d:Float = 20;

        //renderer = new GCustomRenderer([-w,-h,-d,w,-h,-d,-w,h,-d, -w, h, -d, w, -h, -d, w,h,-d],[0,0,1,0,0,1,1,0,0,1,1,1]);//,[0,1,2,2,1,3]);
        renderer = new GCustomRenderer([-w,-h,-d,w,-h,-d,-w,h,-d, w,h,-d,-w,-h,d,w,-h,d,-w,h,d,w,h,d], [0,0,1,0,0,1,1,1,1,0,0,0,1,1,0,1], [0,1,2,2,1,3,5,4,7,7,4,6,3,1,7,7,1,5,2,3,6,6,3,7,0,2,4,4,2,6,1,0,5,5,0,4], false);
        /**/

        initFBX();

        genome.onPostRender.add(postRenderHandler);
        genome.getContext().setBackgroundColor(0x888888,1);
        genome.getContext().onKeyboardSignal.add(keyHandler);
        genome.getContext().onMouseSignal.add(mouseHandler);
    }

    private var omx:Float = 0;
    private var omy:Float = 0;

    private function mouseHandler(signal:GMouseSignal):Void {
        if (signal.buttonDown && signal.type == GMouseSignalType.MOUSE_MOVE) {
            rotationY += signal.x-omx;
            rotationX += signal.y-omy;
            omx = signal.x;
            omy = signal.y;
        } else if (signal.type == GMouseSignalType.MOUSE_DOWN) {
            omx = signal.x;
            omy = signal.y;
        } else if (signal.type == GMouseSignalType.MOUSE_WHEEL) {
            scale+=signal.delta/100;
        }
    }

    private var meshIndex:Int = -1;

    private function keyHandler(signal:GKeyboardSignal):Void {
        if (signal.type != GKeyboardSignalType.KEY_DOWN) return;

        switch (signal.keyCode) {
            case 48:
                meshIndex = -1;
            case 49:
                meshIndex = 0;
            case 50:
                meshIndex = 1;
            case 51:
                meshIndex = 2;
            case 52:
                meshIndex = 3;
            case 53:
                meshIndex = 4;
            case _:
                trace(signal.keyCode);
        }
    }

    private function initFBX():Void {
        // Textures
        var textureNodes:Array<FbxNode> = FbxTools.getAll(object, "Objects.Texture");
        //trace(FbxTools.get(textureNodes[0], "RelativeFilename", true));

        var modelNodes:Array<FbxNode> = FbxTools.getAll(object, "Objects.Model");
        trace(FbxTools.toFloat(modelNodes[0].props[0]));
        return;

        // Geometry
        var vertexNodes:Array<FbxNode> = FbxTools.getAll(object,"Objects.Geometry.Vertices");
        var vertexIndexNodes:Array<FbxNode> = FbxTools.getAll(object,"Objects.Geometry.PolygonVertexIndex");

        var uvNodes:Array<FbxNode> = FbxTools.getAll(object,"Objects.Geometry.LayerElementUV.UV");
        var uvIndexNodes:Array<FbxNode> = FbxTools.getAll(object,"Objects.Geometry.LayerElementUV.UVIndex");

        if (vertexNodes.length != uvNodes.length) throw "Invalid number of UV sets and polygons";

        var mergedVertices:Array<Float> = new Array<Float>();
        var mergedVertexIndices:Array<UInt> = new Array<UInt>();
        var mergedUvs:Array<Float> = new Array<Float>();
        var indexOffset:Int = 0;
        for (i in 0...vertexNodes.length) {
            var currentVertices:Array<Float> = FbxTools.getFloats(vertexNodes[i]);
            var currentVertexIndices:Array<Int> = cast FbxTools.getInts(vertexIndexNodes[i]);
            var currentUVs:Array<Float> = FbxTools.getFloats(uvNodes[i]);
            var currentUVIndices:Array<Int> = FbxTools.getInts(uvIndexNodes[i]);
            if (currentUVIndices.length != currentVertexIndices.length) throw "Not same number of vertex and UV indices!";
            // Create array for our reindexed UVs
            var reindexedUvs:Array<Float> = new Array<Float>();
            for (j in 0...currentUVs.length) {
                reindexedUvs.push(0);
            }

            // Reindex UV coordinates to correspond to vertex indices
            var correctedIndices:Array<UInt> = new Array<UInt>();
            for (j in 0...currentUVIndices.length) {
//                if (currentVertexIndices[j]<0) currentVertexIndices[j] = -currentVertexIndices[j]-1;
                var vertexIndex:Int = currentVertexIndices[j];
                if (vertexIndex < 0) vertexIndex = -vertexIndex-1;
                correctedIndices.push(vertexIndex);
                mergedVertexIndices.push(vertexIndex+indexOffset);

                var uvIndex:Int = currentUVIndices[j];
                reindexedUvs[vertexIndex*2] = currentUVs[uvIndex*2];
                reindexedUvs[vertexIndex*2+1] = 1-currentUVs[uvIndex*2+1];
            }

            trace("Vertices", currentVertices.length/3, currentVertices);
            trace("UVs", reindexedUvs.length/2, reindexedUvs);
            trace("Indices", correctedIndices.length, correctedIndices);
            trace("UVIndices", currentUVIndices);
            trace("Triangles", correctedIndices.length/3);
            var renderer:GCustomRenderer = new GCustomRenderer(currentVertices, reindexedUvs, correctedIndices, false);
            renderers.push(renderer);

            // Merge vertices
            //mergedVertices = mergedVertices.concat(currentVertices);
            //mergedUvs = mergedUvs.concat(reindexedUvs);
            //indexOffset+=Std.int(currentVertices.length/3);
        }

        trace("# Meshes",renderers.length);

        /*
        trace("Vertices", mergedVertices.length, mergedVertices);
        trace("UVs", mergedUvs.length, mergedUvs);
        trace("Indices", mergedVertexIndices.length, mergedVertexIndices);

        //renderer = new GCustomRenderer(vertices, uvs, vertexIndices, false);
        /**/
    }

    private function postRenderHandler():Void {
        var context:IContext = genome.getContext();

        for (i in 0...renderers.length) {
            if (meshIndex>=0 && i!=meshIndex) continue;
            var renderer:GCustomRenderer = renderers[i];
            context.bindRenderer(renderer);

            renderer.transformMatrix.identity();
            //renderer.transformMatrix.prependTranslation(0,0,200);
            renderer.transformMatrix.prependRotation(rotationX,Vector3D.X_AXIS);
            renderer.transformMatrix.prependRotation(rotationY,Vector3D.Y_AXIS);
            renderer.transformMatrix.prependRotation(0,Vector3D.Z_AXIS);
            renderer.transformMatrix.prependScale(scale,scale,scale);
            renderer.transformMatrix.appendTranslation(400,300,300);
            renderer.draw(texture,2);
            /*
            renderer.transformMatrix.identity();
            renderer.transformMatrix.prependTranslation(0,0,250);
            renderer.transformMatrix.prependRotation(32,Vector3D.X_AXIS);
            renderer.transformMatrix.prependRotation(180,Vector3D.Z_AXIS);
            renderer.transformMatrix.prependRotation(45+buildings[2],Vector3D.Y_AXIS);
            renderer.transformMatrix.prependScale(.1,-.1,.1);
            renderer.transformMatrix.appendTranslation(buildings[0],buildings[1]+60-Math.sin(buildings[2]/20)*10,0);
            renderer.draw(texture,2);
            /**/
        }

        context.draw(GTextureManager.getTextureById("logo.png"),695,565,1,1,0,1,1,1,1,GBlendMode.NORMAL);
    }
}
