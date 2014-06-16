package examples.basic;
import com.genome2d.assets.GAssetManager;
import com.genome2d.context.GContextConfig;
import com.genome2d.components.renderables.GTextureText;
import com.genome2d.components.renderables.GTextureText;
import com.genome2d.components.renderables.GTextureTextAlignType;
import com.genome2d.components.renderables.GTextureText;
import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.textures.factories.GTextureAtlasFactory;
import com.genome2d.Genome2D;
import com.genome2d.context.GContextConfig;
import com.genome2d.textures.GTextureAtlas;

class BasicExample4TextureText {

    static public function main() {
        var inst = new BasicExample4TextureText();
    }

    private var _assetManager:GAssetManager;

    public function new() {
        initGenome();
    }

    private function initGenome():Void {
        trace("initGenome");

        Genome2D.getInstance().onInitialized.add(genomeInitializedHandler);
        Genome2D.getInstance().init(new GContextConfig());
    }

    private function genomeInitializedHandler():Void {
        trace("genomeInitializedHandler");

        initAssets();
    }

    private function initAssets():Void {
        trace("initAssets");

        _assetManager = new GAssetManager();
        _assetManager.addUrl("font_gfx", "font.png");
        _assetManager.addUrl("font_xml", "font.fnt");
        _assetManager.onAllLoaded.add(assetsInitializedHandler);
        _assetManager.load();
    }

    private function assetsInitializedHandler():Void {
        trace("assetsInitializedHandler");

        initExample();
    }

    private function initExample():Void {
        GTextureAtlasFactory.createFontFromAssets("font", _assetManager.getImageAssetById("font_gfx"), _assetManager.getXmlAssetById("font_xml"));

        createText(200, 300, "font", "Hello Genome2D world.", GTextureTextAlignType.MIDDLE, 0);

        var text:GTextureText = createText(600, 300, "font", "Hello Genome2D\nin awesome\nmultiline text.", GTextureTextAlignType.MIDDLE, 0, 10);
        text.node.transform.rotation = 0.753;
    }

    private function createText(p_x:Float, p_y:Float, p_textureAtlasId:String, p_text:String, p_align:Int, p_tracking:Int = 0, p_lineSpace:Int = 0):GTextureText {
        var text:GTextureText = cast GNodeFactory.createNodeWithComponent(GTextureText);
        text.textureAtlasId = p_textureAtlasId;
        text.text = p_text;
        text.tracking = p_tracking;
        text.lineSpace = p_lineSpace;
        text.align = p_align;
        text.node.transform.setPosition(p_x, p_y);
        Genome2D.getInstance().root.addChild(text.node);
        return text;
    }
}
