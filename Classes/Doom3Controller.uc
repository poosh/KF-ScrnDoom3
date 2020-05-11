Class Doom3Controller extends KFMonsterController;

var transient float ValidKillTime,NextTeleTimeOnStakeOut,NextTeleTimeOnHunt,LastTeleportTime;
var transient int TeleCount;
var transient bool bRateTeleportDest;
var NavigationPoint LastTeleportedTo;
var vector TeleDest;
var bool bInitKill, bTeleValid, bSleepOnTele;
var int TeleDelayCount;
var byte NoneSightCount;
var Actor RandStakeMoveGoal;

var VolumeColTester Tst;

struct TeleportDestination {
	var NavigationPoint Point;
	var float Rating; // higher rating = higher chance to teleport to this destination

};
var transient array<TeleportDestination> TeleportDestinations; // should be used statically (default.TeleportDestinations)
var transient array<NavigationPoint> BestTeleportPoints; // should be used statically (default.TeleportDestinations)
var transient float BestDestRatio; // if TeleportDestination.Rating >= BestDestRatio, it will be added to BestTeleportPoints
var transient float GlobalNextTeleportTime;

function BeginPlay()
{
	Super.BeginPlay();
}

static function InitTeleportPoints(LevelInfo Level)
{
	local int i;
	local NavigationPoint N;

	for( N=Level.NavigationPointList; N!=None; N=N.NextNavigationPoint )
		++i;

	default.TeleportDestinations.Length = i;

	i = 0;
	for( N=Level.NavigationPointList; N!=None; N=N.NextNavigationPoint ) {
		default.TeleportDestinations[i].Point = N;
		default.TeleportDestinations[i].Rating = 0.5;

		++i;
	}
}

static function BadTeleportDest(NavigationPoint P)
{
	local int i;

	for ( i=0; i < default.TeleportDestinations.Length; ++i ) {
		if ( default.TeleportDestinations[i].Point == P ) {
			default.TeleportDestinations.remove(i, 1);
			return;
		}
	}
}

static function AddToBest(NavigationPoint P)
{
	default.BestTeleportPoints[default.BestTeleportPoints.length] = P;
}
static function RemoveFromBest(NavigationPoint P)
{
	local int i;

	for ( i=0; i < default.BestTeleportPoints.Length; ++i ) {
		if (default.BestTeleportPoints[i] == P) {
				default.BestTeleportPoints.remove(i,1);
				return;
		}
	}
}

static function IncTeleportDestRaiting(NavigationPoint P, float inc)
{
	local int i;
	local float NewRating;

	for ( i=0; i < default.TeleportDestinations.Length; ++i ) {
		if ( default.TeleportDestinations[i].Point == P ) {
			NewRating = default.TeleportDestinations[i].Rating + inc;
			if ( NewRating >= default.BestDestRatio && default.TeleportDestinations[i].Rating < default.BestDestRatio ) {
				AddToBest(P);
			}
			else if ( NewRating < default.BestDestRatio && default.TeleportDestinations[i].Rating >= default.BestDestRatio ) {
				RemoveFromBest(P);
			}
			default.TeleportDestinations[i].Rating = NewRating;
			return;
		}
	}
}

function IncLastTeleportDestRaiting(float inc, optional bool bContinueRating)
{
	if ( bRateTeleportDest && inc != 0 ) {
		IncTeleportDestRaiting(LastTeleportedTo, inc);
		bRateTeleportDest = bContinueRating;
	}
}


