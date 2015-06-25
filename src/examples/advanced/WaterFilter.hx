package examples.advanced;

import com.genome2d.context.IGContext;
import com.genome2d.textures.GTexture;
import com.genome2d.context.stage3d.GStage3DContext;
import com.genome2d.geom.GMatrix3D;
import com.genome2d.context.filters.GFilter;

import flash.Vector;
import flash.display3D.Context3DProgramType;

class WaterFilter extends GFilter {

    private var g2d_matrix:GMatrix3D;
    public var offset:Float = 0;

    public var displacementMap:GTexture;
    public var alphaMap1:GTexture;
	public var alphaMap2:GTexture;
    public var alpha:Float = 1;


    public function new(p_scaleX:Float = .1, p_scaleY:Float = .1) {
        super();

        g2d_matrix = new GMatrix3D();
        g2d_matrix.copyRawDataFrom(Vector.ofArray([p_scaleX,0,0,0, 0, p_scaleY,0,0, 0,0,0,0, 0,0,0,0]));

        overrideFragmentShader = true;

        fragmentCode =			
            "tex ft2, v0, fs2 <2d,linear,mipnone,repeat>   \n" +
			"tex ft3, v0, fs3 <2d,linear,mipnone,repeat>   \n" +
			
			"sub ft4, ft2, fc0.zzzz                         \n" +
            "m44 ft4, ft4, fc1                              \n" +
            "add ft4, v0, ft4                               \n" +
			
			"tex ft0, ft4, fs0 <2d,linear,mipnone,clamp> \n" +
			
			"sub ft4, ft3, fc0.zzzz                         \n" +
            "m44 ft4, ft4, fc1                              \n" +
            "add ft4, v0, ft4                               \n" +
			
			"tex ft1, ft4, fs1 <2d,linear,mipnone,clamp> \n" +
			
			//"mul ft2, ft2, fc0.wwww \n" +
			//"mul ft2, ft2, ft2 \n" +
			//"div ft2, ft2, fc5.y \n" + 
			"mul ft0, ft0, ft2 \n" + 
			"mul ft1, ft1, ft3 \n" +
			"add oc, ft0, ft1";
			//"mov oc, ft0";
			/*
            "mov ft0, v0                                    \n" +
            "add ft0.y, v0.y, fc5.x                         \n" +
            "tex ft0, ft0, fs1 <2d,linear,mipnone,repeat>   \n" +
            "sub ft0, ft0, fc0.zzzz                         \n" +
            "m44 ft0, ft0, fc1                              \n" +
            "add ft0, v0, ft0                               \n" +
            "tex ft1, ft0, fs0 <2d,linear,mipnone,clamp>    \n" +
            "mul oc, ft1, fc6                              ";
            //"tex ft2, v0, fs2 <2d,linear,mipnone,clamp>     \n" +
            //"mul oc, ft1, ft2.wwww";
			/**/
    }

    override public function bind(p_context:IGContext, p_defaultTexture:GTexture):Void {
        p_context.getNativeContext().setProgramConstantsFromMatrix(Context3DProgramType.FRAGMENT, 1, g2d_matrix, true);
        p_context.getNativeContext().setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 5, Vector.ofArray([offset, 4, 0, 0.0, alpha, alpha, alpha, alpha]), 2);
		offset += .0003;

        p_context.getNativeContext().setTextureAt(1, displacementMap.nativeTexture);
        p_context.getNativeContext().setTextureAt(2, alphaMap1.nativeTexture);
		p_context.getNativeContext().setTextureAt(3, alphaMap2.nativeTexture);
    }

    override public function clear(p_context:IGContext):Void {
        p_context.getNativeContext().setTextureAt(1, null);
        p_context.getNativeContext().setTextureAt(2, null);
		p_context.getNativeContext().setTextureAt(3, null);
    }
}