package ctDialogueBox.ctdb.data;

/**
 * a typedef that holds all the data for a dialogue line.
 */
typedef DialogueData =
{
	/**
	 * the text that is displayed for this line
	 */
	var dialogue:String;

    /**
     * the actor to be used for this dialogue
     */
    var actor:String;
    
	/**
	 * the speed of the dialogue. in reality, its the delay between each letter.
	 */
	var speed:Float;

    /**
     * which sounds to load for the dialogue. you can also input a voice line name and itll load that
     */
    var diaSound:String;

    /**
     * the name of the character who this dialogue is for
     */
    var characterName:String;

    /**
     * the portrait this line uses. if its blank, itll use nothing
     */
    var portrait:String;

    /**
     * if this line should be skipped automatically
     */
    var autoSkip:Bool;
    
    /**
     * if this is true, it will simply add onto the last line
     */
    var continueLine:Bool;
    
    /**
     * if this isnt 0, sets the pitch of the dialogue sfx
     */
    var diaPitch:Float;
    
    /**
     * the name of the voice line that should be played on this line. if left blank it plays nothing
     */
    var voiceLine:String;
}