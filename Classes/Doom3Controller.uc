Class Doom3Controller extends KFMonsterController;

enum ETeleDestType {
	TD_None,
	TD_Close,
	TD_Far,
	TD_Random
};
var ETeleDestType LastTeleDestType;

var transient float ValidKillTime,NextTeleTimeOnStakeOut,NextTeleTimeOnHunt,LastTeleportTime;
var transient int TeleCount, TeleAttempts;
var NavigationPoint LastTeleportedTo;
var vector TeleDest;
var bool bInitKill;
var bool bTeleValid, bSleepOnTele;
var array<NavigationPoint> TelePoints;

var float CloseTeleMinDist;  // min distance to the player squared
var float CloseTeleMaxDist;  // max distance to the player squared during for close teleport
var float FarTeleMinSq;  // max distance to the player squared during for close teleport
var int TeleDelayCount;
var byte NoneSightCount;
var Actor RandStakeMoveGoal;

var VolumeColTester Tst;

var transient float GlobalNextTeleportTime;

function BeginPlay()
{
	Super.BeginPlay();
}

function InitializeSkill(float _unused_InSkill)
{
	Skill = Level.Game.GameDifficulty;
}

function ResetSkill()
{
	bLeadTarget = Skill >= 4;
}

// Get rid of this Zed if he's stuck somewhere and noone has seen him
function bool CanKillMeYet()
{
	local Controller C;
	local bool bBoss;

	bBoss = DoomBoss(KFM) != none;

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
		return NoneSightCount > 300;
	return NoneSightCount > 10;
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
		projspeed = fmax(1.0, DoomMonster(Pawn).RangedProjectile.Default.Speed);
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
			FireSpot = HitLocation + vect(0,0,6);
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

function float AdjustAimError(float aimerror, float TargetDist, bool bDefendMelee, bool bInstantProj,
		bool bLeadTargetNow )
{
	if ( (Pawn(Target) != None) && (Pawn(Target).Visibility < 2) )
		aimerror *= 2.5;

	// figure out the relative motion of the target across the bots view, and adjust aim error
	// based on magnitude of relative motion
	aimerror = aimerror * FMin(5,(12 - 11 * (Normal(Target.Location - Pawn.Location)
			Dot Normal((Target.Location + 1.2 * Target.Velocity) - (Pawn.Location + Pawn.Velocity)))));

	// if enemy is charging straight at bot with a melee weapon, improve aim
	if ( bDefendMelee )
		aimerror *= 0.5;

	if ( Target.Velocity == vect(0,0,0) )
		aimerror *= 0.6;

	// aiming improves over time if stopped
	if ( Stopped() && (Level.TimeSeconds > StopStartTime) )
	{
		if ( (Skill+Accuracy) > 4 )
			aimerror *= 0.9;
		aimerror *= FClamp((2 - 0.08 * FMin(skill,7) - FRand()) / (Level.TimeSeconds - StopStartTime + 0.4),
				0.7, 1.0);
	}

	// adjust aim error based on skill
	if ( !bDefendMelee )
		aimerror *= (3.3 - 0.37 * (FClamp(skill+Accuracy,0,8.5) + 0.5 * FRand()));

	// Bots don't aim as well if recently hit, or if they or their target is flying through the air
	if ( ((skill < 7) || (FRand()<0.5)) && (Level.TimeSeconds - Pawn.LastPainTime < 0.2) )
		aimerror *= 1.3;
	if ( (Pawn.Physics == PHYS_Falling) || (Target.Physics == PHYS_Falling) )
		aimerror *= 1.6;

	// Bots don't aim as well at recently acquired targets (because they haven't had a chance to lock in to the target)
	if ( AcquireTime > Level.TimeSeconds - 0.5 - 0.6 * (7 - skill) )
	{
		aimerror *= 1.5;
		if ( bInstantProj )
			aimerror *= 1.5;
	}

	return (Rand(2 * aimerror) - aimerror);
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

// TODO: Switch to the ScrnF function
static final function int GetAlivePlayers(GameInfo Game, out array<PlayerController> Players) {
    local Controller C;
    local int i;

    // The below lines produces a NULL access warning if called client-side to indicate that
    // the function must be called server-side only.
    Players.length = Game.NumPlayers;
    for (C = Game.Level.ControllerList; C != none; C = C.nextController) {
        if (C.bIsPlayer && C.Pawn != none && C.Pawn.Health > 0) {
            Players[i] = PlayerController(C);
            if (Players[i] != none) {
                ++i;
            }
        }
    }
    Players.length = i;
    return i;
}

//returns navigation point close to a player
function PickCloseTeleportDest()
{
	local array<PlayerController> Players;
	local PlayerController Player;
	local PathNode N;
	local float MinDistSq;

	if (GetAlivePlayers(Level.Game, Players) == 0)
		return;  // wtf?

	Player = Players[rand(Players.length)];
	MinDistSq = Square(CloseTeleMinDist);
	foreach Player.RadiusActors(class'PathNode', N, CloseTeleMaxDist, Player.Pawn.Location) {
		// same floor, in 40m radius
		if (abs(Player.Location.Z - N.Location.Z) < 90
				&& VSizeSquared(N.Location - Player.Location) > MinDistSq) {
			TelePoints[TelePoints.Length] = N;
			if (TelePoints.Length >= 20)
				break;
		}
	}
}

function NavigationPoint FindFarTeleportDest()
{
	local array<PlayerController> Players;
	local NavigationPoint N, Best;
	local int i, c;
	local float MinDistSq, DistSq, BestDistSq;

	if (GetAlivePlayers(Level.Game, Players) == 0)
		return FindRandomDest();  // wtf?

	while (++c <= 20) {
		N = FindRandomDest();
		MinDistSq = 999999999;
		for (i = 0; i < Players.Length; ++i) {
			DistSq = VSizeSquared(N.Location - Players[i].Location);
			if (DistSq < FarTeleMinSq)
				break;
			MinDistSq = fmin(MinDistSq, DistSq);
		}
		if (i < Players.Length) continue;  // too close

		for (i = 0; i < Players.Length; ++i) {
			if (FastTrace(N.Location - Players[i].Location))
				break;  // visible
		}
		if (i == Players.Length) {
			// An invisible point - use it;
			return N;
		}

		if (MinDistSq > BestDistSq) {
			Best = N;
			BestDistSq = MinDistSq;
		}
	}
	return Best;
}

function bool FindTeleportDest(ETeleDestType DestType)
{
	local NavigationPoint N;
	local int i;

	bTeleValid = false;

	if (DestType != LastTeleDestType) {
		TelePoints.Length = 0;
	}

	if (TelePoints.Length == 0) {
		LastTeleDestType = DestType;
		switch (DestType) {
			case TD_Close:
				PickCloseTeleportDest();
				break;
			case TD_Far:
				TelePoints[1] = FindFarTeleportDest();
				break;
			case TD_Random:
			default:
				TelePoints[1] = FindRandomDest();
				break;
		}
	}

	while (TelePoints.Length > 0) {
		i = rand(TelePoints.Length);
		N = TelePoints[i];
		TelePoints.remove(i, 10);
		if (N == LastTeleportedTo)
			continue;

		if (TestSpot(Level, Tst, N.Location, Pawn.Class)) {
			TeleDest = Tst.Location;
			LastTeleportedTo = N;
			bTeleValid = true;
			return true;
		}
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
			NextTeleTimeOnHunt = 10.0 + (10.0 + 5*TeleCount) * frand() + fmin(20.0, Pawn.Health/100.0)
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
			&& FindTeleportDest(TD_Close) )
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
	FindTeleportDest(TD_Close);
	TeleAttempts = 0;

DoTele:
	while (!bTeleValid && ++TeleAttempts < 20) {
		// sleep for one tick, then repeat
		sleep(0.01);
		FindTeleportDest(LastTeleDestType);
	}

	if (bTeleValid) {
		Pawn.Acceleration = vect(0,0,0);
		Focus = None;
		FinishRotation();
		StopFiring();
		NextTeleTimeOnStakeOut = 0;
		NextTeleTimeOnHunt = 0;
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
	FindTeleportDest(TD_Far);
	GoToState(, 'DoTele');

Random:
	bSleepOnTele = true;
	FindTeleportDest(TD_Random);
	GoToState(, 'DoTele');
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
	LastTeleDestType=TD_None
	CloseTeleMinDist=250  // 5m
	CloseTeleMaxDist=2000  // 40m
	FarTeleMinSq=62500  // 50m
}
