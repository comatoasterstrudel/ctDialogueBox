package ctDialogueBox.textbox;

class Text extends FlxSprite {
    public var effects:Array<IEffect>;

    public var FieldWidth:Float = 0;
	public var text:String = '';
	public var size:Int = 46;
	public var embeddedFont:Bool = true;
    public var font:String = '';
     
    public var loopingTween:FlxTween;
    public var loopPercent:Float;
    
    public function new(X:Float = 0, Y:Float = 0, FieldWidth:Float = 0, ?text:String, Size:Int = 8, EmbeddedFont:Bool = true)
    {
        super();
        effects = []; 
        for (effect in TextEffectArray.effectClasses)
        {
            effects.push(Type.createInstance(effect, [])); 
        } 

        startLoop();
    }

    public function clear()
    {
        this.offset.set(0,0);
        this.angle = 0;
    }

    override public function update(elapsed:Float)
    {
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

    public function startLoop():Void{
        loopingTween = FlxTween.num(0, 1, .5, {ease: FlxEase.smootherStepInOut, type: PINGPONG}, function(amount):Void{
            loopPercent = FlxMath.roundDecimal(amount, 2);
        });
    }

    public function resetLoop(index:Int):Void{
        startLoop();
        
        var deleteme:Int = index;

        var fakePercent:Int = 0;

        var truePercent:Float = 0;

        var reversing:Bool = false;

        while(deleteme > 0){
            fakePercent += (reversing ? -1 : 1);
            if(fakePercent >= 10) reversing = true; else if(fakePercent <= 0) reversing = false;
            deleteme -= 1;
        }

        truePercent = fakePercent / 10;

        //trace("TEXT: " + text + " INDEX: " + index + " PERCENT: " + truePercent);

        loopingTween.percent = truePercent;
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

    override function destroy():Void{
        if(loopingTween != null){
            loopingTween.cancel();
            loopingTween.destroy();
        }

        super.destroy();
    }
}