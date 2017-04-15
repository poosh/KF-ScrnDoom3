Class CyberDemonAI extends Doom3Controller;

state ZombieHunt
{
	function PickDestination()
	{
		local vector nextSpot, ViewSpot,Dir;
		local float posZ;
		local bool bCanSeeLastSeen;

		if( FindFreshBody() )
			Return;
		if ( Enemy==None || Enemy.Health<=0 )
		{
			Enemy = None;
			WhatToDoNext(23);
			return;
		}
		if( PathFindState==0 )
		{
			InitialPathGoal = FindRandomDest();
			PathFindState = 1;
		}
		if( PathFindState==1 )
		{
			if( InitialPathGoal==None )
				PathFindState = 2;
			else if( ActorReachable(InitialPathGoal) )
			{
				MoveTarget = InitialPathGoal;
				PathFindState = 2;
				Return;
			}
			else if( FindBestPathToward(InitialPathGoal, true,true) )
				Return;
			else PathFindState = 2;
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
			if( KFM.Intelligence==BRAINS_Retarded && FRand()<0.5 )
			{
				Destination+=VRand()*50;
				Return;
			}
			MoveTarget = None;
			return;
		}

		ViewSpot = Pawn.Location + Pawn.BaseEyeHeight * vect(0,0,1);
		bCanSeeLastSeen = bEnemyInfoValid && FastTrace(LastSeenPos, ViewSpot);

		if( LineOfSightTo(Enemy) && CyberDemon(Pawn).NextProjTime<Level.TimeSeconds )
		{
			GoToState(,'BlowEm');
			return;
		}

		if ( FindBestPathToward(Enemy, true,true) )
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
                    else
                        GotoState(, 'AdjustFromWall');
                }
                else
                {
                    Destination = Pawn.Location+VRand()*500;
                    return;
                }
            }
        }
    }
BlowEm:
	Focus = Enemy;
	Pawn.Acceleration = vect(0,0,0);
	FinishRotation();
	KFM.RangedAttack(Enemy);
	while( KFM.bShotAnim )
		Sleep(0.2f);
	PickDestination();
	WhatToDoNext(22);
	Stop;
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
	if( VSize(Enemy.Location-Pawn.Location)<400.f && FRand()<0.5f )
		MoveTo(Normal(Pawn.Location-Enemy.Location)*300.f+VRand()*150.f+Pawn.Location,None);
	if ( !FindBestPathToward(Enemy, false,true) )
	{
		if( LineOfSightTo(Enemy) && CyberDemon(Pawn).NextProjTime<Level.TimeSeconds )
			GotoState('ZombieHunt','BlowEm');
		else GotoState('TacticalMove');
	}
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
	WhatToDoNext(17);
	if ( bSoaking )
		SoakStop("STUCK IN CHARGING!");
}

defaultproperties
{
}
