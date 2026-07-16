package ctDialogueBox.textbox.effects;

import ctDialogueBox.textbox.Text;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween.FlxTweenType;
import flixel.tweens.FlxTween;

class ShakeEffect implements IEffect
{  
   public function new()
    {
    }

    /**
	 *  @param easingKind - Unused
     *  @param height - Bound between 0 and 255, converted into a max offset between 0 and 4px.
	 *  @param duration -Unused
     *  @param nthCharacter - Unused
     */
    public function reset(easingKind:Int, height:Int, speed:Int, nthCharacter:Int):Void
    {
        mappedShaking = height/255. * 4;
    }

    public function update(elapsed:Float):Void
    {
    }

    public function apply(text:Text):Void
    {
		text.offset.x = FlxG.random.float(-mappedShaking, mappedShaking);
		text.offset.y = FlxG.random.float(-mappedShaking, mappedShaking);
    }

    public function setActive(active:Bool):Void
    {
        this.active = active;
    }

    public function isActive():Bool
    {
        return active;
    }

	private var basePos:Array<Int> = []; // x, y
	private var mappedShaking:Float;
	private var active:Bool = false;
}