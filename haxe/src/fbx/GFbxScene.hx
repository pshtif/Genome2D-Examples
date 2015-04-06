package fbx;

import fbx.FbxNode;
import fbx.FbxTools;

import com.genome2d.geom.GFloat4;
import com.genome2d.geom.GMatrix3D;
import com.genome2d.context.stage3d.renderers.GCustomRenderer;
import com.genome2d.Genome2D;
import com.genome2d.context.IContext;
import com.genome2d.textures.GTextureManager;

class GFbxScene {
    public var lightDirection:GFloat4;
    public var ambientColor:GFloat4;
    public var lightColor:GFloat4;
    public var tintColor:GFloat4;

    private var g2d_renderers:Array<GFbxRenderer>;
    private var g2d_fbxData:FbxNode;
    private var g2d_nodes:Map<String,GFbxNode>;

    private var g2d_modelMatrix:GMatrix3D;
    public function getModelMatrix():GMatrix3D {
        return g2d_modelMatrix;
    }

    public function new() {
        g2d_nodes = new Map<String,GFbxNode>();

        lightDirection = new GFloat4(1,1,1,1);
        ambientColor = new GFloat4(1,1,1,1);
        tintColor = new GFloat4(1,1,1,1);
        lightColor = new GFloat4(1,1,1,1);
    }

    public function init(p_fbxData:FbxNode):Void {
        g2d_fbxData = p_fbxData;

        initTextures();
        initMaterials();
        initModels();
        initGeometry();

        initConnections();

        create();
    }

    private function initTextures():Void {
        var textureNodes:Array<FbxNode> = FbxTools.getAll(g2d_fbxData, "Objects.Texture");
        for (node in textureNodes) {
            var texture:GFbxTexture = new GFbxTexture(node);
            g2d_nodes.set(texture.id, texture);
        }
    }

    private function initModels():Void {
        var modelNodes:Array<FbxNode> = FbxTools.getAll(g2d_fbxData, "Objects.Model");

        for (node in modelNodes) {
            var model:GFbxModel = new GFbxModel(node);
            g2d_nodes.set(model.id, model);
        }
    }

    private function initMaterials():Void {
        var materialNodes:Array<FbxNode> = FbxTools.getAll(g2d_fbxData, "Objects.Material");

        for (node in materialNodes) {
            var material:GFbxMaterial = new GFbxMaterial(node);
            g2d_nodes.set(material.id, material);
        }
    }

    private function initGeometry():Void {
        var geometryNodes:Array<FbxNode> = FbxTools.getAll(g2d_fbxData,"Objects.Geometry");

        for (node in geometryNodes) {
            var geometry:GFbxGeometry = new GFbxGeometry(node);

            g2d_nodes.set(geometry.id, geometry);
        }
    }

    private function initConnections():Void {
        var connectionNodes:Array<FbxNode> = FbxTools.getAll(g2d_fbxData, "Connections.C");

        for (node in connectionNodes) {
            var sourceId:String = Std.string(FbxTools.toFloat(node.props[1]));
            var source:GFbxNode = g2d_nodes.get(sourceId);
            var destinationId:String = Std.string(FbxTools.toFloat(node.props[2]));
            var destination:GFbxNode = g2d_nodes.get(destinationId);
            if (destination != null && source != null) {
                destination.connections.set(source.id, source);
            }
        }
    }

    private function create():Void {
        g2d_modelMatrix = new GMatrix3D();
        g2d_renderers = new Array<GFbxRenderer>();

        for (node in g2d_nodes) {
            var model:GFbxModel = (Std.is(node,GFbxModel)) ? cast node : null;
            if (model != null) {
                var fbxRenderer:GFbxRenderer = new GFbxRenderer(this, model);
                g2d_renderers.push(fbxRenderer);
            }
        }
    }

    public function render(p_cameraMatrix:GMatrix3D, p_type:Int = 1):Void {
        for (renderer in g2d_renderers) {
            renderer.renderer.ambientColor = ambientColor;
            renderer.renderer.lightColor = lightColor;
            renderer.renderer.tintColor = tintColor;
        }

        switch (p_type) {
            // Normal
            case 1:
                for (renderer in g2d_renderers) {
                    renderer.render(p_cameraMatrix, g2d_modelMatrix, 2, 1);
                }
            // Reflection
            case 2:
                for (renderer in g2d_renderers) {
                    renderer.render(p_cameraMatrix, g2d_modelMatrix, 1, 1);
                }
            // Shadow
            case 3:
                for (renderer in g2d_renderers) {
                    renderer.render(p_cameraMatrix, g2d_modelMatrix, 1, 2);
                }
            // Invisible
            case 4:
                for (renderer in g2d_renderers) {
                    renderer.renderer.tintColor.w = 0;
                    renderer.render(p_cameraMatrix, g2d_modelMatrix, 2, 1);
                    renderer.renderer.tintColor.w = 0;
                }

        }
    }
}