// Get rid of this Zed if he's stuck somewhere and noone has seen him
function bool CanKillMeYet()
{
	local Controller C;
    local bool bBoss;

    bBoss = DoomMonster(KFM) != none && DoomMonster(KFM).bIsBossSpawn;

	if( !bInitKill )
	{
		bInitKill = true;
        //beta 9 - give more time before killing bosses
        if ( bBoss )
            ValidKillTime = Level.TimeSeconds+600; // 10 minutes
        else if ( KFM.default.Health >= 1000 )
            ValidKillTime = Level.TimeSeconds+60;
        else
            ValidKillTime = Level.TimeSeconds+20; //kill small stuff earlier

		NextTeleTimeOnStakeOut = Level.TimeSeconds+FRand()*5.f;
		NextTeleTimeOnHunt = Level.TimeSeconds+FRand()*10.f;
		return false;
	}

	for( C=Level.ControllerList; C!=None; C=C.nextController )
	{
		if( C.bIsPlayer && C.PlayerReplicationInfo!=None && C.Pawn!=None && C.Pawn.Health>0 && C.LineOfSightTo(Pawn) )
		{
			if( NoneSightCount>=5 )
			{
				KFM.OriginalGroundSpeed = KFM.Default.GroundSpeed;
				KFM.GroundSpeed = KFM.Default.GroundSpeed;
			}
			NoneSightCount = 0;
			return false;
		}
	}
	if( NoneSightCount>=5 ) // Walk faster to find players.
	{
		KFM.OriginalGroundSpeed = FMax(KFM.GroundSpeed,300.f);
		KFM.GroundSpeed = KFM.OriginalGroundSpeed;
	}

    NoneSightCount++;

    if( ValidKillTime>Level.TimeSeconds )
		return false;
    if (bBoss)
        return ( NoneSightCount>300);
	return ( NoneSightCount>30);
}

function bool FireWeaponAt(Actor A) // Don't fire until finished turning toward enemy.
{
	local int YawDif;

	if ( A == None )
		A = Enemy;
	if ( (A == None) || (Focus != A) )
		return false;
	YawDif = (Pawn.Rotation.Yaw-rotator(A.Location-Pawn.Location).Yaw) & 65535;
	if( YawDif>4000 && YawDif<61536 )
		return false;
	Target = A;
	Monster(Pawn).RangedAttack(Target);
	return false;
}

