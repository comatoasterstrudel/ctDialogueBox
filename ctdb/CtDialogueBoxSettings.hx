package ctDialogueBox.ctdb;

import flixel.math.FlxPoint;
import flixel.util.FlxColor;

@:structInit

/**
* the settings used to customize the dialogue box
*/
class CtDialogueBoxSettings{
    /**
     * The path to the font file you want to use. if left null, will use HaxeFlixel default font.
     * eg: assets/font/andy.ttf
     */
    public var font:String;

    /**
     * the size the text should be
     * eg: 10
     */
    public var fontSize:Int;
    
    /**
     * the path to the image for your dialogue box. if left null, will make a 800x300 white box.
     * eg: assets/images/dialogueBox.png
     */
    public var boxImgPath:String;
    
    /**
     * the offset for where the text will be located. leaving this null will center the box in the middle of the screen
     * eg: new FlxPoint(0, 0) 
     */
    public var boxPosition:FlxPoint;
    
    /**
     * the offset for where the text will be located relative to the textbox.
     * eg: new FlxPoint(0, 0) 
     */
    public var textOffset:FlxPoint;
    
    /**
     * the color the text will become. this will overwrite actor text colors if set.
     * eg: FlxColor.WHITE
     */
    public var textColor:FlxColor;
    
    public function new(
        font:String = null,
        fontSize:Int = 15,
        boxImgPath:String = null,
        boxPosition:FlxPoint = null,
	    textOffset:FlxPoint = null,
        textColor:FlxColor = null
    )
    {
        this.font = font;
        this.fontSize = fontSize;
        this.boxImgPath = boxImgPath;
		this.boxPosition = boxPosition ?? null;
        this.textOffset = textOffset ?? new FlxPoint(0, 0);
        this.textColor = textColor;
    }
}