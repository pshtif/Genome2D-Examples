package examples;

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

class UIEdit {

    static public function main() {
        var inst = new UIEdit();
    }

    private var genome:Genome2D;
    private var treelist:TreeList;
    private var anchorGizmo:AnchorGizmo;
    private var rectGizmo:RectGizmo;
    private var ui:GUI;

    public function new() {
        initGenome();
    }

    private function initGenome():Void {
        trace("initGenome");

        genome = Genome2D.getInstance();
        genome.onInitialized.add(genomeInitializedHandler);
        genome.init(new GContextConfig());
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

    private var xmlDef:String = '<def>'+
                                    '<textureSkin id="xpSkin" textureId="Untitled.png" />'+
                                    '<fontSkin id="font" fontAtlasId="font_ui.png" autoSize="true" fontScale=".5"/>'+

                                    '<element>'+
                                        "<vertical gap='100'/>"+
                                        '<element skinId="xpSkin"></element>'+
                                        '<element skinId="font">Lorem</element>'+
                                        '<element skinId="xpSkin"></element>'+
                                        '<element skinId="font">Lorem</element>'+
                                        '<element skinId="xpSkin"></element>'+
                                        '<element skinId="font">Lorem</element>'+
                                        '<element skinId="xpSkin"></element>'+
                                    '</element>'+
                                '</def>';

    private var elementDef:String = '<element mouseDown="test" skinId="xpSkin"/>';
    private var skinDef:String = '<fontSkin id="font" fontAtlasId="font_ui.png" autoSize="0"/>';

    public function test(signal:GUIMouseSignal):Void {
        trace("here");
    }

    private function initExample():Void {
        trace("initExample");
        GAssetManager.generateTextures();
        var a:GUITextureSkin;
        var f:GUIFontSkin;
        var a:GUIVerticalLayout;
        var b:GUIHorizontalLayout;

        var camera:GCameraController = cast GNode.createWithComponent(GCameraController);
        camera.setViewport(2048,1536,true);
        genome.root.addChild(camera.node);


        ui = cast GNode.createWithComponent(GUI);
        ui.node.setPosition(0,0);
        ui.node.mouseEnabled = true;
        genome.root.addChild(ui.node);

        /**/
        var element:GUIElement = null;
        var xml:Xml = Xml.parse(xmlDef).firstChild();
        for (i in xml.elements()) {
            var p:IGPrototypable = GPrototypeFactory.createPrototype(i);
            trace(p.getPrototype());
            if (Std.is(p,GUIElement)) {
                element = cast p;
                element.name = "container";
                element.mouseEnabled = true;
                element.anchorX = 300;
                element.anchorY = 300;
                ui.root.addChild(element);

                element.setClient(this);
            }
        }

        //if (element != null) element.addChild(cast GPrototypeFactory.createPrototype(Xml.parse(elementDef).firstElement()));
        /*
        ui = cast GNode.createWithComponent(GUI);
        ui.root.setRect(0,0,2038,1536);
        ui.node.mouseEnabled = true;
        genome.root.addChild(ui.node);

        var scrollContainer:GUIElement = new GUIElement();
        scrollContainer.id = "container";
        scrollContainer.mouseEnabled = true;
        scrollContainer.onMouseDown.add(mouseDownHandler);
        ui.root.addChild(scrollContainer);

            var skin:GUITextureSkin = new GUITextureSkin();
            skin.sliceLeft = 43;
            skin.sliceRight = 86;
            skin.sliceTop = 43;
            skin.sliceBottom = 86;
            //skin.textureId = "ui.png_img_shop_card_cleen";
            skin.textureId = "Untitled.png";

            var card:GUIElement = new GUIElement();
            card.normalSkin = skin;
        card.preferredWidth = 300;
        card.preferredHeight = 300;
            scrollContainer.addChild(card);

            var image:GUIElement = new GUIElement();
            image.normalSkin = new GUITextureSkin();
            image.anchorTop = image.anchorBottom = .3;
            card.addChild(image);
        /*
        rectGizmo = new RectGizmo();
        Lib.current.addChild(rectGizmo);

        anchorGizmo = new AnchorGizmo();
        Lib.current.addChild(anchorGizmo);

        treelist = new TreeList();
        treelist.parseData(ui.root);
        treelist.x = 0;
        treelist.y = 300;
        treelist.onSelect.add(selectHandler);
        genome.getContext().getNativeStage().addChild(treelist);
        /**/
    }

    private function mouseDownHandler(signal:GUIMouseSignal):Void {
        trace(signal.target, signal.target.skin!=null?signal.target.skinId:"");
    }

    private function selectHandler(p_element:GUIElement):Void {
        ui.invalidate();
        rectGizmo.setElement(p_element);
        anchorGizmo.setElement(p_element);
    }
}
