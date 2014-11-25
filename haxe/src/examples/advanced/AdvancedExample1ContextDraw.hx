package examples.advanced;
import com.genome2d.assets.GXmlAsset;
import com.genome2d.geom.GRectangle;
import com.genome2d.context.IContext;
import com.genome2d.Genome2D;
import com.genome2d.textures.GTextureFilteringType;
import com.genome2d.node.GNode;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.textures.factories.GTextureAtlasFactory;
import com.genome2d.textures.factories.GTextureFactory;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.context.GContextConfig;
import com.genome2d.assets.GImageAsset;
import com.genome2d.textures.GTextureAtlas;
import com.genome2d.textures.GTexture;
import com.genome2d.assets.GAssetManager;

class AdvancedExample1ContextDraw {

    static function main() {
        var inst = new AdvancedExample1ContextDraw();
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
        assetManager.add(new GXmlAsset("atlas_xml", "atlas.xml"));
        assetManager.add(new GImageAsset("atlas_gfx", "atlas.png"));
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

        GTextureFactory.createFromAsset("crate", cast assetManager.getAssetById("texture_gfx"));
        atlas = GTextureAtlasFactory.createFromAssets("atlas", cast assetManager.getAssetById("atlas_gfx"), cast assetManager.getAssetById("atlas_xml"));
        atlas.setFilteringType(GTextureFilteringType.LINEAR);

        Genome2D.getInstance().onPreRender.add(onPreRender);
    }

    private function onPreRender():Void {
        var texture:GTexture = GTexture.getTextureById("crate");
        var context:IContext = Genome2D.getInstance().getContext();
        var skewX:Float = 0;
        var skewY:Float = 1;
        //context.drawMatrix(textures,2*(.5-Math.abs(skewX)), skewX, skewY, 1, 200, 200-100*Math.abs(skewX));
        context.drawSource(atlas.getSubTexture("g100"), 0, 0, 128, 128, 100, 100);
    }
}
