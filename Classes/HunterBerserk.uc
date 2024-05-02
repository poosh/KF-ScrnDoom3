 class HunterBerserk extends DoomBoss;

var transient float NextRangedAttackTime,NextChestOpenTime,NextRageTime;
var HunterChargeEffect ChargeEffect;
var HunterMainEffect BodyEffect;
var Sound ChestRipSound[3];
var Sound PreFireSound;
var bool bIsRageMode,bClientRageAnim;
var HunterBerserkEffect ChargingFX;
var transient float ChestOpenedUntil;

replication
{
	reliable if( Role == ROLE_Authority )
		bIsRageMode;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	if( Level.NetMode!=NM_DedicatedServer )
	{
		BodyEffect = Spawn(class'HunterMainEffect',self);
		AttachToBone(BodyEffect,'heart1');
	}
	bHasRoamed = false;
}
simulated function PostNetReceive()
{
	if( bIsRageMode!=bClientRageAnim )
		SetRageAnimations();
}
function RangedAttack(Actor A)
{
	local float h;

	if ( bShotAnim )
		return;

	h = float(Health) / HealthMax;

	if( !bHasRoamed ) {
		RoamAtPlayer();
		bIsRageMode = true;
		SetRageAnimations();
		NextRageTime = Level.TimeSeconds + 6.0 + frand()*5.f;
	}
	else if( IsInMeleeRange(A) && MaxMeleeAttacks > 0 ) {
		PrepareStillAttack(A);
		--MaxMeleeAttacks;
		if( bIsRageMode ) {
			// rage mode does double damage, so counts as two melee attacks
			--MaxMeleeAttacks;
			MeleeAttack();
			SetAnimAction(MeleeAnims[1]);
		}
		else if( frand() < 0.2f ) {
			MakeStrafeStep();
		}
		else {
			SetAnimAction(MeleeAnims[0]);
		}
	}
	else if( bIsRageMode ) {
		if( Level.TimeSeconds > NextRageTime ) {
			NextRageTime = Level.TimeSeconds + 3.0 + 6.0*h + 3.0*frand();
			PrepareStillAttack(A);
			SetAnimAction('Pain3');
			bIsRageMode = false;
			SetRageAnimations();
		}
		else if( Level.TimeSeconds > NextRangedAttackTime && VSizeSquared(A.Location-Location) < 90000.f ) {
			NextRangedAttackTime = Level.TimeSeconds + 2.0 + 3.0*frand();
			PrepareMovingAttack(A,-0.7);
			SetAnimAction('JumpStart');
			MaxMeleeAttacks = max(MaxMeleeAttacks, 2);
		}
		// else continue roaming
	}
	else if( Level.TimeSeconds > NextChestOpenTime ) {
		NextChestOpenTime = Level.TimeSeconds + 4.0 + 6.0*frand();
		PrepareStillAttack(A);
		PlaySound(PreFireSound,SLOT_Interact);
		SetAnimAction('Attack2');
		ChestOpenedUntil = Level.TimeSeconds + 2.15;
		MaxMeleeAttacks = default.MaxMeleeAttacks;
	}
	else if( Level.TimeSeconds > NextRageTime ) {
		NextRageTime = Level.TimeSeconds + 5.0 - 4.0*h + 3.0*frand();
		RoamAtPlayer();
		bIsRageMode = true;
		SetRageAnimations();
		MaxMeleeAttacks = default.MaxMeleeAttacks;
	}
	else if ( frand() < 0.6 ) {
		MakeStrafeStep();
	}
	else {
		RoamAtPlayer();
		NextRageTime = Level.TimeSeconds;
	}
}

function RoamAtPlayer()
{
	super.RoamAtPlayer();
	ChestOpenedUntil = Level.TimeSeconds + 1.0;
}

function bool ShouldTryRanged( Actor A )
{
	return Level.TimeSeconds > NextRangedAttackTime || Level.TimeSeconds > NextChestOpenTime;
}

function bool ShouldChargeAtPlayer()
{
	return bIsRageMode;
}

