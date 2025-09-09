package ctDialogueBox.test;

import ctDialogueBox.*;
import ctDialogueBox.ctdb.*;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class CtDialogueTestState extends FlxState
{
	override public function create()
	{
		super.create();
		
		var textbox = new CtDialogueBox({
			boxImgPath: "dialogueBox", 
			textColor: FlxColor.WHITE, 
			fontSize: 46, 
			font: 'assets/fonts/andy.ttf',
			textOffset: new FlxPoint(30, 30)
		});
		add(textbox); 
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
