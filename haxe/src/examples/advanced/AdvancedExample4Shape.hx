package examples.advanced;
import com.genome2d.textures.GTextureManager;
import com.genome2d.components.renderable.GShape;
import com.genome2d.context.IContext;
import com.genome2d.context.stage3d.GStage3DContext;
import com.genome2d.geom.GRectangle;
import flash.Vector;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureFilteringType;
import com.genome2d.node.GNode;
import com.genome2d.Genome2D;
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
        var contextConfig:GContextConfig = new GContextConfig();

        Genome2D.getInstance().onInitialized.add(genomeInitializedHandler);
        Genome2D.getInstance().init(contextConfig);
    }

    private function genomeInitializedHandler():Void {
        trace("initAssets");
        GAssetManager.addFromUrl("Untitled.png");
        GAssetManager.onQueueLoaded.add(assetsInitializedHandler);
        GAssetManager.loadQueue();
    }

    private function assetsInitializedHandler():Void {
        trace("assetsInitializedHandler");

        initExample();
    }

    private var v:Array<Float>;
    private var u:Array<Float>;
    private var texture:GTexture;

    private function initExample():Void {
        trace("genomeInitializedHandler");

        texture = GTextureManager.createTextureFromAsset("textures", GAssetManager.getImageAssetById("Untitled.png"));

        var w:Int = 100 ;
        var h:Int = 200 ;
        v = [0,0, w,0, 0,h, w,0, w,h, 0,h];
        u = [0,0.0, 1,0, 0,1, 1,0, 1,1, 0,1];

        var shape:GShape = cast GNode.createWithComponent(GShape);
        shape.texture = GTextureManager.getTextureById("textures");
        shape.setup(v,u);
        //shape.init([-20,20, -20,-20, 20,-20],[0,1, 0,0, 1,0]);
        shape.node.setPosition(300,300);
        shape.node.blue = 0;
        Genome2D.getInstance().root.addChild(shape.node);

        Genome2D.getInstance().onPostRender.add(postRenderHandler);
    }

    private function postRenderHandler():Void {
        var context:IContext = Genome2D.getInstance().getContext();
        //context.draw(textures, 100, 100);
        //context.drawPoly(GTexture.getTextureById("textures"), )
    }
}
