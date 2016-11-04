package com.genome2d.examples.custom;
import com.genome2d.debug.GDebug;
import com.genome2d.components.GComponent;
class CustomComponent extends GComponent {
    public var test:String = "Somarina";

    override public function init():Void {
        test = "Hovadina";

        node.core.onUpdate.add(update_handler);
    }

    private function update_handler(p_delta:Float):Void {
        GDebug.info(test);
    }


}
