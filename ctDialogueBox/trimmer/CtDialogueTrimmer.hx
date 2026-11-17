package ctDialogueBox.trimmer;

#if debug
#if ctDialogueTrimmer

import openfl.display.PNGEncoderOptions;
import openfl.utils.ByteArray;
import sys.io.File;
import sys.FileSystem;

/**
 * This is a class that trims the empty spaces from faces and saving the offsets to a file..
 * this is mostly just a weird optimization thing i needed for spirit-intel
 */
class CtDialogueTrimmer
{
    /**
     *  @param folder the folder you want the faces + jsons outputted to
    **/
    public static function trimDialogueFaces(?faceText:String = "_face_", ?folder:String = "trim/", ?settings:CtDialogueBoxSettings):Void{
        if(settings == null) settings = CtDialogueBox.defaultSettings;

        var checkedFaces:Array<String> = [];
        var facesToTrim:Array<String> = [];

        trace("[CTDBTRIMMER] Queueing faces..");

        for(actor in ActorData.getListOfActors(settings)){
            var aData:ActorData = CtDialogueBox.registry.get(ActorData, actor);

            for(portrait in aData.layeredPortraits){ // GET FACES
                for(layer in portrait.layers){
                    if(layer.contains(faceText)){
                        if(checkedFaces.contains(layer)) continue;

                        trace("[CTDBTRIMMER] Added face \"" + layer + "\"");

                        checkedFaces.push(layer);

                        var path = settings.dialogueImagePath + 'dialoguePortraits/layers/' + layer + ".png";

                        facesToTrim.push(path);
                    } else {
                        continue;
                    }
                }
            }
        }

        for(face in facesToTrim){
            var offsetFileName = face.replace(".png", "_offsets.json");

            if(Assets.exists(offsetFileName)) continue; // this file was already trimmed before so lets skip it
                
            trace("[CTDBTRIMMER] Trimming face at \"" + face + "\"...");

            var base = new CtSprite().createFromImage(face);
            
            var sprite = new CtSprite().createColorBlock(Std.int(base.width), Std.int(base.height), 0x00BD7474, true);
            sprite.stamp(base, 0, 0);

            //find offset
            var offset:FlxPoint = FlxPoint.get();

            var stop:Bool = false;

            //find highest pixel
            for (y in 0...sprite.pixels.height)
            {
                if(stop) break;

                for (x in 0...sprite.pixels.width)
                {
                    var pixelColor:FlxColor = sprite.pixels.getPixel32(x, y);

                    if (pixelColor.alpha > 0) // this is a non transparent pixel
                    {
                        offset.y = y;
                        stop = true;
                        break;
                    }
                }
            }

            stop = false;

            // find leftmost pixel
            for (x in 0...sprite.pixels.width)
            {
                if(stop) break;

                for (y in 0...sprite.pixels.height)
                {
                    var pixelColor:FlxColor = sprite.pixels.getPixel32(x, y);

                    if (pixelColor.alpha > 0) // this is a non transparent pixel
                    {
                        offset.x = x;
                        stop = true;
                        break;
                    }
                }
            }

            //trim
            CtUtil.trimSprite(sprite);

            //create save folder
            FileSystem.createDirectory(folder);

            //save png
            var bitmapData = sprite.pixels;
            var pngBytes:ByteArray = bitmapData.encode(bitmapData.rect, new PNGEncoderOptions());
            
            File.saveBytes(folder + CtUtil.getStringPastCharacter(face, "/"), pngBytes);

            //save json
            var trimdata:TrimData = {x: Std.int(offset.x), y: Std.int(offset.y)};

            File.saveContent(folder + CtUtil.getStringPastCharacter(offsetFileName, "/"), Json.stringify(trimdata, null, "\t"));
        }

        trace("[CTDBTRIMMER] Finished trimming! Results are located at \"" + folder + "\"");
    }
}
#end
#end