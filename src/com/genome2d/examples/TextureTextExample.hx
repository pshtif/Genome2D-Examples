/*
 * 	Genome2D - 2D GPU Framework
 * 	http://www.genome2d.com
 *
 *	Copyright 2011-2014 Peter Stefcek. All rights reserved.
 *
 *	License:: ./doc/LICENSE.md (https://github.com/pshtif/Genome2D/blob/master/LICENSE.md)
 */
package com.genome2d.examples;

import com.genome2d.assets.GAsset;
import com.genome2d.assets.GAssetManager;
import com.genome2d.components.renderable.GSprite;
import com.genome2d.components.renderable.text.GText;
import com.genome2d.context.GContextConfig;
import com.genome2d.Genome2D;
import com.genome2d.node.GNode;
import com.genome2d.text.GFontManager;
import com.genome2d.text.GTextFormat;
import com.genome2d.text.GTextureTextRenderer;
import com.genome2d.textures.GTextureManager;
import com.genome2d.utils.GHAlignType;
import com.genome2d.utils.GVAlignType;


class TextureTextExample extends AbstractExample
{

    static public function main() {
        var inst = new TextureTextExample();
    }
	
    /**
        Initialize Example code
     **/
    override public function initExample():Void {
		title = "TEXTURE TEXT EXAMPLE";
		detail = "The most common way to render text in GPU renderers is to use textured text composed of sprites.";
		
		createText(250, 150, "HELLO WORLD.", GVAlignType.MIDDLE, GHAlignType.CENTER);
    }
	
    private function createText(p_x:Float, p_y:Float, p_text:String, p_vAlign:GVAlignType, p_hAlign:GHAlignType, p_tracking:Int = 0, p_lineSpace:Int = 0):GText {
        var text:GText = cast GNode.createWithComponent(GText);
		
        text.renderer.textureFont = GFontManager.getFont("assets/font.fnt");
        text.width = 300;
        text.height = 300;
        text.text = p_text;
        text.tracking = p_tracking;
        text.lineSpace = p_lineSpace;
        text.vAlign = p_vAlign;
        text.hAlign = p_hAlign;
        text.node.setPosition(p_x, p_y);

        container.addChild(text.node);

        return text;
    }
}
