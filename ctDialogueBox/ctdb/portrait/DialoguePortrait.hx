package ctdb.portrait;

import ctDialogueBox.*;
import ctDialogueBox.ctdb.*;
import ctDialogueBox.ctdb.data.*;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import openfl.Assets;

/**
 * this is the class that holds dialogue portraits!! yayy
 */
class DialoguePortrait extends FlxSprite
{
    /**
     * the sprite for the actual box
     */
    var settings:CtDialogueBoxSettings;
    
    public function new(settings:CtDialogueBoxSettings){
        super();
        
        this.settings = settings;
        
        visible = false;
    }
    
    /**
     * call this to update the portrait displayed on this sprite!!
     * @param dialogueData the data for the current dialogue line
     * @param actorData the data for the current actor
     */
    public function updatePortrait(dialogueData:DialogueData, actorData:ActorData):Void{                
        if(dialogueData.portrait != '' && actorData.portraitPrefix != ''){
            var portraitPath:String = (settings.dialogueImagePath + 'dialoguePortraits/' + actorData.portraitPrefix + '_' + dialogueData.portrait + '.png');

            if(!Assets.exists(portraitPath)){
                visible = false;

                FlxG.log.warn('[CTDB] Can\'t find Dialogue Portrait: "$portraitPath".');
            } else {
                visible = true;
                loadGraphic(portraitPath);
                
                var offsets:FlxPoint;
                
                if(actorData.portraitRight){
                    offsets = settings.portraitOffsetRight;
                } else {
                    offsets = settings.portraitOffsetLeft;
                }
                
                screenCenter();
                setPosition(x + offsets.x, y + offsets.y);
            }
        } else {
            visible = false; 
        }
    }
}