function bool FindFreshBody()
{
	return false; // Never feed on player corpses.
}
function DoTacticalMove()
{
	if( Enemy!=None && LineOfSightTo(Enemy) && DoomMonster(Pawn).ShouldTryRanged(Enemy) )
		GoToState('ZombieHunt','DoRangeNow');
	else GotoState('TacticalMove');
}
function rotator AdjustAim(FireProperties FiredAmmunition, vector projStart, int aimerror)
{
	local rotator FireRotation, TargetLook;
	local float FireDist, TargetDist, ProjSpeed;
	local actor HitActor;
	local vector FireSpot, FireDir, TargetVel, HitLocation, HitNormal;
	local int realYaw;
	local bool bDefendMelee, bClean, bLeadTargetNow;

	if ( DoomMonster(Pawn).RangedProjectile!=None )
		projspeed = DoomMonster(Pawn).RangedProjectile.Default.Speed;
	else projspeed = 2000.f;

	// make sure bot has a valid target
	if ( Target == None )
	{
		Target = Enemy;
		if ( Target == None )
			return Rotation;
	}
	FireSpot = Target.Location;
	TargetDist = VSize(Target.Location - Pawn.Location);

	// perfect aim at stationary objects
	if ( Pawn(Target) == None )
	{
		if ( !FiredAmmunition.bTossed )
			return rotator(Target.Location - projstart);
		else
		{
			FireDir = AdjustToss(projspeed,ProjStart,Target.Location,true);
			SetRotation(Rotator(FireDir));
			return Rotation;
		}
	}

	bLeadTargetNow = FiredAmmunition.bLeadTarget && bLeadTarget;
	bDefendMelee = ( (Target == Enemy) && DefendMelee(TargetDist) );
	aimerror = AdjustAimError(aimerror,TargetDist,bDefendMelee,FiredAmmunition.bInstantHit, bLeadTargetNow);

	// lead target with non instant hit projectiles
	if ( bLeadTargetNow )
	{
		TargetVel = Target.Velocity;
		// hack guess at projecting falling velocity of target
		if ( Target.Physics == PHYS_Falling )
		{
			if ( Target.PhysicsVolume.Gravity.Z <= Target.PhysicsVolume.Default.Gravity.Z )
				TargetVel.Z = FMin(TargetVel.Z + FMax(-400, Target.PhysicsVolume.Gravity.Z * FMin(1,TargetDist/projSpeed)),0);
			else
				TargetVel.Z = FMin(0, TargetVel.Z);
		}
		// more or less lead target (with some random variation)
		FireSpot += FMin(1, 0.7 + 0.6 * FRand()) * TargetVel * TargetDist/projSpeed;
		FireSpot.Z = FMin(Target.Location.Z, FireSpot.Z);

		if ( (Target.Physics != PHYS_Falling) && (FRand() < 0.55) && (VSize(FireSpot - ProjStart) > 1000) )
		{
			// don't always lead far away targets, especially if they are moving sideways with respect to the bot
			TargetLook = Target.Rotation;
			if ( Target.Physics == PHYS_Walking )
				TargetLook.Pitch = 0;
			bClean = ( ((Vector(TargetLook) Dot Normal(Target.Velocity)) >= 0.71) && FastTrace(FireSpot, ProjStart) );
		}
		else // make sure that bot isn't leading into a wall
			bClean = FastTrace(FireSpot, ProjStart);
		if ( !bClean)
		{
			// reduce amount of leading
			if ( FRand() < 0.3 )
				FireSpot = Target.Location;
			else
				FireSpot = 0.5 * (FireSpot + Target.Location);
		}
	}

	bClean = false; //so will fail first check unless shooting at feet
	if ( FiredAmmunition.bTrySplash && (Pawn(Target) != None) && ((Skill >=4) || bDefendMelee)
		&& (((Target.Physics == PHYS_Falling) && (Pawn.Location.Z + 80 >= Target.Location.Z))
			|| ((Pawn.Location.Z + 19 >= Target.Location.Z) && (bDefendMelee || (skill > 6.5 * FRand() - 0.5)))) )
	{
	 	HitActor = Trace(HitLocation, HitNormal, FireSpot - vect(0,0,1) * (Target.CollisionHeight + 6), FireSpot, false);
 		bClean = (HitActor == None);
		if ( !bClean )
		{
			FireSpot = HitLocation + vect(0,0,3);
			bClean = FastTrace(FireSpot, ProjStart);
		}
		else
			bClean = ( (Target.Physics == PHYS_Falling) && FastTrace(FireSpot, ProjStart) );
	}

	if ( !bClean )
	{
		//try middle
		FireSpot.Z = Target.Location.Z;
 		bClean = FastTrace(FireSpot, ProjStart);
	}
	if ( FiredAmmunition.bTossed && !bClean && bEnemyInfoValid )
	{
		FireSpot = LastSeenPos;
	 	HitActor = Trace(HitLocation, HitNormal, FireSpot, ProjStart, false);
		if ( HitActor != None )
		{
			bCanFire = false;
			FireSpot += 2 * Target.CollisionHeight * HitNormal;
		}
		bClean = true;
	}

	if( !bClean )
	{
		// try head
 		FireSpot.Z = Target.Location.Z + 0.9 * Target.CollisionHeight;
 		bClean = FastTrace(FireSpot, ProjStart);
	}
	if ( !bClean && (Target == Enemy) && bEnemyInfoValid )
	{
		FireSpot = LastSeenPos;
		if ( Pawn.Location.Z >= LastSeenPos.Z )
			FireSpot.Z -= 0.4 * Enemy.CollisionHeight;
	 	HitActor = Trace(HitLocation, HitNormal, FireSpot, ProjStart, false);
		if ( HitActor != None )
		{
			FireSpot = LastSeenPos + 2 * Enemy.CollisionHeight * HitNormal;
			if ( Monster(Pawn).SplashDamage() && (Skill >= 4) )
			{
			 	HitActor = Trace(HitLocation, HitNormal, FireSpot, ProjStart, false);
				if ( HitActor != None )
					FireSpot += 2 * Enemy.CollisionHeight * HitNormal;
			}
			bCanFire = false;
		}
	}

	// adjust for toss distance
	if ( FiredAmmunition.bTossed )
		FireDir = AdjustToss(projspeed,ProjStart,FireSpot,true);
	else
		FireDir = FireSpot - ProjStart;

	FireRotation = Rotator(FireDir);
	realYaw = FireRotation.Yaw;
	InstantWarnTarget(Target,FiredAmmunition,vector(FireRotation));

	FireRotation.Yaw = SetFireYaw(FireRotation.Yaw + aimerror);
	FireDir = vector(FireRotation);
	// avoid shooting into wall
	FireDist = FMin(VSize(FireSpot-ProjStart), 400);
	FireSpot = ProjStart + FireDist * FireDir;
	HitActor = Trace(HitLocation, HitNormal, FireSpot, ProjStart, false);
	if ( HitActor != None )
	{
		if ( HitNormal.Z < 0.7 )
		{
			FireRotation.Yaw = SetFireYaw(realYaw - aimerror);
			FireDir = vector(FireRotation);
			FireSpot = ProjStart + FireDist * FireDir;
			HitActor = Trace(HitLocation, HitNormal, FireSpot, ProjStart, false);
		}
		if ( HitActor != None )
		{
			FireSpot += HitNormal * 2 * Target.CollisionHeight;
			if ( Skill >= 4 )
			{
				HitActor = Trace(HitLocation, HitNormal, FireSpot, ProjStart, false);
				if ( HitActor != None )
					FireSpot += Target.CollisionHeight * HitNormal;
			}
			FireDir = Normal(FireSpot - ProjStart);
			FireRotation = rotator(FireDir);
		}
	}

	SetRotation(FireRotation);
	return FireRotation;
}

