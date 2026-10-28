package ctDialogueBox.textbox.effects;

import ctDialogueBox.textbox.Text;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween.FlxTweenType;
import flixel.tweens.FlxTween;

class WaveEffect implements IEffect
{
    private var active:Bool = false;

    public function new()
    {
        //
    }

    public function reset(easingKind:Int, height:Int, speed:Int, nthCharacter:Int):Void
    {
        //
    }

    public function update(elapsed:Float):Void
    {
        //
    }

    public function apply(text:Text):Void
    {
        var amount:Float = text.height * .45;

        text.offset.y = (amount * text.loopPercent) - amount / 2;
    }

    public function setActive(active:Bool):Void
    {
        this.active = active;
    }

    public function isActive():Bool
    {
        return active;
    }
}