package ctDialogueBox.editor;

#if debug
#if ctDialogueEditor
import flixel.FlxSubState;
import flixel.ui.FlxButton;

class CtDialogueTester extends FlxSubState
{
    var file:DialogueFile;

    var bg:CtSprite;
    var leave:FlxButton;

    var box:CtDialogueBox;

    public function new(file:DialogueFile, ?startingNum:Int = 0):Void{
        super();

        this.file = file;

        bg = new CtSprite().createColorBlock(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.alpha = .9;
        add(bg);

        box = new CtDialogueBox();
        box.addDialogueFileDirectly(file);
        add(box);

        box.onComplete.add(function():Void{
            close();
        });

        box.openBox();

        box.playDialogue();

        while(box.curLine < startingNum){
            box.advanceLine(1);
        }

        leave = new FlxButton(FlxG.width - 100, 30, "Leave", function():Void{
            close();
        });
        add(leave);   
    }
}
#end
#end