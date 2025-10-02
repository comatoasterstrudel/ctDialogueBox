package ctDialogueBox.ctdb.sound;

/**
 * an enum to show which type of sound this dialogue line is using
 */
enum CurrentSoundMode
{
    /**
     * the current line of dialogue wont play sound
     */
    None;
    
    /**
     * a sound will be played on every letter that gets typed, whether it be a single sound or multiple
     */
    TextSound;
    
    /**
     * a single sound will be played for the entirety of the dialogue line, mostly for voice lines
     */
    VoiceLine;
}