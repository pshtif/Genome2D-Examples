package examples;

import com.genome2d.ui.GUIElement;
import flash.geom.Rectangle;
import flash.events.MouseEvent;
import flash.display.Sprite;
import com.genome2d.geom.GRectangle;

class AnchorGizmo extends Sprite {
    inline static public var SIZE:Int = 10;
    inline static private var DRAG_COLOR:Int = 0xFFFFFF;

    private var dragging:Int = 0;
    private var offsetX:Float = 0;
    private var offsetY:Float = 0;
    private var centerX:Float = 0;
    private var centerY:Float = 0;

    private var element:GUIElement;
    private var anchorRect:GRectangle;
    private var parentRect:GRectangle;

    public function new() {
        super();

        anchorRect = new GRectangle();
        parentRect = new GRectangle();

        invalidate();

        this.addEventListener(MouseEvent.MOUSE_DOWN, gizmoMouseDownHandler);
    }

    public function setElement(p_element:GUIElement):Void {
        element = p_element;
        parentRect.setTo(element.parent.g2d_worldLeft, element.parent.g2d_worldTop, element.parent.g2d_finalWidth, element.parent.g2d_finalHeight);
        anchorRect.setTo(element.parent.g2d_worldLeft+element.anchorLeft*element.parent.g2d_finalWidth,
                          element.parent.g2d_worldTop+element.anchorTop*element.parent.g2d_finalHeight,
                          element.parent.g2d_finalWidth*(element.anchorRight - element.anchorLeft),
                          element.parent.g2d_finalHeight*(element.anchorBottom - element.anchorTop));
        trace(anchorRect);
        invalidate();
    }

    private function updateElement():Void {
        var anchorLeft:Float = anchorRect.left-parentRect.left;
        var anchorRight:Float = anchorRect.right-parentRect.left;
        var anchorTop:Float = anchorRect.top-parentRect.top;
        var anchorBottom:Float = anchorRect.bottom-parentRect.top;

        element.anchorLeft = anchorLeft/parentRect.width;
        element.anchorRight = anchorRight/parentRect.width;
        element.anchorTop = anchorTop/parentRect.height;
        element.anchorBottom = anchorBottom/parentRect.height;

        var pivotX:Float = element.g2d_worldLeft+element.pivotX*element.g2d_finalWidth;
        var pivotY:Float = element.g2d_worldTop+element.pivotY*element.g2d_finalHeight;
        element.anchorX = pivotX-anchorLeft-parentRect.left;
        element.anchorY = pivotY-anchorTop-parentRect.top;

        element.left = element.g2d_worldLeft - anchorRect.left;
        element.right = anchorRect.right - element.g2d_worldRight;
        element.top = element.g2d_worldTop - anchorRect.top;
        element.bottom = anchorRect.bottom - element.g2d_worldBottom;
    }

    private function gizmoMouseDownHandler(event:MouseEvent):Void {
        centerX = anchorRect.left+anchorRect.width/2 - event.stageX;
        centerY = anchorRect.top+anchorRect.height/2 - event.stageY;
        offsetX = Math.abs(centerX)-anchorRect.width/2;
        offsetY = Math.abs(centerY)-anchorRect.height/2;


        if (event.localX<anchorRect.left-SIZE/4) dragging+=1;
        if (event.localY<anchorRect.top-SIZE/4) dragging+=2;
        if (event.localX>anchorRect.right+SIZE/4) dragging+=4;
        if (event.localY>anchorRect.bottom+SIZE/4) dragging+=8;

        stage.addEventListener(MouseEvent.MOUSE_MOVE, gizmoMouseMoveHandler);
        stage.addEventListener(MouseEvent.MOUSE_UP, gizmoMouseUpHandler);
    }

