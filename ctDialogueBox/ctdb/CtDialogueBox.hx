package ctDialogueBox.ctdb;

import ctDialogueBox.*;
import ctDialogueBox.ctdb.data.*;
import ctDialogueBox.ctdb.namebox.*;
import ctDialogueBox.ctdb.portrait.*;
import ctDialogueBox.ctdb.portrait.*;
import ctDialogueBox.ctdb.sound.*;
import ctDialogueBox.textbox.*;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.sound.FlxSound;
import flixel.util.FlxColor;
import openfl.Assets;

/**
 * this is the actual dialogue box object!! 9/8/25
 */
class CtDialogueBox extends FlxSpriteGroup{
    /**
     * the sprite for the actual box
     */
    var dialogueBox:FlxSprite;
    
    /**
     * This is the textbox object that actually displays the letters.
     */
    var textbox:Textbox;
    
    /**
     * the object that holds the dialogue portrait
     */
    var dialoguePortrait:DialoguePortrait;
    
    /**
     * the box that displays the name of the character speaking!!
     */
    var nameBox:NameBox;
    
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
     * the settings used to customize this dialogue box
     */
    public var settings:CtDialogueBoxSettings;
    
    /**
     * you can set these settings globally, and they will be applied when not passing arguments into CtDialogueBox!!
     */
    public static var defaultSettings:CtDialogueBoxSettings = null;
    
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

        if(settings.boxImgPath == null){ //create a white box, since no image was provided
            dialogueBox.makeGraphic(300, 100, FlxColor.WHITE);
        } else { //load desired image
            var boxPath:String = (settings.dialogueImagePath + 'dialogueBox/' + settings.boxImgPath + '.png');
            
            if(Assets.exists(boxPath)){
                dialogueBox.loadGraphic(boxPath);                
			}
			else
			{
                FlxG.log.warn('[CTDB] Can\'t find Dialogue Box Image: "$boxPath", loading default box.');
                dialogueBox.makeGraphic(300, 100, FlxColor.WHITE);
            }
        }
        
        dialogueBox.screenCenter();            

        if(settings.boxPosition != null){
            dialogueBox.setPosition(dialogueBox.x + settings.boxPosition.x, dialogueBox.y + settings.boxPosition.y);
        }
        
		textbox = new Textbox(dialogueBox.x + settings.textOffset.x, dialogueBox.y + settings.textOffset.y, {
			color: settings.textColor ?? FlxColor.BLACK,
			font: settings.font,
            fontSize: settings.fontSize,
			textFieldWidth: settings.textFieldWidth == 0 ? dialogueBox.width : settings.textFieldWidth,
            numLines: settings.textRows
		});
        add(textbox);
        
        antialiasing = true;
    }
    
    override function update(elapsed:Float):Void{
        super.update(elapsed);
        
        if(busy) return;
        
        if(settings.pressedAcceptFunction()){
            advanceLine(1);
        }
    }
    
    /**
     * call this to open the dialogue box and play its opening animation
     */
    public function openBox():Void{
        visible = true;
        
        busy = false;
        playDialogue();
    }
    
    /**
     * call this to close the dialogue box and play its closing animation
     */
    public function closeBox():Void{
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
        
        //set the text
        textbox.setText(dialogueData.dialogue);
        
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
        
        //update the name box
        nameBox.updateName(actorData);

        //start typing!!
        textbox.bring();
        
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
                }
                
                textbox.characterDisplayCallbacks = [];
                
                textbox.characterDisplayCallbacks.push(function(character:Text)
                {
                    if(currentSoundMode == TextSound){
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
}