class Maggot extends DoomMonster;

var(Sounds) Sound RandomDodgeSound[2],Snorts[8],LonelySound[2];
var bool bChargingNow;
var transient float NextLungeTime;
var name RealWalkAnim;
var float ChargeDistance;
var transient float NextChargeTime;
var transient float ChargeEndTime;

replication
{
	reliable if(bNetDirty && Role == ROLE_Authority)
		bChargingNow;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	if( FRand()<0.5f )
		MovementAnims[0] = 'Walk2';
	RealWalkAnim = MovementAnims[0];
	ChargeDistance = (1000.0 + 1000.0*frand()) ** 2;
}

simulated function PostNetReceive()
{
	UpdateAnims();
}

simulated function UpdateAnims()
{
	if (bChargingNow)  {
		MovementAnims[0] = 'Run';
	}
	else {
		MovementAnims[0] = RealWalkAnim;
	}
}

function ZombieMoan()
{
	PlaySound(LonelySound[Rand(2)], SLOT_Talk,8);
}

function RangedAttack(Actor A)
{
	if ( bShotAnim )
		return;

	if (IsInMeleeRange(A)) {
		PrepareStillAttack(A);
		SetAnimAction(MeleeAnims[Rand(3)]);
		return;
	}

	if (NextLungeTime<Level.TimeSeconds && IsInMeleeRange(A, 250.f)) {
		NextLungeTime = Level.TimeSeconds + 2.0 + 4.0*frand();
		if (frand() < 0.7) {
			PrepareStillAttack(A);
			SetAnimAction('Jump_Start');
			Controller.Focus = None;
			Controller.FocalPoint = Normal(A.Location-Location)*10000.f+Location;
			Controller.GoToState('WaitForAnim');
			return;
		} // les try charge
	}

	if (!bChargingNow && VSizeSquared(A.Location-Location) < ChargeDistance) {
		NextChargeTime = Level.TimeSeconds + 5.0 + 5.0*frand();
		GoToState('RunningState');
	}
}

// While enemy is not in reach but still in sight.
function bool ShouldTryRanged( Actor A )
{
	return !bChargingNow && VSizeSquared(A.Location-Location) < 562500.0;
}

state RunningState
{
	function BeginState()
	{
		ChargeEndTime = Level.TimeSeconds + (5.0 + 3.0 * Level.Game.GameDifficulty) * (0.5 + 0.5*frand());
		MaxDesiredSpeed = 2.9f;
		bChargingNow = true;
		UpdateAnims();
	}

	function EndState()
	{
		MaxDesiredSpeed = 1.f;
		bChargingNow = False;
		UpdateAnims();
	}

Begin:
	RoamAtPlayer();
	while( bShotAnim )
		Sleep(0.25);

	while (!bShotAnim && Controller!=None && Controller.Target!=None && Level.TimeSeconds < ChargeEndTime)
	{
		Sleep(0.5);
		MaxDesiredSpeed = 2.9f;
	}
	GoToState('');
}

simulated function AnimEnd(int Channel)
{
	local name N;

	if( Level.NetMode!=NM_Client && bShotAnim )
	{
		N = GetCurrentAnim();
		if( N=='Jump_Start' || N=='Lunge' )
		{
			if( N=='Jump_Start' )
			{
				if( Controller==None || Controller.Target==None )
					Velocity = vector(Rotation)*1200.f;
				else Velocity = Normal(Controller.Target.Location-Location)*1200.f;
				Velocity.Z+=200.f;
				Enable('Bump');
				SetPhysics(PHYS_Falling);
				bLunging = true;
			}
			SetAnimAction('Lunge');
			return;
		}
	}
	Super.AnimEnd(Channel);
}
function Landed(vector HitNormal)
{
	if( Level.NetMode!=NM_Client && bShotAnim && (GetCurrentAnim()=='Jump_Start' || GetCurrentAnim()=='Lunge') )
	{
		bLunging = false;
		SetAnimAction('Jump_End');
		Velocity = vect(0,0,0);
		Acceleration = vect(0,0,0);
		return;
	}
	Super.Landed(HitNormal);
}
singular function Bump(actor Other)
{
	if ( bShotAnim && bLunging && Pawn(Other)!=None && Controller!=None && Other==Controller.Target )
	{
		bLunging = false;
		MeleeDamageTarget(LungeAttackDamage,Velocity*100.f);
	}
	Super.Bump(Other);
}

