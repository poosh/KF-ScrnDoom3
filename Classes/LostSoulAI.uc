Class LostSoulAI extends Doom3Controller;

var vector ChargeDir;

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
	if( Pawn!=None )
	{
		if( Enemy!=None && ActorReachable(Enemy) && !IsInState('ChargeIn') && LostSoul(Pawn).ReadyToCharge(Enemy) )
			GoToState('ChargeIn');
		else GotoState('ZombieCharge');
	}
}
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
	if ( !FindBestPathToward(Enemy, false,true) )
		GotoState('TacticalMove');
Moving:
	if( KFM.Intelligence==BRAINS_Retarded )
	{
		if( FRand()<0.3 )
			MoveTo(Pawn.Location+VRand()*200,None);
		else if( MoveTarget==Enemy && FRand()<0.5 )
			MoveTo(MoveTarget.Location+VRand()*50,None);
		else MoveToward(MoveTarget,FaceActor(1),,ShouldStrafeTo(MoveTarget));
	}
	else MoveToward(MoveTarget,FaceActor(1),,ShouldStrafeTo(MoveTarget));
	if( MoveTarget==Enemy )
	{
		Pawn.Acceleration = vect(0,0,0);
		KFM.RangedAttack(Enemy);
		While( KFM.bShotAnim )
			Sleep(0.35);
		MoveTo(Pawn.Location-Normal(Enemy.Location-Pawn.Location)*300.f+VRand()*150.f,Enemy);
	}
	WhatToDoNext(17);
	if ( bSoaking )
		SoakStop("STUCK IN CHARGING!");
}
state ChargeIn
{
Ignores Timer,NotifyBump,SeePlayer,HearNoise,DamageAttitudeTo,GetOutOfTheWayOfShot;

	function Tick( float Delta )
	{
		local Actor A;
		local vector HL,HN;

		A = Pawn.Trace(HL,HN,Pawn.Location+ChargeDir*20.f,Pawn.Location,true,Pawn.GetCollisionExtent());
		if( A!=None )
		{
			if( Pawn(A)!=None && LostSoul(A)==None )
				A.TakeDamage(LostSoul(Pawn).ChargeHitDamage,Pawn,Normal(Pawn.Location-A.Location)*A.CollisionRadius+A.Location,ChargeDir*80000.f,KFM.CurrentDamType);
			WhatToDoNext(19);
		}
	}
	function EndState()
	{
		if( Pawn!=None && Pawn.Health>0 )
		{
			LostSoul(Pawn).EndCharge();
			SetCombatTimer();
		}
	}
Begin:
	ChargeDir = Normal(Enemy.Location-Pawn.Location);
	MoveTo(Pawn.Location+ChargeDir*(VSize(Enemy.Location-Pawn.Location)+400.f));
	WhatToDoNext(18);
	if ( bSoaking )
		SoakStop("STUCK IN CHARGE MOVE!");
}

defaultproperties
{
}
