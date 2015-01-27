package test;

import com.genome2d.textures.GTextureManager;
import com.genome2d.node.GNode;
import com.genome2d.components.renderable.GSprite;
import com.genome2d.assets.GAssetManager;
import com.genome2d.context.GContextConfig;
import com.genome2d.Genome2D;
import com.genome2d.context.stats.GStats;

class Test {
    static function main() {
        new Test();
    }

    private var genome:Genome2D;

    public function new() {
        initGenome();
    }

    private function initGenome():Void {
        GStats.visible = true;
        trace("here");

        genome = Genome2D.getInstance();
        genome.onInitialized.addOnce(genomeInitializedHandler);
        genome.init(new GContextConfig());
    }

    private function genomeInitializedHandler():Void {
        initAssets();
    }

    private function initAssets():Void {
        GAssetManager.addFromUrl("atlas.png");
        GAssetManager.addFromUrl("atlas.xml");
        GAssetManager.onQueueLoaded.addOnce(assetsLoadedHandler);
        GAssetManager.loadQueue();
    }

    private var type:Int = 3;
    private var count:Int = 400000;

    private function assetsLoadedHandler():Void {
        GAssetManager.generateTextures();

        GNode.context = Genome2D.getInstance().getContext();
        GNode.texture = GTextureManager.getTextureById("atlas.png_0");

        for (i in 0...count) createSprite();

        if (type != 3) genome.onPostRender.add(postRenderHandler);
    }

    private function createSprite():Void {
        switch (type) {
            case 1:
                createTestSprite();
            case 2:
                createLinkedTestSprite();
            case 3:
                createNodeSprite();
        }
    }

    private var _testSprites:Array<TestSprite>;
    private function createTestSprite():Void {
        if (_testSprites == null) _testSprites = new Array<TestSprite>();
        var testSprite:TestSprite = new TestSprite();
        testSprite.x = 100;//Math.random()*800;
        testSprite.y = 100;//Math.random()*600;

        _testSprites.push(testSprite);
    }

    private var _firstSprite:TestSprite;
    private var _lastSprite:TestSprite;
    private function createLinkedTestSprite():Void {
        var testSprite:TestSprite = new TestSprite();
        testSprite.x = Math.random()*784+16;
        testSprite.y = Math.random()*584+16;

        if (_firstSprite == null) {
            _lastSprite = _firstSprite = testSprite;
        } else {
            _lastSprite.next = testSprite;
            _lastSprite = testSprite;
        }
    }

    private function createNodeSprite():Void {
        var nodeSprite:GSprite = cast GNode.createWithComponent(GSprite);
        nodeSprite.textureId = "atlas.png_0";
        nodeSprite.node.transform.x = Math.random()*784+16;
        nodeSprite.node.transform.y = Math.random()*584+16;
        genome.root.addChild(nodeSprite.node);
    }

    private function postRenderHandler():Void {
        if (type == 1) {
            for (i in 0...count) _testSprites[i].render();
        }
        if (type == 2) {
            var sprite:TestSprite = _firstSprite;
            while (sprite != null) {
                sprite.render();
                sprite = sprite.next;
            }
        }
    }
}
