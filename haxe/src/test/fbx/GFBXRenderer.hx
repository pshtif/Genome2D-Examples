package test.fbx;
import com.genome2d.context.stage3d.GStage3DContext;
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
        renderer = new GCustomRenderer(fbxGeometry.vertices, fbxGeometry.uvs, fbxGeometry.indices, fbxGeometry.vertexNormals, false);
        var fbxTexture:GFBXTexture = p_model.getMaterial().getTexture();
        if (fbxTexture == null) throw "Invalid texture.";
        texture = GTextureManager.getTextureById(fbxTexture.relativePath);
        trace(fbxTexture.relativePath, texture);
    }

    public function render(p_cameraMatrix:GMatrix3D, p_modelMatrix:GMatrix3D, p_cull:Int, p_renderType:Int):Void {
        var context:GStage3DContext = cast Genome2D.getInstance().getContext();
        context.setBlendMode(GBlendMode.NORMAL, true);
        context.bindRenderer(renderer);

        renderer.modelMatrix = p_modelMatrix;
        renderer.cameraMatrix = p_cameraMatrix;

        renderer.draw(texture, p_cull, p_renderType);
    }
}
