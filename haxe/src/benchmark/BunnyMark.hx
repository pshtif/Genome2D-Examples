package benchmark;

import com.genome2d.node.factory.GNodeFactory;
import com.genome2d.context.GContextCamera;
import com.genome2d.components.renderables.GSprite;
import com.genome2d.context.stats.GStats;
import com.genome2d.assets.GAssetManager;
import com.genome2d.textures.factories.GTextureFactory;
import com.genome2d.textures.GTexture;
import com.genome2d.Genome2D;
import com.genome2d.context.GContextConfig;

class BunnyMark
{
    static public function main() {
        var inst = new BunnyMark();
    }

    private var genome:Genome2D;
    private var texture:GTexture;
    private var assetManager:GAssetManager;

    private var useNodes:Bool = true;
    private var bunnies:Array<Bunny>;

    public function new() {
        initGenome();
    }

    private function initGenome():Void {
        GStats.visible = true;

        genome = Genome2D.getInstance();
        genome.onInitialized.add(genomeInitializedHandler);
        genome.init(new GContextConfig());
    }

    private function genomeInitializedHandler():Void {
        initAssets();
    }

    private function initAssets():Void {
        assetManager = new GAssetManager();
        assetManager.addUrl("bunny_gfx", "bunny.png");
        assetManager.onAllLoaded.add(assetsInitializedHandler);
        assetManager.load();
    }

    private function assetsInitializedHandler():Void {
        texture = GTextureFactory.createFromAsset("bunny", assetManager.getImageAssetById("bunny_gfx"));

        bunnies = new Array<Bunny>();

        addBunnies();

        //genome.onPostRender.add(postRenderHandler);
    }

    private function addBunnies():Void {
        for (i in 0...30000) {
            if (!useNodes) {
                var bunny:Bunny = new Bunny();
                bunny.speedX = Math.random () * 10;
                bunny.speedY = (Math.random () * 10) - 5;
                bunnies.push (bunny);
            } else {
                var bunny:BunnySprite = cast GNodeFactory.createNodeWithComponent(BunnySprite);
                bunny.speedX = Math.random () * 10;
                bunny.speedY = (Math.random () * 10) - 5;
                genome.root.addChild(bunny.node);
            }
        }
    }

    private function postRenderHandler():Void {
        for (i in 0...bunnies.length) {
            var bunny:Bunny = bunnies[i];

            bunny.update();
            genome.getContext().draw(texture, bunny.x, bunny.y);
        }
    }
}

class Bunny {
    public var x:Float = 0;
    public var y:Float = 0;

    public var speedX:Float;
    public var speedY:Float;

    static public var minX:Float = 0;
    static public var maxX:Float = 800;
    static public var minY:Float = 0;
    static public var maxY:Float = 600;

    public function new() {

    }

    inline public function update():Void {
        x += speedX;
        y += speedY;
        speedY += 0.75;

        if (x > maxX) {
            speedX *= -1;
            x = maxX;
        } else if (x < minX) {
            speedX *= -1;
            x = minX;
        }

        if (y > maxY) {
            speedY *= -0.85;
            y = maxY;
            //spin = (Math.random () - 0.5) * 0.2;

            if (Math.random() > 0.5) {
                speedY -= Math.random () * 6;
            }
        } else if (y < minY) {
            speedY = 0;
            y = minY;
        }
    }

}

class BunnySprite extends GSprite {
    public var speedX:Float;
    public var speedY:Float;

    static public var minX:Float = 0;
    static public var maxX:Float = 800;
    static public var minY:Float = 0;
    static public var maxY:Float = 600;

    override public function init() {
        //node.transform.useWorldSpace = true;
        textureId = "bunny";
    }

    override public function render(p_camera:GContextCamera, p_useMatrix:Bool):Void {
        node.transform.x += speedX;
        node.transform.y += speedY;
        speedY += 0.75;

        if (node.transform.x > maxX) {
            speedX *= -1;
            node.transform.x = maxX;
        } else if (node.transform.x < minX) {
            speedX *= -1;
            node.transform.x = minX;
        }

        if (node.transform.y > maxY) {
            speedY *= -0.85;
            node.transform.y = maxY;

            if (Math.random() > 0.5) {
                speedY -= Math.random () * 6;
            }
        } else if (node.transform.y < minY) {
            speedY = 0;
            node.transform.y = minY;
        }

        super.render(p_camera, p_useMatrix);
    }

}