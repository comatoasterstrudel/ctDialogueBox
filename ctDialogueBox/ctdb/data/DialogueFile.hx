package ctDialogueBox.ctdb.data;

/**
 * a class that holds all the data from a dialogue json file.
 */
class DialogueFile extends CtJsonLoader
{
	/**
	 * the list of data for each line of dialogue
	 */
	public var dialogueLines:Array<DialogueData> = [];

	/**
	 * the path for this dialogue file
	 */
	public var path:String;
	
	public function new(path:String = "n")
	{		
		this.path = path;
		
		super(path, null, true);

		if(data == null){
			if(path != "n") FlxG.log.warn('[CTDB] Can\'t find Dialogue File: "$path". Loading placeholder.');
			
			var ddata = getBlankDialogueData();
			ddata.dialogue = "Placeholder Dialogue. Check " + path + "?";
			dialogueLines.push(ddata);
			return;
		}
				
		loadFromData(data);
	}

	public static function getBlankDialogueData():DialogueData{
		return {
			dialogue: "",
			actor: "",
			speed: 0.03,
			portrait: "",
			autoSkip: false,
			continueLine: false,
			diaPitch: 1,
			voiceLine: '',
			events: [],
			choicerOptions: []
		}
	}

	public function loadFromText(txt:String):Void{
		loadFromData(Json.parse(txt));
				
        //it works
	}

	public function loadFromData(data:Dynamic):Void{		
		dialogueLines = data.map(function(item)
		{
			var choicerOptions:Array<ChoicerOptionData> = []; // my bad this is sort of jank
			
			if(item.choicerOptions != null){
				for(i in 0...item.choicerOptions.length){
					var choicerOption = item.choicerOptions[i];
					
					choicerOptions.push({
						text: choicerOption.text ?? "",
						continueDialogue: choicerOption.continueDialogue ?? false,
						dialogue: choicerOption.dialogue ?? [],
						tag: choicerOption.tag ?? ""
					});
				}
			}
			
			return {
				dialogue: item.dialogue ?? '',
				actor: item.actor ?? '',
				speed: item.speed ?? 0.03,
				portrait: item.portrait ?? '',
				autoSkip: item.autoSkip ?? false,
				continueLine: item.continueLine ?? false,
				diaPitch: item.diaPitch == null ? 1 : item.diaPitch,
				voiceLine: item.voiceLine ?? '',
				events: item.events ?? [],
				choicerOptions: choicerOptions,
			};
		});
	}

	public static function getListOfDialogue(?settings:CtDialogueBoxSettings):Array<String>{
        if(settings == null) settings = CtDialogueBox.defaultSettings;

        var list = CtUtil.findFilesInPath(settings.dialogueDataPath + 'content/', [".json"], true, true);
		return list;
    }
}