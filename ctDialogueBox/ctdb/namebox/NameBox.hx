package ctDialogueBox.ctdb.namebox;

import ctDialogueBox.ctdb.data.*;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.Assets;

class NameBox extends FlxSpriteGroup
{
    /**
     * the sprite used for the actual name box
     */
    var nameBoxSpr:FlxSprite;
    
    /**
     * optional: the sprite for the left end of the name box
     */
    var nameBoxLeftEnd:FlxSprite;
    
    /**
     * optional: the sprite for the left end of the name box
     */
    var nameBoxRightEnd:FlxSprite;
    
    /**
     * the text that displays the characters name
     */
    var nameText:FlxText;
    
    /**
     * the sprite for the actual box
     */
    var settings:CtDialogueBoxSettings;
    
    var dialogueBox:FlxSprite;
    
    public function new(settings:CtDialogueBoxSettings, dialogueBox:FlxSprite){
        super();
        
        this.settings = settings;
        this.dialogueBox = dialogueBox;
        
        nameBoxSpr = new FlxSprite();
        add(nameBoxSpr);
        
        if(settings.nameBoxImgPath == null){ //make your own sprite for this..
            nameBoxSpr.makeGraphic(1, 40, FlxColor.WHITE);
        } else {
            var nameBoxPath:String = (settings.dialogueImagePath + 'nameBox/' + settings.nameBoxImgPath + '.png');

            if(Assets.exists(nameBoxPath)){
                nameBoxSpr.loadGraphic(nameBoxPath);                
			}
			else
			{
                FlxG.log.warn('[CTDB] Can\'t find Name Box Image: "$nameBoxPath", loading default name box.');
                nameBoxSpr.makeGraphic(1, 40, FlxColor.WHITE);
            }
        }
        
        if(settings.nameBoxLeftEndImgPath != null){
            var nameBoxLeftEndPath:String = (settings.dialogueImagePath + 'nameBox/' + settings.nameBoxLeftEndImgPath + '.png');

            if(Assets.exists(nameBoxLeftEndPath)){     
                nameBoxLeftEnd = new FlxSprite().loadGraphic(nameBoxLeftEndPath);
                add(nameBoxLeftEnd);          
			}
			else
			{
                FlxG.log.warn('[CTDB] Can\'t find Name Box Left End Image: "$nameBoxLeftEndPath".');
            }
        }
        
          if(settings.nameBoxRightEndImgPath != null){
            var nameBoxRightEndPath:String = (settings.dialogueImagePath + 'nameBox/' + settings.nameBoxRightEndImgPath + '.png');

            if(Assets.exists(nameBoxRightEndPath)){     
                nameBoxRightEnd = new FlxSprite().loadGraphic(nameBoxRightEndPath);
                add(nameBoxRightEnd);          
			}
			else
			{
                FlxG.log.warn('[CTDB] Can\'t find Name Box Left End Image: "$nameBoxRightEndPath".');
            }
        }
        
        nameText = new FlxText();
        nameText.setFormat(settings.nameBoxFont, settings.nameBoxFontSize, settings.nameBoxTextColor);
        add(nameText);
        
        visible = false;
    }
    
    /**
     * call this to update the namebox!!
     * @param actorData the actor that is currently speaking
     */
    public function updateName(actorData:ActorData):Void{
        if(actorData.exists && actorData.vanityName != ''){
            visible = true;

            nameText.text = actorData.vanityName;
            
            if(actorData.nameBoxTextColor == 0){
                nameText.color = settings.nameBoxTextColor ?? FlxColor.BLACK;
            } else {
                nameText.color = actorData.nameBoxTextColor;    
            }
            
            nameBoxSpr.setGraphicSize(nameText.width, nameBoxSpr.height);
            nameBoxSpr.updateHitbox();
            
            var position = settings.nameBoxPosition;
            
            switch(settings.nameBoxFollowType){
                case Match:
                    if(actorData.portraitRight){
                        position = Right;
                    } else if(!actorData.portraitRight){
                        position = Left;
                    }
                case Opposite:
                    if(actorData.portraitRight){
                        position = Left;
                    } else if(!actorData.portraitRight){
                        position = Right;
                    }
                case None:
                    //
            }
            
            nameBoxSpr.y = dialogueBox.y - nameBoxSpr.height;
            switch(position){
                case Left:
                    nameBoxSpr.x = dialogueBox.x;
                    if(nameBoxLeftEnd != null) nameBoxSpr.x += nameBoxLeftEnd.width;
                case Right:
                    nameBoxSpr.x = dialogueBox.x + dialogueBox.width - nameBoxSpr.width;
                    if(nameBoxRightEnd != null) nameBoxSpr.x -= nameBoxRightEnd.width;
                case Center:
                    nameBoxSpr.x = dialogueBox.x + dialogueBox.width / 2 - nameBoxSpr.width / 2;
            }
            
            alignSprites();            
        } else { //dont use the name box
            visible = false;
        }
    }
    
    /**
     * call this to make sure the ends line up with the real box
     */
    function alignSprites():Void{
        if(nameBoxLeftEnd != null) nameBoxLeftEnd.setPosition(nameBoxSpr.x - nameBoxLeftEnd.width, nameBoxSpr.y);
        if(nameBoxRightEnd != null) nameBoxRightEnd.setPosition(nameBoxSpr.x + nameBoxSpr.width, nameBoxSpr.y);
        nameText.setPosition(nameBoxSpr.x, nameBoxSpr.y + nameBoxSpr.height / 2 - nameText.height / 2);
    }
}