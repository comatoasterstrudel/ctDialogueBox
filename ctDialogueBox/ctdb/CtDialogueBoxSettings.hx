package ctDialogueBox.ctdb;

import ctDialogueBox.ctdb.data.*;
import ctDialogueBox.ctdb.namebox.*;
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
     * how long the text will go before wrapping to a new line. leaving this as 0 will set it to the width of the dialogue box.
     * eg: 200
     */
    public var textFieldWidth:Float;
    
    /**
     * how many vertical rows of text there can be. this is 4 by default
     * eg: 4
     */
    public var textRows:Int;
    
    /**
     * the offset for where the text will be located relative to the textbox.
     * eg: new FlxPoint(0, 0) 
     */
    public var textOffset:FlxPoint;
    
    /**
     * the color the text will become. this will be overwritten by actor colors.
     * eg: FlxColor.WHITE
     */
    public var textColor:FlxColor;
    
    /**
     * if this is true, dialogue portraits will be rendered on top of the dialogue box. 
     * default: true
     */
    public var portraitOnTopOfBox:Bool;
    
    /**
     * how much dialogue portraits will be offset while in the left position
     * default: 200 to the left, 200 down.
     */
    public var portraitOffsetLeft:FlxPoint;
    
    /**
     * how much dialogue portraits will be offset while in the right position
     * default: 200 to the right, 200 down.
     */
    public var portraitOffsetRight:FlxPoint;
    
    /**
     * the name of your name box image. if left null, will make a small white box.
     * eg: nameBox
     */
    public var nameBoxImgPath:String;
    
    /**
     * the name of your name box left end image. if left null, wont use any left end.
     * eg: nameBoxLeftEnd
     */
    public var nameBoxLeftEndImgPath:String;

     /**
     * the name of your name box right end image. if left null, wont use any left end.
     * eg: nameBoxRightEnd
     */
    public var nameBoxRightEndImgPath:String;

    /**
     * where the name box is located by default. 
     * default: Left
     */
    public var nameBoxPosition:NameBoxPosition;
    
    /**
     * should the name box match where the current portrait is?
     */
    public var nameBoxToPortraitPosition:Bool;
    
    /**
     * how big the namebox text should be
     * default: 25
     */
    public var nameBoxFontSize:Int;

    /**
     * The path to the font file you want to use on the namebox. if left null, will use HaxeFlixel default font.
     * eg: assets/font/andy.ttf
     */
    public var nameBoxFont:String;
    
    /**
     * the color the name text is. this will be overwritten by actor colors.
     * eg: FlxColor.WHITE
     */
    public var nameBoxTextColor:FlxColor;
    
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
     * the folder in your assets folder where your dialogue sounds are located
     * default: assets/sounds/dialogue/
     */
    public var dialogueSoundPath:String;
    
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
        textFieldWidth:Float = null,
        textRows:Int = null,
	    textOffset:FlxPoint = null,
        textColor:FlxColor = null,
        portraitOnTopOfBox:Bool = null,
        portraitOffsetLeft:FlxPoint = null,
	    portraitOffsetRight:FlxPoint = null,
        nameBoxImgPath:String = null,
        nameBoxLeftEndImgPath:String = null,
        nameBoxRightEndImgPath:String = null,
        nameBoxPosition:NameBoxPosition = null,
        nameBoxToPortraitPosition:Bool = null,
        nameBoxFontSize:Int = null,
        nameBoxFont:String = null,
        nameBoxTextColor:FlxColor = null,
        dialogueDataPath:String = null,
        dialogueImagePath:String = null,
        dialogueSoundPath:String = null,
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
        this.textFieldWidth = textFieldWidth ?? 0;
        this.textRows = textRows ?? 4;
        this.textOffset = textOffset ?? new FlxPoint(0, 0);
        this.textColor = textColor;
        this.portraitOnTopOfBox = portraitOnTopOfBox ?? true;
        this.portraitOffsetLeft = portraitOffsetLeft ?? new FlxPoint(-200, 200);
        this.portraitOffsetRight = portraitOffsetRight ?? new FlxPoint(200, 200);
        this.nameBoxImgPath = nameBoxImgPath;
        this.nameBoxLeftEndImgPath = nameBoxLeftEndImgPath;
        this.nameBoxRightEndImgPath = nameBoxRightEndImgPath;
        this.nameBoxPosition = nameBoxPosition ?? Left;
        this.nameBoxToPortraitPosition = nameBoxToPortraitPosition ?? false;
        this.nameBoxFontSize = nameBoxFontSize ?? 25;
        this.nameBoxFont = nameBoxFont;
        this.nameBoxTextColor = nameBoxTextColor;
        this.dialogueDataPath = dialogueDataPath ?? 'assets/data/dialogue/';
        this.dialogueImagePath = dialogueImagePath ?? 'assets/images/dialogue/';
        this.dialogueSoundPath = dialogueSoundPath ?? 'assets/sounds/dialogue/';
        this.pressedAcceptFunction = pressedAcceptFunction ?? function():Bool{return(FlxG.keys.justPressed.ENTER);};
        this.pressedSkipFunction = pressedSkipFunction ?? function():Bool{return(FlxG.keys.pressed.CONTROL);};
        this.onComplete = onComplete;
        this.onLineAdvance = onLineAdvance;
    }
}