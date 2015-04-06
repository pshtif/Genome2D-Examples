package fbx;

import fbx.FbxTools;
import fbx.FbxNode;

class GFbxTexture extends GFbxNode {
    public var relativePath:String;

    public function new(p_fbxNode:FbxNode):Void {
        super(p_fbxNode);

        relativePath = FbxTools.toString(FbxTools.get(p_fbxNode, "RelativeFilename", true).props[0]);
    }
}
