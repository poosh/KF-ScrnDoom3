Class WraithController extends Doom3Controller;

var transient float NextTeleTime,TotalTeleTime;

state ZombieHunt
{
AdjustFromWall:
	MoveTo(Destination, MoveTarget);

Begin:
	WaitForLanding();
	if ( CanSee(Enemy) )
		SeePlayer(Enemy);
WaitForAnim:
	if ( Monster(Pawn).bShotAnim )
	{
		Sleep(0.35);
		Goto('WaitForAnim');
	}
	PickDestination();

SpecialNavig:
	if( NextTeleTime<Level.TimeSeconds )
	{
		NextTeleTime = Level.TimeSeconds+5.f+FRand()*6.f;
		if( FRand()<0.3 )
			TotalTeleTime = Level.TimeSeconds+FRand()*5.f;
	}
	if ( TotalTeleTime>Level.TimeSeconds && NavigationPoint(MoveTarget)!=None && VSize(Enemy.Location-Pawn.Location)>Wraith(Pawn).TeleportRadius )
	{
		Wraith(Pawn).TeleportTo(MoveTarget.Location);
		Sleep(0.4f);
	}
	else if (MoveTarget == None)
		MoveTo(Destination);
	else
		MoveToward(MoveTarget,FaceActor(10),,(FRand() < 0.75) && ShouldStrafeTo(MoveTarget));

	WhatToDoNext(27);
	if ( bSoaking )
		SoakStop("STUCK IN HUNTING!");
}

defaultproperties
{
}
