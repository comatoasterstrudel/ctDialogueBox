package ctDialogueBox.editor;

#if debug
#if ctDialogueEditor
import flixel.addons.text.FlxTextInput;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.FlxUICheckBox;
import lime.ui.FileDialog;
import sys.io.File;
import ctDialogueBox.editor.CtDialogueTester;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.geom.Point;
using StringTools;

class CtDialogueEditor extends FlxState
{
    var box = new CtDialogueBox();

    var bg:CtSprite;

    var diaText:FlxTextInput;
    var dialogueTopText:FlxText;
    var textBg:CtSprite;

    var button_loadFromJson:FlxButton;
    var button_export:FlxButton;
    var button_previous:FlxButton;
    var button_next:FlxButton;
    var button_new:FlxButton;
    var button_copy:FlxButton;
    var button_delete:FlxButton;
    var button_test:FlxButton;
    var button_testFromCurrentPos:FlxButton;

    var actorselector:FlxUIDropDownMenu;
    var actorText:FlxText;

    var portraitselector:FlxUIDropDownMenu;
    var portraitText:FlxText;
    var portraitBg:CtSprite;
    var portraitSprite:DialoguePortrait;

    var curLineText:FlxText;

    var dialogues:Array<DialogueData> = [];
    var curDialogue:Int = 0;

    var fileBg:CtSprite;
    var fileText:FlxText;

    var speedSelector:FlxUINumericStepper;
    var speedText:FlxText;

    var pitchSelector:FlxUINumericStepper;
    var pitchText:FlxText;

    var autoSkipBox:FlxUICheckBox;

    var continueLineBox:FlxUICheckBox;

    var voiceLineInput:FlxTextInput;
    var voiceLineText:FlxText;
    var voiceLineBg:CtSprite;

    public function new():Void{
        super();

        bg = new CtSprite().createColorBlock(820, FlxG.height, FlxColor.BLACK);
        bg.alpha = .4;
        add(bg);

        portraitBg = new CtSprite();
        add(portraitBg);

        portraitSprite = new DialoguePortrait(box.settings);
        add(portraitSprite);

        bgColor = FlxColor.GRAY;

        diaText = new FlxTextInput(35, 35, 400, "[Dialogue Text]", 20);
        diaText.fieldHeight = 400;

        textBg = new CtSprite(diaText.x, diaText.y).createColorBlock(Std.int(diaText.width), 400, FlxColor.BLACK);
        textBg.alpha = .3;
        add(textBg);

        add(diaText);

        dialogueTopText = new FlxText(diaText.x, 2, 0, "Dialogue", 16);
        add(dialogueTopText);

        fileBg = new CtSprite();
        add(fileBg);

        fileText = new FlxText(diaText.x, 2, 0, "File: [", 16);
        fileText.alignment = RIGHT;
        add(fileText);

        updateFileText();

        button_loadFromJson = new FlxButton(FlxG.width - 200, 35, "Load Json", loadDialogueJson);
        add(button_loadFromJson);

        button_loadFromJson = new FlxButton(FlxG.width - 200, 80, "Export Json", exportJson);
        add(button_loadFromJson);

        button_test = new FlxButton(FlxG.width - 200, 300, "Test", function():Void{
            test();
        });
        add(button_test);

        button_testFromCurrentPos = new FlxButton(FlxG.width - 200, 345, "Test from line", function():Void{
            test(curDialogue);
        });
        add(button_testFromCurrentPos);

        button_previous = new FlxButton(FlxG.width - 450, 35, "<---", function():Void{
            changeSelection(true, -1);
        });
        add(button_previous);

        button_next = new FlxButton(FlxG.width - 350, 35, "--->", function():Void{
            changeSelection(true, 1);
        });
        add(button_next);

        button_new = new FlxButton(button_previous.x, 80, "New Line", function():Void{
            changeSelection(true);
            dialogues.insert(curDialogue + 1, DialogueFile.getBlankDialogueData());
            changeSelection(false, 1);
        });
        add(button_new);

        button_delete = new FlxButton(button_next.x, 80, "Delete Line", function():Void{
            if(dialogues.length <= 1){
                return;
            }
            dialogues.remove(dialogues[curDialogue]);
            changeSelection(false, -1);
        });
        add(button_delete);

        button_new = new FlxButton(button_previous.x, 140, "Copy Line", function():Void{
            changeSelection(true);
            dialogues.insert(curDialogue + 1, Reflect.copy(dialogues[curDialogue]));
            changeSelection(false, 1);
        });
        add(button_new);

        curLineText = new FlxText(0,0,0,"0 / 0");
        curLineText.size = 30;
        curLineText.setPosition(button_new.x + button_new.width / 2 - curLineText.width / 2, button_new.y + 100);
        add(curLineText);

        var actorList = CtUtil.findFilesInPath(box.settings.dialogueDataPath + 'actors/', [".json"], false);

        var actors:Array<String> = [];

        actors.push("");

        for(actor in actorList){
            var real = actor;
            real = real.replace("actor_", "");
            real = real.replace(".json", "");
            actors.push(real);
        }

        actorselector = new FlxUIDropDownMenu(diaText.x + diaText.width + 10, 35, FlxUIDropDownMenu.makeStrIdLabelArray(actors), function(selectedId:String)
        {
            dialogues[curDialogue].actor = selectedId;
            updateAvailablePortraits();
        });
        add(actorselector);
        
        actorText = new FlxText(actorselector.x, 2, 0, "Actor", 16);
        add(actorText);

        portraitselector = new FlxUIDropDownMenu(actorselector.x + actorselector.width + 10, 35, FlxUIDropDownMenu.makeStrIdLabelArray(["", "haha"]), function(selectedId:String)
        {
            dialogues[curDialogue].portrait = selectedId;
            updatePortrait();
        });
        add(portraitselector);
        
        portraitText = new FlxText(portraitselector.x, 0, 0, "Portrait", 16);
        add(portraitText);

        speedSelector = new FlxUINumericStepper(diaText.x, diaText.y + diaText.height + 50, 0.002, 0.03, 0.0, 1.0, 3);
        add(speedSelector);

        speedText = new FlxText(speedSelector.x, speedSelector.y - 35, 0, "Speed", 16);
        add(speedText);

        pitchSelector = new FlxUINumericStepper(diaText.x + 100, diaText.y + diaText.height + 50, 0.1, 1, 0.1, 999, 1);
        add(pitchSelector);

        pitchText = new FlxText(pitchSelector.x, pitchSelector.y - 35, 0, "Sound Pitch", 16);
        add(pitchText);

        autoSkipBox = new FlxUICheckBox(diaText.x + 250, speedSelector.y, null, null, "Auto Skip");
        add(autoSkipBox);

        continueLineBox = new FlxUICheckBox(autoSkipBox.x, speedSelector.y + 50, null, null, "Continue Line");
        add(continueLineBox);

        voiceLineInput = new FlxTextInput(35, diaText.y + diaText.height + 200, 400, "[voice line]", 20);
        voiceLineInput.fieldHeight = 50;

        voiceLineBg = new CtSprite(voiceLineInput.x, voiceLineInput.y).createColorBlock(Std.int(voiceLineInput.width), 50, FlxColor.BLACK);
        voiceLineBg.alpha = .3;
        add(voiceLineBg);

        add(voiceLineInput);

        voiceLineText = new FlxText(voiceLineInput.x, voiceLineInput.y - 35, 0, "Voiceline", 16);
        add(voiceLineText);

        // done

        var data = DialogueFile.getBlankDialogueData();
        data.dialogue = "Welcome to the dialogue editor!";

        dialogues = [data];
        curDialogue = 0;
        changeSelection(); 
    }

