package fbx;

import fbx.FbxTools.FbxProp;

typedef FbxNode = {
    var name : String;
    var props : Array<FbxProp>;
    var childs : Array<FbxNode>;
}
