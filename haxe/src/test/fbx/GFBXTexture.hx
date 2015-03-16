package test.fbx;
import hxd.fmt.fbx.FbxTools;
import hxd.fmt.fbx.FbxNode;
class GFBXTexture extends GFBXNode {
    public var relativePath:String;

    public function new(p_fbxNode:FbxNode):Void {
        super(p_fbxNode);

        relativePath = FbxTools.toString(FbxTools.get(p_fbxNode, "RelativeFilename", true).props[0]);
    }
}
