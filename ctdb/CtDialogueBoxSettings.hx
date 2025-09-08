package ctDialogueBox.ctdb;

import flixel.math.FlxPoint;

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
    
    public function new(
        font:String = null,
        boxImgPath:String = null,
        boxPosition:FlxPoint = null,
        textOffset:FlxPoint = null
    )
    {
        this.font = font;
        this.boxImgPath = boxImgPath;
        this.boxPosition = boxPosition ?? new FlxPoint(0, 0);
        this.textOffset = textOffset ?? new FlxPoint(0, 0);
    }
}