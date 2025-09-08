package ctDialogueBox.test;

import ctDialogueBox.*;
import ctDialogueBox.ctdb.*;
import flixel.FlxState;

class CtDialogueTestState extends FlxState
{
	override public function create()
	{
		super.create();
		
		var textbox = new CtDialogueBox({});
		add(textbox);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
