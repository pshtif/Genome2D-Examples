package examples.advanced;
import com.genome2d.geom.GRectangle;
import flash.Vector;
import com.genome2d.textures.GTexture;
import com.genome2d.components.renderables.GShape;
import com.genome2d.textures.GTextureFilteringType;
import com.genome2d.node.GNode;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.textures.factories.GTextureAtlasFactory;
import com.genome2d.textures.factories.GTextureFactory;
import com.genome2d.Genome2D;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.context.GContextConfig;
import com.genome2d.assets.GXmlAsset;
import com.genome2d.assets.GImageAsset;
import com.genome2d.textures.GTextureAtlas;
import com.genome2d.textures.GTexture;
import com.genome2d.assets.GAssetManager;

class Example9Shape {

    static function main() {
        var inst = new Example9Shape();
    }

    private var assetManager:GAssetManager;
    private var texture:GTexture;
    private var atlas:GTextureAtlas;

    public function new() {
        initAssets();
    }

    private function initAssets():Void {
        trace("initAssets");
        assetManager = new GAssetManager();
        assetManager.add(new GImageAsset("texture_gfx", "textures.jpg"));
        assetManager.add(new GImageAsset("atlas_gfx", "atlas.png"));
        assetManager.add(new GXmlAsset("atlas_xml", "atlas.xml"));
        assetManager.onLoaded.add(assetsInitializedHandler);
        assetManager.load();
    }

    private function assetsInitializedHandler():Void {
        trace("assetsInitializedHandler");
        var contextConfig:GContextConfig = new GContextConfig(new GRectangle(0,0,800,600));

        Genome2D.getInstance().onInitialized.add(genomeInitializedHandler);
        Genome2D.getInstance().init(contextConfig);
    }

    private function genomeInitializedHandler():Void {
        trace("genomeInitializedHandler");

        GTextureFactory.createFromAsset("textures", cast assetManager.getAssetById("texture_gfx"));
        GTextureAtlasFactory.createFromAssets("atlas", cast assetManager.getAssetById("atlas_gfx"), cast assetManager.getAssetById("atlas_xml"));

        var w:Int = 100 ;
        var h:Int = 100 ;
        var v:Array<Float> = [0,0, w,0, 0,h, w,0, w,h, 0,h];
        var u:Array<Float> = [0,0, 1,0, 0,1, 1,0, 1,1, 0,1];

        var shape:GShape = cast GNodeFactory.createNodeWithComponent(GShape);
        shape.texture = GTexture.getTextureById("textures");
        shape.init(v,u);
        //shape.init([-20,20, -20,-20, 20,-20],[0,1, 0,0, 1,0]);
        shape.node.transform.setPosition(300,300);
        shape.node.transform.blue = 0;
        Genome2D.getInstance().root.addChild(shape.node);
    }
}
