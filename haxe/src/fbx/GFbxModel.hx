package fbx;

import fbx.FbxTools;
import fbx.FbxNode;

class GFbxModel extends GFbxNode {
    public function getGeometry():GFbxGeometry {
        for (connection in connections) {
            if (Std.is(connection, GFbxGeometry)) return cast connection;
            if (Std.is(connection, GFbxModel)) return cast(connection,GFbxModel).getGeometry();
        }
        return null;
    }

    public function getMaterial():GFbxMaterial {
        for (connection in connections) {
            if (Std.is(connection, GFbxMaterial)) return cast connection;
            if (Std.is(connection, GFbxModel)) return cast(connection,GFbxModel).getMaterial();
        }
        return null;
    }

    public function new(p_fbxNode:FbxNode):Void {
        super(p_fbxNode);
    }
}
