Class SabaothAI extends DoomBossAI;

state ZombieCharge
{
Begin:
	if (Pawn.Physics == PHYS_Falling)
	{
		Focus = Enemy;
		Destination = Enemy.Location;
		WaitForLanding();
	}
	if ( Enemy == None )
		WhatToDoNext(16);
WaitForAnim:
	While( KFM.bShotAnim )
		Sleep(0.35);
	if( VSizeSquared(Enemy.Location-Pawn.Location)<160000.f
			&& (DoomMonster(Pawn).MaxMeleeAttacks <= 0 || frand() < 0.2f) )
	{
		MoveTo(Pawn.Location + 500.0*Normal(Pawn.Location-Enemy.Location) + 450.0*VRand(), none);
	}
	if ( !FindBestPathToward(Enemy, false,true) )
		GotoState('TacticalMove');
Moving:
	MoveToward(MoveTarget,FaceActor(1),,ShouldStrafeTo(MoveTarget));
	WhatToDoNext(17);
	if ( bSoaking )
		SoakStop("STUCK IN CHARGING!");
}

defaultproperties
{
}
