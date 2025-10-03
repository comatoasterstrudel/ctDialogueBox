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
     * are you currently using the normal name box or a custom one tied to an actor?
     */
    var usingCustomNameBoxSprite:Bool = false;
    
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
        
        nameBoxSpr = new FlxSprite();
        add(nameBoxSpr);
        
        loadNameBoxSprite();
        
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
        var useCustomNameBoxSprite:Bool = (actorData.exists && actorData.customNameBoxImgPath != null);
        var customNameBoxPath:String = (settings.dialogueImagePath + 'customNameBox/' + actorData.customNameBoxImgPath + '.png');
        
        if(useCustomNameBoxSprite && !Assets.exists(customNameBoxPath)){
            FlxG.log.warn('[CTDB] Can\'t find Custom Name Box Image: "$customNameBoxPath".');
            useCustomNameBoxSprite = false;
        }
        
        if(useCustomNameBoxSprite){
            usingCustomNameBoxSprite = true;
            nameBoxSpr.loadGraphic(customNameBoxPath);
            
            visible = true;
            nameText.visible = false;
            if(nameBoxLeftEnd != null) nameBoxLeftEnd.visible = false;
            if(nameBoxRightEnd != null) nameBoxRightEnd.visible = false;
            
           alignSprites(actorData);
        } else if(actorData.exists && actorData.vanityName != ''){
            if(usingCustomNameBoxSprite){
                loadNameBoxSprite();
                usingCustomNameBoxSprite = false;
            }
            
            visible = true;
            nameText.visible = true;
            if(nameBoxLeftEnd != null) nameBoxLeftEnd.visible = true;
            if(nameBoxRightEnd != null) nameBoxRightEnd.visible = true;
            
            nameText.text = actorData.vanityName;
            
            if(actorData.nameBoxTextColor == 0){
                nameText.color = settings.nameBoxTextColor ?? FlxColor.BLACK;
            } else {
                nameText.color = actorData.nameBoxTextColor;    
            }
            
            nameBoxSpr.setGraphicSize(nameText.width, nameBoxSpr.height);
            nameBoxSpr.updateHitbox();
            
            alignSprites(actorData);            
        } else { //dont use the name box
            visible = false;
        }
    }
    
    /**
     * call this to make sure the ends line up with the real box
     */
    function alignSprites(actorData:ActorData):Void{
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
                if(nameBoxLeftEnd != null && !usingCustomNameBoxSprite) nameBoxSpr.x += nameBoxLeftEnd.width;
            case Right:
                nameBoxSpr.x = dialogueBox.x + dialogueBox.width - nameBoxSpr.width;
                if(nameBoxRightEnd != null && !usingCustomNameBoxSprite) nameBoxSpr.x -= nameBoxRightEnd.width;
            case Center:
                nameBoxSpr.x = dialogueBox.x + dialogueBox.width / 2 - nameBoxSpr.width / 2;
        }
            
        if(nameBoxLeftEnd != null && !usingCustomNameBoxSprite) nameBoxLeftEnd.setPosition(nameBoxSpr.x - nameBoxLeftEnd.width, nameBoxSpr.y);
        if(nameBoxRightEnd != null && !usingCustomNameBoxSprite) nameBoxRightEnd.setPosition(nameBoxSpr.x + nameBoxSpr.width, nameBoxSpr.y);
        nameText.setPosition(nameBoxSpr.x, nameBoxSpr.y + nameBoxSpr.height / 2 - nameText.height / 2);
    }
    
    /**
     * call this to load the name box sprite
     */
    function loadNameBoxSprite():Void{
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
    }
}