static function bool TestSpot( LevelInfo Map, out VolumeColTester T, vector P, class<Actor> A )
{
	if( T==None )
	{
		foreach Map.DynamicActors(Class'VolumeColTester',T,'Test')
			break;
		if( T==None )
		{
			T = Map.Spawn(Class'VolumeColTester',,'Test',P);
			if( T==None )
				return false;
			T.bCollideWhenPlacing = True;
		}
	}
	T.SetCollisionSize(A.Default.CollisionRadius,A.Default.CollisionHeight);
	return T.SetLocation(P);
}

function NavigationPoint PickBestTeleportDest()
{
	if ( default.BestTeleportPoints.length == 0)
		return none;

	return default.BestTeleportPoints[rand(default.BestTeleportPoints.length)];
}

//returns navigation point close to a player
function NavigationPoint PickCloseTeleportDest()
{
	local Controller C;
	local PlayerController Player;
	local array<PlayerController> Players;
	local array<NavigationPoint> Points;
	local NavigationPoint N;
	local float MinDistSq;
	local int i;

	for ( C = Level.ControllerList; C != none; C = C.nextController ) {
		Player = PlayerController(C);
		if ( Player != none && Player.Pawn != none && Player.Pawn.Health > 0 ) {
			Players[i++] = Player;
		}
	}
	if (Players.length == 0)
		return none; //wtf?


	Player = Players[rand(Players.length)];
	MinDistSq = (Player.CollisionRadius + KFM.CollisionRadius) * (Player.CollisionRadius + KFM.CollisionRadius);
	foreach Player.RadiusActors(class'NavigationPoint', N, 1000) {
		// same floor, in 20m radius
		if ( (Player.Location.Z - N.Location.Z < 200)
				&& (Player.Location.Z - N.Location.Z > -200)
				&& VSizeSquared(N.Location-Player.Location) > MinDistSq ) {
			//debug
			Points[Points.Length] = N;
			if ( Points.Length >= 50 )
				break;
		}
	}

	if ( Points.Length == 0 )
		return none;

	//Level.Game.BroadCast(Player, "Close teleportation ("$Points.length$")");
	return Points[rand(Points.length)];
}

function NavigationPoint PickTeleportDest()
{
	local int i, j, k;
	local float r;
	local float MaxRating;
	local NavigationPoint MaxRatingPoint;

	if ( default.TeleportDestinations.length == 0 )
		InitTeleportPoints(Level);

	i = Rand(default.TeleportDestinations.length);
	MaxRatingPoint = default.TeleportDestinations[i].Point;
	MaxRating = default.TeleportDestinations[i].Rating;

	j = 10;
	while ( j-- > 0 ) {
		r = frand();
		i = Rand(default.TeleportDestinations.length);
		k = 10;
		while ( k-- > 0 ) {
			if ( default.TeleportDestinations[i].Rating >= r)
				return default.TeleportDestinations[i].Point;
			else if ( default.TeleportDestinations[i].Rating > MaxRating && frand()<0.75 ) {
				MaxRatingPoint = default.TeleportDestinations[i].Point;
				MaxRating = default.TeleportDestinations[i].Rating;
			}

			i = Rand(default.TeleportDestinations.length);
			if ( ++i >= default.TeleportDestinations.length )
				i = 0; //search from begining
		}
	}
	// random didn't worked, so return the point with highest rating from searched ones
	return MaxRatingPoint;
}

