package ctDialogueBox.textbox.effects;

import ctDialogueBox.textbox.Text;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween.FlxTweenType;
import flixel.tweens.FlxTween;

class WaveEffect implements IEffect
{

    public function new()
    {
    }

    /**
     *  @param easingKind - Bound between 0 and 2. Defaulting in linear if out bounds.
     *  @param height - Bound between 0 and 255, converted into a max offset between 0 and 30px.
     *  @param duration - Bound between 0 and 255, converted into a duration between 200ms and 5s.
     *  @param nthCharacter - Unused
     */
    public function reset(easingKind:Int, height:Int, speed:Int, nthCharacter:Int):Void
    {
        //
    }

    public function update(elapsed:Float):Void
    {
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

    private var tween:FlxTween;
    private var offsetY:Float;
    private var active:Bool = false;
}