    override function update(elapsed:Float):Void{
        super.update(elapsed);
    }

    function loadDialogueJson():Void{
        var fileDialog = new FileDialog();

        fileDialog.onSelect.add(function(path:String) {
            var fileBytes = sys.io.File.getBytes(path);

            var file = new DialogueFile();
            file.loadFromText(cast fileBytes);
            dialogues = file.dialogueLines;

            curDialogue = 0;
            changeSelection(); 

            for(i in 0...dialogues.length + 1){
                changeSelection(true, 1);
            }
            
            curDialogue = 0;
            changeSelection(); 

            updateFileText(path);
        });

        fileDialog.browse(lime.ui.FileDialogType.OPEN, "json", null, "Select a dialogue json");   
    }

    function changeSelection(?save:Bool = false, ?amount:Int = 0):Void{
        if(save){
            saveChanges();
        }

        curDialogue += amount;

        if(curDialogue > dialogues.length - 1){
            curDialogue = 0;
        } else if(curDialogue < 0){
            curDialogue = dialogues.length - 1;
        }

        updateWithDialogueData(dialogues[curDialogue]);

        curLineText.text = (curDialogue + 1) + " / " + dialogues.length;
    }

    function updateWithDialogueData(dialogueData:DialogueData):Void{
        diaText.text = dialogueData.dialogue;

        actorselector.selectedId = "";
        actorselector.selectedId = dialogueData.actor;

        updateAvailablePortraits();

        speedSelector.value = dialogueData.speed;

        pitchSelector.value = dialogueData.diaPitch;

        autoSkipBox.checked = dialogueData.autoSkip;
        
        continueLineBox.checked = dialogueData.continueLine;

        voiceLineInput.text = dialogueData.voiceLine;
    }