simulated function AnimEnd(int Channel)
{
	if( Level.NetMode!=NM_Client && bShotAnim && GetCurrentAnim()=='JumpStart' )
	{
		SetAnimAction(AirStillAnim);
		if( Controller.Target==None )
			Velocity = vector(Rotation)*1400.f;
		else Velocity = Normal(Controller.Target.Location-Location)*1400.f;
		Controller.FocalPoint = Velocity*5.f+Location;
		Controller.Focus = None;
		Velocity.Z = FMax(Velocity.Z,220.f);
		SetPhysics(PHYS_Falling);
		return;
	}
	else if( bLunging && Physics==PHYS_Falling )
		return; // Keep animating...
	Super.AnimEnd(Channel);
}
simulated function SetAnimAction(name NewAction)
{
	if( NewAction=='JumpStart' )
		bLunging = true;
	if( NewAction==SightAnim && Level.NetMode!=NM_DedicatedServer )
	{
		if( ChargingFX!=None )
			ChargingFX.OwnerGone();
		ChargingFX = Spawn(Class'HunterBerserkEffect',Self);
	}
	Super.SetAnimAction(NewAction);
}
singular function Bump(actor Other)
{
	if( Level.NetMode!=NM_Client && bLunging && Controller!=None && Other==Controller.Target )
	{
		MeleeDamageTarget(LungeAttackDamage,Velocity*100.f);
		Velocity = vect(0,0,-50.f);
	}
	Super.Bump(Other);
}

simulated function Landed(vector HitNormal)
{
	if( bLunging )
	{
		PlayAnim('JumpEnd');
		bLunging = false;
		return;
	}
	Super.Landed(HitNormal);
}

simulated function SetRageAnimations()
{
	local byte i;

	if( bClientRageAnim==bIsRageMode )
		return;
	bClientRageAnim = bIsRageMode;
	if( bIsRageMode )
	{
		MeleeDamage*=2;
		OriginalGroundSpeed*=1.5;
		GroundSpeed = OriginalGroundSpeed;
	}
	else
	{
		MeleeDamage = Default.MeleeDamage;
		OriginalGroundSpeed = Default.GroundSpeed;
		GroundSpeed = Default.GroundSpeed;
	}
	if( Level.NetMode==NM_DedicatedServer )
		return;

	if( bIsRageMode )
	{
		for( i=0; i<4; ++i )
		{
			WalkAnims[i] = 'Charge';
			MovementAnims[i] = 'Charge';
		}
		IdleWeaponAnim = 'Idle2';
		IdleRestAnim = 'Idle2';
		TurnLeftAnim = 'Idle2';
		TurnRightAnim = 'Idle2';
	}
	else
	{
		for( i=0; i<4; ++i )
		{
			WalkAnims[i] = Default.WalkAnims[i];
			MovementAnims[i] = Default.MovementAnims[i];
		}
		IdleWeaponAnim = Default.IdleWeaponAnim;
		IdleRestAnim = Default.IdleRestAnim;
		TurnLeftAnim = Default.TurnLeftAnim;
		TurnRightAnim = Default.TurnRightAnim;
	}
}

function MakeStrafeStep()
{
	local vector X,Y,Z;

	PlaySound(Sound'Hunter_berzerker_evade1',SLOT_Talk);
	GetAxes(Rotation,X,Y,Z);
	bShotAnim = true;
	Controller.Focus = None;
	Controller.FocalPoint = Location+X*8000.f;
	Controller.MoveTarget = None;
	if( FRand()<0.5f )
	{
		SetAnimAction('DodgeL');
		Acceleration = Y*GroundSpeed*-0.8f;
	}
	else
	{
		SetAnimAction('DodgeR');
		Acceleration = Y*GroundSpeed*0.8f;
	}
}

simulated function FireProjectile()
{
	bIsRageMode = false; // No longer vulnerable.
	if( Level.NetMode!=NM_DedicatedServer )
		PlaySound(FireSound,SLOT_Interact);
	if( Level.NetMode!=NM_Client )
		FireProj(GetBoneCoords('mouth').Origin);
}

function SpawnProj()
{
}

simulated function SpawnAttackEffect()
{
	if( Level.NetMode!=NM_DedicatedServer )
	{
		ChargeEffect = Spawn(class'HunterChargeEffect',self,,);
		AttachToBone(ChargeEffect,'mouth');
	}
}

simulated function ChestRip()
{
	bIsRageMode = true; // Make temp vulnerable.
	if( Level.NetMode!=NM_DedicatedServer )
		PlaySound(ChestRipSound[Rand(3)],SLOT_Talk,8);
}

simulated function RemoveEffects()
{
	if(BodyEffect != None)
	{
		DetachFromBone(BodyEffect);
		BodyEffect.Kill();
	}
	if(ChargeEffect != None)
	{
		DetachFromBone(ChargeEffect);
		ChargeEffect.Kill();
	}
	if( ChargingFX!=None )
		ChargingFX.OwnerGone();
}

simulated function FadeSkins()
{
	Skins[0] = FadeFX;
	MakeBurnAway();
}

simulated function BurnAway()
{
	Skins[0] = BurnFX;
	Skins[1] = BurnFX;
	Skins[2] = BurnFX;
	Burning = true;
}

