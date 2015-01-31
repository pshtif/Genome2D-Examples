package examples;

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

    private var _bottomMenuPrototype:String = '<element anchorY="200">'+
                                                '<horizontal/>'+
                                              '</element>';

    private var elementDef:String = '<element name="Quest" mouseDown="questDownHandler" skinId="ui_btn_bottom"><element name="label" skinId="uiFont">Quests</element></element>';
    private var skinDef:String = '<fontSkin id="font" fontAtlasId="font_ui.png" autoSize="0"/>';

    public function test(signal:GUIMouseSignal):Void {
        trace("here");
    }

    private function initExample():Void {
        trace("initExample");
        var a = [{a:"aaaa"}];
        trace(Type.typeof(a));
        trace(Std.is(a,Array));
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

        new GUITextureSkin("ui_btn_bottom", "ui.png_btn_bottom");
        new GUITextureSkin("ui_btn_bottom_map", "ui.png_btn_bottom_map");
        new GUIFontSkin("uiFont", "font_ui.png");

        var element:GUIElement = cast GPrototypeFactory.createPrototype(_bottomMenuPrototype);
        ui.root.addChild(element);

        element.listItemPrototype = Xml.parse('<element name="Quest" mouseDown="questDownHandler" skinId="ui_btn_bottom"><element name="label" skinId="uiFont">Quests</element></element>').firstElement();
        element.setValue([{label:"test"},{}]);

        var element2:GUIElement = cast GPrototypeFactory.createPrototype(_bottomMenuPrototype);
        element2.anchorY = 400;
        ui.root.addChild(element2);

        trace(element.getPrototype());
        element2.listItemPrototype = element.getPrototype();
        ui.root.addChild(element2);
        element2.setValue([{},{}]);
    }

    private var test2:String = '<element anchorX="0" anchorY="200" anchorLeft="0" anchorRight="0" anchorTop="0" anchorBottom="0" pivotX="0" pivotY="0" left="0" right="0" top="0" bottom="0" preferredWidth="0" preferredHeight="0" name="GUIElement" skinId="" mouseEnabled="true" visible="true" flushBatch="false" mouseDown="null" mouseUp="null" mouseClick="null" mouseOver="null" mouseOut="null" mouseMove="null"><horizontal gap="10" type="2"/><element anchorX="0" anchorY="0" anchorLeft="0" anchorRight="0" anchorTop="0" anchorBottom="0" pivotX="0" pivotY="0" left="0" right="0" top="0" bottom="0" preferredWidth="0" preferredHeight="0" name="Quest" skinId="ui_btn_bottom" mouseEnabled="true" visible="true" flushBatch="false" mouseDown="questDownHandler" mouseUp="null" mouseClick="null" mouseOver="null" mouseOut="null" mouseMove="null"><element anchorX="0" anchorY="0" anchorLeft="0" anchorRight="0" anchorTop="0" anchorBottom="0" pivotX="0" pivotY="0" left="0" right="0" top="0" bottom="0" preferredWidth="0" preferredHeight="0" name="label" skinId="uiFont" mouseEnabled="true" visible="true" flushBatch="false" mouseDown="null" mouseUp="null" mouseClick="null" mouseOver="null" mouseOut="null" mouseMove="null"/></element><element anchorX="0" anchorY="0" anchorLeft="0" anchorRight="0" anchorTop="0" anchorBottom="0" pivotX="0" pivotY="0" left="0" right="0" top="0" bottom="0" preferredWidth="0" preferredHeight="0" name="Quest" skinId="ui_btn_bottom" mouseEnabled="true" visible="true" flushBatch="false" mouseDown="questDownHandler" mouseUp="null" mouseClick="null" mouseOver="null" mouseOut="null" mouseMove="null"><element anchorX="0" anchorY="0" anchorLeft="0" anchorRight="0" anchorTop="0" anchorBottom="0" pivotX="0" pivotY="0" left="0" right="0" top="0" bottom="0" preferredWidth="0" preferredHeight="0" name="label" skinId="uiFont" mouseEnabled="true" visible="true" flushBatch="false" mouseDown="null" mouseUp="null" mouseClick="null" mouseOver="null" mouseOut="null" mouseMove="null"/></element></element>';

    private function mouseDownHandler(signal:GUIMouseSignal):Void {
        trace(signal.target, signal.target.skin!=null?signal.target.skinId:"");
    }

    private function selectHandler(p_element:GUIElement):Void {
        ui.invalidate();
        rectGizmo.setElement(p_element);
        anchorGizmo.setElement(p_element);
    }
}
