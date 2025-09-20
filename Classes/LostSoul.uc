class LostSoul extends DoomMonster;

var Emitter LostTrail;
var(Sounds) Sound ChargeSound;
var bool bCharging;
var() int ChargeHitDamage;
var(Anims) array<name> ChargeAnims;
var transient float NextChargeTime;

replication
{
	reliable if(bNetDirty && Role == ROLE_Authority)
		bCharging;
}

simulated function PostBeginPlay()
{
	local Rotator Rot;

	Super.PostBeginPlay();

 	if ( Level.NetMode != NM_DedicatedServer )
	{
		Rot.Roll = -16384;
		LostTrail = Spawn(class'LostSoulTrailEffect',Self);
		AttachToBone(LostTrail, 'LostFlame');
		LostTrail.SetRelativeRotation(Rot);
		LostTrail.SetRelativeLocation(vect(-5,0,0));
	}
}

function RangedAttack(Actor A)
{
	if ( bShotAnim )
		return;
	if( IsInMeleeRange(A) )
	{
		PrepareStillAttack(A);
		SetAnimAction(MeleeAnims[Rand(2)]);
	}
}
function bool ReadyToCharge( Actor A )
{
	local float DistSq;

	if( NextChargeTime>Level.TimeSeconds )
		return false;
	DistSq = VSizeSquared(A.Location-Location);
	if( DistSq>1000000.f || DistSq<10000.f )
		return false;
	bCharging = true;
	AirSpeed = 850;
	PlaySound(ChargeSound,SLOT_Talk,1.7f);
	if( ChargeAnims.Length==1 )
		SetAnimAction(ChargeAnims[0]);
	else SetAnimAction(ChargeAnims[Rand(ChargeAnims.Length)]);
	NextChargeTime = Level.TimeSeconds+3.f+FRand()*3.f;
	return true;
}
function EndCharge()
{
	Velocity = vect(0,0,0);
	bCharging = false;
	AirSpeed = Default.AirSpeed;
}

simulated function PlayDirectionalDeath(Vector HitLoc)
{
	LifeSpan = 0.6f;

	if( Level.NetMode!=NM_DedicatedServer )
	{
		Spawn(class'LostSoulExplosion');
		Spawn(class'LostSoulExplodeDust');
	}
	bHidden = true;
	if(LostTrail != None)
		LostTrail.Kill();
}

simulated function Destroyed()
{
	if(LostTrail != None)
		LostTrail.Kill();
	Super.Destroyed();
}

function SetMovementPhysics()
{
	SetPhysics(PHYS_Flying);
}

singular function Falling()
{
	SetPhysics(PHYS_Flying);
}

simulated function PlayChargeSound()
{
}

// function SetOverlayMaterial(Material mat, float time, bool bOverride);

