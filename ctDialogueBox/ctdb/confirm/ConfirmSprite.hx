package ctDialogueBox.ctdb.confirm;

class ConfirmSprite extends CtSprite
{
    var box:CtDialogueBox;
    
    var itsActive:Bool = false;

    public function new(box:CtDialogueBox):Void{
        super();

        this.box = box;

        if(box.settings.confirmImagePath != ""){
            itsActive = true;

            createFromImage(box.settings.dialogueImagePath + "confirm/" + box.settings.confirmImagePath + ".png");
        }

        visible = false;
    }

    public function updateSprite(status:Status){
        if(!itsActive) return;

        if(status == DONE && !box.choicer.playing){
            visible = true;
            setPosition(box.dialogueBox.x + box.dialogueBox.width - width - (box.settings.confirmOffset.x), box.dialogueBox.y + box.dialogueBox.height - height - (box.settings.confirmOffset.y));
        } else {
            visible = false;
        }
    }
}