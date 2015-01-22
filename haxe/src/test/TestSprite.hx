package test;
import com.genome2d.textures.GTextureManager;
import com.genome2d.textures.GTexture;
import com.genome2d.Genome2D;
import com.genome2d.context.stage3d.GStage3DContext;
class TestSprite {
    public var x:Float;
    public var y:Float;

    private var _context:GStage3DContext;
    private var _texture:GTexture;

    public var next:TestSprite;

    public function new() {
        _context = Genome2D.getInstance().getContext();
        _texture = GTextureManager.getTextureById("atlas.png_0");
    }

    inline public function render():Void {
        _context.draw(_texture,x,y,1,1);
    }
}
