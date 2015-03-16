package test.fbx;
import hxd.fmt.fbx.FbxTools;
import hxd.fmt.fbx.FbxNode;
class GFBXNode {
    public var id:String;
    public var name:String;

    public var connections:Map<String,GFBXNode>;

    public function new(p_fbxNode:FbxNode) {
        id = Std.string(FbxTools.toFloat(p_fbxNode.props[0]));
        name = FbxTools.toString(p_fbxNode.props[1]);

        connections = new Map<String,GFBXNode>();
    }
}
