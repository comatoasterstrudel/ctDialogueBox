package ctDialogueBox.test;

import ctDialogueBox.*;
import ctDialogueBox.ctdb.*;
import flixel.FlxG;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class CtDialogueTestState extends FlxState
{	
	var menuOptions:Array<String> = ['Base Box', 'OCRPG Recreation', 'Text Effects', 'Actors', 'Test Default Settings Option', 'Text Field Width', 'Voice Lines', 'Text Sounds', 'Dialogue Portraits', 'Name Plate'];

	var texts:Array<FlxText> = [];

	var curSelected:Int = 0;

	var busy:Bool = false;
	
	override public function create()
	{
		trace(menuOptions);

		for (i in 0...menuOptions.length)
		{
			var text = new FlxText(10, 30 * i, 0, menuOptions[i], 20);
			text.ID = i;
			add(text);

			texts.push(text);
		}
		
		changeSelection();

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if(busy) return;
		
		if (FlxG.keys.justPressed.UP)
		{
			changeSelection(-1);
		}

		if (FlxG.keys.justPressed.DOWN)
		{
			changeSelection(1);
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			busy = true;
			
			new FlxTimer().start(0.1, function(tmr):Void{				
				switch(menuOptions[curSelected]){
					case 'Base Box':
						var textbox = new CtDialogueBox({
							onComplete: function():Void{
								new FlxTimer().start(0.1, function(tmr):Void{				
									busy = false; 
								});
							}
						});
						textbox.loadDialogueFiles(['dia_test']);
						textbox.openBox();
						add(textbox); 
					case 'OCRPG Recreation':
						var textbox = new CtDialogueBox({
							boxImgPath: "dialogueBox", 
							textColor: FlxColor.WHITE, 
							fontSize: 46, 
							font: 'assets/fonts/andy.ttf',
							textOffset: new FlxPoint(30, 30),
							onComplete: function():Void{
								new FlxTimer().start(0.1, function(tmr):Void{				
									busy = false; 
								});
							}
						});
						textbox.loadDialogueFiles(['dia_test']);
						textbox.openBox();
						add(textbox); 
					case 'Text Effects':
						var textbox = new CtDialogueBox({
							onComplete: function():Void{
								new FlxTimer().start(0.1, function(tmr):Void{				
									busy = false; 
								});
							}
						});
						textbox.loadDialogueFiles(['dia_effects']);
						textbox.openBox();
						add(textbox); 
					case 'Actors':
						var textbox = new CtDialogueBox({
							onComplete: function():Void{
								new FlxTimer().start(0.1, function(tmr):Void{				
									busy = false; 
								});
							}
						});
						textbox.loadDialogueFiles(['dia_actors']);
						textbox.openBox();
						add(textbox); 
					case 'Test Default Settings Option':
						CtDialogueBox.defaultSettings = {
							boxImgPath: "dialogueBox", 
							textColor: FlxColor.WHITE, 
							fontSize: 46, 
							font: 'assets/fonts/andy.ttf',
							textOffset: new FlxPoint(30, 30),
							onComplete: function():Void{
								new FlxTimer().start(0.1, function(tmr):Void{				
									busy = false; 
								});
							}
						};
						
						var textbox = new CtDialogueBox();
						textbox.loadDialogueFiles(['dia_test']);
						textbox.openBox();
						add(textbox); 
					case 'Text Field Width':
						var textbox = new CtDialogueBox({
							textFieldWidth: 100,
							onComplete: function():Void{
								new FlxTimer().start(0.1, function(tmr):Void{				
									busy = false; 
								});
							}
						});
						textbox.loadDialogueFiles(['dia_shortwrap']);
						textbox.openBox();
						add(textbox); 
					case 'Voice Lines':
						var textbox = new CtDialogueBox({
							onComplete: function():Void{
								new FlxTimer().start(0.1, function(tmr):Void{				
									busy = false; 
								});
							}
						});
						textbox.loadDialogueFiles(['dia_voiceline']);
						textbox.openBox();
						add(textbox); 
					case 'Text Sounds':
						var textbox = new CtDialogueBox({
							onComplete: function():Void{
								new FlxTimer().start(0.1, function(tmr):Void{				
									busy = false; 
								});
							}
						});
						textbox.loadDialogueFiles(['dia_textsnd']);
						textbox.openBox();
						add(textbox); 
					case 'Dialogue Portraits':
						var textbox = new CtDialogueBox({
							boxImgPath: "widebox", 
							nameBoxImgPath: "wideNameBox",
							nameBoxLeftEndImgPath: "wideNameBoxLeftEnd",
							nameBoxRightEndImgPath: "wideNameBoxRightEnd",
							textOffset: new FlxPoint(30, 30),
							boxPosition: new FlxPoint(0, 285),
							nameBoxFollowType: Match,
							portraitOnTopOfBox: false,
							onComplete: function():Void{
								new FlxTimer().start(0.1, function(tmr):Void{				
									busy = false; 
								});
							}
						});
						textbox.loadDialogueFiles(['dia_portraits']);
						textbox.openBox();
						add(textbox); 
					case 'Name Plate':
						var textbox = new CtDialogueBox({
							onComplete: function():Void{
								new FlxTimer().start(0.1, function(tmr):Void{				
									busy = false; 
								});
							}
						});
						textbox.loadDialogueFiles(['dia_nameplate']);
						textbox.openBox();
						add(textbox); 
				}
			});
		}
	}

	function changeSelection(amount:Int = 0):Void
	{
		curSelected += amount;

		if (curSelected < 0)
		{
			curSelected = menuOptions.length - 1;
		}
		if (curSelected > menuOptions.length - 1)
		{
			curSelected = 0;
		}

		for (i in texts)
		{
			if (curSelected == i.ID)
			{
				i.x = 30;
				i.alpha = 1;
			}
			else
			{
				i.x = 10;
				i.alpha = .4;
			}
		}
	}
}
