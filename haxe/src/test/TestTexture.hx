package test;
import flash.display.Sprite;
import com.genome2d.textures.GTextureManager;
import flash.geom.Rectangle;
import flash.display.BitmapData;
import com.genome2d.textures.GTextureFilteringType;
import flash.display3D.Context3DProfile;
import com.genome2d.context.GContextConfig;
import com.genome2d.Genome2D;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;
import com.genome2d.textures.GTexture;
import com.genome2d.context.IContext;

class TestTexture extends Sprite {
    private var context:IContext;
    private var texture:GTexture;

    static function main() {
        new TestTexture();
    }

    private function new():Void {
        super();
        Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
        Lib.current.stage.align = StageAlign.TOP_LEFT;

        Genome2D.getInstance().onInitialized.addOnce(genomeInitializedHandler);
        var config:GContextConfig = new GContextConfig(stage);
        config.profile=Context3DProfile.BASELINE_EXTENDED;
        Genome2D.getInstance().init(config);
    }

    private function genomeInitializedHandler():Void{
        createTexture(150);
        context = Genome2D.getInstance().getContext();
        context.setBackgroundColor(0xDADADA);
        Genome2D.getInstance().onPreRender.add(preRenderHandler);
    }

    private function preRenderHandler():Void{
        texture.filteringType = GTextureFilteringType.NEAREST;
        //context.draw(texture,100,300);			// this line
        context.drawSource(texture,0,0,114,114,0,0,100,100);
        context.drawSource(texture,0,0,113,113,0,0,300,100);
        context.draw(texture,300.5,300.5);
        texture.filteringType = GTextureFilteringType.LINEAR;
        context.drawSource(texture,0,0,114,114,0,0,500,100);
        context.drawSource(texture,0,0,113,113,0,0,700,100);
    }

    private function createTexture(SIZE:Int):Void {
        var bmd:BitmapData = new BitmapData(SIZE,SIZE,false,0xFFFFFF);
        var i:Int = 0;
        while (i<SIZE) {
            bmd.fillRect(new Rectangle(0,i,SIZE,1),0x000000 );
            bmd.fillRect(new Rectangle(i,0,1,SIZE),0x000000 );
            i+=7;
        }
        texture = GTextureManager.createTextureFromBitmapData("tex1", bmd);
    }
}