function bool FindTeleportDest(bool bUseClosePoints, bool bUseBestPoints)
{
	local NavigationPoint N;
	local int k;
	local float r;

	bTeleValid = false;
	// monster is supposed to teleport again - so previous teleport destination wasn't good enough
	if ( LastTeleportedTo != none )
		IncLastTeleportDestRaiting(-0.05);

	r = frand();

	// 10% change to spawn close to players, or 50%, if all monsters are spawned already
	if ( bUseClosePoints && (r > 0.9 || ( KFGameType(Level.Game).TotalMaxMonsters == 0 && r > 0.5 )) )
		N = PickCloseTeleportDest();

	// do not use best spots, if all monsters were spawned already
	if ( bUseBestPoints && N == none && KFGameType(Level.Game).TotalMaxMonsters > 0 && r < fmin(0.5, default.BestTeleportPoints.length * 0.05) ) {
		N = PickBestTeleportDest();
	}

	if ( N == none ) {
		N = PickTeleportDest();
	}

	k = 20; // 20 tries
	while ( k-- > 0 ) {
		// do not teleport to the same spot twice
		if ( N != LastTeleportedTo ) {
			if( TestSpot(Level,Tst,N.Location,Pawn.Class) ||
				 TestSpot(Level,Tst,N.Location+vect(0,0,1)*(Pawn.CollisionHeight-N.CollisionHeight),Pawn.Class) )
			{
				TeleDest = Tst.Location;
				LastTeleportedTo = N;
				bTeleValid = true;
				return true;
			}
			else {
				IncTeleportDestRaiting(N, -0.1); // can't spawn here - so lower point's rating
			}
		}
		N = PickTeleportDest();
	}
	return false;
}

function float SpawnTeleportFX()
{
	local class<DemonSpawnBase> D;

	D = DoomMonster(Pawn).DoomTeleportFXClass;
	if( D==None )
		return 1.f;

	Spawn(Class'DemonSpawnB',,,Pawn.Location,rot(0,0,0));
	Spawn(D,,,TeleDest,rot(0,0,0));
	return D.Default.TeleportInTime;
}

function bool PickRandDest()
{
	if( RandStakeMoveGoal==None )
	{
		RandStakeMoveGoal = FindRandomDest();
		if( RandStakeMoveGoal==None )
			return false;
	}
	if( ActorReachable(RandStakeMoveGoal) )
	{
		MoveTarget = RandStakeMoveGoal;
		RandStakeMoveGoal = None;
	}
	else if( !FindBestPathToward(RandStakeMoveGoal,true,true) )
	{
		RandStakeMoveGoal = None;
		return false;
	}
	return true;
}

