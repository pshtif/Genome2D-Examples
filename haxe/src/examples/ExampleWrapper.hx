package examples;

import com.genome2d.context.stats.GStats;
import examples.basic.BasicExample1Initialization;
import examples.basic.BasicExample2Sprite;
//import examples.basic.BasicExample3MovieClip;
import examples.basic.BasicExample4Mouse;
//import examples.basic.BasicExample5TextureText;
//import examples.basic.BasicExample6SimpleParticles;

//import examples.advanced.AdvancedExample2TileMap;
//import examples.advanced.AdvancedExample4Shape;

//import examples.ui.UIExample1Showcase;

class ExampleWrapper {
    static function main() {
        var inst = new ExampleWrapper();
    }

    public function new() {
        //GStats.visible = true;
        //BasicExample1Initialization.main();
        //BasicExample2Sprite.main();
        //BasicExample3MovieClip.main();
        BasicExample4Mouse.main();
        //BasicExample5TextureText.main();
        //BasicExample6SimpleParticles.main();
        //AdvancedExample2TileMap.main();
        //AdvancedExample4Shape.main();
        //UIExample1Showcase.main();

        //Test.main();
    }
}