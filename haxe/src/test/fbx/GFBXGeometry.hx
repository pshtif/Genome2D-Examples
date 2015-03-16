package test.fbx;
import hxd.fmt.fbx.FbxTools;
import hxd.fmt.fbx.FbxNode;
class GFBXGeometry extends GFBXNode {

    public var vertices:Array<Float>;
    public var indices:Array<UInt>;
    public var uvs:Array<Float>;

    public function new(p_fbxNode:FbxNode) {
        super(p_fbxNode);

        var vertexNode:FbxNode = FbxTools.getAll(p_fbxNode,"Vertices")[0];
        var vertexIndexNode:FbxNode = FbxTools.getAll(p_fbxNode,"PolygonVertexIndex")[0];

        var uvNode:FbxNode = FbxTools.getAll(p_fbxNode,"LayerElementUV.UV")[0];
        var uvIndexNode:FbxNode = FbxTools.getAll(p_fbxNode,"LayerElementUV.UVIndex")[0];

        vertices = FbxTools.getFloats(vertexNode);
        var currentVertexIndices:Array<Int> = cast FbxTools.getInts(vertexIndexNode);
        var currentUVs:Array<Float> = FbxTools.getFloats(uvNode);
        var currentUVIndices:Array<Int> = FbxTools.getInts(uvIndexNode);
        if (currentUVIndices.length != currentVertexIndices.length) throw "Not same number of vertex and UV indices!";
        // Create array for our reindexed UVs
        uvs = new Array<Float>();
        for (j in 0...currentUVs.length) {
            uvs.push(0);
        }

        // Reindex UV coordinates to correspond to vertex indices
        indices = new Array<UInt>();
        for (j in 0...currentUVIndices.length) {
            var vertexIndex:Int = currentVertexIndices[j];
            if (vertexIndex < 0) vertexIndex = -vertexIndex-1;
            indices.push(vertexIndex);
            //mergedVertexIndices.push(vertexIndex+indexOffset);

            var uvIndex:Int = currentUVIndices[j];
            uvs[vertexIndex*2] = currentUVs[uvIndex*2];
            uvs[vertexIndex*2+1] = 1-currentUVs[uvIndex*2+1];
        }
        /*
        trace("Vertices", vertices.length/3, vertices);
        trace("UVs", uvs.length/2, uvs);
        trace("Indices", indices.length, indices);
        trace("Triangles", indices.length/3);
        /**/
    }
}
