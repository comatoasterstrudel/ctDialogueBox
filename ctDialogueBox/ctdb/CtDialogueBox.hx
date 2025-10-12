package ctDialogueBox.ctdb;

import ctDialogueBox.*;
import ctDialogueBox.ctdb.box.*;
import ctDialogueBox.ctdb.data.*;
import ctDialogueBox.ctdb.namebox.*;
import ctDialogueBox.ctdb.portrait.*;
import ctDialogueBox.ctdb.portrait.*;
import ctDialogueBox.ctdb.sound.*;
import ctDialogueBox.textbox.*;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxSpriteGroup;
import flixel.sound.FlxSound;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.Assets;

/**
 * this is the actual dialogue box object!! 9/8/25
 */
class CtDialogueBox extends FlxSpriteGroup{
    /**
     * the sprite for the actual box
     */
    public var dialogueBox:FlxSprite;
    
    /**
     * This is the textbox object that actually displays the letters.
     */
    public var textbox:Textbox;
    
    /**
     * the object that holds the dialogue portrait
     */
    public var dialoguePortrait:DialoguePortrait;
    
    /**
     * the box that displays the name of the character speaking!!
     */
    public var nameBox:NameBox;
    
    /**
     * the array of the dialogue files to play here
     */
    var dialogueFiles:Array<DialogueFile> = [];
    
    /**
     * which dialogue file youre on. 
     */
    var curDialogueFile:Int = 0;
    
    /**
     * which line of the current dialogue file youre on
     */
    var curLine:Int = 0;
    
    /**
     * if this line is going to autoskip or not
     */
    var autoSkipping:Bool = false;
    
    /**
     * is this line continuing off of a previous line?
     */
    var continuing:Bool = false;
    
    /**
     * the text from the previous line.
     */
    var lastText:String = '';
    
    /**
     * the text for the line currently playing.
     */
    var currentText:String = '';
    
    /**
     * if this is true, you won't be able to advance dialogue
     */
    var busy:Bool = true;
    
    /**
     * the current type of sound this box should be playing on this line
     */
    var currentSoundMode:CurrentSoundMode;
    
    /**
     * the flxsound object for the voiceLine when used
     */
    var voiceLineSound:FlxSound;
    
    /**
     * the array of text sounds that can be played
     */
    var textSounds:Array<FlxSound> = [];
    
    /**
     * the last type of graphic the dialogue box used. this is saved so the box isnt reloading its graphic every line for no reason.
     */
    var lastCurDialogueBoxGraphicType:DialogueBoxGraphicType;

    /**
     * the current type of graphic the dialogue box is using. this is saved so the box isnt reloading its graphic every line for no reason.
     */
    var curDialogueBoxGraphicType:DialogueBoxGraphicType;
    
    /**
     * the last image path used. this is saved so the box isnt reloading its graphic every line for no reason.
     */
    var curDialogueBoxImgPath:String = '';
    
    /**
     * the settings used to customize this dialogue box
     */
    public var settings:CtDialogueBoxSettings;
    
    /**
     * you can set these settings globally, and they will be applied when not passing arguments into CtDialogueBox!!
     */
    public static var defaultSettings:CtDialogueBoxSettings = null;
    
    /**
     * is this dialogue box open now?
     */
    public var open:Bool = false;
    
    public function new(?settings:CtDialogueBoxSettings = null):Void{
        super();
        
        visible = false;

        if(defaultSettings != null && settings == null){
            settings = defaultSettings;    
        } else if(settings == null){
            settings = {};
        }
        
        this.settings = settings;
                
        dialogueBox = new FlxSprite();
        
        nameBox = new NameBox(settings, dialogueBox);
        
        dialoguePortrait = new DialoguePortrait(settings);
        if(!settings.portraitOnTopOfBox) add(dialoguePortrait);
        
        add(dialogueBox);
        add(nameBox);
        
        if(settings.portraitOnTopOfBox) add(dialoguePortrait);
                
        if(!preloadedFonts.get(settings.font + '_' + settings.fontSize)){
            if(settings.autoPreloadFont){
                preloadFont(settings.font, settings.fontSize);
            } else FlxG.log.warn('[CTDB] Your font and size combo (' + settings.font + '_' + settings.fontSize + ') isnt preloaded, which means your game may stutter while typing text. try using CtDialogueBox.preloadFont() or set autoPreloadFont to true while initializing your dialogue box.');  
        }
        
		textbox = new Textbox(0, 0, {
			color: settings.textColor ?? FlxColor.BLACK,
			font: settings.font,
            fontSize: settings.fontSize,
			textFieldWidth: settings.textFieldWidth == 0 ? dialogueBox.width : settings.textFieldWidth,
            numLines: settings.textRows
		}, settings);
        add(textbox);
        
        loadDialogueBoxGraphic();        
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        if(busy) return;
        
        if(autoSkipping){
            if(textbox.status != WRITING){
                advanceLine(1);
            }
            return;
        }
        
        if(settings.pressedAcceptFunction()){
            advanceLine(1);
        }
    }
    
