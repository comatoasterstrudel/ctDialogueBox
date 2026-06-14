package ctdb.choicer;

class Choicer extends FlxSpriteGroup
{
    public var playing:Bool = false;
    
    var menuManager:CtMenuManager;
    
    var textOptions:FlxSpriteGroup;
    
    var cursor:CtSprite;
    
    var curOptions:Array<ChoicerOptionData> = [];
    
    var onComplete:ChoicerOptionData->Void;
    
    var readyToFinish:Bool = false;
    var finished:Bool = false;
    var finishedOption:ChoicerOptionData;
    
    /**
     * the sprite for the actual box
     */
    var settings:CtDialogueBoxSettings;
    
    /**
     * the dialogue box that this name box is tied to
     */
    var dialogueBox:FlxSprite;
    
    public function new(settings:CtDialogueBoxSettings, dialogueBox:FlxSprite){
        super();
        
        this.settings = settings;
        this.dialogueBox = dialogueBox;
        
        textOptions = new FlxSpriteGroup();
        add(textOptions);
        
        menuManager = new CtMenuManager(settings.choicerPressedUpFunction, settings.choicerPressedDownFunction, settings.choicerPressedAcceptFunction);
        menuManager.disable();
        
        addCursor();
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);    
        
        if(!finished){
            if(readyToFinish){
                onComplete(finishedOption);
            } else {
                menuManager.update();
            }            
        }

    }
    
    public function openChoicer(choicerOptions:Array<ChoicerOptionData>, onComplete:ChoicerOptionData->Void):Void{
        curOptions = choicerOptions;
        readyToFinish = false;
        finished = false;      
        finishedOption = null;
        
        this.onComplete = function(choicerOption:ChoicerOptionData):Void{
            closeChoicer();
            onComplete(choicerOption);    
        };
        
        clearOptions();
        addOptions();
        
        menuManager.enable();
        visible = true;
        playing = true;
    }
    
    function closeChoicer():Void{  
        finished = true;      
        menuManager.disable();
        visible = false;
        playing = false;
    }
    
    function clearOptions():Void{
        var destroyThese:Array<FlxSprite> = [];
        
        for(text in textOptions){
            destroyThese.push(text);
        }
        
        for(text in destroyThese){
            textOptions.remove(text, true);
            text.destroy();
        }
        
        destroyThese = [];        
    }
    
    function addOptions():Void{
        var menuOptions:Array<Array<CtMenuOption>> = [[]];
                
        for(i in 0...curOptions.length){
            var choicerOption = curOptions[i];
            
            var text = new FlxText(0, 0, 0, choicerOption.text);
            text.setFormat(settings.choicerFont, settings.choicerFontSize, settings.choicerNonSelectedColor, settings.choicerPosition == Left ? LEFT : (settings.choicerPosition == Right ? RIGHT : (CENTER)));
            add(text);
            
            var cursorSpacing = (cursor == null ? 0 : (settings.choicerCursorSpacing + cursor.height));
            
            switch(settings.choicerPosition){
                case Left:
                    text.x = (dialogueBox.x) + cursorSpacing;
                case Center:
                    CtUtil.centerSpriteOnSprite(text, dialogueBox, true, false);
                case Right:
                    text.x = (dialogueBox.x + dialogueBox.width - text.width) - cursorSpacing;
            }
            
            text.setPosition((text.x) + settings.choicerOffset.x, (dialogueBox.y + (settings.choicerSpacing * i)) + settings.choicerOffset.y);
            
            menuOptions[0].push({sprite: text, hoverFunction: function(s):Void{
                s.color = settings.choicerSelectedColor;
                s.alpha = settings.choicerSelectedAlpha;
            }, nonHoverFunction: function(s):Void{
                s.color = settings.choicerNonSelectedColor;
                s.alpha = settings.choicerNonSelectedAlpha;
            }, clickFunction: function(s):Void{
                readyToFinish = true;
                finishedOption = choicerOption;
            }, cursorDirection: (settings.choicerPosition == Right ? RIGHT : LEFT)});
        }
        
        menuManager.setMenuOptions(menuOptions, true);
    }
    
    function addCursor():Void{
        if(settings.choicerCursorPath == ""){
            return;    
        }
        
        var cursorPath:String = (settings.dialogueImagePath + 'choicer/' + settings.choicerCursorPath + '.png');
        
        if(Assets.exists(cursorPath)){
            cursor = new CtSprite().createFromImage(cursorPath);
            add(cursor);
            
            menuManager.addCursor(cursor, settings.choicerCursorSpacing, false);
        } else {
            FlxG.log.warn('[CTDB] Can\'t find Choicer Cursor Image: "$cursorPath".');
        }
    }
} 