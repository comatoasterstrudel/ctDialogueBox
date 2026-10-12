package ctDialogueBox.ctdb.data;

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
	 * the volume of the actors voice volume
	 */
	public var textSoundVolume:Float = 1;
	
	/**
	 * the suffix this character uses for their portraits. for example, if your portrait is called "coma_neutral", the suffix would be "coma". if blank, this character wont use portraits
	 */
	public var portraitPrefix:String = '';
	
	/**
	 * should the portraits for this character be on the right? if blank it will just stay true
	 */
	public var portraitRight:Bool = true;
	
	/**
	 * The info for layered portraits.
	 */
	public var layeredPortraits:Array<LayeredPortrait> = [];

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

	/**
	 * The color choicer texts will become when this actor is being used
	 */
	public var choicerSelectedTextColor:FlxColor;

	/**
	 * The color choicer texts will become when this actor is being used
	 */
	public var choicerUnselectedTextColor:FlxColor;

	/**
	 * list of all available portraits
	 */
	public var portraitList:Array<String> = [];

	public function new(path:String, settings:CtDialogueBoxSettings){
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
		textSoundVolume = data.textSoundVolume == null ? 1 : data.textSoundVolume;
		choicerSelectedTextColor = (data.choicerSelectedTextColor == null) ? FlxColor.WHITE : FlxColor.fromRGB(data.choicerSelectedTextColor[0] ?? 255, data.choicerSelectedTextColor[1] ?? 255, data.choicerSelectedTextColor[2] ?? 255, 255);
		choicerUnselectedTextColor = (data.choicerUnselectedTextColor == null) ? FlxColor.WHITE : FlxColor.fromRGB(data.choicerUnselectedTextColor[0] ?? 255, data.choicerUnselectedTextColor[1] ?? 255, data.choicerUnselectedTextColor[2] ?? 255, 255);

		if(data.layeredPortraits != null){
			layeredPortraits = data.layeredPortraits.map(function(item)
			{
				return {
					name: item.name,
					layers: item.layers
				};
			});
		}

		portraitList = getAllPortraits(this, settings);
    }

	public static function getAllPortraits(data:ActorData, settings:CtDialogueBoxSettings):Array<String>
	{
		var list:Array<String> = [];

		//first, add layered portraits
		for(layer in data.layeredPortraits){
			if(!list.contains(layer.name)){
				list.push(layer.name);
			}
		}

		//add normal portraits
		var portraitList = CtUtil.findFilesInPath(settings.dialogueImagePath + 'dialoguePortraits/', [".png"], false, false);

		for(portrait in portraitList){
			if(portrait.contains(data.portraitPrefix + "_") && data.portraitPrefix != "") {
				var real = portrait;

				real = real.replace(data.portraitPrefix + "_", "");
				real = real.replace(".png", "");

				if(!list.contains(real)) list.push(real);
			}
		}

		return list;
	}
}