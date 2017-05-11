class HunterHellTime extends DoomMonster;

var transient float NextRangedTime;
var bool bTeleportNow;
var HunterHellTimeTrailEffect Trails[8];
var ImpHandTrail FireTrail;

var Sound ChestRipSound[3];
var Sound PreFireSound;
var Sound TeleportSound;
var Sound TeleportStart;
var(Anims) Name RangedAttacks[3];
var Sound SpawnSound;

var vector RepTeleport;
var float RepResetTime;
var bool bResetRepT;

replication
{
	reliable if( Role==ROLE_Authority )
		RepTeleport;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if( Level.NetMode!=NM_DedicatedServer )
	{
		PlaySound(SpawnSound,SLOT_Interact);
		Trails[0] = Spawn(class'HunterHellTimeTrailEffect',self);
		AttachToBone(Trails[0],'chunk1_joint');
		Trails[1] = Spawn(class'HunterHellTimeTrailEffect',self);
		AttachToBone(Trails[1],'chunk2_joint');
		Trails[2] = Spawn(class'HunterHellTimeTrailEffect',self);
		AttachToBone(Trails[2],'chunk3_joint');
		Trails[3] = Spawn(class'HunterHellTimeTrailEffect',self);
		AttachToBone(Trails[3],'chunk4_joint');
		Trails[4] = Spawn(class'HunterHellTimeTrailEffect',self);
		AttachToBone(Trails[4],'chunk5_joint');
		Trails[5] = Spawn(class'HunterHellTimeTrailEffect',self);
		AttachToBone(Trails[5],'chunk6_joint');
		Trails[6] = Spawn(class'HunterHellTimeTrailEffect',self);
		AttachToBone(Trails[6],'chunk7_joint');
		Trails[7] = Spawn(class'HunterHellTimeTrailEffect',self);
		AttachToBone(Trails[7],'chunk8_joint');
	}
	bHasRoamed = false;
}

function RangedAttack(Actor A)
{
	if ( bShotAnim )
		return;

	if( !bHasRoamed )
		RoamAtPlayer();
	if( IsInMeleeRange(A) )
	{
		PrepareStillAttack(A);
		SetAnimAction(MeleeAnims[Rand(3)]);
	}
	else if( NextRangedTime<Level.TimeSeconds )
	{
		Controller.Target = A;
		if( Health>2000 )
			NextRangedTime = Level.TimeSeconds+0.6f+FRand()*1.5f;
		PrepareStillAttack(A);
		if( bTeleportNow )
		{
			SetAnimAction('Teleport');
			if( Health<800 )
				bTeleportNow = (FRand()<0.5f);
			else bTeleportNow = false;
			SetTimer(0.4,false);
		}
		else
		{
			SetAnimAction(RangedAttacks[Rand(3)]);
			bTeleportNow = (Health<1500 || FRand()<0.75f);
		}
	}
}

function Timer()
{
	local vector End,HL,HN,E,Best;
	local byte i;
	local bool bFarDist;
	local float D,BD;

	E.X = CollisionRadius*0.75f;
	E.Y = E.X;
	E.Z = CollisionHeight*0.75f;
	bFarDist = (Controller.Target!=None && VSizeSquared(Controller.Target.Location-Location)>1440000.f);
	while( ++i<8 )
	{
		if( bFarDist )
			End = Controller.Target.Location;
		else End = Location;
		End.X+=(FRand()*1000.f-500.f);
		End.Y+=(FRand()*1000.f-500.f);
		if( Controller.Target!=None )
			End.Z = Controller.Target.Location.Z+(FRand()*200.f-40.f);
		else End.Z+=(FRand()*200.f-100.f);

		if( Trace(HL,HN,End,Location,false,E)!=None )
			End = HL+HN*CollisionRadius*0.25f;

		if( VSizeSquared(End-Location)>360000.f )
			break;
	}
	if( VSizeSquared(End-Location)<250000.f )
	{
		i = 0;
		while( ++i<10 )
		{
			End = Location;
			End.X+=(FRand()*1000.f-500.f);
			End.Y+=(FRand()*1000.f-500.f);
			End.Z+=(FRand()*800.f-400.f);

			if( Trace(HL,HN,End,Location,false,E)!=None )
				End = HL+HN*CollisionRadius*0.25f;

			D = VSizeSquared(End-Location);
			if( Controller.Target!=None && !FastTrace(End,Controller.Target.Location) )
				D*=0.6f;
			if( D>250000.f )
			{
				Best = End;
				break;
			}
			if( BD<D )
			{
				Best = End;
				BD = D;
			}
		}
		End = Best;
	}

	HL = Location;
	if( !SetLocation(End) )
		return;
	if( Level.NetMode!=NM_Client )
		SpawnTeleEffects(HL,Location);
	RepTeleport = HL;
	RepResetTime = Level.TimeSeconds+0.6f;
	bResetRepT = true;
	if( Controller.Target!=None )
		SetRotation(rotator(Controller.Target.Location-Location));
}
simulated function Tick( float Delta )
{
	if( bResetRepT && RepResetTime<Level.TimeSeconds )
	{
		bResetRepT = false;
		RepTeleport = vect(0,0,0);
	}
	Super.Tick(Delta);
}
simulated function PostNetReceive()
{
	if( RepTeleport!=vect(0,0,0) )
	{
		if( VSize(Location-RepTeleport)>20.f )
			SpawnTeleEffects(RepTeleport,Location);
		RepTeleport = vect(0,0,0);
	}
}

