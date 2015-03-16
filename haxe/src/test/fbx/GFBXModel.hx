package test.fbx;
import hxd.fmt.fbx.FbxTools;
import hxd.fmt.fbx.FbxNode;
class GFBXModel extends GFBXNode {
    public function getGeometry():GFBXGeometry {
        for (connection in connections) {
            if (Std.is(connection, GFBXGeometry)) return cast connection;
        }
        return null;
    }

    public function getMaterial():GFBXMaterial {
        for (connection in connections) {
            if (Std.is(connection, GFBXMaterial)) return cast connection;
        }
        return null;
    }

    public function new(p_fbxNode:FbxNode):Void {
        super(p_fbxNode);
    }
}
