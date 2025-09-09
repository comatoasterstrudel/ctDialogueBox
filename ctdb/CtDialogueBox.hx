package ctDialogueBox.ctdb;

import ctDialogueBox.*;
import ctDialogueBox.textbox.*;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import sys.FileSystem;

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
    
    public function new(settings:CtDialogueBoxSettings):Void{
        super();
        
        dialogueBox = new FlxSprite();
        add(dialogueBox);
        
        if(settings.boxImgPath == null){ //create a white box, since no image was provided
            dialogueBox.makeGraphic(300, 100, FlxColor.WHITE);
        } else { //load desired image
            var boxPath:String = (settings.dialogueImagePath + settings.boxImgPath + '.png');
            
            if(FileSystem.exists(boxPath)){
                dialogueBox.loadGraphic(boxPath);                
			}
			else
			{
                FlxG.log.warn('[CTDB] Can\'t find Dialogue Box Image: $boxPath, loading default box.');
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
    }
}