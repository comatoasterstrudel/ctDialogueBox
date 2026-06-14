package ctDialogueBox.ctdb.data;

/**
 * a typedef that holds all the data for a choicer option.
 */
typedef ChoicerOptionData =
{
    /**
     * The text to be displayed for this option
     */
    var text:String;
    
    /**
     * Should selecting this option let the dialogue continue as normal?
     */
    var continueDialogue:Bool;
    
    /**
     * The dialogues that will be loaded when this option is selected
     */
    var dialogue:Array<String>;
    
    /**
     * The tag associated with this option
     */
    var tag:String;
}