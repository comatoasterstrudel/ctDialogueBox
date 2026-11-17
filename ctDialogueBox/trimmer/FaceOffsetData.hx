package trimmer;

class FaceOffsetData extends CtJsonLoader
{
    public var offset = FlxPoint.get();

    public function new(path:String, ?settings:CtDialogueBoxSettings):Void{
        if(settings == null) settings = CtDialogueBox.defaultSettings;

        super(path);

        offset.set(data.x, data.y);
    }

    public static function getAllFaceOffsets(?settings:CtDialogueBoxSettings):Array<String>
    {
        if(settings == null) settings = CtDialogueBox.defaultSettings;

        return CtUtil.findFilesInPath(settings.dialogueImagePath + "dialoguePortraits/layers/", ["_offsets.json"], true);
    }
}