simulated function AnimEnd( int Channel )
{
	Super.AnimEnd(Channel);
	if( bCharging )
		PlayAnim(ChargeAnims[Rand(ChargeAnims.Length)]);
	else LoopAnim(MovementAnims[0],,0.1f);
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
function bool IsHeadShot(vector loc, vector ray, float AdditionalScale)
{
	return true;
}

defaultproperties
{
	ChargeSound=Sound'2009DoomMonstersSounds.LostSoul.LostSoul_charge_01'
	ChargeHitDamage=15
	ChargeAnims(0)="Charge"
	SightAnim="Sight"
	HitAnimsX(0)="Pain"
	HitAnimsX(1)="pain2"
	MeleeAttackSounds(0)=Sound'2009DoomMonstersSounds.LostSoul.LostSoul_attack_02'
	MeleeAttackSounds(1)=Sound'2009DoomMonstersSounds.LostSoul.LostSoul_attack_02'
	MeleeAttackSounds(2)=Sound'2009DoomMonstersSounds.LostSoul.LostSoul_attack_02'
	MeleeAttackSounds(3)=Sound'2009DoomMonstersSounds.LostSoul.LostSoul_attack_02'
	SightSound=Sound'2009DoomMonstersSounds.LostSoul.LostSoul_sight_01'
	DoomTeleportFXClass=Class'ScrnDoom3KF.DemonSpawnB'
	BurnedTextureNum(0)=1
	HasHitAnims=True
	MeleeAnims(0)="Attack1"
	MeleeAnims(1)="Attack2"
	MeleeDamage=19
	DodgeSkillAdjust=4.000000
	HitSound(0)=Sound'2009DoomMonstersSounds.LostSoul.LostSoul_pain_01'
	HitSound(1)=Sound'2009DoomMonstersSounds.LostSoul.LostSoul_pain_02'
	HitSound(2)=Sound'2009DoomMonstersSounds.LostSoul.LostSoul_pain_01'
	HitSound(3)=Sound'2009DoomMonstersSounds.LostSoul.LostSoul_pain_02'
	DeathSound(0)=Sound'2009DoomMonstersSounds.LostSoul.LostSoul_death_01'
	DeathSound(1)=Sound'2009DoomMonstersSounds.LostSoul.LostSoul_death_02'
	DeathSound(2)=Sound'2009DoomMonstersSounds.LostSoul.LostSoul_death_04'
	DeathSound(3)=Sound'2009DoomMonstersSounds.LostSoul.LostSoul_death_04'
	ChallengeSound(0)=Sound'2009DoomMonstersSounds.LostSoul.LostSoul_chatter_01'
	ChallengeSound(1)=Sound'2009DoomMonstersSounds.LostSoul.LostSoul_chatter_02'
	ChallengeSound(2)=Sound'2009DoomMonstersSounds.LostSoul.LostSoul_sight_02'
	ChallengeSound(3)=Sound'2009DoomMonstersSounds.LostSoul.LostSoul_sight_03'
	ScoringValue=15
	WallDodgeAnims(0)="Walk"
	WallDodgeAnims(1)="Walk"
	WallDodgeAnims(2)="Walk"
	WallDodgeAnims(3)="Walk"
	IdleHeavyAnim="Walk"
	IdleRifleAnim="Walk"
	FireHeavyRapidAnim="Walk"
	FireHeavyBurstAnim="Walk"
	FireRifleRapidAnim="Walk"
	FireRifleBurstAnim="Walk"
	bCanFly=True
	bCanStrafe=True
	MeleeRange=40.000000
	GroundSpeed=400.000000
	AirSpeed=280.000000
	HealthMax=140.000000
	Health=140
	MenuName="Lost Soul"
	ControllerClass=Class'ScrnDoom3KF.LostSoulAI'
	bPhysicsAnimUpdate=False
	MovementAnims(0)="Walk"
	MovementAnims(1)="Walk"
	MovementAnims(2)="Walk"
	MovementAnims(3)="Walk"
	TurnLeftAnim="Walk"
	TurnRightAnim="Walk"
	SwimAnims(0)="Walk"
	SwimAnims(1)="Walk"
	SwimAnims(2)="Walk"
	SwimAnims(3)="Walk"
	CrouchAnims(0)="Walk"
	CrouchAnims(1)="Walk"
	CrouchAnims(2)="Walk"
	CrouchAnims(3)="Walk"
	WalkAnims(0)="Walk"
	WalkAnims(1)="Walk"
	WalkAnims(2)="Walk"
	WalkAnims(3)="Walk"
	AirAnims(0)="Walk"
	AirAnims(1)="Walk"
	AirAnims(2)="Walk"
	AirAnims(3)="Walk"
	TakeoffAnims(0)="Walk"
	TakeoffAnims(1)="Walk"
	TakeoffAnims(2)="Walk"
	TakeoffAnims(3)="Walk"
	LandAnims(0)="Walk"
	LandAnims(1)="Walk"
	LandAnims(2)="Walk"
	LandAnims(3)="Walk"
	DoubleJumpAnims(0)="Walk"
	DoubleJumpAnims(1)="Walk"
	DoubleJumpAnims(2)="Walk"
	DoubleJumpAnims(3)="Walk"
	DodgeAnims(0)="Walk"
	DodgeAnims(1)="Walk"
	DodgeAnims(2)="Walk"
	DodgeAnims(3)="Walk"
	AirStillAnim="Walk"
	TakeoffStillAnim="Walk"
	CrouchTurnRightAnim="Walk"
	CrouchTurnLeftAnim="Walk"
	IdleCrouchAnim="Walk"
	IdleSwimAnim="Walk"
	IdleWeaponAnim="Walk"
	IdleRestAnim="Walk"
	IdleChatAnim="Walk"
	AmbientSound=Sound'2009DoomMonstersSounds.LostSoul.LostSoul_idle_01'
	Mesh=SkeletalMesh'2009DoomMonstersAnims.LostSoulMesh'
	DrawScale=1.700000
	Skins(0)=Shader'2009DoomMonstersTex.Lost.LostTeethShader'
	Skins(1)=Combiner'2009DoomMonstersTex.Lost.JLostSkin'
	Skins(2)=Combiner'2009DoomMonstersTex.Lost.JLostSkin'
	CollisionRadius=17.000000
	CollisionHeight=20.000000

	MotionDetectorThreat=0.25 //5.14
	MinHeadShotDamageMult=1.0 //9.20
	RootBone="head"

	ZapThreshold=0.25
	ZappedDamageMod=2.0
}