function TakeDamage( int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex )
{
	local int OldHealth;

	if ( Damage > 0) {
		if( !IsHeadShot(HitLocation,Normal(Momentum),1.f) )
			Damage *= 0.5; // 50% damage resistance to body damage
		else if( bLunging || Level.TimeSeconds < ChestOpenedUntil )
			Damage *= 2.5; // shot in the opened chest
		else
			Damage *= 0.75; // 25% damage resistance to the closed chest
	}
	OldHealth = Health;
	Super.TakeDamage(Damage,InstigatedBy,HitLocation,Momentum,DamageType,HitIndex);
	// strong headshots stop hunter in midair
	if ( bLunging && OldHealth - Health >= 666 ) {
		if (bIsRageMode) {
			NextRageTime = 0;  // stop raging
		}
		Velocity = vect(0, 0, -50);
	}
}

function bool IsHeadShot(vector loc, vector ray, float AdditionalScale)
{
	local vector M,diff;
	local float t,DotMM,Distance;
	local Coords C;

	// If we are a dedicated server estimate what animation is most likely playing on the client
	if( Level.NetMode==NM_DedicatedServer && !IsAnimating() )
	{
		if (Physics == PHYS_Falling)
			PlayAnim(AirAnims[0], 1.0, 0.0);
		else if( DesiredSpeed==0.f )
			PlayAnim(IdleRestAnim, 1.0, 0.0);
		else PlayAnim(MovementAnims[0], 1.0, 0.0);
		SetAnimFrame(0.5);
	}
	C = GetBoneCoords(HeadBone);

	if( (C.XAxis Dot ray)>-0.09f )
		return false;

	// Express snipe trace line in terms of B + tM
	M = ray * (6.0 * CollisionHeight + 6.0 * CollisionRadius);

	// Find Point-Line Squared Distance
	diff = C.Origin - loc;
	t = M Dot diff;
	if (t > 0)
	{
		DotMM = M dot M;
		if (t < DotMM)
		{
			t = t / DotMM;
			diff = diff - (t * M);
		}
		else
		{
			t = 1;
			diff -= M;
		}
	}
	Distance = Sqrt(diff Dot diff);
	if ( bLunging )
		return Distance < 2.0 * HeadRadius * HeadScale * AdditionalScale;

	return (Distance < (HeadRadius * HeadScale * AdditionalScale));
}

/*function Tick( float Delta )
{
	local Coords C;

	Super.Tick(Delta);
	C = GetBoneCoords(HeadBone);
	DrawDebugLine(C.Origin,C.Origin+C.XAxis*128.f,255,0,0);
	DrawDebugLine(C.Origin,C.Origin+C.YAxis*128.f,0,255,0);
	DrawDebugLine(C.Origin,C.Origin+C.ZAxis*128.f,0,0,255);
}*/

