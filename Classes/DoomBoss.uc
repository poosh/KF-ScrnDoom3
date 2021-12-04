class DoomBoss extends DoomMonster;

var int OriginalScoringValue;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	if ( Role == ROLE_Authority ) {
		//increase bounty for defeating the boss with same scale as increasing its health.
		// Need to update default value too "because Tripwire"
		ScoringValue = OriginalScoringValue * (1.0 + PlayerCountHealthScale * fmax(Level.Game.NumPlayers - 1, 0));
		default.ScoringValue = ScoringValue;
	}
}

event bool EncroachingOn( actor Other )
{
	if ( Pawn(Other) != none )
		return false;
	return Super.EncroachingOn(Other);
}

defaultproperties
{
	ControllerClass=Class'ScrnDoom3KF.DoomBossAI'
	CrispUpThreshhold=1
	ZapThreshold=5
	PlayerCountHealthScale=0.75
	ScoringValue=750
	OriginalScoringValue=750
}