    /**
     * call this to load the graphic for this dialogue box!! this is a function so that actors can have their own dialogue box images.
     * @param dialogueData the data for a dialogue line. can be null.
     * @param actorData the data for the current actor. can be null.
     */
    public function loadDialogueBoxGraphic(?dialogueData:DialogueData, ?actorData:ActorData):Void{
        lastCurDialogueBoxGraphicType = curDialogueBoxGraphicType;
        
        var useCustomBox:Bool = false;
        
        useCustomBox = (settings.boxImgPath != null || actorData != null && actorData.exists && actorData.customDialogueBoxImgPath != null);
        
        if(!useCustomBox){ //create a white box, since no image was provided
            curDialogueBoxGraphicType = Default;
            
            if(curDialogueBoxGraphicType == lastCurDialogueBoxGraphicType) {
                positionBox();      
                return;
            }
            
            dialogueBox.makeGraphic(300, 100, FlxColor.WHITE);
        } else { //load desired image
            var boxName:String = settings.boxImgPath;
            
            if(actorData != null && actorData.exists && actorData.customDialogueBoxImgPath != null){
                curDialogueBoxGraphicType = CustomActor;

                boxName = actorData.customDialogueBoxImgPath;               
            } else {
                curDialogueBoxGraphicType = Custom;

                boxName = settings.boxImgPath;
            }
                        
            var boxPath:String = (settings.dialogueImagePath + 'dialogueBox/' + boxName + '.png');
            
            if(curDialogueBoxGraphicType == lastCurDialogueBoxGraphicType && curDialogueBoxImgPath == boxPath) {
                positionBox();      
                return;
            }
            
            curDialogueBoxImgPath = boxPath;
            
            if(Assets.exists(boxPath)){
                dialogueBox.loadGraphic(boxPath);                
			}
			else
			{
                FlxG.log.warn('[CTDB] Can\'t find Dialogue Box Image: "$boxPath", loading default box.');
                dialogueBox.makeGraphic(300, 100, FlxColor.WHITE);
            }
        }
        
        positionBox();      
    }
    
    /**
     * call this to position the box and text properly
     */
    public function positionBox():Void{
         dialogueBox.screenCenter();            

        if(settings.boxPosition != null){
            dialogueBox.setPosition(dialogueBox.x + settings.boxPosition.x, dialogueBox.y + settings.boxPosition.y);
        }  
        
        if(textbox != null){
            textbox.x = dialogueBox.x + settings.textOffset.x;
            textbox.y = dialogueBox.y + settings.textOffset.y;
            textbox.settings.textFieldWidth = settings.textFieldWidth == 0 ? dialogueBox.width : settings.textFieldWidth;
        }   
    }
    
    /**
     * call this to open the dialogue box and play its opening animation
     */
    public function openBox():Void{
        curLine = 0;
        curDialogueFile = 0;
        
        open = true;
        
        visible = true;
        
        busy = false;
        playDialogue();
    }
    
    /**
     * call this to close the dialogue box and play its closing animation
     */
    public function closeBox():Void{
        open = false;

        busy = true;    
        
        clearSounds();
        
        if(settings.onComplete != null) settings.onComplete();
        
        visible = false;
    }
    
    /**
     * call this to start playing the dialogue
     */
    public function playDialogue():Void{
        if(dialogueFiles == null || dialogueFiles.length <= 0){
            FlxG.log.warn('[CTDB] There aren\'t any dialogue files loaded! Use loadDialogueFiles() first!');
            return;
        }
        
        advanceLine(0);
    }
    
