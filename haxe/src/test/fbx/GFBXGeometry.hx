package test.fbx;
import hxd.fmt.fbx.FbxTools;
import hxd.fmt.fbx.FbxNode;
class GFBXGeometry extends GFBXNode {

    public var vertices:Array<Float>;
    public var indices:Array<UInt>;
    public var uvs:Array<Float>;
    public var importedNormals:Array<Float>;
    public var vertexNormals:Array<Float>;
    public var faceNormals:Array<Float>;

    public function new(p_fbxNode:FbxNode) {
        super(p_fbxNode);

        var vertexNode:FbxNode = FbxTools.getAll(p_fbxNode,"Vertices")[0];
        var vertexIndexNode:FbxNode = FbxTools.getAll(p_fbxNode,"PolygonVertexIndex")[0];

        var normalsNode:FbxNode = FbxTools.getAll(p_fbxNode, "LayerElementNormal.Normals")[0];

        var uvNode:FbxNode = FbxTools.getAll(p_fbxNode,"LayerElementUV.UV")[0];
        trace("FUCK", FbxTools.getAll(p_fbxNode,"LayerElementUV.UV").length);
        var uvIndexNode:FbxNode = FbxTools.getAll(p_fbxNode,"LayerElementUV.UVIndex")[0];

        vertices = FbxTools.getFloats(vertexNode);
        importedNormals = FbxTools.getFloats(normalsNode);
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
        calculateFaceNormals();
        calculateVertexNormals();
    }

    private function calculateFaceNormals():Void {
        faceNormals = new Array<Float>();
        var i:Int = 0;
        while (i<indices.length) {
            var p1x:Float = vertices[indices[i]*3];
            var p1y:Float = vertices[indices[i]*3+1];
            var p1z:Float = vertices[indices[i]*3+2];
            var p2x:Float = vertices[indices[i+1]*3];
            var p2y:Float = vertices[indices[i+1]*3+1];
            var p2z:Float = vertices[indices[i+1]*3+2];
            var p3x:Float = vertices[indices[i+2]*3];
            var p3y:Float = vertices[indices[i+2]*3+1];
            var p3z:Float = vertices[indices[i+2]*3+2];
            var e1x:Float = p1x-p2x;
            var e1y:Float = p1y-p2y;
            var e1z:Float = p1z-p2z;
            var e2x:Float = p3x-p2x;
            var e2y:Float = p3y-p2y;
            var e2z:Float = p3z-p2z;
            var nx:Float = e1y*e2z - e1z*e2y;
            var ny:Float = e1z*e2x - e1x*e2z;
            var nz:Float = e1x*e2y - e1y*e2x;
            var nl:Float = Math.sqrt(nx*nx+ny*ny+nz*nz);
            nx /= nl;
            ny /= nl;
            nz /= nl;
            faceNormals.push(nx);
            faceNormals.push(ny);
            faceNormals.push(nz);
            i+=3;
        }
    }

    private function getVertexFaces(p_vertexIndex:UInt):Array<UInt> {
        var faces:Array<UInt> = new Array<UInt>();
        for (i in 0...indices.length) {
            if (indices[i] == p_vertexIndex) {
                var face:UInt = Std.int(i/3);
                if (faces.indexOf(face) == -1) faces.push(face);
            }
        }
        return faces;
    }

    private function calculateVertexNormals():Void {
        vertexNormals = new Array<Float>();
        var vertexCount:Int = Std.int(vertices.length/3);
        for (i in 0...vertexCount) {
            var sharedFaces:Array<UInt> = getVertexFaces(i);
            var nx:Float = 0;
            var ny:Float = 0;
            var nz:Float = 0;
            for (faceIndex in sharedFaces) {
                nx += faceNormals[faceIndex*3];
                ny += faceNormals[faceIndex*3+1];
                nz += faceNormals[faceIndex*3+2];
            }
            var nl:Float = Math.sqrt(nx*nx+ny*ny+nz*nz);
            vertexNormals.push(nx/nl);
            vertexNormals.push(ny/nl);
            vertexNormals.push(nz/nl);
        }
    }
}
