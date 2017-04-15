Class SabaothAI extends Doom3Controller;

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
	if( VSizeSquared(Enemy.Location-Pawn.Location)<160000.f && FRand()<0.2f )
		MoveTo(Normal(Pawn.Location-Enemy.Location)*500.f+VRand()*450.f+Pawn.Location,None);
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
