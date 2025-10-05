package ctDialogueBox.textbox;

import ctDialogueBox.ctdb.CtDialogueBox;
import ctDialogueBox.textbox.effects.IEffect;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;

class Text extends FlxSprite {
    public var effects:Array<IEffect>;

    public var FieldWidth:Float = 0;
	public var text:String = '';
	public var size:Int = 46;
	public var embeddedFont:Bool = true;
    public var font:String = '';
    
    public function new(X:Float = 0, Y:Float = 0, FieldWidth:Float = 0, ?text:String, Size:Int = 8, EmbeddedFont:Bool = true)
    {
        super();
        effects = []; 
        for (effect in TextEffectArray.effectClasses)
        {
            effects.push(Type.createInstance(effect, [])); 
        }
    }

    public function clear()
    {
        this.offset.set(0,0);
    }

    override public function update(elapsed:Float)
    {
        for (effect in effects)
        {
            if (effect.isActive())
            {
                effect.update(elapsed);
                effect.apply(this);
            }
        }
    }
    
    public function loadLetter(textbox:Textbox):Void
	{			
        var preloadPath:String = textbox.settings.font + '_' + textbox.settings.fontSize + '_' + text;
        
        if(CtDialogueBox.preloadedFonts.get(textbox.settings.font + '_' + textbox.settings.fontSize)){
			loadGraphic(FlxG.bitmap.get(preloadPath));
		} else {
			var testBitmapText = new FlxText();
			testBitmapText.fieldWidth = 0;
			testBitmapText.text = text;
			testBitmapText.setFormat(textbox.settings.font, textbox.settings.fontSize, textbox.settings.color, LEFT);
			testBitmapText.draw(); // regenerate its graphic
			
			loadGraphic(testBitmapText.pixels); 
            
            testBitmapText.destroy();
		}
				
		//updateHitbox();
        //trace('Loaded character: ' + text); 
	}
}