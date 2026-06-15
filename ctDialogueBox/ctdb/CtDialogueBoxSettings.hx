package ctDialogueBox.ctdb;

import ctDialogueBox.ctdb.choicer.ChoicerPosition;

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
     * should the game preload the font youre using automatically? may stutter once you initially load your dialogue box if you use this method instead of preloading at the start of your program.
     */
    public var autoPreloadFont:Bool;
    
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
     * the field widht that will be used if you have a portrait on the left
     */
    public var portraitFieldWidthLeft:Float;
    
    /**
     * the field widht that will be used if you have a portrait on the right
     */
    public var portraitFieldWidthRight:Float;
        
    /**
     * the offset to the box that will be used if you have a portrait on the left
     */
    public var portraitBoxOffsetLeft:Float;
    
    /**
     * the offset to the box that will be used if you have a portrait on the right
     */
    public var portraitBoxOffsetRight:Float;
    
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
     * where the name box is located relative to the current portrait
     * default: none
     */
    public var nameBoxFollowType:NameBoxFollowType;
    
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
     * the offset to the box that will be used if you have the box on the left
     */
    public var nameBoxOffsetLeft:FlxPoint;
    
    /**
     * the offset to the box that will be used if you have the box on the right
     */
    public var nameBoxOffsetRight:FlxPoint;
    
    /**
     * the offset to the box that will be used if you have the box in the center
     */
    public var nameBoxOffsetCenter:FlxPoint;
    
    /**
     * the size of the font for the choicer
     */
    public var choicerFontSize:Int;
    
    /**
     * The font for the choicer
     */
    public var choicerFont:String;
    
    /**
     * Should the choice texts be on the Left, Right or Center of the dialogue box?
     */
    public var choicerPosition:ChoicerPosition;

    /**
     * How much you want to offset the choice texts by
     */
    public var choicerOffset:FlxPoint;
    
    /**
     * How much space you want between choice texts
     */
    public var choicerSpacing:Float;
    
    /**
     * How transparent a choicer text should be while selected
     */
    public var choicerSelectedAlpha:Float;
    
    /**
     * How transparent a choicer text should be while not selected
     */
    public var choicerNonSelectedAlpha:Float;
    
    /**
     * The color a choicer text should be while selected
     */
    public var choicerSelectedColor:FlxColor;
    
     /**
     * The color a choicer text should be while not selected
     */
    public var choicerNonSelectedColor:FlxColor;
        
    /**
     * path to the cursor you want to use for the choicer. if blank, wont use a cursor
     */
    public var choicerCursorPath:String;
    
    /**
     * How far you want the cursor to be from the text object
     */
    public var choicerCursorSpacing:Float;
    
    /**
     * a list of characters that wont play text sounds
     */
    public var excludedTextSoundCharacters:Array<String> = [];
    
    /**
     * how long the typing will pause for between sentences.
     */
    public var sentencePauseLength:Float;
    
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
     * this is the function to check if youve pressed the up button, or however you want to handle the choicer controls
     * default: FlxG.keys.justPressed.UP
     */
    public var choicerPressedUpFunction:Void->Bool;
    
    /**
     * this is the function to check if youve pressed the down button, or however you want to handle the choicer controls
     * default: FlxG.keys.justPressed.DOWN
     */
    public var choicerPressedDownFunction:Void->Bool;
    
    /**
     * this is the function to check if youve pressed the enter button, or however you want to handle the choicer controls
     * default: FlxG.keys.justPressed.ENTER
     */
    public var choicerPressedAcceptFunction:Void->Bool;
    
    public function new(
        font:String = null,
        fontSize:Int = null,
        autoPreloadFont:Bool = null,
        boxImgPath:String = null,
        boxPosition:FlxPoint = null,
        textFieldWidth:Float = null,
        textRows:Int = null,
	    textOffset:FlxPoint = null,
        textColor:FlxColor = null,
        portraitOnTopOfBox:Bool = null,
        portraitOffsetLeft:FlxPoint = null,
	    portraitOffsetRight:FlxPoint = null,
        portraitFieldWidthLeft:Float = null,
        portraitFieldWidthRight:Float = null,
        portraitBoxOffsetLeft:Float = null,
        portraitBoxOffsetRight:Float = null,
        nameBoxImgPath:String = null,
        nameBoxLeftEndImgPath:String = null,
        nameBoxRightEndImgPath:String = null,
        nameBoxPosition:NameBoxPosition = null,
        nameBoxFollowType:NameBoxFollowType = null,
        nameBoxFontSize:Int = null,
        nameBoxFont:String = null,
        nameBoxTextColor:FlxColor = null,
        nameBoxOffsetLeft:FlxPoint = null,
        nameBoxOffsetRight:FlxPoint = null,
        nameBoxOffsetCenter:FlxPoint = null,
        choicerFontSize:Int = null,
        choicerFont:String = null,
        choicerPosition:ChoicerPosition = null,
        choicerOffset:FlxPoint = null,
        choicerSpacing:Float = null,
        choicerSelectedAlpha:Float = null,
        choicerNonSelectedAlpha:Float = null,
        choicerSelectedColor:FlxColor = null,
        choicerNonSelectedColor:FlxColor = null,
        choicerCursorPath:String = null,
        choicerCursorSpacing:Float = null,
        excludedTextSoundCharacters:Array<String> = null,
        sentencePauseLength:Float = null,
        dialogueDataPath:String = null,
        dialogueImagePath:String = null,
        dialogueSoundPath:String = null,
        pressedAcceptFunction:Void->Bool = null,
        pressedSkipFunction:Void->Bool = null,
        choicerPressedUpFunction:Void->Bool = null,
        choicerPressedDownFunction:Void->Bool = null,
        choicerPressedAcceptFunction:Void->Bool = null,
    )
    {
        this.font = font ?? FlxAssets.FONT_DEFAULT;
        this.fontSize = fontSize ?? 15;
        this.autoPreloadFont = autoPreloadFont ?? false;
        this.boxImgPath = boxImgPath;
		this.boxPosition = boxPosition;
        this.textFieldWidth = textFieldWidth ?? 0;
        this.textRows = textRows ?? 4;
        this.textOffset = textOffset ?? new FlxPoint(0, 0);
        this.textColor = textColor;
        this.portraitOnTopOfBox = portraitOnTopOfBox ?? true;
        this.portraitOffsetLeft = portraitOffsetLeft ?? new FlxPoint(-200, 200);
        this.portraitOffsetRight = portraitOffsetRight ?? new FlxPoint(200, 200);
        this.portraitFieldWidthLeft = portraitFieldWidthLeft ?? textFieldWidth;
        this.portraitFieldWidthRight = portraitFieldWidthRight ?? textFieldWidth;
        this.portraitBoxOffsetLeft = portraitBoxOffsetLeft ?? 0;
        this.portraitBoxOffsetRight = portraitBoxOffsetRight ?? 0;
        this.nameBoxImgPath = nameBoxImgPath;
        this.nameBoxLeftEndImgPath = nameBoxLeftEndImgPath;
        this.nameBoxRightEndImgPath = nameBoxRightEndImgPath;
        this.nameBoxPosition = nameBoxPosition ?? Left;
        this.nameBoxFollowType = nameBoxFollowType ?? None;
        this.nameBoxFontSize = nameBoxFontSize ?? 25;
        this.nameBoxFont = nameBoxFont;
        this.nameBoxTextColor = nameBoxTextColor;
        this.nameBoxOffsetLeft = nameBoxOffsetLeft ?? new FlxPoint(0,0);
        this.nameBoxOffsetRight = nameBoxOffsetRight ?? new FlxPoint(0,0);
        this.nameBoxOffsetCenter = nameBoxOffsetCenter ?? new FlxPoint(0,0);
        this.choicerFontSize = choicerFontSize ?? 15;
        this.choicerFont = choicerFont ?? FlxAssets.FONT_DEFAULT;
        this.choicerPosition = choicerPosition ?? Left;
        this.choicerOffset = choicerOffset ?? new FlxPoint(0, 0);
        this.choicerSpacing = choicerSpacing ?? 50;
        this.choicerSelectedAlpha = choicerSelectedAlpha ?? 1;
        this.choicerNonSelectedAlpha = choicerNonSelectedAlpha ?? .5;
        this.choicerSelectedColor = choicerSelectedColor ?? FlxColor.BLACK;
        this.choicerNonSelectedColor = choicerNonSelectedColor ?? FlxColor.BLACK;
        this.choicerCursorPath = choicerCursorPath ?? "";
        this.choicerCursorSpacing = choicerCursorSpacing ?? 15;
        this.excludedTextSoundCharacters = excludedTextSoundCharacters ?? [];
        this.sentencePauseLength = sentencePauseLength ?? 0;
        this.dialogueDataPath = dialogueDataPath ?? 'assets/data/dialogue/';
        this.dialogueImagePath = dialogueImagePath ?? 'assets/images/dialogue/';
        this.dialogueSoundPath = dialogueSoundPath ?? 'assets/sounds/dialogue/';
        this.pressedAcceptFunction = pressedAcceptFunction ?? function():Bool{return(FlxG.keys.justPressed.ENTER);};
        this.pressedSkipFunction = pressedSkipFunction ?? function():Bool{return(FlxG.keys.pressed.CONTROL);};
        this.choicerPressedUpFunction = choicerPressedUpFunction ?? function():Bool{return(FlxG.keys.justPressed.UP);};
        this.choicerPressedDownFunction = choicerPressedDownFunction ?? function():Bool{return(FlxG.keys.justPressed.DOWN);};
        this.choicerPressedAcceptFunction = choicerPressedAcceptFunction ?? function():Bool{return(FlxG.keys.justPressed.ENTER);};
    }
}