simulated function SpawnTeleEffects(vector OldLoc, vector NewLoc)
{
	local xEmitter xBeam, xBeamSmall[2];
	local Coords BoneLocation;
	local HunterHellTimePortal Portal;

	xBeam = Spawn(class'HunterHellTimeBeam',,,OldLoc);
	xBeam.mSpawnVecA = NewLoc;
	BoneLocation = GetBoneCoords('Ruparm_orbit');
	xBeamSmall[0] = Spawn(class'HunterHellTimeThinBeam',,,OldLoc);
	xBeamSmall[0].mSpawnVecA = BoneLocation.Origin;
	BoneLocation = GetBoneCoords('Luparm_orbit');
	xBeamSmall[1] = Spawn(class'HunterHellTimeThinBeam',,,OldLoc);
	xBeamSmall[1].mSpawnVecA = BoneLocation.Origin;
	Spawn(class'HunterHellTimeFlare',self,,OldLoc,);
	Portal = Spawn(class'HunterHellTimePortal',,,NewLoc,Rotation);
	Portal.SetBase(self);
	PlaySound(TeleportSound,SLOT_Misc,1,,600.f);
}

simulated function FireProjectile()
{
	if( Level.NetMode!=NM_Client )
	{
		switch( Rand(3) )
		{
		case 0:
			FireProj(GetBoneCoords('chunk1_joint').Origin);
			FireProj(GetBoneCoords('chunk2_joint').Origin);
			FireProj(GetBoneCoords('chunk3_joint').Origin);
			break;
		case 1:
			FireProj(GetBoneCoords('chunk4_joint').Origin);
			FireProj(GetBoneCoords('chunk5_joint').Origin);
			FireProj(GetBoneCoords('chunk6_joint').Origin);
			FireProj(GetBoneCoords('chunk2_joint').Origin);
			break;
		default:
			FireProj(GetBoneCoords('chunk7_joint').Origin);
			FireProj(GetBoneCoords('chunk8_joint').Origin);
			break;
		}
	}
	PlaySound(FireSound,SLOT_Interact);
}

function SpawnMultiProj()
{
}

simulated function FireLProjectile()
{
	if( FireTrail!=None )
		FireTrail.Destroy();
	if ( Level.NetMode!=NM_Client )
		FireProj(GetBoneCoords('lmissile').Origin);
	PlaySound(FireSound,SLOT_Interact);
}

simulated function SpawnLProj()
{
	if( Level.NetMode!=NM_DedicatedServer )
	{
		FireTrail = Spawn(class'ImpHandTrail');
		AttachToBone(FireTrail, 'lmissile');
		//PlaySound(FireBallCreate,SLOT_Interact);
	}
}

simulated function FireRProjectile()
{
	if( FireTrail!=None )
		FireTrail.Destroy();
	if ( Level.NetMode!=NM_Client )
		FireProj(GetBoneCoords('rmissile').Origin);
	PlaySound(FireSound,SLOT_Interact);
}

simulated function SpawnRProj()
{
	if( Level.NetMode!=NM_DedicatedServer )
	{
		FireTrail = Spawn(class'ImpHandTrail');
		AttachToBone(FireTrail,'rmissile');
		//PlaySound(FireBallCreate,SLOT_Interact);
	}
}