    /**
     * call this to advance the dialogue box!!
     * @param amount the amount of lines to jump forward
     */
    function advanceLine(amount:Int):Void{
        if(amount > 0 && textbox.status == WRITING){
            textbox.skipLine();
            return;
        }
        
        curLine += amount;
        
        if(curLine >= dialogueFiles[curDialogueFile].dialogueLines.length){ //end of dialogue
            curDialogueFile ++;
            if(curDialogueFile >= dialogueFiles.length){ //end of files
                closeBox();
            } else {
                curLine = 0;
                advanceLine(0);
            }
            
            return;
        }        
        
        var dialogueData = dialogueFiles[curDialogueFile].dialogueLines[curLine];
        
        var jsonPath:String = (settings.dialogueDataPath + 'actors/actor_' + dialogueData.actor + '.json');
        var actorData = new ActorData(jsonPath);
        
        //set continuing before anything else
        continuing = dialogueData.continueLine;
        
        //set the correct dialogue box
        loadDialogueBoxGraphic(dialogueData, actorData);
        
        //set the text
        if(continuing){
            lastText = currentText;
            currentText = lastText + dialogueData.dialogue;
            
            textbox.prepareString(currentText);
        } else {
            lastText = currentText;
            currentText = dialogueData.dialogue;
            
            textbox.setText(currentText);            
        }
        
        //set the proper text speed
        textbox.settings.charactersPerSecond = (1 / dialogueData.speed);
        
        //set the proper text color
        var theColor:FlxColor = (actorData.exists ? actorData.textColor : settings.textColor);
        textbox.settings.color = theColor;
        
        //set the current sound mode
        if(dialogueData.voiceLine != ''){
            currentSoundMode = VoiceLine;
        } else if(actorData.exists && actorData.textSound != ''){
            currentSoundMode = TextSound;
        } else {
            currentSoundMode = None;
        }
        
        //clear the sound from the previous lines, then set the new sounds
        clearSounds();
        setSounds(dialogueData, actorData);
        
        //update the dialogue portrait
        dialoguePortrait.updatePortrait(dialogueData, actorData);
        
        //update the textbox position to account for portraits
        if(dialoguePortrait.onScreen){
            if(dialoguePortrait.curRight){
                textbox.x += settings.portraitBoxOffsetRight;
            } else {
                textbox.x += settings.portraitBoxOffsetLeft;
            }
        }
        
        //update the field width to account for portraits
        if(dialoguePortrait.onScreen){
            if(dialoguePortrait.curRight && settings.portraitFieldWidthRight != 0){
                textbox.settings.textFieldWidth = settings.portraitFieldWidthRight;
            } else if(settings.portraitFieldWidthLeft != 0){
                textbox.settings.textFieldWidth = settings.portraitFieldWidthLeft;
            }
        }
        
        //update the name box
        nameBox.updateName(actorData);

        // auto skip ?  ok
        autoSkipping = dialogueData.autoSkip;
        
        //start typing!!
        if(continuing){
            var previousLine:Int = textbox.currentLineIndex;
            var previousCharacter:Int = textbox.currentCharacterIndex;
            
            textbox.bring();            

            textbox.currentLineIndex = previousLine;
            textbox.currentCharacterIndex = previousCharacter;
        } else {
            textbox.lastWord = 'THISISNTAREALWORD';
            textbox.bring();            
        }
        
        // call advance function!!
        if(settings.onLineAdvance != null) settings.onLineAdvance(dialogueData);
        
        //call events!!
        if(settings.onEvent != null){
            for(i in dialogueData.events){
                settings.onEvent(i);
            }   
        }
    }
    
    /**
     * call this to clear the sounds used previously
     */
    function clearSounds():Void{
        if(voiceLineSound != null){
            voiceLineSound.stop();
            voiceLineSound.destroy();
            voiceLineSound = null;
        }
        for(i in textSounds){
            if(i != null){
                i.stop();
                i.destroy();
            }
        }
        textSounds = [];
    }
    
