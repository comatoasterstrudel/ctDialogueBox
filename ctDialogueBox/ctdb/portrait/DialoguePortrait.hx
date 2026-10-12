package ctDialogueBox.ctdb.portrait;

/**
 * this is the class that holds dialogue portraits!! yayy
 */
class DialoguePortrait extends FlxSprite
{
    /**
     * the sprite for the actual box
     */
    var settings:CtDialogueBoxSettings;
    
    /**
     * if this portrait is on the right currently
     */
    public var curRight:Bool = false;
    
    /**
     * is this portrait on the box currently?
     */
    public var onScreen:Bool = false;
    
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
        var reposition:Bool = false;

        if(actorData.portraitList.contains(dialogueData.portrait)){
            var usedLayered:Bool = false;

            // check for layered portrait first
            for(layer in actorData.layeredPortraits){
                if(layer.name == dialogueData.portrait){
                    usedLayered = true;
                    applyLayeredPortrait(actorData, dialogueData.portrait);
                    break;
                }
            }

            // apply normal portrait
            if(!usedLayered){
                applyNormalPortrait(actorData, dialogueData.portrait);
            }

            color = actorData.portraitColor;
                
            var offsets:FlxPoint;
            
            if(actorData.portraitRight){
                offsets = settings.portraitOffsetRight;
                curRight = true;
            } else {
                offsets = settings.portraitOffsetLeft;
                curRight = false;
            }
            
            screenCenter();
            if(settings.positionPortraitFromBottom) y = (FlxG.height / 2) - (height);
            
            setPosition(x + offsets.x, (y + offsets.y));
            
            onScreen = true;
            visible = true;

            antialiasing = settings.antialiasing;
        } else {
            onScreen = false;
            visible = false;

            if(dialogueData.portrait != ""){
                FlxG.log.error('[CTDB] Can\'t find Dialogue Portrait: "${dialogueData.portrait}" on actor ${actorData.name}.');
            }
        }
    }

    function applyNormalPortrait(data:ActorData, portrait:String):Void{
        var portraitPath:String = (settings.dialogueImagePath + 'dialoguePortraits/' + data.portraitPrefix + '_' + portrait + '.png');

        loadGraphic(portraitPath);
        updateHitbox();
    }

    function applyLayeredPortrait(data:ActorData, portrait:String):Void{
        var prePath = (settings.dialogueImagePath + 'dialoguePortraits/layers/');

        var layeredPortrait:LayeredPortrait = null;

        // get layered portrait
        for(lPortrait in data.layeredPortraits){
            if(lPortrait.name == portrait) {
                layeredPortrait = lPortrait;
                break;
            }
        }

        var addedLayers:Int = 0;

        for(i in 0...layeredPortrait.layers.length){
            var fullPath = prePath + layeredPortrait.layers[i] + ".png";

            if(!Assets.exists(fullPath)){
                FlxG.log.error('[CTDB] Layered portrait layer "${layeredPortrait.layers[i]}" doesn\'t exist!! skipping.');
                continue;
            }

            if(addedLayers == 0){ // load a graphic fully as a base
                loadGraphic(fullPath);
            } else {
                stamp(new FlxSprite().loadGraphic(fullPath));
            }
            
            addedLayers ++;
        }

        if(addedLayers <= 0){
            FlxG.log.error('[CTDB] Layered portrait ' + layeredPortrait.name + " doesnt have any valid layers!!");
            makeGraphic(20, 20, FlxColor.PURPLE);
        }
    }
}