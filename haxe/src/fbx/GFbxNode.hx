package fbx;
import fbx.FbxTools;
import fbx.FbxNode;

class GFbxNode {
    public var id:String;
    public var name:String;

    public var connections:Map<String,GFbxNode>;

    public function new(p_fbxNode:FbxNode) {
        id = Std.string(FbxTools.toFloat(p_fbxNode.props[0]));
        name = FbxTools.toString(p_fbxNode.props[1]);

        connections = new Map<String,GFbxNode>();
    }
}
