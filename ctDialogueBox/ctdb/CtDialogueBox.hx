package ctDialogueBox.ctdb;

import ctDialogueBox.*;
import ctDialogueBox.ctdb.data.*;
import ctDialogueBox.textbox.*;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import openfl.Assets;
using StringTools;

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
     * the settings used to customize this dialogue box
     */
    var settings:CtDialogueBoxSettings;
    
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
    
    public function new(settings:CtDialogueBoxSettings):Void{
        super();
        
        this.settings = settings;
                
        dialogueBox = new FlxSprite();
        add(dialogueBox);
        
        if(settings.boxImgPath == null){ //create a white box, since no image was provided
            dialogueBox.makeGraphic(300, 100, FlxColor.WHITE);
        } else { //load desired image
            var boxPath:String = (settings.dialogueImagePath + settings.boxImgPath + '.png');
            var cdb = boxPath.replace('assets/', 'ctDialogueBox/');
            
            if(Assets.exists(boxPath)){
                dialogueBox.loadGraphic(boxPath);                
			}
			else if(Assets.exists(cdb)){
                dialogueBox.loadGraphic(cdb);                
			}
			else
			{
                FlxG.log.warn('[CTDB] Can\'t find Dialogue Box Image: "$boxPath", loading default box.');
                dialogueBox.makeGraphic(800, 300, FlxColor.WHITE);
            }
        }
        
        if(settings.boxPosition == null){
            dialogueBox.screenCenter();            
        } else {
            dialogueBox.setPosition(settings.boxPosition.x, settings.boxPosition.y);
        }
        
		textbox = new Textbox(dialogueBox.x + settings.textOffset.x, dialogueBox.y + settings.textOffset.x, {
			color: settings.textColor ?? FlxColor.BLACK,
			font: settings.font,
            fontSize: settings.fontSize,
			textFieldWidth: dialogueBox.width
		});
        textbox.setText('testing testing 123');
        textbox.bring();
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
        //busy = true;  
        
        busy = false;
        playDialogue();
    }
    
    /**
     * call this to close the dialogue box and play its closing animation
     */
    public function closeBox():Void{
        busy = true;    
        
        if(settings.onComplete != null) settings.onComplete();
        
        destroy();
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
        
        //start typing!!
        textbox.bring();
        
        if(settings.onLineAdvance != null) settings.onLineAdvance(dialogueData);
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