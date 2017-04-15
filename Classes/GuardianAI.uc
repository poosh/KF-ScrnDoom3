Class GuardianAI extends Doom3Controller;

function FightEnemy(bool bCanCharge)
{
	if( Guardian(Pawn).NeedNewSeekers() )
		GoToState('RegenSeekers','Begin');
	else Super.FightEnemy(bCanCharge);
}

State RegenSeekers
{
Ignores DamageAttitudeTo,SeePlayer,HearNoise,SetEnemy,EnemyNotVisible;

	function EndState()
	{
		if( Pawn!=None && Pawn.Health>0 )
			Guardian(Pawn).EndRegen();
	}
Begin:
	MoveTo(Pawn.Location+VRand()*300.f);
	Guardian(Pawn).BeginRegen();
	Sleep(Guardian(Pawn).SeekerRegenTime);
	Guardian(Pawn).SpawnSeekers();
	Sleep(2.f);
	WhatToDoNext(25);
}

defaultproperties
{
}
