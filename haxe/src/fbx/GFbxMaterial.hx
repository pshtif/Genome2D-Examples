package fbx;
import fbx.FbxTools;
import fbx.FbxNode;

class GFbxMaterial extends GFbxNode {

    public function getTexture():GFbxTexture {
        for (connection in connections) {
            if (Std.is(connection, GFbxTexture)) return cast connection;
        }
        return null;
    }

    public function new(p_fbxNode:FbxNode):Void {
        super(p_fbxNode);
    }
}
