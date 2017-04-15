Class SeekerAI extends Doom3Controller;

var bool bHasAwaked;

function ExecuteWhatToDoNext()
{
	if( !bHasAwaked )
	{
		bHasAwaked = true;
		GoToState('WakeUpMove');
	}
	else if( Seeker(Pawn).Mother==None )
		GoToState('DeathWander');
	else
	{
		Enemy = Seeker(Pawn).Mother.Controller.Enemy;
		Super.ExecuteWhatToDoNext();
	}
}

function bool FindNewEnemy()
{
	if ( Level.Game.bGameEnded || Seeker(Pawn).Mother==None || Seeker(Pawn).Mother.Controller==None || Enemy==Seeker(Pawn).Mother.Controller.Enemy )
		return false;
	Enemy = Seeker(Pawn).Mother.Controller.Enemy;
	return true;
}
state WakeUpMove
{
Ignores SeePlayer,HearNoise,DamageAttitudeTo,SetEnemy;

Begin:
	MoveTo(Pawn.Location+VRand()*300.f+vect(0,0,500),None);
	WhatToDoNext(18);
}
state DeathWander
{
Ignores SeePlayer,HearNoise,DamageAttitudeTo,SetEnemy;

Begin:
	MoveTo(Pawn.Location+VRand()*200.f,None);
	Pawn.Died(None,Class'Suicided',Pawn.Location);
}
state ZombieCharge
{
	function DamageAttitudeTo(Pawn Other, float Damage)
	{
		if( KFM.Intelligence>=BRAINS_Mammal && Other!=None && SetEnemy(Other) )
			GoToState(,'Backoff');
	}
	final function vector GetSeekPoint()
	{
		local vector P,HL,HN;

		P.X = 100.f*FRand()-50.f;
		P.Y = 100.f*FRand()-50.f;
		P = (Enemy.Location-Normal(P)*(400+FRand()*200.f)+vect(0,0,400));
		if( Pawn.Trace(HL,HN,P,Pawn.Location,false)!=None )
			P = HL+HN*10.f;
		return P;
	}
	final function vector GetBackOffPoint()
	{
		local vector P,HL,HN;

		P = Enemy.Location-Pawn.Location;
		P.Z = 0;
		P = (Enemy.Location-Normal(P)*(800+FRand()*500.f)+vect(0,0,500)+VRand()*300.f);
		if( Pawn.Trace(HL,HN,P,Pawn.Location,false)!=None )
			P = HL+HN*10.f;
		return P;
	}
	function EndState()
	{
		Pawn.AirSpeed = Pawn.Default.AirSpeed;
	}
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
	if( MoveTarget==Enemy )
	{
		MoveTo(GetSeekPoint(),Enemy);
		if( FRand()<0.35f )
		{
			Focus = Enemy;
			Pawn.Acceleration = vect(0,0,0);
			Pawn.Velocity = vect(0,0,0);
			Pawn.AirSpeed = 0.001f;
			Sleep(0.5f+FRand()*2.f);
			Pawn.AirSpeed = Pawn.Default.AirSpeed;
		}
	}
	else MoveToward(MoveTarget,FaceActor(1),,ShouldStrafeTo(MoveTarget));
	WhatToDoNext(17);
	if ( bSoaking )
		SoakStop("STUCK IN CHARGING!");
Backoff:
	Pawn.AirSpeed = Pawn.Default.AirSpeed;
	MoveTo(GetBackOffPoint(),None);
	WhatToDoNext(16);
	if ( bSoaking )
		SoakStop("STUCK IN CHARGING!");
}
state ZombieHunt
{
	function PickDestination()
	{
		local vector nextSpot, ViewSpot,Dir;
		local float posZ;
		local bool bCanSeeLastSeen;

		if ( (Enemy != None) && !KFM.bCannibal && (Enemy.Health <= 0) )
		{
			Enemy = None;
			WhatToDoNext(23);
			return;
		}

		if ( Pawn.JumpZ > 0 )
			Pawn.bCanJump = true;

		if( KFM.Intelligence==BRAINS_Retarded && FRand()<0.25 )
		{
			Destination = Pawn.Location+VRand()*200;
			Return;
		}
		if ( ActorReachable(Enemy) )
		{
			Destination = Enemy.Location;
			MoveTarget = None;
			return;
		}

		if( LineOfSightTo(Enemy) && DoomMonster(Pawn).ShouldTryRanged(Enemy) )
		{
			GoToState(,'DoRangeNow');
			return;
		}

		ViewSpot = Pawn.Location + Pawn.BaseEyeHeight * vect(0,0,1);
		bCanSeeLastSeen = bEnemyInfoValid && FastTrace(LastSeenPos, ViewSpot);

		if ( FindBestPathToward(Enemy, true,true) )
			return;

		if ( Seeker(Pawn).Mother!=None && FindBestPathToward(Seeker(Pawn).Mother, true,true) )
			return;

		if ( bSoaking && (Physics != PHYS_Falling) )
			SoakStop("COULDN'T FIND PATH TO ENEMY "$Enemy);

		MoveTarget = None;
		if ( !bEnemyInfoValid )
		{
			Enemy = None;
			GotoState('StakeOut');
			return;
		}

		Destination = LastSeeingPos;
		bEnemyInfoValid = false;
		if ( FastTrace(Enemy.Location, ViewSpot) && VSize(Pawn.Location - Destination) > Pawn.CollisionRadius )
            {
			SeePlayer(Enemy);
			return;
            }

		posZ = LastSeenPos.Z + Pawn.CollisionHeight - Enemy.CollisionHeight;
		nextSpot = LastSeenPos - Normal(Enemy.Velocity) * Pawn.CollisionRadius;
		nextSpot.Z = posZ;
		if ( FastTrace(nextSpot, ViewSpot) )
			Destination = nextSpot;
		else if ( bCanSeeLastSeen )
		{
			Dir = Pawn.Location - LastSeenPos;
			Dir.Z = 0;
			if ( VSize(Dir) < Pawn.CollisionRadius )
			{
				Destination = Pawn.Location+VRand()*500;
				return;
			}
			Destination = LastSeenPos;
		}
		else
		{
			Destination = LastSeenPos;
			if ( !FastTrace(LastSeenPos, ViewSpot) )
			{
				// check if could adjust and see it
				if ( PickWallAdjust(Normal(LastSeenPos - ViewSpot)) || FindViewSpot() )
				{
					if ( Pawn.Physics == PHYS_Falling )
						SetFall();
					else GotoState(,'AdjustFromWall');
				}
				else
				{
					Destination = Pawn.Location+VRand()*500;
					return;
				}
			}
		}
	}
}

state StakeOut
{
Begin:
	// If stuck, suicide.
	GoToState('DeathWander');
}

defaultproperties
{
}