defaultproperties
{
	 LungeAttackDamage=35
	 ChestRipSound(0)=Sound'2009DoomMonstersSounds.Hunter.Hunter_chestrip_01'
	 ChestRipSound(1)=Sound'2009DoomMonstersSounds.Hunter.Hunter_chestrip_03'
	 ChestRipSound(2)=Sound'2009DoomMonstersSounds.Hunter.Hunter_chestrip_04'
	 PreFireSound=Sound'2009DoomMonstersSounds.Hunter.Hunter_fb_prefire_01'
	 DeathAnims(0)="DeathF"
	 DeathAnims(1)="DeathB"
	 DeathAnims(2)="DeathF"
	 DeathAnims(3)="DeathB"
	 SightAnim="Rage"
	 HitAnimsX(0)="Pain"
	 HitAnimsX(1)="Pain"
	 HitAnimsX(2)="Pain"
	 HitAnimsX(3)="Pain"
	 MinHitAnimDelay=3.000000
	 MeleeAttackSounds(0)=Sound'2009DoomMonstersSounds.Hunter.Hunter_attack_01'
	 MeleeAttackSounds(1)=Sound'2009DoomMonstersSounds.Hunter.Hunter_attack_07'
	 MeleeAttackSounds(2)=Sound'2009DoomMonstersSounds.Hunter.Hunter_attack_09'
	 MeleeAttackSounds(3)=Sound'2009DoomMonstersSounds.Hunter.Hunter_attack_11'
	 SightSound=Sound'2009DoomMonstersSounds.Hunter.Hunter_sight_01'
	 FadeClass=Class'ScrnDoom3KF.HunterBerserkMaterialSequence'
	 RangedProjectile=Class'ScrnDoom3KF.HunterProjectile'
	 DoomTeleportFXClass=Class'ScrnDoom3KF.BossDemonSpawn'
	 HasHitAnims=True
	 BigMonster=True
	 aimerror=50
	 BurnAnimTime=0.250000
	 MeleeAnims(0)="Attack1"
	 MeleeAnims(1)="Attack3"
	 MeleeDamage=23
	 bFatAss=True
	 FootStep(0)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_step1'
	 FootStep(1)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_step1'
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
	 ChallengeSound(0)=Sound'2009DoomMonstersSounds.Hunter.Hunter_mono_growl_25'
	 ChallengeSound(1)=Sound'2009DoomMonstersSounds.Hunter.Hunter_st_growl_25'
	 ChallengeSound(2)=Sound'2009DoomMonstersSounds.Hunter.Hunter_mono_growl_03'
	 ChallengeSound(3)=Sound'2009DoomMonstersSounds.Hunter.Hunter_mono_growl_27'
	 FireSound=Sound'2009DoomMonstersSounds.Hunter.Hunter_fb_prefire_03'
	 WallDodgeAnims(0)="DodgeL"
	 WallDodgeAnims(1)="DodgeR"
	 WallDodgeAnims(2)="DodgeL"
	 WallDodgeAnims(3)="DodgeR"
	 IdleHeavyAnim="Idle"
	 IdleRifleAnim="Idle"
	 FireHeavyRapidAnim="Run"
	 FireHeavyBurstAnim="Run"
	 FireRifleRapidAnim="Run"
	 FireRifleBurstAnim="Run"
	 bCanJump=False
	 MeleeRange=100.000000
	 GroundSpeed=400.000000
	 HealthMax=5000
	 Health=5000
	 HeadRadius=21.000000
	 MenuName="Berserk Hunter"
	 MovementAnims(0)="Run"
	 MovementAnims(1)="Run"
	 MovementAnims(2)="Run"
	 MovementAnims(3)="Run"
	 TurnLeftAnim="Idle"
	 TurnRightAnim="Idle"
	 SwimAnims(0)="Run"
	 SwimAnims(1)="Run"
	 SwimAnims(2)="Run"
	 SwimAnims(3)="Run"
	 CrouchAnims(0)="Run"
	 CrouchAnims(1)="Run"
	 CrouchAnims(2)="Run"
	 CrouchAnims(3)="Run"
	 WalkAnims(0)="Run"
	 WalkAnims(1)="Run"
	 WalkAnims(2)="Run"
	 WalkAnims(3)="Run"
	 AirAnims(0)="JumpMiddle"
	 AirAnims(1)="JumpMiddle"
	 AirAnims(2)="JumpMiddle"
	 AirAnims(3)="JumpMiddle"
	 TakeoffAnims(0)="JumpMiddle"
	 TakeoffAnims(1)="JumpMiddle"
	 TakeoffAnims(2)="JumpMiddle"
	 TakeoffAnims(3)="JumpMiddle"
	 LandAnims(0)="Run"
	 LandAnims(1)="Run"
	 LandAnims(2)="Run"
	 LandAnims(3)="Run"
	 DoubleJumpAnims(0)="Run"
	 DoubleJumpAnims(1)="Run"
	 DoubleJumpAnims(2)="Run"
	 DoubleJumpAnims(3)="Run"
	 DodgeAnims(0)="DodgeL"
	 DodgeAnims(1)="DodgeR"
	 AirStillAnim="JumpMiddle"
	 TakeoffStillAnim="Run"
	 CrouchTurnRightAnim="Run"
	 CrouchTurnLeftAnim="Run"
	 IdleCrouchAnim="Idle"
	 IdleSwimAnim="Idle"
	 IdleWeaponAnim="Idle"
	 IdleRestAnim="Idle"
	 IdleChatAnim="Idle"
	 HeadBone="heart1"
	 Mesh=SkeletalMesh'2009DoomMonstersAnims.HunterBerserkMesh'
	 DrawScale=1.0
	 PrePivot=(Z=5)
	 Skins(0)=Combiner'2009DoomMonstersTex.HunterBerserk.JHunterBerserkSkin'
	 Skins(1)=Texture'2009DoomMonstersTex.HunterBerserk.HunterBerserkClaws'
	 Skins(2)=Shader'2009DoomMonstersTex.HunterBerserk.HunterBerserkHeartShader'
	 CollisionRadius=26 //30
	 CollisionHeight=44 // 50
	 Mass=2000.000000
	 bUseExtendedCollision=True
	 ColOffset=(Z=60)
	 ColRadius=35
	 ColHeight=50
	 OnlineHeadshotOffset=(X=37,Z=36)

	 ZapThreshold=5.0
	 ZappedDamageMod=2.0
	 MaxMeleeAttacks=6
}
