package ctDialogueBox.ctdb.data;

import ctDialogueBox.ctdb.data.*;
import flixel.FlxG;
import haxe.Json;
import openfl.Assets;

/**
 * a class that holds all the data from a dialogue json file.
 */
class DialogueFile
{
	/**
	 * the raw data from the json file
	 */
	var data:Dynamic;

	/**
	 * the list of data for each line of dialogue
	 */
	public var dialogueLines:Array<DialogueData> = [];

	/**
	 * the path for this dialogue file
	 */
	public var path:String;
	
	public function new(path:String)
	{
		this.path = path;
		
		if(!Assets.exists(path)){
			FlxG.log.warn('[CTDB] Can\'t find Dialogue File: "$path". Loading placeholder.');
			
			dialogueLines.push({
				dialogue: "Placeholder Dialogue. Check " + path + "?",
				actor: "",
				speed: 0.03,
				portrait: "",
				autoSkip: false,
				continueLine: false,
				diaPitch: 0,
				voiceLine: '',
				events: []
			});
			
			return;
		}
		
		data = Json.parse(Assets.getText(path));
		
		dialogueLines = data.map(function(item)
		{
			return {
				dialogue: item.dialogue ?? '',
				actor: item.actor ?? '',
				speed: item.speed ?? 0.03,
				portrait: item.portrait ?? '',
				autoSkip: item.autoSkip ?? false,
				continueLine: item.continueLine ?? false,
				diaPitch: item.diaPitch ?? 0.0,
				voiceLine: item.voiceLine ?? '',
				events: item.events ?? []
			};
		});
        //it works
	}
}