    /**
     * call this to set the sounds for this line!!
     */
    function setSounds(dialogueData:DialogueData, actorData:ActorData):Void{
        var sndExtension:String = #if desktop '.ogg'; #end #if html5 '.mp3'; #end
        
        switch(currentSoundMode){
            case VoiceLine:
                var sndPath:String = settings.dialogueSoundPath + 'voiceLines/' + dialogueData.voiceLine + sndExtension;
                
                if(Assets.exists(sndPath)){
                    voiceLineSound = new FlxSound().loadEmbedded(sndPath, false, true);
                    FlxG.sound.list.add(voiceLineSound);
                    voiceLineSound.play();
                    
                    if(dialogueData.diaPitch > 0) voiceLineSound.pitch = dialogueData.diaPitch;
                } else {
                    FlxG.log.warn('[CTDB] Can\'t find Voice Line: "$sndPath".');
                    currentSoundMode = None;
                }
            case TextSound:                                
                var sndPath:String = settings.dialogueSoundPath + 'textSounds/' + actorData.textSound;

                if (Assets.exists(sndPath + '1' + sndExtension)){ //multiple sounds
                    var counter:Int = 1;
                    
                    while(Assets.exists(sndPath + Std.string(counter) + sndExtension)){
                        textSounds.push(FlxG.sound.load(sndPath + Std.string(counter) + sndExtension, 1));
                        counter++;
                    }			
                } else if (Assets.exists(sndPath + sndExtension)){
                    textSounds.push(FlxG.sound.load(sndPath + sndExtension, 1));
                }
                
                if(textSounds.length < 1){
                    FlxG.log.warn('[CTDB] Can\'t find Text Sounds: "' + (sndPath + sndExtension) + '".');
                    currentSoundMode = None;
                } else {
                    if(dialogueData.diaPitch > 0) {
                        for(textSnd in textSounds){
                            textSnd.pitch = dialogueData.diaPitch;                            
                        }
                    }
                }
                
                textbox.characterDisplayCallbacks = [];
                
                textbox.characterDisplayCallbacks.push(function(character:Text)
                {
                    if(currentSoundMode == TextSound && !settings.excludedTextSoundCharacters.contains(character.text)){
                        for(i in textSounds){
                            if(i.playing) i.stop();
                        }
                        FlxG.random.getObject(textSounds).play(true);                        
                    }
                });
            case None:
                // do nothing
        }
    }
    
    /**
     * call this to load which json files to play on this dialogue box.
     * @param dialogueNames the names of the json files to play. eg: ['dia_one', 'subfolder/dia_two']
     */
    public function loadDialogueFiles(dialogueNames:Array<String>):Void{
        dialogueFiles = [];
        
        for(i in dialogueNames){
            var jsonPath:String = (settings.dialogueDataPath + 'content/' + i + '.json');
            
            var data = new DialogueFile(jsonPath);
            if(data.dialogueLines == null) continue;
            dialogueFiles.push(data);
        }
    }
    
    /**
     * the list of fonts that have been preloaded
     */
    public static var preloadedFonts:Map<String, Bool> = [];
    
    /**
     * call this to preload the letters of a font. if you dont, your program might stutter when loading long dialogues. sorry this system is really jank D:
     * this is recommended to be called at the start of your program
     * @param font the path to your font
     * @param size the size of your font 
     */
    public static function preloadFont(font:String = null, size:Int = 15):Void{
        if(font == null) font = FlxAssets.FONT_DEFAULT; else {
           if(!Assets.exists(font) && font != FlxAssets.FONT_DEFAULT && font != FlxAssets.FONT_DEBUGGER){
                FlxG.log.warn('[CTDB] Can\'t find Font file: "$font".');
                return;
            }    
        }
        
        if(preloadedFonts.get(font + '_' + size)){
            FlxG.log.warn('[CTDB] Already preloaded font: "' + font + '_' + size + '".');
            return;
        }
        
        for (i in [
			" ", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b",
			"c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "!", "@", "#", "$", "%",
			"^", "&", "*", "(", ")", "-", "_", "=", "+", "[", "]", "{", "}", ";", ":", "'", "\"", ",", ".", "<", ">", "/", "?", "`", "~", "0", "1", "2",
			"3", "4", "5", "6", "7", "8", "9"
		])
		{
			var testBitmapText = new FlxText();
			testBitmapText.fieldWidth = 0;
			testBitmapText.text = i;
			testBitmapText.setFormat(font, size, FlxColor.WHITE, LEFT);
			testBitmapText.draw(); // regenerate its graphic

			var graphic:FlxGraphic = FlxGraphic.fromBitmapData(testBitmapText.pixels, true, font + '_' + size + '_' + i, true);
			graphic.persist = true;
		}
        
        preloadedFonts.set(font + '_' + size, true);
    }
}