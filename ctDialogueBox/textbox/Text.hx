package ctDialogueBox.textbox;

class Text extends FlxSprite {
    public var effects:Array<IEffect>;

    public var FieldWidth:Float = 0;
	public var text:String = '';
	public var size:Int = 46;
	public var embeddedFont:Bool = true;
    public var font:String = '';
     
    public var loopPercent:Float;
    public var loopTimer:Float = 0;
    public var loopOffset:Float = 0;

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
        this.angle = 0;
    }

    override function update(elapsed:Float):Void{
        loopTimer += (elapsed * 4);
        loopTimer = loopTimer % (Math.PI * 2);

        loopPercent = (Math.sin(loopTimer + loopOffset) + 1) / 2;

        updateEffects(elapsed);
    }
    
    public function loadLetter(textbox:Textbox, curIndex:Int):Void
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

        antialiasing = textbox.ctSettings.textAntialiasing;
				
        clear();

		resetLoop(curIndex);
	}

    public function resetLoop(index:Int):Void{   
        loopTimer = 0;

        loopOffset = index * .5;
    }

    function updateEffects(elapsed:Float):Void{
        for (effect in effects)
        {
            if (effect.isActive())
            {
                effect.update(elapsed);
                effect.apply(this);
            }
        }
    }

    function anyEffectsActive():Bool{
        var fff:Bool = false;

        for (effect in effects)
        {
            if (effect.isActive())
            {
                fff = true;
            }
        }

        return fff;
    }
}