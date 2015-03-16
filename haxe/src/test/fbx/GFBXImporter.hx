package test.fbx;
import com.genome2d.geom.GMatrix3D;
import hxd.fmt.fbx.FbxTools;
import hxd.fmt.fbx.FbxTools;
import com.genome2d.context.stage3d.renderers.GCustomRenderer;
import hxd.fmt.fbx.FbxNode;
class GFBXImporter {
    private var g2d_renderers:Array<GFBXRenderer>;
    private var g2d_fbxData:FbxNode;
    private var g2d_nodes:Map<String,GFBXNode>;

    public var scale:Float = .1;
    public var x:Float = 400;
    public var y:Float = 300;
    public var z:Float = 300;

    public function new() {
        g2d_nodes = new Map<String,GFBXNode>();
    }

    public function init(p_fbxData:FbxNode):Void {
        g2d_fbxData = p_fbxData;

        initTextures();
        initMaterials();
        initModels();
        initGeometry();

        initConnections();

        create();

        return;

        // Geometry
        var vertexNodes:Array<FbxNode> = FbxTools.getAll(g2d_fbxData,"Objects.Geometry.Vertices");
        var vertexIndexNodes:Array<FbxNode> = FbxTools.getAll(g2d_fbxData,"Objects.Geometry.PolygonVertexIndex");

        var uvNodes:Array<FbxNode> = FbxTools.getAll(g2d_fbxData,"Objects.Geometry.LayerElementUV.UV");
        var uvIndexNodes:Array<FbxNode> = FbxTools.getAll(g2d_fbxData,"Objects.Geometry.LayerElementUV.UVIndex");

        if (vertexNodes.length != uvNodes.length) throw "Invalid number of UV sets and polygons";

        var mergedVertices:Array<Float> = new Array<Float>();
        var mergedVertexIndices:Array<UInt> = new Array<UInt>();
        var mergedUvs:Array<Float> = new Array<Float>();
        var indexOffset:Int = 0;
        for (i in 0...vertexNodes.length) {
            var currentVertices:Array<Float> = FbxTools.getFloats(vertexNodes[i]);
            var currentVertexIndices:Array<Int> = cast FbxTools.getInts(vertexIndexNodes[i]);
            var currentUVs:Array<Float> = FbxTools.getFloats(uvNodes[i]);
            var currentUVIndices:Array<Int> = FbxTools.getInts(uvIndexNodes[i]);
            if (currentUVIndices.length != currentVertexIndices.length) throw "Not same number of vertex and UV indices!";
            // Create array for our reindexed UVs
            var reindexedUvs:Array<Float> = new Array<Float>();
            for (j in 0...currentUVs.length) {
                reindexedUvs.push(0);
            }

            // Reindex UV coordinates to correspond to vertex indices
            var correctedIndices:Array<UInt> = new Array<UInt>();
            for (j in 0...currentUVIndices.length) {
//                if (currentVertexIndices[j]<0) currentVertexIndices[j] = -currentVertexIndices[j]-1;
                var vertexIndex:Int = currentVertexIndices[j];
                if (vertexIndex < 0) vertexIndex = -vertexIndex-1;
                correctedIndices.push(vertexIndex);
                mergedVertexIndices.push(vertexIndex+indexOffset);

                var uvIndex:Int = currentUVIndices[j];
                reindexedUvs[vertexIndex*2] = currentUVs[uvIndex*2];
                reindexedUvs[vertexIndex*2+1] = 1-currentUVs[uvIndex*2+1];
            }

            trace("Vertices", currentVertices.length/3, currentVertices);
            trace("UVs", reindexedUvs.length/2, reindexedUvs);
            trace("Indices", correctedIndices.length, correctedIndices);
            trace("UVIndices", currentUVIndices);
            trace("Triangles", correctedIndices.length/3);
            //var renderer:GCustomRenderer = new GCustomRenderer(currentVertices, reindexedUvs, correctedIndices, false);
            //g2d_renderers.push(renderer);

            // Merge vertices
            //mergedVertices = mergedVertices.concat(currentVertices);
            //mergedUvs = mergedUvs.concat(reindexedUvs);
            //indexOffset+=Std.int(currentVertices.length/3);
        }

        trace("# Renderers",g2d_renderers.length);

        /*
        trace("Vertices", mergedVertices.length, mergedVertices);
        trace("UVs", mergedUvs.length, mergedUvs);
        trace("Indices", mergedVertexIndices.length, mergedVertexIndices);

        //renderer = new GCustomRenderer(vertices, uvs, vertexIndices, false);
        /**/
    }

    private function initTextures():Void {
        var textureNodes:Array<FbxNode> = FbxTools.getAll(g2d_fbxData, "Objects.Texture");
        for (node in textureNodes) {
            var texture:GFBXTexture = new GFBXTexture(node);
            g2d_nodes.set(texture.id, texture);
        }
    }

    private function initModels():Void {
        var modelNodes:Array<FbxNode> = FbxTools.getAll(g2d_fbxData, "Objects.Model");

        for (node in modelNodes) {
            var model:GFBXModel = new GFBXModel(node);
            g2d_nodes.set(model.id, model);
        }
    }

    private function initMaterials():Void {
        var materialNodes:Array<FbxNode> = FbxTools.getAll(g2d_fbxData, "Objects.Material");

        for (node in materialNodes) {
            var material:GFBXMaterial = new GFBXMaterial(node);
            g2d_nodes.set(material.id, material);
        }
    }

    private function initGeometry():Void {
        var geometryNodes:Array<FbxNode> = FbxTools.getAll(g2d_fbxData,"Objects.Geometry");

        for (node in geometryNodes) {
            var geometry:GFBXGeometry = new GFBXGeometry(node);
            g2d_nodes.set(geometry.id, geometry);
        }
    }

    private function initConnections():Void {
        var connectionNodes:Array<FbxNode> = FbxTools.getAll(g2d_fbxData, "Connections.C");

        for (node in connectionNodes) {
            var sourceId:String = Std.string(FbxTools.toFloat(node.props[1]));
            var source:GFBXNode = g2d_nodes.get(sourceId);
            var destinationId:String = Std.string(FbxTools.toFloat(node.props[2]));
            var destination:GFBXNode = g2d_nodes.get(destinationId);
            if (destination != null && source != null) {
                trace(sourceId, destinationId, source, destination);
                destination.connections.set(source.id, source);
            }
            //trace(sourceId, destinationId);
        }
    }

    private function create():Void {
        g2d_renderers = new Array<GFBXRenderer>();

        for (node in g2d_nodes) {
            var model:GFBXModel = (Std.is(node,GFBXModel)) ? cast node : null;
            if (model != null) {
                var fbxRenderer:GFBXRenderer = new GFBXRenderer(model);
                g2d_renderers.push(fbxRenderer);
            }
        }
    }

    public function render(p_matrix:GMatrix3D):Void {
        for (renderer in g2d_renderers) {
            renderer.render(x, y, z, scale, p_matrix);
        }
    }
}
