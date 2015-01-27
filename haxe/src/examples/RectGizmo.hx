package examples;

import com.genome2d.ui.element.GUIElement;
import flash.geom.Rectangle;
import flash.events.MouseEvent;
import flash.display.Sprite;
import com.genome2d.geom.GRectangle;

class RectGizmo extends Sprite {
    inline static public var SIZE:Int = 10;
    inline static public var DRAG_COLOR:Int = 0xFFFFFF;

    private var dragging:Int = 0;
    private var offsetX:Float = 0;
    private var offsetY:Float = 0;
    private var centerX:Float = 0;
    private var centerY:Float = 0;

    private var element:GUIElement;
    private var elementRect:GRectangle;

    public function new() {
        super();

        elementRect = new GRectangle();

        invalidate();

        this.addEventListener(MouseEvent.MOUSE_DOWN, gizmoMouseDownHandler);
    }

    public function setElement(p_element:GUIElement):Void {
        element = p_element;
        elementRect.setTo(element.g2d_worldLeft, element.g2d_worldTop, element.g2d_worldRight-element.g2d_worldLeft, element.g2d_worldBottom-element.g2d_worldTop);
        invalidate();
    }

    private function updateElement():Void {
        element.setRect(elementRect.left, elementRect.top, elementRect.right, elementRect.bottom);
    }

    private function gizmoMouseDownHandler(event:MouseEvent):Void {
        centerX = elementRect.left+elementRect.width/2 - event.stageX;
        centerY = elementRect.top+elementRect.height/2 - event.stageY;
        offsetX = Math.abs(centerX)-elementRect.width/2;
        offsetY = Math.abs(centerY)-elementRect.height/2;

        if (event.localX<elementRect.left+SIZE/2) dragging+=1;
        if (event.localY<elementRect.top+SIZE/2) dragging+=2;
        if (event.localX>elementRect.right-SIZE/2) dragging+=4;
        if (event.localY>elementRect.bottom-SIZE/2) dragging+=8;

        stage.addEventListener(MouseEvent.MOUSE_MOVE, gizmoMouseMoveHandler);
        stage.addEventListener(MouseEvent.MOUSE_UP, gizmoMouseUpHandler);
    }

    private function gizmoMouseMoveHandler(event:MouseEvent):Void {
        if (dragging & 1 != 0) {
            elementRect.left = Math.min(event.stageX+offsetX,elementRect.right);
        } else if (dragging & 4 != 0) {
            elementRect.right = Math.max(event.stageX-offsetX,elementRect.left);
        }
        if (dragging & 2 != 0) {
            elementRect.top = Math.min(event.stageY+offsetY,elementRect.bottom);
        } else if (dragging & 8 != 0) {
            elementRect.bottom = Math.max(event.stageY-offsetY,elementRect.top);
        }
        if (dragging == 0) {
            elementRect.x = event.stageX-elementRect.width/2+centerX;
            elementRect.y = event.stageY-elementRect.height/2+centerY;
        }

        invalidate();

        updateElement();
    }

    private function invalidate():Void {
        graphics.clear();

        if (element != null) {
            graphics.beginFill(0xFF0000,0);
            graphics.drawRect(elementRect.left-SIZE,elementRect.top-SIZE,elementRect.width+SIZE*2,elementRect.height+SIZE*2);
            graphics.endFill();

            if (elementRect.width != 0 || elementRect.height != 0) {
                graphics.lineStyle(1,0xFFFFFF,.5);
                graphics.drawRect(elementRect.left,elementRect.top,elementRect.width,elementRect.height);
            }

            drawHandles();
        }
    }

    private function gizmoMouseUpHandler(event:MouseEvent):Void {
        dragging = 0;
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, gizmoMouseMoveHandler);
        stage.removeEventListener(MouseEvent.MOUSE_UP, gizmoMouseUpHandler);
    }

    private function drawHandles():Void {
        graphics.lineStyle(1,0x0);
        graphics.beginFill(DRAG_COLOR);
        graphics.drawRect(elementRect.left-SIZE,elementRect.top-SIZE,SIZE,SIZE);
        graphics.endFill();
        graphics.beginFill(DRAG_COLOR);
        graphics.drawRect(elementRect.right,elementRect.top-SIZE,SIZE,SIZE);
        graphics.endFill();
        graphics.beginFill(DRAG_COLOR);
        graphics.drawRect(elementRect.left-SIZE,elementRect.bottom,SIZE,SIZE);
        graphics.endFill();
        graphics.beginFill(DRAG_COLOR);
        graphics.drawRect(elementRect.right,elementRect.bottom,SIZE,SIZE);
        graphics.endFill();
    }
}