state ZombieHunt
{
	function BeginState()
	{
		if ( NextTeleTimeOnHunt == 0 ) {
			TeleDelayCount = 0;
			NextTeleTimeOnHunt = 10.0 + (10.0 + 5*TeleCount) * frand() + Pawn.Health/100.0
					+ fmin(60.0, 5.0*TeleCount);
			if ( Pawn.bCanFly )
				NextTeleTimeOnHunt *= 2.0;
			NextTeleTimeOnHunt += Level.TimeSeconds;
		}
		else if ( NextTeleTimeOnHunt - Level.TimeSeconds < 2.0  && ++TeleDelayCount <= 3) {
			// prevent teleporting immediately after going into ZombieHunt state. But only up to 3 times.
			NextTeleTimeOnHunt = Level.TimeSeconds + 5.0 + 5.0*frand();
		}
		// Level.GetLocalPlayerController().ClientMessage(Pawn $ " hunting. Teleporting in " $ (NextTeleTimeOnHunt - Level.TimeSeconds));
	}

	function EndState();

	function PickDestination()
	{
		local vector nextSpot, ViewSpot,Dir;
		local float posZ;
		local bool bCanSeeLastSeen;

		if ( Level.TimeSeconds > NextTeleTimeOnHunt && Level.TimeSeconds > LastTeleportTime + 30.0
				&& Level.TimeSeconds > default.GlobalNextTeleportTime ) {
			// Level.GetLocalPlayerController().ClientMessage(Pawn $ " teleporting during hunting");
			NextTeleTimeOnHunt = 0;
			GoToState('Teleport');
			return;
		}

		if( FindFreshBody() )
			Return;
		if ( (Enemy != None) && !KFM.bCannibal && (Enemy.Health <= 0) )
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
			LastSeenTime = Level.TimeSeconds;
			Destination = Enemy.Location;
			if( KFM.Intelligence==BRAINS_Retarded && FRand()<0.5 )
			{
				Destination+=VRand()*50;
				Return;
			}
			MoveTarget = None;
			return;
		}

		if( LineOfSightTo(Enemy) && DoomMonster(Pawn).ShouldTryRanged(Enemy) )
		{
			LastSeenTime = Level.TimeSeconds;
			GoToState(,'DoRangeNow');
			return;
		}

		ViewSpot = Pawn.Location + Pawn.BaseEyeHeight * vect(0,0,1);
		bCanSeeLastSeen = bEnemyInfoValid && FastTrace(LastSeenPos, ViewSpot);

		if ( FindBestPathToward(Enemy, true,true) )
		{
			LastSeenTime = Level.TimeSeconds;
			return;
		}

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
		if ( FastTrace(Enemy.Location, ViewSpot) && VSize(Pawn.Location - Destination) > Pawn.CollisionRadius ) {
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

DoRangeNow:
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


state TacticalMove
{
	function BeginState()
	{
		bForcedDirection = false;
		MinHitWall += 0.15;
		Pawn.bAvoidLedges = true;
		Pawn.bStopAtLedges = true;
		Pawn.bCanJump = false;
		bAdjustFromWalls = false;
	}

TacticalTick:
	Sleep(0.02);
Begin:
	if (Pawn.Physics == PHYS_Falling)
	{
		Focus = Enemy;
		Destination = Enemy.Location;
		WaitForLanding();
	}
	PickDestination();

DoMove:
	if ( !Pawn.bCanStrafe )
	{
		if( !KFM.bShotAnim && Enemy!=None && DoomMonster(Pawn).ShouldTryRanged(Enemy) && LineOfSightTo(Enemy) )
		{
			LastSeenTime = Level.TimeSeconds;
			Pawn.Acceleration = vect(0,0,0);
			Focus = Enemy;
			FinishRotation();
			KFM.RangedAttack(Enemy);
		}
		StopFiring();
WaitForAnim:
		while( KFM.bShotAnim )
			Sleep(0.25);
		MoveTo(Destination);
	}
	else
	{
DoStrafeMove:
		MoveTo(Destination, Enemy);
	}
	if ( bForcedDirection && (Level.TimeSeconds - StartTacticalTime < 0.2) )
	{
		if ( Skill > 2 + 3 * FRand() )
		{
			bMustCharge = true;
			WhatToDoNext(51);
		}
		GoalString = "RangedAttack from failed tactical";
		DoRangedAttackOn(Enemy);
	}
	if ( (Enemy == None) || EnemyVisible() || !FastTrace(Enemy.Location, LastSeeingPos) || Monster(Pawn).PreferMelee() || !Pawn.bCanStrafe )
		Goto('FinishedStrafe');
	//CheckIfShouldCrouch(LastSeeingPos,Enemy.Location, 0.5);

RecoverEnemy:
	GoalString = "Recover Enemy";
	HidingSpot = Pawn.Location;
	StopFiring();
	Sleep(0.1 + 0.2 * FRand());
	Destination = LastSeeingPos + 4 * Pawn.CollisionRadius * Normal(LastSeeingPos - Pawn.Location);
	MoveTo(Destination, Enemy);

	if ( FireWeaponAt(Enemy) )
	{
		Pawn.Acceleration = vect(0,0,0);
		if ( Monster(Pawn).SplashDamage() )
		{
			StopFiring();
			Sleep(0.05);
		}
		else
			Sleep(0.1 + 0.3 * FRand() + 0.06 * (7 - FMin(7,Skill)));
		if ( FRand() > 0.5 )
		{
			Enable('EnemyNotVisible');
			Destination = HidingSpot + 4 * Pawn.CollisionRadius * Normal(HidingSpot - Pawn.Location);
			Goto('DoMove');
		}
	}
FinishedStrafe:
	WhatToDoNext(21);
	if ( bSoaking )
		SoakStop("STUCK IN TACTICAL MOVE!");
}

// Wander around more, if fail for long enough, teleport.
state StakeOut
{
Begin:
	if (NextTeleTimeOnStakeOut == 0) {
		NextTeleTimeOnStakeOut = Level.TimeSeconds + 5.0 + 10*frand() + fmin(60, 5.0*TeleCount);
		// Level.GetLocalPlayerController().ClientMessage(Pawn $ " stuck. Teleporting in " $ (NextTeleTimeOnStakeOut - Level.TimeSeconds));
	}
	Pawn.Acceleration = vect(0,0,0);
	Focus = None;
	FinishRotation();
	if ( Enemy!=None && KFM.HasRangedAttack() && (FRand() < 0.5) && (VSize(Enemy.Location - FocalPoint) < 150)
		 && (Level.TimeSeconds - LastSeenTime < 4) && ClearShot(FocalPoint,true) )
		FireWeaponAt(Enemy);
	else
		StopFiring();
	Sleep(0.4 + FRand()*0.4);
	if( (bInitKill || (Level.TimeSeconds-LastSeenTime)>10.f) && Level.TimeSeconds>NextTeleTimeOnStakeOut
			&& FindTeleportDest(true, true) )
	{
		// Level.GetLocalPlayerController().ClientMessage(Pawn $ " teleporting due to being stuck");
		bSleepOnTele = true;
		GotoState('Teleport', 'DoTele');
	}
	else if( FRand()<0.5f && PickRandDest() )
		MoveToward(MoveTarget);
	else
		MoveTo(Pawn.Location+VRand()*(Pawn.CollisionRadius+300.f));

	WhatToDoNext(31);
	if ( bSoaking )
		SoakStop("STUCK IN STAKEOUT!");
}

state Teleport
{
Begin:
	bSleepOnTele = true;
	FindTeleportDest(true, true);

DoTele:
	Pawn.Acceleration = vect(0,0,0);
	Focus = None;
	FinishRotation();
	StopFiring();
	NextTeleTimeOnStakeOut = 0;
	NextTeleTimeOnHunt = 0;
	if( bTeleValid ) {
		default.GlobalNextTeleportTime = Level.TimeSeconds + 3.0;
		if (bSleepOnTele) {
			sleep(SpawnTeleportFX());
		}
		else {
			SpawnTeleportFX();
		}

		if (Pawn.SetLocation(TeleDest)) {
			++TeleCount;
			LastTeleportTime = Level.TimeSeconds;
			bRateTeleportDest = true;
			DoomMonster(Pawn).NotifyTeleport();
		}
		while( KFM.bShotAnim )
			Sleep(0.25f);
	}

Next:
	WhatToDoNext(61);
	if ( bSoaking )
		SoakStop("STUCK IN TELEPORT!");

Away:
	bSleepOnTele = false;
	if ( FindTeleportDest(false, false) ) {
		GoToState(, 'DoTele');
	}
	else {
		GotoState(, 'Next');
	}

Random:
	bSleepOnTele = true;
	if ( FindTeleportDest(false, false) ) {
		GoToState(, 'DoTele');
	}
	else {
		GotoState(, 'Next');
	}
}

state ZombieCharge
{
	function HearNoise(float Loudness, Actor NoiseMaker)
	{
		if( KFM.Intelligence==BRAINS_Human && NoiseMaker!=None && NoiseMaker.Instigator!=None && FastTrace(NoiseMaker.Location,Pawn.Location) )
			SetEnemy(NoiseMaker.Instigator);
	}
Begin:
	LastSeenTime = Level.TimeSeconds;
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
	if( !DoomMonster(Pawn).ShouldChargeAtPlayer() )
	{
		Focus = Enemy;
		Target = Enemy;
		Pawn.Acceleration = vect(0,0,0);
		Sleep(0.5f);
		WhatToDoNext(17);
	}
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
	WhatToDoNext(17);
	if ( bSoaking )
		SoakStop("STUCK IN CHARGING!");
}

defaultproperties
{
	BestDestRatio=0.69;
}
