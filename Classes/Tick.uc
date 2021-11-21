class Tick extends DoomMonster;

var bool bLunging;
var transient float NextLungeTime;
var() byte LungeAttackDamage;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if( FRand()<0.33f )
		MovementAnims[0] = 'Walk2';
	else if( FRand()<0.33f )
		MovementAnims[0] = 'Walk3';
}
function RangedAttack(Actor A)
{
	if ( bShotAnim )
		return;

	if( !bHasRoamed )
		RoamAtPlayer();
	else if( IsInMeleeRange(A) )
	{
		PrepareStillAttack(A);
		SetAnimAction(MeleeAnims[Rand(2)]);
	}
	else if( NextLungeTime<Level.TimeSeconds && IsInMeleeRange(A,120.f) )
	{
		NextLungeTime = Level.TimeSeconds+2.f+FRand()*2.f;
		if( FRand()<0.5f )
			return;
		PrepareStillAttack(A);
		SetAnimAction('Jump_Start');
		Controller.Focus = None;
		Controller.FocalPoint = Normal(A.Location-Location)*10000.f+Location;
		Controller.GoToState('WaitForAnim');
	}
}

simulated function AnimEnd(int Channel)
{
	if( Level.NetMode!=NM_Client && bShotAnim && GetCurrentAnim()=='Jump_Start' )
	{
		if( Controller==None || Controller.Target==None )
			Velocity = vector(Rotation)*700.f;
		else Velocity = Normal(Controller.Target.Location-Location)*700.f;
		Velocity.Z+=260.f;
		Enable('Bump');
		SetPhysics(PHYS_Falling);
		bLunging = true;
		SetAnimAction(AirStillAnim);
		return;
	}
	Super.AnimEnd(Channel);
}
function Landed(vector HitNormal)
{
	if( bLunging )
	{
		bLunging = false;
		bShotAnim = false;
	}
	Super.Landed(HitNormal);
}
singular function Bump(actor Other)
{
	if ( Level.NetMode!=NM_Client && bLunging && Pawn(Other)!=None && Controller!=None && Other==Controller.Target )
	{
		bLunging = false;
		MeleeDamageTarget(LungeAttackDamage,Velocity*30.f);
	}
	Super.Bump(Other);
}

// function SetOverlayMaterial(Material mat, float time, bool bOverride);

simulated function FadeSkins()
{
}

simulated function BurnAway()
{
}

simulated function SpawnSparksFX()
{
}

simulated function ZombieCrispUp()
{
	bAshen = true;
	bCrispified = true;

	SetBurningBehavior();

	if ( Level.NetMode == NM_DedicatedServer || class'GameInfo'.static.UseLowGore() )
		Return;

	Skins[1] = Texture'TickLeg_burned';
	Skins[2] = Texture'TickSkin2_burned';
}

