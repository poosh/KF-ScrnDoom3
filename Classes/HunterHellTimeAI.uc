Class HunterHellTimeAI extends Doom3Controller;

function FightEnemy(bool bCanCharge)
{
	if( KFM.bShotAnim )
	{
		GoToState('WaitForAnim');
		Return;
	}
	if ( Enemy == none || Enemy.Health <= 0 )
		FindNewEnemy();

	if ( (Enemy == FailedHuntEnemy) && (Level.TimeSeconds == FailedHuntTime) )
	{
		if ( Enemy == FailedHuntEnemy )
		{
			GoalString = "FAILED HUNT - HANG OUT";
			if ( EnemyVisible() )
				bCanCharge = false;
		}
	}
	if ( !EnemyVisible() )
	{
		GoalString = "Hunt";
		GotoState('ZombieHunt');
		return;
	}

	// see enemy - decide whether to charge it or strafe around/stand and fire
	Target = Enemy;
	GoalString = "Charge";
	PathFindState = 2;
	DoCharge();
}
function DoCharge()
{
	if(pawn != none)
		GotoState('ZombieCharge');
}
state ZombieCharge
{
	function BeginState()
	{
		Pawn.MaxDesiredSpeed = 0.01f;
	}
	function EndState()
	{
		SetMaxDesiredSpeed();
	}
Begin:
	Focus = Enemy;
	if ( Enemy == None )
		WhatToDoNext(16);
	Pawn.Acceleration = vect(0,0,0);
	Pawn.Velocity = vect(0,0,0);
	Timer();
WaitForAnim:
	While( KFM.bShotAnim )
		Sleep(0.35);
Moving:
	if( LineOfSightTo(Enemy) )
	{
		Focus = Enemy;
		Pawn.Acceleration = vect(0,0,0);
		Pawn.Velocity = vect(0,0,0);
		Sleep(1.f+FRand()*2.f);
	}
	WhatToDoNext(17);
	if ( bSoaking )
		SoakStop("STUCK IN CHARGING!");
}

defaultproperties
{
}
