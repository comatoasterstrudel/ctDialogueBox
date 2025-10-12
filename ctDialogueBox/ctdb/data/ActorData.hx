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
	 * the color that the portraits of this character will become. its white be default.
	 */
	public var portraitColor:FlxColor;
	
	/**
	 * the name of the text sound this character should play. if blank, wont play anything
	 */
	public var textSound:String = '';
	
	/**
	 * the suffix this character uses for their portraits. for example, if your portrait is called "coma_neutral", the suffix would be "coma". if blank, this character wont use portraits
	 */
	public var portraitPrefix:String = '';
	
	/**
	 * should the portraits for this character be on the right? if blank it will just stay true
	 */
	public var portraitRight:Bool = true;
	
	/**
	 * the path to this characters custom dialogue box sprite box sprite. if this is null itll default to the normal sprite
	 */
	public var customDialogueBoxImgPath:String;
	
	 /**
     * the color the text on the namebox should be for this character
     */
    public var nameBoxTextColor:FlxColor;
	
	/**
	 * the path to this characters custom name box sprite. if this is null they wont have one.
	 */
	public var customNameBoxImgPath:String;
	
	public function new(path:String){
		if(!Assets.exists(path)){
			if(!path.endsWith('actor_.json')) FlxG.log.warn('[CTDB] Can\'t find Actor File: "$path".');
            
            exists = false;
            
			return;
		}
        
		data = Json.parse(Assets.getText(path));

		name = data.name ?? '';
        vanityName = data.vanityName ?? '';
        textColor = (data.textColor == null) ? FlxColor.WHITE : FlxColor.fromRGB(data.textColor[0] ?? 255, data.textColor[1] ?? 255, data.textColor[2] ?? 255, 255);
		portraitColor = (data.portraitColor == null) ? FlxColor.WHITE : FlxColor.fromRGB(data.portraitColor[0] ?? 255, data.portraitColor[1] ?? 255, data.portraitColor[2] ?? 255, 255);
		textSound = data.textSound ?? '';
		portraitPrefix = data.portraitPrefix ?? '';
		portraitRight = data.portraitRight ?? true;
		customDialogueBoxImgPath = data.customDialogueBoxImgPath;
		nameBoxTextColor = data.nameBoxTextColor == null ? (0) : FlxColor.fromRGB(data.nameBoxTextColor[0] ?? 255, data.nameBoxTextColor[1] ?? 255, data.nameBoxTextColor[2] ?? 255, 255);
		customNameBoxImgPath = data.customNameBoxImgPath;
    }
}