defaultproperties
{
	LungeAttackDamage=15
	DeathAnims(0)="DeathF"
	DeathAnims(1)="DeathB"
	DeathAnims(2)="DeathF"
	DeathAnims(3)="DeathB"
	SightAnim="Sight"
	HitAnimsX(0)="Pain_L"
	HitAnimsX(1)="Pain_R"
	HitAnimsX(2)="Pain_Head"
	HitAnimsX(3)="Pain_Head"
	MeleeAttackSounds(0)=Sound'2009DoomMonstersSounds.Tick.Tick_chirp1'
	MeleeAttackSounds(1)=Sound'2009DoomMonstersSounds.Tick.Tick_chirp2'
	MeleeAttackSounds(2)=Sound'2009DoomMonstersSounds.Tick.Tick_chirp3'
	MeleeAttackSounds(3)=Sound'2009DoomMonstersSounds.Tick.Tick_chirp4'
	SightSound=Sound'2009DoomMonstersSounds.Tick.tick_sight1'
	HasHitAnims=True
	MeleeAnims(0)="Attack1"
	MeleeAnims(1)="Attack2"
	MeleeDamage=10
	FootStep(0)=Sound'2009DoomMonstersSounds.Tick.tick_walk1'
	FootStep(1)=Sound'2009DoomMonstersSounds.Tick.tick_walk2'
	DodgeSkillAdjust=4.000000
	HitSound(0)=Sound'2009DoomMonstersSounds.Tick.tick_pain1'
	HitSound(1)=Sound'2009DoomMonstersSounds.Tick.tick_pain2'
	HitSound(2)=Sound'2009DoomMonstersSounds.Tick.tick_pain3'
	HitSound(3)=Sound'2009DoomMonstersSounds.Tick.tick_pain4'
	DeathSound(0)=Sound'2009DoomMonstersSounds.Tick.tick_death1'
	DeathSound(1)=Sound'2009DoomMonstersSounds.Tick.tick_death2'
	DeathSound(2)=Sound'2009DoomMonstersSounds.Tick.tick_death3'
	DeathSound(3)=Sound'2009DoomMonstersSounds.Tick.tick_death3'
	ChallengeSound(0)=Sound'2009DoomMonstersSounds.Tick.tick_sight2'
	ChallengeSound(1)=Sound'2009DoomMonstersSounds.Tick.tick_sight3'
	ChallengeSound(2)=Sound'2009DoomMonstersSounds.Tick.Tick_chirp5'
	ChallengeSound(3)=Sound'2009DoomMonstersSounds.Tick.Tick_chirp6'
	ScoringValue=10
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
	MeleeRange=20.000000
	GroundSpeed=110.000000
	Mass=20
	HealthMax=90.000000
	Health=90
	HeadRadius=15.000000
	MenuName="Tick"
	MovementAnims(0)="Walk1"
	MovementAnims(1)="Walk1"
	MovementAnims(2)="Walk1"
	MovementAnims(3)="Walk1"
	TurnLeftAnim="Walk2"
	TurnRightAnim="Walk2"
	SwimAnims(0)="Walk1"
	SwimAnims(1)="Walk1"
	SwimAnims(2)="Walk1"
	SwimAnims(3)="Walk1"
	CrouchAnims(0)="Walk3"
	CrouchAnims(1)="Walk3"
	CrouchAnims(2)="Walk3"
	CrouchAnims(3)="Walk3"
	WalkAnims(0)="Walk1"
	WalkAnims(1)="Walk1"
	WalkAnims(2)="Walk1"
	WalkAnims(3)="Walk1"
	AirAnims(0)="Jump_Mid"
	AirAnims(1)="Jump_Mid"
	AirAnims(2)="Jump_Mid"
	AirAnims(3)="Jump_Mid"
	TakeoffAnims(0)="Jump_Start"
	TakeoffAnims(1)="Jump_Start"
	TakeoffAnims(2)="Jump_Start"
	TakeoffAnims(3)="Jump_Start"
	LandAnims(0)="Jump_Mid"
	LandAnims(1)="Jump_Mid"
	LandAnims(2)="Jump_Mid"
	LandAnims(3)="Jump_Mid"
	DoubleJumpAnims(0)="Jump_Start"
	DoubleJumpAnims(1)="Jump_Start"
	DoubleJumpAnims(2)="Jump_Start"
	DoubleJumpAnims(3)="Jump_Start"
	DodgeAnims(0)="DodgeL"
	DodgeAnims(1)="DodgeR"
	AirStillAnim="Jump_Mid"
	TakeoffStillAnim="Jump_Start"
	CrouchTurnRightAnim="Walk3"
	CrouchTurnLeftAnim="Walk3"
	IdleCrouchAnim="Idle"
	IdleSwimAnim="Idle"
	IdleWeaponAnim="Idle"
	IdleRestAnim="Idle"
	IdleChatAnim="Idle"
	Mesh=SkeletalMesh'2009DoomMonstersAnims.TickMesh'
	Skins(0)=Texture'2009DoomMonstersTex.Revenant.InvisMat'
	Skins(1)=Shader'2009DoomMonstersTex.Tick.TickLegShader'
	Skins(2)=Texture'2009DoomMonstersTex.Tick.TickSkin2'
	CollisionHeight=20.000000

	MotionDetectorThreat=0.25 //5.14
	FireRootBone="Body2"

	ZappedDamageMod=2.0
	ZapThreshold=0.25
}
