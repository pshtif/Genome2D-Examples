package test.fbx;
import com.genome2d.context.GBlendMode;
import com.genome2d.Genome2D;
import com.genome2d.geom.GMatrix3D;
import com.genome2d.textures.GTextureManager;
import com.genome2d.textures.GTexture;
import com.genome2d.context.stage3d.renderers.GCustomRenderer;
class GFBXRenderer {
    public var renderer:GCustomRenderer;
    public var texture:GTexture;

    public function new(p_model:GFBXModel):Void {
        var fbxGeometry:GFBXGeometry = p_model.getGeometry();
        if (fbxGeometry == null) throw "Invalid model.";
        renderer = new GCustomRenderer(fbxGeometry.vertices, fbxGeometry.uvs, fbxGeometry.indices, false);
        var fbxTexture:GFBXTexture = p_model.getMaterial().getTexture();
        if (fbxTexture == null) throw "Invalid texture.";
        texture = GTextureManager.getTextureById(fbxTexture.relativePath);
        trace(fbxTexture.relativePath, texture);
    }

    public function render(p_x:Float, p_y:Float, p_z:Float, p_scale:Float, p_matrix:GMatrix3D):Void {
        Genome2D.getInstance().getContext().setBlendMode(GBlendMode.NORMAL, true);
        Genome2D.getInstance().getContext().bindRenderer(renderer);

        renderer.transformMatrix.identity();
        renderer.transformMatrix.prepend(p_matrix);
        renderer.transformMatrix.prependScale(p_scale,p_scale,p_scale);
        renderer.transformMatrix.appendTranslation(p_x,p_y,p_z);
        renderer.draw(texture,2);
    }
}
