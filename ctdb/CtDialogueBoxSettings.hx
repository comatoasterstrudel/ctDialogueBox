package ctDialogueBox.ctdb;

import ctDialogueBox.ctdb.data.*;
import flixel.FlxG;
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
     * the name of your dialogue box image. if left null, will make a 800x300 white box.
     * eg: dialogueBox
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
    
    /**
     * the folder in your assets folder where your dialogue files are located
     * default: assets/data/dialogue/
     */
    public var dialogueDataPath:String;
    
    /**
     * the folder in your assets folder where your dialogue images are located
     * default: assets/images/dialogue/
     */
    public var dialogueImagePath:String;
    
    /**
     * this is the function to check if youve pressed the enter button, or however you want the dialogue to progress
     * default: FlxG.keys.justPressed.ENTER
     */
    public var pressedAcceptFunction:Void->Bool;
    
    /**
     * this is the function to check if youre holding down the ctrl key, or however you want the dialogue to be able to be skipped
     * default: FlxG.keys.pressed.CONTROL
     */
    public var pressedSkipFunction:Void->Bool;
    
    /**
     * the function that should happen when the dialogue is finished.
     */
    public var onComplete:Void->Void;
    
    /**
     * the function that should happen when you advance a dialogue line. this gives back the data for that line
     */
    public var onLineAdvance:DialogueData->Void;
    
    public function new(
        font:String = null,
        fontSize:Int = null,
        boxImgPath:String = null,
        boxPosition:FlxPoint = null,
	    textOffset:FlxPoint = null,
        textColor:FlxColor = null,
        dialogueDataPath:String = null,
        dialogueImagePath:String = null,
        pressedAcceptFunction:Void->Bool = null,
        pressedSkipFunction:Void->Bool = null,
        onComplete:Void->Void = null,
        onLineAdvance:DialogueData->Void = null
    )
    {
        this.font = font;
        this.fontSize = fontSize ?? 15;
        this.boxImgPath = boxImgPath;
		this.boxPosition = boxPosition;
        this.textOffset = textOffset ?? new FlxPoint(0, 0);
        this.textColor = textColor;
        this.dialogueDataPath = dialogueDataPath ?? 'assets/data/dialogue/';
        this.dialogueImagePath = dialogueImagePath ?? 'assets/images/dialogue/';
        this.pressedAcceptFunction = pressedAcceptFunction ?? function():Bool{return(FlxG.keys.justPressed.ENTER);};
        this.pressedSkipFunction = pressedSkipFunction ?? function():Bool{return(FlxG.keys.pressed.CONTROL);};
        this.onComplete = onComplete;
        this.onLineAdvance = onLineAdvance;
    }
}