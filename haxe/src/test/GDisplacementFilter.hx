package test;

import flash.display3D.Context3DProgramType;
import com.genome2d.textures.GContextTexture;
import com.genome2d.context.stage3d.GStage3DContext;
import flash.Vector;
import com.genome2d.geom.GMatrix3D;
import com.genome2d.context.filters.GFilter;
class GDisplacementFilter extends GFilter {

    private var g2d_matrix:GMatrix3D;
    public var displacementMap:GContextTexture;
    private var g2d_offset:Float = 0;
    public var alpha:Float = 1;


    public function new() {
        super();

        var scaleX:Float = 1/256;
        var scaleY:Float = 2/256;
        g2d_matrix = new GMatrix3D();
        g2d_matrix.copyRawDataFrom(Vector.ofArray([scaleX,0,0,0, 0,scaleY,0,0, 0,0,0,0, 0,0,0,0]));

        overrideFragmentShader = true;

        fragmentCode =
            "mov ft0, v0                                    \n" +
            "add ft0.y, v0.y, fc5.x                         \n" +
            "tex ft0, ft0, fs1 <2d,linear,mipnone,repeat>    \n" +
            "sub ft0, ft0, fc0.zzzz                         \n" +
            "m44 ft0, ft0, fc1                              \n" +
            "add ft0, v0, ft0                               \n" +
            "tex ft1, ft0, fs0 <2d,linear,mipnone,clamp>    \n" +
            "mul oc, ft1, fc6";
    }

    override public function bind(p_context:GStage3DContext, p_defaultTexture:GContextTexture):Void {
        p_context.getNativeContext().setProgramConstantsFromMatrix(Context3DProgramType.FRAGMENT, 1, g2d_matrix, true);
        p_context.getNativeContext().setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 5, Vector.ofArray([g2d_offset,0,0,0.0,alpha,alpha,alpha,alpha]), 2);
        g2d_offset += .0003;

        p_context.getNativeContext().setTextureAt(1, displacementMap.nativeTexture);
    }

    override public function clear(p_context:GStage3DContext):Void {
        p_context.getNativeContext().setTextureAt(1, null);
    }
}