simulated function PlayDodgeSound()
{
	PlaySound(RandomDodgeSound[Rand(2)], SLOT_Interact,8);
}

simulated function FadeSkins()
{
	Skins[1] = InvisMat;
	Skins[2] = FadeFX;
	MakeBurnAway();
}

simulated function BurnAway()
{
	Skins[0] = InvisMat;
	Skins[1] = BurnFX;
	Skins[2] = BurnFX;
	Skins[3] = InvisMat;
	Burning = true;
}

defaultproperties
{
	RandomDodgeSound(0)=Sound'2009DoomMonstersSounds.Maggot.Maggot_evade_right'
	RandomDodgeSound(1)=Sound'2009DoomMonstersSounds.Maggot.Maggot_evade_left'
	Snorts(0)=Sound'2009DoomMonstersSounds.Maggot.Maggot_melee1'
	Snorts(1)=Sound'2009DoomMonstersSounds.Maggot.Maggot_melee4'
	Snorts(2)=Sound'2009DoomMonstersSounds.Maggot.Maggot_melee2'
	Snorts(3)=Sound'2009DoomMonstersSounds.Maggot.Maggot_melee1h2'
	Snorts(4)=Sound'2009DoomMonstersSounds.Maggot.Maggot_melee3'
	Snorts(5)=Sound'2009DoomMonstersSounds.Maggot.Maggot_melee3h2'
	Snorts(6)=Sound'2009DoomMonstersSounds.Maggot.Maggot_melee2h2'
	Snorts(7)=Sound'2009DoomMonstersSounds.Maggot.Maggot_melee4h2'
	LonelySound(0)=Sound'2009DoomMonstersSounds.Maggot.Maggot_distant_screams_01'
	LonelySound(1)=Sound'2009DoomMonstersSounds.Maggot.Maggot_distant_screams_03'
	LungeAttackDamage=30
	DeathAnims(0)="DeathF"
	DeathAnims(1)="DeathB"
	DeathAnims(2)="DeathF"
	DeathAnims(3)="DeathB"
	SightAnim="Sight"
	HitAnimsX(0)="Pain_L"
	HitAnimsX(1)="Pain_R"
	HitAnimsX(2)="Pain_Chest"
	HitAnimsX(3)="Pain_Chest"
	MeleeAttackSounds(0)=Sound'2009DoomMonstersSounds.Maggot.Maggot_attack_01'
	MeleeAttackSounds(1)=Sound'2009DoomMonstersSounds.Maggot.Maggot_attack_03'
	MeleeAttackSounds(2)=Sound'2009DoomMonstersSounds.Maggot.Maggot_attack_01'
	MeleeAttackSounds(3)=Sound'2009DoomMonstersSounds.Maggot.Maggot_attack_03'
	SightSound=Sound'2009DoomMonstersSounds.Maggot.Maggot_sight_01'
	BurningMaterial=Texture'2009DoomMonstersTex.Maggot.MaggotSkin'
	BurnClass=Class'ScrnDoom3KF.MaggotBurnTex'
	FadeClass=Class'ScrnDoom3KF.MaggotMaterialSequence'
	BurnedTextureNum(0)=2
	HasHitAnims=True
	BurnAnimTime=0.250000
	MeleeAnims(0)="Attack1_New"
	MeleeAnims(1)="Attack2_New"
	MeleeAnims(2)="Attack1"
	MeleeDamage=20
	FootStep(0)=Sound'2009DoomMonstersSounds.Maggot.Maggot_fs_01'
	FootStep(1)=Sound'2009DoomMonstersSounds.Maggot.Maggot_fs_02'
	DodgeSkillAdjust=4.000000
	HitSound(0)=Sound'2009DoomMonstersSounds.Maggot.Maggot_pain_02'
	HitSound(1)=Sound'2009DoomMonstersSounds.Maggot.Maggot_pain_04'
	HitSound(2)=Sound'2009DoomMonstersSounds.Maggot.Maggot_pain_05'
	HitSound(3)=Sound'2009DoomMonstersSounds.Maggot.Maggot_pain_05'
	DeathSound(0)=Sound'2009DoomMonstersSounds.Maggot.Maggot_death_01'
	DeathSound(1)=Sound'2009DoomMonstersSounds.Maggot.Maggot_death_02'
	DeathSound(2)=Sound'2009DoomMonstersSounds.Maggot.Maggot_death_03'
	DeathSound(3)=Sound'2009DoomMonstersSounds.Maggot.Maggot_death_04'
	ChallengeSound(0)=Sound'2009DoomMonstersSounds.Maggot.Maggot_idle_01'
	ChallengeSound(1)=Sound'2009DoomMonstersSounds.Maggot.Maggot_idle_02'
	ChallengeSound(2)=Sound'2009DoomMonstersSounds.Maggot.Maggot_hiss3h2'
	ChallengeSound(3)=Sound'2009DoomMonstersSounds.Maggot.Maggot_idle_03'
	ScoringValue=20
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
	RagdollOverride="D3Maggot"
	MeleeRange=80.000000
	GroundSpeed=100.000000
	HealthMax=350.000000
	Health=350
	MenuName="Maggot"
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
	AirAnims(0)="Lunge"
	AirAnims(1)="Lunge"
	AirAnims(2)="Lunge"
	AirAnims(3)="Lunge"
	TakeoffAnims(0)="Jump_Start"
	TakeoffAnims(1)="Jump_Start"
	TakeoffAnims(2)="Jump_Start"
	TakeoffAnims(3)="Jump_Start"
	LandAnims(0)="Jump_End"
	LandAnims(1)="Jump_End"
	LandAnims(2)="Jump_End"
	LandAnims(3)="Jump_End"
	DoubleJumpAnims(0)="Jump_Start"
	DoubleJumpAnims(1)="Jump_Start"
	DoubleJumpAnims(2)="Jump_Start"
	DoubleJumpAnims(3)="Jump_Start"
	DodgeAnims(0)="DodgeL"
	DodgeAnims(1)="DodgeR"
	AirStillAnim="Lunge"
	TakeoffStillAnim="Jump_Start"
	CrouchTurnRightAnim="Walk"
	CrouchTurnLeftAnim="Walk"
	IdleCrouchAnim="Idle"
	IdleSwimAnim="Idle"
	IdleWeaponAnim="Idle"
	IdleRestAnim="Idle"
	IdleChatAnim="Idle"
	Mesh=SkeletalMesh'2009DoomMonstersAnims.MaggotMesh'
	Skins(0)=Shader'2009DoomMonstersTex.Maggot.Skin0'
	Skins(1)=Shader'2009DoomMonstersTex.Maggot.TongueShader'
	Skins(2)=Combiner'2009DoomMonstersTex.Maggot.JMaggotSkin'
	Skins(3)=Shader'2009DoomMonstersTex.Maggot.EyeShader'
	CollisionRadius=24.000000
	CollisionHeight=30.000000
	bUseExtendedCollision=True
	ColOffset=(Y=0,Z=0)
	ColRadius=45.000000
	ColHeight=30.000000

	MotionDetectorThreat=0.50 //5.14

	HeadBone="Rhead" //7.00
	HeadBone2="Lhead" //8.11
	HeadRadius=12
	ZappedDamageMod=1.5
}