simulated function PlaySummonSound()
{
	PlaySound(PreFireSound,SLOT_Talk, 8);
}

simulated function RemoveEffects()
{
	local int i;

	for(i=0;i<8;i++)
	{
		if(Trails[i] != None)
		{
			DetachFromBone(Trails[i]);
			Trails[i].Kill();
		}
	}
}

simulated function FadeSkins()
{
	Skins[1] = FadeFX;
	MakeBurnAway();
}
simulated function BurnAway()
{
	local byte i;

	for(i=0;i<Skins.Length;i++)
		Skins[i] = BurnFX;
	Burning = true;
}
function SetMovementPhysics()
{
	SetPhysics(PHYS_Flying);
}
simulated function AnimEnd( int Channel )
{
	Super.AnimEnd(Channel);
	LoopAnim(MovementAnims[0],,0.1f);
}
simulated function AssignInitialPose()
{
	if ( DrivenVehicle != None )
	{
		if ( HasAnim(DrivenVehicle.DriveAnim) )
			LoopAnim(DrivenVehicle.DriveAnim,, 0.1);
		else
			LoopAnim('Vehicle_Driving',, 0.1);
	}
	else LoopAnim(MovementAnims[0],,0.1f);
	BoneRefresh();
}

defaultproperties
{
     ChestRipSound(0)=Sound'2009DoomMonstersSounds.Hunter.Hunter_chestrip_01'
     ChestRipSound(1)=Sound'2009DoomMonstersSounds.Hunter.Hunter_chestrip_03'
     ChestRipSound(2)=Sound'2009DoomMonstersSounds.Hunter.Hunter_chestrip_04'
     PreFireSound=Sound'2009DoomMonstersSounds.Hunter.Hunter_helltime_summon'
     TeleportSound=Sound'2009DoomMonstersSounds.Hunter.Hunter_helltime_teleport1'
     TeleportStart=Sound'2009DoomMonstersSounds.Hunter.Hunter_helltime_tpstart'
     RangedAttacks(0)="Attack1"
     RangedAttacks(1)="Attack2"
     RangedAttacks(2)="Attack3"
     SpawnSound=Sound'2009DoomMonstersSounds.Hunter.Hunter_helltime_appear'
     DeathAnims(0)="DeathF"
     DeathAnims(1)="DeathB"
     DeathAnims(2)="DeathF"
     DeathAnims(3)="DeathB"
     SightAnim="Sight"
     MinHitAnimDelay=3.000000
     MeleeAttackSounds(0)=Sound'2009DoomMonstersSounds.Hunter.Hunter_attack_01'
     MeleeAttackSounds(1)=Sound'2009DoomMonstersSounds.Hunter.Hunter_attack_07'
     MeleeAttackSounds(2)=Sound'2009DoomMonstersSounds.Hunter.Hunter_attack_09'
     MeleeAttackSounds(3)=Sound'2009DoomMonstersSounds.Hunter.Hunter_attack_11'
     SightSound=Sound'2009DoomMonstersSounds.Hunter.Hunter_sight_01'
     BurningMaterial=Texture'2009DoomMonstersTex.HunterHellTime.HunterHellTimeSkin'
     RangedProjectile=Class'ScrnDoom3KF.HunterHellTimeProjectile'
     DoomTeleportFXClass=Class'ScrnDoom3KF.BossDemonSpawn'
     BurnedTextureNum(0)=1
     bHasFireWeakness=False
     BigMonster=True
     aimerror=10
     BurnAnimTime=0.250000
     MeleeAnims(0)="Attack4"
     MeleeAnims(1)="Attack5"
     MeleeAnims(2)="Attack6"
     MeleeDamage=50
     bBoss=True
     DodgeSkillAdjust=2.000000
     HitSound(0)=Sound'2009DoomMonstersSounds.Hunter.Hunter_pain_01'
     HitSound(1)=Sound'2009DoomMonstersSounds.Hunter.Hunter_pain_02'
     HitSound(2)=Sound'2009DoomMonstersSounds.Hunter.Hunter_pain_06'
     HitSound(3)=Sound'2009DoomMonstersSounds.Hunter.Hunter_pain_08'
     DeathSound(0)=Sound'2009DoomMonstersSounds.Hunter.Hunter_death_03'
     DeathSound(1)=Sound'2009DoomMonstersSounds.Hunter.Hunter_death_05'
     DeathSound(2)=Sound'2009DoomMonstersSounds.Hunter.Hunter_death_03'
     DeathSound(3)=Sound'2009DoomMonstersSounds.Hunter.Hunter_death_05'
     ChallengeSound(0)=Sound'2009DoomMonstersSounds.Hunter.Hunter_helltime_chatter_03'
     ChallengeSound(1)=Sound'2009DoomMonstersSounds.Hunter.Hunter_st_growl_25'
     ChallengeSound(2)=Sound'2009DoomMonstersSounds.Hunter.Hunter_mono_growl_03'
     ChallengeSound(3)=Sound'2009DoomMonstersSounds.Hunter.Hunter_mono_growl_27'
     FireSound=Sound'2009DoomMonstersSounds.Hunter.Hunter_fb_prefire_03'
     ScoringValue=750
     WallDodgeAnims(0)="DodgeL"
     WallDodgeAnims(1)="DodgeR"
     WallDodgeAnims(2)="DodgeL"
     WallDodgeAnims(3)="DodgeR"
     IdleHeavyAnim="Idle"
     IdleRifleAnim="Idle"
     FireHeavyRapidAnim="Idle"
     FireHeavyBurstAnim="Idle"
     FireRifleRapidAnim="Idle"
     FireRifleBurstAnim="Idle"
     bCanJump=False
     bCanFly=True
     bCanStrafe=True
     MeleeRange=70.000000
     GroundSpeed=300.000000
     HealthMax=4500.000000
     Health=4500
     PlayerCountHealthScale=0.75
     HeadRadius=16.000000
     MenuName="HellTime Hunter"
     ControllerClass=Class'ScrnDoom3KF.HunterHellTimeAI'
     bPhysicsAnimUpdate=False
     MovementAnims(0)="Idle"
     MovementAnims(1)="Idle"
     MovementAnims(2)="Idle"
     MovementAnims(3)="Idle"
     TurnLeftAnim="Idle"
     TurnRightAnim="Idle"
     SwimAnims(0)="Idle"
     SwimAnims(1)="Idle"
     SwimAnims(2)="Idle"
     SwimAnims(3)="Idle"
     CrouchAnims(0)="Idle"
     CrouchAnims(1)="Idle"
     CrouchAnims(2)="Idle"
     CrouchAnims(3)="Idle"
     WalkAnims(0)="Idle"
     WalkAnims(1)="Idle"
     WalkAnims(2)="Idle"
     WalkAnims(3)="Idle"
     AirAnims(0)="Idle"
     AirAnims(1)="Idle"
     AirAnims(2)="Idle"
     AirAnims(3)="Idle"
     TakeoffAnims(0)="Idle"
     TakeoffAnims(1)="Idle"
     TakeoffAnims(2)="Idle"
     TakeoffAnims(3)="Idle"
     LandAnims(0)="Idle"
     LandAnims(1)="Idle"
     LandAnims(2)="Idle"
     LandAnims(3)="Idle"
     DoubleJumpAnims(0)="Idle"
     DoubleJumpAnims(1)="Idle"
     DoubleJumpAnims(2)="Idle"
     DoubleJumpAnims(3)="Idle"
     DodgeAnims(0)="DodgeL"
     DodgeAnims(1)="DodgeR"
     AirStillAnim="Idle"
     TakeoffStillAnim="Idle"
     CrouchTurnRightAnim="Idle"
     CrouchTurnLeftAnim="Idle"
     IdleCrouchAnim="Idle"
     IdleSwimAnim="Idle"
     IdleWeaponAnim="Idle"
     IdleRestAnim="Idle"
     IdleChatAnim="Idle"
     HeadBone="Jaw"
     AmbientSound=Sound'2009DoomMonstersSounds.Hunter.Hunter_helltime_flight1'
     Mesh=SkeletalMesh'2009DoomMonstersAnims.HunterHellTimeMesh'
     DrawScale=1.0
     Skins(0)=Texture'2009DoomMonstersTex.HunterHellTime.HunterHellTimeMeat'
     Skins(1)=Combiner'2009DoomMonstersTex.HunterHellTime.JHunterHellTimeSkin'
     SoundVolume=168
     SoundRadius=400.000000
     CollisionRadius=26
     CollisionHeight=44

     bUseExtendedCollision=True
     ColOffset=(Z=30.000000)
     ColRadius=60
     ColHeight=60

     ZapThreshold=2
}
