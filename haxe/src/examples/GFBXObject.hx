package examples;
import hxd.fmt.fbx.FbxTools;
import com.genome2d.context.stage3d.renderers.GCustomRenderer;
import hxd.fmt.fbx.FbxNode;
class GFBXObject {
    private var g2d_renderers:Array<GCustomRenderer>;

    public function new() {
    }

    private function init(p_fbxData:FbxNode):Void {
        // Textures
        var textureNodes:Array<FbxNode> = FbxTools.getAll(object, "Objects.Texture");
        //trace(FbxTools.get(textureNodes[0], "RelativeFilename", true));

        var modelNodes:Array<FbxNode> = FbxTools.getAll(object, "Objects.Model");
        trace(FbxTools.toFloat(modelNodes[0].props[0]));
        return;

        // Geometry
        var vertexNodes:Array<FbxNode> = FbxTools.getAll(object,"Objects.Geometry.Vertices");
        var vertexIndexNodes:Array<FbxNode> = FbxTools.getAll(object,"Objects.Geometry.PolygonVertexIndex");

        var uvNodes:Array<FbxNode> = FbxTools.getAll(object,"Objects.Geometry.LayerElementUV.UV");
        var uvIndexNodes:Array<FbxNode> = FbxTools.getAll(object,"Objects.Geometry.LayerElementUV.UVIndex");

        if (vertexNodes.length != uvNodes.length) throw "Invalid number of UV sets and polygons";

        var mergedVertices:Array<Float> = new Array<Float>();
        var mergedVertexIndices:Array<UInt> = new Array<UInt>();
        var mergedUvs:Array<Float> = new Array<Float>();
        var indexOffset:Int = 0;
        for (i in 0...vertexNodes.length) {
            var currentVertices:Array<Float> = FbxTools.getFloats(vertexNodes[i]);
            var currentVertexIndices:Array<Int> = cast FbxTools.getInts(vertexIndexNodes[i]);
            var currentUVs:Array<Float> = FbxTools.getFloats(uvNodes[i]);
            var currentUVIndices:Array<Int> = FbxTools.getInts(uvIndexNodes[i]);
            if (currentUVIndices.length != currentVertexIndices.length) throw "Not same number of vertex and UV indices!";
            // Create array for our reindexed UVs
            var reindexedUvs:Array<Float> = new Array<Float>();
            for (j in 0...currentUVs.length) {
                reindexedUvs.push(0);
            }

            // Reindex UV coordinates to correspond to vertex indices
            var correctedIndices:Array<UInt> = new Array<UInt>();
            for (j in 0...currentUVIndices.length) {
//                if (currentVertexIndices[j]<0) currentVertexIndices[j] = -currentVertexIndices[j]-1;
                var vertexIndex:Int = currentVertexIndices[j];
                if (vertexIndex < 0) vertexIndex = -vertexIndex-1;
                correctedIndices.push(vertexIndex);
                mergedVertexIndices.push(vertexIndex+indexOffset);

                var uvIndex:Int = currentUVIndices[j];
                reindexedUvs[vertexIndex*2] = currentUVs[uvIndex*2];
                reindexedUvs[vertexIndex*2+1] = 1-currentUVs[uvIndex*2+1];
            }

            trace("Vertices", currentVertices.length/3, currentVertices);
            trace("UVs", reindexedUvs.length/2, reindexedUvs);
            trace("Indices", correctedIndices.length, correctedIndices);
            trace("UVIndices", currentUVIndices);
            trace("Triangles", correctedIndices.length/3);
            var renderer:GCustomRenderer = new GCustomRenderer(currentVertices, reindexedUvs, correctedIndices, false);
            renderers.push(renderer);

            // Merge vertices
            //mergedVertices = mergedVertices.concat(currentVertices);
            //mergedUvs = mergedUvs.concat(reindexedUvs);
            //indexOffset+=Std.int(currentVertices.length/3);
        }

        trace("# Meshes",renderers.length);

        /*
        trace("Vertices", mergedVertices.length, mergedVertices);
        trace("UVs", mergedUvs.length, mergedUvs);
        trace("Indices", mergedVertexIndices.length, mergedVertexIndices);

        //renderer = new GCustomRenderer(vertices, uvs, vertexIndices, false);
        /**/
    }
}