    function updateAvailablePortraits():Void{
        var portraits:Array<String> = [""];

        if(dialogues[curDialogue].actor != ""){
            var portraitList = CtUtil.findFilesInPath(box.settings.dialogueImagePath + 'dialoguePortraits/', [".png"], false);

            for(portrait in portraitList){
                var actordata = new ActorData(box.settings.dialogueDataPath + 'actors/actor_' + dialogues[curDialogue].actor + '.json');

                if(portrait.contains(actordata.portraitPrefix + "_") && actordata.portraitPrefix != "") {
                    var real = portrait;

                    real = real.replace(actordata.portraitPrefix + "_", "");
                    real = real.replace(".png", "");

                    portraits.push(real);
                }
            }
        }

        portraitselector.setData(FlxUIDropDownMenu.makeStrIdLabelArray(portraits));

        portraitselector.selectedId = "";
        portraitselector.selectedId = dialogues[curDialogue].portrait;

        dialogues[curDialogue].portrait = portraitselector.selectedId;

        updatePortrait();
    }

    function updatePortrait():Void{
        if(dialogues[curDialogue].portrait == ""){
            portraitSprite.kill();
            portraitBg.kill();
        } else {
            portraitSprite.revive();
            portraitBg.revive();

            var actordata = new ActorData(box.settings.dialogueDataPath + 'actors/actor_' + dialogues[curDialogue].actor + '.json');

            portraitSprite.updatePortrait(dialogues[curDialogue], actordata);
            trimSpr(portraitSprite);
            portraitSprite.setGraphicSize(350);
            portraitSprite.updateHitbox();
            portraitSprite.setPosition(bg.x + bg.width - portraitSprite.width - 20, FlxG.height - portraitSprite.height - 20);
            
            portraitBg.createColorBlock(Std.int(portraitSprite.width + 10), Std.int(portraitSprite.height + 10), FlxColor.WHITE);
            portraitBg.alpha = .5;
            
            CtUtil.centerSpriteOnSprite(portraitBg, portraitSprite, true, true);
        }
    }

    function trimSpr(sprite:FlxSprite):Void {
        var bmp:BitmapData = sprite.pixels;
        
        var bounds:Rectangle = bmp.getColorBoundsRect(0xFF000000, 0x00000000, false);
        
        if (bounds.width == 0 || bounds.height == 0) return;
        
        var trimmedBmp = new BitmapData(Std.int(bounds.width), Std.int(bounds.height), true, 0x00000000);
        
        trimmedBmp.copyPixels(bmp, bounds, new Point(0, 0));
        
        sprite.pixels = trimmedBmp;
        sprite.offset.set(bounds.x, bounds.y);
        sprite.updateHitbox();
    }

    function saveChanges():Void{
        if(dialogues[curDialogue] == null) return;

        dialogues[curDialogue].dialogue = diaText.text;
        dialogues[curDialogue].actor = actorselector.selectedId;
        dialogues[curDialogue].speed = speedSelector.value;
        dialogues[curDialogue].autoSkip = autoSkipBox.checked;
        dialogues[curDialogue].continueLine = continueLineBox.checked;
        dialogues[curDialogue].diaPitch = pitchSelector.value;
        dialogues[curDialogue].voiceLine = voiceLineInput.text;
    }

    function exportJson():Void{
        saveChanges();
        var data = Json.stringify(dialogues, null, "\t");

        var fileDialog = new FileDialog();

        fileDialog.onSelect.add(function(path:String) {
            File.saveContent(path, data);
            updateFileText(path);
        });

        fileDialog.browse(lime.ui.FileDialogType.SAVE, "json", null, "Select a dialogue json");   
    }

    function test(startingNum:Int = 0):Void{
        saveChanges();
        var file = new DialogueFile();
        file.loadFromText(Json.stringify(dialogues, null, "\t"));
        openSubState(new CtDialogueTester(file, startingNum));
    };

    function updateFileText(text:String = "\n?"):Void{
        fileText.scale.x = 1;
        fileText.text = "[[GRAY]]File:[[GRAY]]\n" + text;

        fileText.text = fileText.text.replace("\\", "\\" + "\n");

        while(fileText.height > FlxG.height / 2){
            fileText.scale.y -= 0.01;
            fileText.updateHitbox();
        }
        fileText.updateHitbox();

        fileText.x = FlxG.width - fileText.width - 5;
        fileText.y = FlxG.height - fileText.height - 5;

        fileText.applyMarkup(fileText.text, [
            new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.GRAY), "[[GRAY]]")
        ]);

        fileBg.createColorBlock(Std.int(fileText.width + 10), Std.int(fileText.height + 10), FlxColor.WHITE);
        fileBg.alpha = .5;
        fileBg.setPosition(fileText.x - 5, fileText.y - 5);
    }
}
#end
#end