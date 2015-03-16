package test.fbx;
import hxd.fmt.fbx.FbxTools;
import hxd.fmt.fbx.FbxNode;
class GFBXMaterial extends GFBXNode {

    public function getTexture():GFBXTexture {
        for (connection in connections) {
            if (Std.is(connection, GFBXTexture)) return cast connection;
        }
        return null;
    }

    public function new(p_fbxNode:FbxNode):Void {
        super(p_fbxNode);
    }
}
