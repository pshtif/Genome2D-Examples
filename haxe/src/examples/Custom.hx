package examples;

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

    private function initExample():Void {
        trace("initExample");
        GAssetManager.generateTextures();

        texture = GTextureManager.getTextureById("Untitled.png");

        var w:Float = 50;
        var h:Float = 50;
        var d:Float = 50;

        //renderer = new GCustomRenderer([-w,-h,-d,w,-h,-d,-w,h,-d, -w, h, -d, w, -h, -d, w,h,-d],[0,0,1,0,0,1,1,0,0,1,1,1]);//,[0,1,2,2,1,3]);
        renderer = new GCustomRenderer([-w,-h,-d,w,-h,-d,-w,h,-d, w,h,-d,-w,-h,d,w,-h,d,-w,h,d,w,h,d], [0,0,1,0,0,1,1,1,1,0,0,0,1,1,0,1], [0,1,2,2,1,3,5,4,7,7,4,6,3,1,7,7,1,5,2,3,6,6,3,7,0,2,4,4,2,6,1,0,5,5,0,4], true);
        renderer.transformMatrix.appendTranslation(0,0,1000);

        genome.onPostRender.add(postRenderHandler);
    }

    private function postRenderHandler():Void {
        var context:IContext = genome.getContext();

        renderer.transformMatrix.prependRotation(1,Vector3D.X_AXIS);
        renderer.transformMatrix.prependRotation(1,Vector3D.Y_AXIS);

        context.bindRenderer(renderer);
        renderer.draw(texture);
    }
}
