package ctDialogueBox.ctdb.data;

import flixel.FlxG;
import flixel.util.FlxColor;
import haxe.Json;
import openfl.Assets;

using StringTools;

/**
 * data for the actors during dialogue.
 */
class ActorData
{
    /**
	 * the raw data from the json file
	 */
	var data:Dynamic;

    /**
     * if this is false, the actor will not exist! easy peasy!
     */
    public var exists:Bool = true;
    
	/**
	 * the name of the actor. if this is "" or the file isnt real, this actor will not exist.
	 */
	public var name:String = '';

    /**
	 * the displayed name of the actor. this appears on the name box
	 */
	public var vanityName:String = '';
    
    /**
     * the color the text should be for this character
     */
    public var textColor:FlxColor;
    
	/**
	 * the name of the text sound this character should play. if blank, wont play anything
	 */
	public var textSound:String = '';
	
	public function new(path:String){
		if(!Assets.exists(path)){
			if(!path.endsWith('actor_.json')) FlxG.log.warn('[CTDB] Can\'t find Actor File: "$path".');
            
            exists = false;
            
			return;
		}
        
		data = Json.parse(Assets.getText(path));

		name = data.name ?? '';
        vanityName = data.vanityName ?? '';
        textColor = FlxColor.fromRGB(data.textColor[0] ?? 255, data.textColor[1] ?? 255, data.textColor[2] ?? 255, 255);
		textSound = textSound ?? '';
    }
}