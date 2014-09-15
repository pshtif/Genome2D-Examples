package examples;

import com.genome2d.context.stats.GStats;
import examples.basic.BasicExample1Sprite;
import examples.basic.BasicExample2MovieClip;
import examples.basic.BasicExample3Mouse;
import examples.basic.BasicExample4TextureText;
import examples.basic.BasicExample5SimpleParticles;

class ExampleWrapper {
    static function main() {
        var inst = new ExampleWrapper();
    }

    public function new() {
        GStats.visible = true;

        //BasicExample1Sprite.main();
        //BasicExample2MovieClip.main();
        //BasicExample3Mouse.main();
        //BasicExample4TextureText.main();
        BasicExample5SimpleParticles.main();
        //Test.main();
    }
}