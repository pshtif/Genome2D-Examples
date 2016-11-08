package com.genome2d.examples.custom;
import com.genome2d.input.GMouseInputType;
import com.genome2d.input.GMouseInput;
import com.genome2d.components.renderable.IGInteractive;
import com.genome2d.textures.GTextureManager;
import com.genome2d.components.renderable.GShape;
import com.genome2d.node.GNode;
import com.genome2d.components.renderable.GSprite;
import com.genome2d.components.GComponent;
class GEMoveGizmo extends GComponent {
    private var arrowThickness:Int = 2;
    private var arrowLength:Int = 50;
    private var arrowSize:Int = 12;
    private var rectSize:Int = 20;

    private var _verticalArrow:GShape;
    private var _horizontalArrow:GShape;
    private var _rectangle:GSprite;

    private var _dragging:Int = 0;
    private var _omx:Float;
    private var _omy:Float;
    private var _overNode:GNode;
    private var _draggingNode:GNode;
    private var _over:Int = 0;

    private var _boundNode:GNode;


    override public function init():Void {
        node.alpha = .5;

        _horizontalArrow = GNode.createWithComponent(GShape);
        _horizontalArrow.setup([0,-arrowThickness/2, arrowLength,-arrowThickness/2, 0,arrowThickness/2, 0,arrowThickness/2, arrowLength,-arrowThickness/2, arrowLength,arrowThickness/2, arrowLength,arrowSize/2, arrowLength,-arrowSize/2, arrowLength+arrowSize,0],[0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0]);
        _horizontalArrow.texture = GTextureManager.getTexture("assets/white.png");
        _horizontalArrow.node.mouseEnabled = true;
        _horizontalArrow.node.color = 0x00FF00;
        _horizontalArrow.node.onMouseDown.add(mouseDown_handler);
        _horizontalArrow.node.onMouseOver.add(mouseOver_handler);
        _horizontalArrow.node.onMouseOut.add(mouseOut_handler);
        node.addChild(_horizontalArrow.node);

        _verticalArrow = GNode.createWithComponent(GShape);
        _verticalArrow.setup([0,-arrowThickness/2, arrowLength,-arrowThickness/2, 0,arrowThickness/2, 0,arrowThickness/2, arrowLength,-arrowThickness/2, arrowLength,arrowThickness/2, arrowLength,arrowSize/2, arrowLength,-arrowSize/2, arrowLength+arrowSize,0],[0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0]);
        _verticalArrow.texture = GTextureManager.getTexture("assets/white.png");
        _verticalArrow.node.mouseEnabled = true;
        _verticalArrow.node.rotation = -Math.PI/2;
        _verticalArrow.node.color = 0xFF0000;
        _verticalArrow.node.onMouseDown.add(mouseDown_handler);
        _verticalArrow.node.onMouseOver.add(mouseOver_handler);
        _verticalArrow.node.onMouseOut.add(mouseOut_handler);
        node.addChild(_verticalArrow.node);


        _rectangle = GNode.createWithComponent(GSprite);
        _rectangle.texture = GTextureManager.getTexture("assets/white.png");
        _rectangle.node.mouseEnabled = true;
        _rectangle.node.setScale(rectSize/2,rectSize/2);
        _rectangle.node.setPosition(rectSize/2,-rectSize/2);
        _rectangle.node.color = 0x0000FF;
        _rectangle.node.alpha = .5;
        _rectangle.node.onMouseDown.add(mouseDown_handler);
        _rectangle.node.onMouseOver.add(mouseOver_handler);
        _rectangle.node.onMouseOut.add(mouseOut_handler);
        node.addChild(_rectangle.node);
    }

    public function bind(p_node:GNode):Void {
        _boundNode = p_node;
    }

    private function mouseOver_handler(p_input:GMouseInput):Void {
        if (_overNode != null && _overNode != _draggingNode) _overNode.color = _over == 1 ? 0xFF0000 : _over == 2 ? 0x00FF00 : 0xFFFF00;

        if (p_input.dispatcher == _verticalArrow.node) {
            _over = 1;
        } else if (p_input.dispatcher == _horizontalArrow.node) {
            _over = 2;
        } else {
            _over = 3;
        }

        _overNode = cast p_input.dispatcher;
        if (_draggingNode == null) _overNode.color = 0xFFFF00;
    }

    private function mouseOut_handler(p_input:GMouseInput):Void {
        if (_overNode == p_input.dispatcher) {
            if (_draggingNode != _overNode && _overNode != null) _overNode.color = _over == 1 ? 0xFF0000 : _over == 2 ? 0x00FF00 : 0x0000FF;

            _overNode = null;
            _over = 0;
        }
    }

    private function mouseDown_handler(p_input:GMouseInput):Void {
        if (p_input.dispatcher == _verticalArrow.node) {
            _dragging = 1;
        } else if (p_input.dispatcher == _horizontalArrow.node) {
            _dragging = 2;
        } else {
            _dragging = 3;
        }

        _omx = p_input.contextX;
        _omy = p_input.contextY;
        _draggingNode = cast p_input.dispatcher;
        node.core.getContext().onMouseInput.add(contextMouseInput_handler);
    }

    private function contextMouseInput_handler(p_input:GMouseInput):Void {
        switch (p_input.type) {
            case GMouseInputType.MOUSE_MOVE:
                if (_dragging & 2 == 2) {
                    node.x += p_input.contextX - _omx;
                    if (_boundNode != null) _boundNode.x += p_input.contextX - _omx;
                }
                if (_dragging & 1 == 1) {
                    node.y += p_input.contextY - _omy;
                    if (_boundNode != null) _boundNode.y += p_input.contextY - _omy;
                }
                _omx = p_input.contextX;
                _omy = p_input.contextY;
            case GMouseInputType.MOUSE_UP:
                node.core.getContext().onMouseInput.remove(contextMouseInput_handler);
                if (_draggingNode != _overNode) {
                    _draggingNode.color = _dragging == 1 ? 0xFF0000 : _dragging == 2 ? 0x00FF00 : 0x0000FF;
                } else if (_overNode != null) {
                    _overNode.color = 0xFFFF00;
                }
                _dragging = 0;
                _draggingNode = null;
        }
    }
}
