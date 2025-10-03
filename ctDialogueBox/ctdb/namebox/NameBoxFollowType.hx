package ctDialogueBox.ctdb.namebox;

/**
 * an enum to dictate where the name box will appear relative to the current portrait
 */
enum NameBoxFollowType
{
    /**
     * the name box will appear on the same side as the current portrait
     */
    Match;
    
    /**
     * the name box will appear on the opposite side of the current portrait
     */
    Opposite;
    
    /**
     * the name box wont be affected by portrait position
     */
    None;
}