    private function gizmoMouseMoveHandler(event:MouseEvent):Void {
        if (dragging & 1 != 0) {
            anchorRect.left = Math.max(parentRect.left,Math.min(event.stageX+offsetX,anchorRect.right));
        } else if (dragging & 4 != 0) {
            anchorRect.right = Math.min(parentRect.right,Math.max(event.stageX-offsetX,anchorRect.left));
        }
        if (dragging & 2 != 0) {
            anchorRect.top = Math.max(parentRect.top,Math.min(event.stageY+offsetY,anchorRect.bottom));
        } else if (dragging & 8 != 0) {
            anchorRect.bottom = Math.min(parentRect.bottom,Math.max(event.stageY-offsetY,anchorRect.top));
        }
        if (dragging == 0) {
            anchorRect.x = event.stageX-anchorRect.width/2+centerX;
            if (anchorRect.x<parentRect.left) anchorRect.x = parentRect.left else if (anchorRect.x>parentRect.right) anchorRect.x = parentRect.right;
            anchorRect.y = event.stageY-anchorRect.height/2+centerY;
            if (anchorRect.y<parentRect.top) anchorRect.y = parentRect.top else if (anchorRect.y>parentRect.bottom) anchorRect.y = parentRect.bottom;
        }

        invalidate();

        updateElement();
    }

    private function invalidate():Void {
        graphics.clear();
        if (element != null) {
            graphics.lineStyle(1,0xFFFFFF);
            graphics.drawRect(parentRect.left, parentRect.top, parentRect.width, parentRect.height);
            graphics.lineStyle(0,0x0,0);

            graphics.beginFill(0xFF0000,0);
            graphics.drawRect(anchorRect.left-SIZE,anchorRect.top-SIZE,anchorRect.width+SIZE*2,SIZE);
            graphics.endFill();
            graphics.beginFill(0xFF0000,0);
            graphics.drawRect(anchorRect.left-SIZE,anchorRect.bottom,anchorRect.width+SIZE*2,SIZE);
            graphics.endFill();
            graphics.beginFill(0xFF0000,0);
            graphics.drawRect(anchorRect.left-SIZE,anchorRect.top-SIZE,SIZE,anchorRect.height+SIZE*2);
            graphics.endFill();
            graphics.beginFill(0xFF0000,0);
            graphics.drawRect(anchorRect.right,anchorRect.top-SIZE,SIZE,anchorRect.height+SIZE*2);
            graphics.endFill();

            if (anchorRect.width != 0 || anchorRect.height != 0) {
                graphics.lineStyle(1,0xFF0000,.5);
                graphics.drawRect(anchorRect.left,anchorRect.top,anchorRect.width,anchorRect.height);
            }

            drawTriangles();
        }
    }

    private function gizmoMouseUpHandler(event:MouseEvent):Void {
        dragging = 0;
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, gizmoMouseMoveHandler);
        stage.removeEventListener(MouseEvent.MOUSE_UP, gizmoMouseUpHandler);
    }

    private function drawTriangles():Void {
        graphics.lineStyle(1,0x0);
        graphics.beginFill(DRAG_COLOR);
        graphics.moveTo(anchorRect.left,anchorRect.top);
        graphics.lineTo(anchorRect.left-SIZE/2,anchorRect.top-SIZE);
        graphics.lineTo(anchorRect.left-SIZE,anchorRect.top-SIZE/2);
        graphics.endFill();

        graphics.beginFill(DRAG_COLOR);
        graphics.moveTo(anchorRect.right,anchorRect.top);
        graphics.lineTo(anchorRect.right+SIZE/2,anchorRect.top-SIZE);
        graphics.lineTo(anchorRect.right+SIZE,anchorRect.top-SIZE/2);
        graphics.endFill();

        graphics.beginFill(DRAG_COLOR);
        graphics.moveTo(anchorRect.left,anchorRect.bottom);
        graphics.lineTo(anchorRect.left-SIZE/2,anchorRect.bottom+SIZE);
        graphics.lineTo(anchorRect.left-SIZE,anchorRect.bottom+SIZE/2);
        graphics.endFill();

        graphics.beginFill(DRAG_COLOR);
        graphics.moveTo(anchorRect.right,anchorRect.bottom);
        graphics.lineTo(anchorRect.right+SIZE/2,anchorRect.bottom+SIZE);
        graphics.lineTo(anchorRect.right+SIZE,anchorRect.bottom+SIZE/2);
        graphics.endFill();
    }
}
