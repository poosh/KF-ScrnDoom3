Class CacodemonAI extends Doom3Controller;

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
Moving:
	if( VSize(Enemy.Location-Pawn.Location)<300.f )
		MoveTo(Normal(Pawn.Location-Enemy.Location)*200.f+VRand()*50.f+Pawn.Location,None);
	else if( VSize(Enemy.Location-Pawn.Location)>1000.f )
		MoveTo(Normal(Enemy.Location-Pawn.Location)*200.f+VRand()*50.f+Pawn.Location,None);
	else MoveTo(VRand()*200.f+Pawn.Location,None);
	if( Enemy!=None && Cacodemon(Pawn).NextRangedTime<Level.TimeSeconds && LineOfSightTo(Enemy) )
	{
		Focus = Enemy;
		FinishRotation();
		KFM.RangedAttack(Enemy);
	}
	WhatToDoNext(17);
	if ( bSoaking )
		SoakStop("STUCK IN CHARGING!");
}

defaultproperties
{
}
