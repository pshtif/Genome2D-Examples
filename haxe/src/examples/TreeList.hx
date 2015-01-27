package examples;

import msignal.Signal.Signal1;
import flash.display.MovieClip;
import flash.text.TextFormat;
import flash.text.TextField;
import com.genome2d.ui.element.GUIElement;
import flash.events.MouseEvent;
import flash.display.Sprite;

class TreeList extends Sprite {
    inline static private var ROW_SIZE:Int = 20;

    private var rootElement:GUIElement;
    private var dtf:TextFormat;
    private var offset:Float;
    private var selected:Int = -1;
    private var container:Sprite;
    private var highlight:Sprite;
    private var highlighted:Float = -1;
    private var elements:Array<GUIElement>;

    public var onSelect:Signal1<GUIElement>;

    public function new() {
        super();

        onSelect = new Signal1<GUIElement>();
        dtf = new TextFormat("Arial",12,0x0);

        elements = new Array<GUIElement>();
        container = new Sprite();
        addChild(container);
        highlight = new Sprite();
        addChild(highlight);
    }

    private function invalidate():Void {
        elements = new Array<GUIElement>();
        container.removeChildren(0,container.numChildren-1);
        parseData(rootElement);
    }

    public function parseData(p_element:GUIElement, p_depth:Int = 0):Void {
        if (p_element == null) return;
        if (p_depth == 0) {
            offset = 0;
            rootElement = p_element;
        } else {
            addItem(p_element, p_depth);
        }
        if (p_element.children != null) {
            for (child in p_element.children) {
                parseData(child, p_depth+1);
            }
        }
    }

    private function addItem(p_element:GUIElement, p_depth:Int):Void {
        var tf:TextField = new TextField();
        tf.defaultTextFormat = dtf;
        tf.width = 100;
        tf.height = ROW_SIZE;
        tf.selectable = false;
        tf.x = p_depth*10;
        tf.mouseEnabled = false;
        tf.text = (p_element.name != null) ? p_element.name : "Element";

        var clip:MovieClip = new MovieClip();
        clip.graphics.beginFill(0xFFFFFF);
        clip.graphics.drawRect(0,0,100,20);
        clip.y = offset;
        clip.addChild(tf);
        clip.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        container.addChild(clip);

        elements.push(p_element);

        offset += ROW_SIZE;
    }

    private function getElement(p_index:Int):GUIElement {
        return elements[p_index];
    }

    private function getElementIndex(p_element:GUIElement):Int {
        for (i in 0...elements.length) {
            if (elements[i] == p_element) return i;
        }
        return -1;
    }

    private function mouseDownHandler(event:MouseEvent):Void {
        var index:Int = container.getChildIndex(event.target);
        doSelect(index);

        stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
    }

    private function mouseMoveHandler(event:MouseEvent):Void {
        var index:Float = Math.floor(this.mouseY/(ROW_SIZE*.5));
        index /= 2;
        if (index>=0 && index<container.numChildren) doHighlight(index);
    }

    private function mouseUpHandler(event:MouseEvent):Void {
        highlight.graphics.clear();

        doSwap();

        stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
    }

    private function doSwap():Void {
        if (highlighted>=0 && highlighted<container.numChildren && highlighted != selected) {
            var se:GUIElement = getElement(selected);
            var he:GUIElement = getElement(Std.int(highlighted));
            if (highlighted == Std.int(highlighted)) {
                if (!he.isParent(se)) {
                    he.addChild(se);
                    invalidate();
                    doSelect(getElementIndex(se));
                }
            } else {
                if (!he.isParent(se)) {
                    he.parent.addChildAt(se,he.parent.getChildIndex(he));
                    invalidate();
                    doSelect(getElementIndex(se));
                }
            }
        }

        highlighted = -1;
    }

    private function doSelect(p_index:Int):Void {
        doUnselect();
        selected = p_index;
        var clip:MovieClip = (selected>=0 && selected<container.numChildren) ? cast container.getChildAt(selected) : null;
        clip.graphics.clear();
        clip.graphics.beginFill(0x00AAFF);
        clip.graphics.drawRect(0,0,100,ROW_SIZE);

        onSelect.dispatch(getElement(selected));
    }

    private function doUnselect():Void {
        if (selected == -1) return;
        var clip:MovieClip = (selected>=0 && selected<container.numChildren) ? cast container.getChildAt(selected) : null;
        clip.graphics.clear();
        clip.graphics.beginFill(0xFFFFFF);
        clip.graphics.drawRect(0,0,100,ROW_SIZE);
        selected = -1;
    }

    private function doHighlight(p_index:Float):Void {
        highlight.graphics.clear();
        highlighted = p_index;

        if (highlighted == selected) return;

        highlight.graphics.lineStyle(2,0xFFAA00);
        if (p_index==Std.int(highlighted)) {
            highlight.graphics.drawRoundRect(1,1,100-2,ROW_SIZE-2,14,14);
            highlight.y = highlighted*ROW_SIZE;
        } else {
            highlight.graphics.drawCircle(2,0,2);
            highlight.graphics.drawRect(0,0,100,0);
            highlight.y = highlighted*ROW_SIZE+ROW_SIZE*.5;
        }
    }
}