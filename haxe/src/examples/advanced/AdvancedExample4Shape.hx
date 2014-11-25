package examples.advanced;
import com.genome2d.context.IContext;
import com.genome2d.context.stage3d.GStage3DContext;
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

class AdvancedExample4Shape {

    static public function main() {
        var inst = new AdvancedExample4Shape();
    }

    private var assetManager:GAssetManager;

    public function new() {
        initAssets();
    }

    private function initAssets():Void {
        trace("initAssets");
        assetManager = new GAssetManager();
        assetManager.addUrl("texture_gfx", "textures.jpg");
        assetManager.onAllLoaded.add(assetsInitializedHandler);
        assetManager.load();
    }

    private function assetsInitializedHandler():Void {
        trace("assetsInitializedHandler");
        var contextConfig:GContextConfig = new GContextConfig();

        Genome2D.getInstance().onInitialized.add(genomeInitializedHandler);
        Genome2D.getInstance().init(contextConfig);
    }

    private var v:Array<Float>;
    private var u:Array<Float>;
    private var texture:GTexture;

    private function genomeInitializedHandler():Void {
        trace("genomeInitializedHandler");

        texture = GTextureFactory.createFromAsset("textures", cast assetManager.getAssetById("texture_gfx"));

        var w:Int = 100 ;
        var h:Int = 100 ;
        v = [0,0, w,0, 0,h, w,0, w,h, 0,h];
        u = [0,0.0, 1,0, 0,1, 1,0, 1,1, 0,1];

        var shape:GShape = cast GNodeFactory.createNodeWithComponent(GShape);
        shape.texture = GTexture.getTextureById("textures");
        shape.setup(v,u);
        //shape.init([-20,20, -20,-20, 20,-20],[0,1, 0,0, 1,0]);
        shape.node.transform.setPosition(300,300);
        shape.node.transform.blue = 0;
        Genome2D.getInstance().root.addChild(shape.node);

        Genome2D.getInstance().onPostRender.add(postRenderHandler);
    }

    private function postRenderHandler():Void {
        var context:IContext = Genome2D.getInstance().getContext();
        //context.draw(textures, 100, 100);
        //context.drawPoly(GTexture.getTextureById("textures"), )
    }
}
