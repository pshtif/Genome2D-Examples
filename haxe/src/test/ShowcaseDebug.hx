package test;

import com.genome2d.debug.GDebugPriority;
import com.genome2d.macros.MGDebug;
import com.genome2d.debug.GProfiler;
import com.genome2d.macros.MGProfiler;
import com.genome2d.debug.IGProfilable;
import com.genome2d.debug.GDebug;
import com.genome2d.Genome2D;
import com.genome2d.context.GContextConfig;
import com.genome2d.debug.IGDebuggable;
class ShowcaseDebug implements IGDebuggable implements IGProfilable {
    static public function main() {
        var inst = new ShowcaseDebug();
    }

    private var _genome:Genome2D;

    public function new() {
        initGenome();
    }

    private function initGenome():Void {
        _genome = Genome2D.getInstance();
        _genome.onInitialized.add(genomeInitializedHandler);
        _genome.init(new GContextConfig());
        GProfiler.showProfileCallEnds = false;
    }

    private function genomeInitializedHandler():Void {
        GProfiler.showMethodProfile("test.ShowcaseDebug", "test");
    }

    @genome_profile
    public function test():Void {
        for (i in 0...1000000) {
            var a:Float = 0;
        }
    }
}
