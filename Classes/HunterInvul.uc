class HunterInvul extends DoomBoss;

#exec obj load file=2009DoomMonstersTex.utx

var HunterInvulHandBeams HBeams[2];
var HunterInvulHandBeamsLong HBeamsLong[2];
var transient float NextRangedAttack,NextShockwaveTime;
var Sound PreFireSound,ShieldedHit[4];
var Name RangedAttacks[3];
var float ShockRadius;
var int ShockDamage;
var class<DamageType> ShockWaveDamageType;
var Emitter ElecX[11];
var bool bIsInvulnerable,bClientInvulnerable;
var int NumMultiFires;
var float ShieldDamageMult;

replication
{
	reliable if( Role == ROLE_Authority )
		bIsInvulnerable;
}

simulated function PostNetReceive()
{
	if( bIsInvulnerable!=bClientInvulnerable )
		SetInvulnerability();
}

simulated function SetInvulnerability()
{
	local byte i;

	bHasFireWeakness = !bIsInvulnerable;
	if( bIsInvulnerable==bClientInvulnerable )
		return;
	bClientInvulnerable = bIsInvulnerable;
	if( Level.NetMode==NM_DedicatedServer )
		return;
	if( bIsInvulnerable )
	{
		AmbientGlow = 255;
		ElecX[0] = Spawn(class'HunterInvulElecAttachmentsLarge', self);
		AttachToBone(ElecX[0],'Lloarm');
		ElecX[1] = Spawn(class'HunterInvulElecAttachmentsLarge', self);
		AttachToBone(ElecX[1],'Rloarm');
		ElecX[2] = Spawn(class'HunterInvulElecAttachmentsMedium', self);
		AttachToBone(ElecX[2],'Rpalm');
		ElecX[3] = Spawn(class'HunterInvulElecAttachmentsMedium', self);
		AttachToBone(ElecX[3],'Lpalm');
		ElecX[4] = Spawn(class'HunterInvulElecAttachmentsMedium', self);
		AttachToBone(ElecX[4],'LAnkleX');
		ElecX[5] = Spawn(class'HunterInvulElecAttachmentsMedium', self);
		AttachToBone(ElecX[5],'RAnkleX');
		ElecX[6] = Spawn(class'HunterInvulElecAttachmentsMedium', self);
		AttachToBone(ElecX[6],'HK_jaw_2');
		ElecX[7] = Spawn(class'HunterInvulElecAttachmentsLarge', self);
		AttachToBone(ElecX[7],'RlegX');
		ElecX[8] = Spawn(class'HunterInvulElecAttachmentsLarge', self);
		AttachToBone(ElecX[8],'LlegX');
		ElecX[9] = Spawn(class'HunterInvulElecAttachmentsSuper', self);
		AttachToBone(ElecX[9],'SpineX');
		ElecX[10] = Spawn(class'HunterInvulElecAttachmentsSuper', self);
		AttachToBone(ElecX[10],'BellyX');

		for( i=0; i<ArrayCount(MovementAnims); i++ )
		{
			WalkAnims[i] = 'Walk';
			MovementAnims[i] = 'Walk';
		}
		Skins[1] = Shader'HunterInvulShader';

		bHasFireWeakness = false;
		BurnDown = 0;
	}
	else
	{
		AmbientGlow = Default.AmbientGlow;
		for( i=0; i<ArrayCount(ElecX); ++i )
		{
			if( ElecX[i]!=None )
			{
				DetachFromBone(ElecX[i]);
				ElecX[i].Kill();
			}
		}
		for( i=0; i<ArrayCount(MovementAnims); i++ )
		{
			WalkAnims[i] = 'Walk1';
			MovementAnims[i] = 'Walk1';
		}
		Skins[1] = Default.Skins[1];
		bHasFireWeakness = true;
	}
}
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	if( Level.NetMode!=NM_Client )
		bHasRoamed = false;
}

function RangedAttack(Actor A)
{
	if ( bShotAnim )
		return;

	if( !bHasRoamed ) {
		RoamAtPlayer();
	}
	else if( IsInMeleeRange(A, -50) && MaxMeleeAttacks > 0 ) {
		MaxMeleeAttacks--;
		PrepareStillAttack(A);
		SetAnimAction(MeleeAnims[0]);
	}
	else if( NextRangedAttack < Level.TimeSeconds || MaxMeleeAttacks == 0 ) {
		if (MaxMeleeAttacks <= 0) {
			MaxMeleeAttacks = rand(default.MaxMeleeAttacks+1);
			NumMultiFires = 2 + rand(2);
			NextRangedAttack = Level.TimeSeconds - 1;
		}

		if( NumMultiFires <= 0 ) {
			if ( FRand() < 0.75*Health/HealthMax ) {
				NextRangedAttack = Level.TimeSeconds+0.7f+FRand()*2.f;
				return;
			}
			NumMultiFires = Rand(4);
		}
		else if( --NumMultiFires==0 ) {
			if( Health<1500 )
				NextRangedAttack = Level.TimeSeconds+0.7f+FRand();
			else
				NextRangedAttack = Level.TimeSeconds+1.f+FRand()*3.f;
		}

		if( !bIsInvulnerable ) {
			NumMultiFires = 0;
			RoamAtPlayer();
			NextRangedAttack = Level.TimeSeconds + 3.f + FRand()*2.f;
		}
		else if( NextShockwaveTime < Level.TimeSeconds && NumMultiFires <= 0 ) {
			// become vulnerable
			PrepareStillAttack(A);
			PlaySound(PreFireSound,SLOT_Interact);
			SetAnimAction('ShockWave');
		}
		else {
			// range attack
			NextShockwaveTime -= 5.0;  // Hunter uses shield to charge projectile
			PrepareStillAttack(A);
			PlaySound(PreFireSound,SLOT_Interact);
			SetAnimAction(RangedAttacks[Rand(3)]);
		}
	}
}

simulated function PlayDirectionalHit(Vector HitLoc)
{
	local byte i;

	for(i=0;i<2;i++)
	{
		if(HBeams[i] != None)
		{
			DetachFromBone(HBeams[i]);
			HBeams[i].Kill();
		}
		if(HBeamsLong[i] != None)
		{
			DetachFromBone(HBeamsLong[i]);
			HBeamsLong[i].Kill();
		}
	}
	Super.PlayDirectionalHit(HitLoc);
}

simulated function FireRProjectile()
{
	local HunterInvulProjectile Proj;

	if( Level.NetMode!=NM_Client )
	{
		Proj = HunterInvulProjectile(FireProj(GetBoneCoords('rmissile').Origin));
		if( Proj!=None )
			Proj.Seeking = Controller.Target;
	}
	if( Level.NetMode!=NM_DedicatedServer )
		PlaySound(FireSound,SLOT_Interact);
}

simulated function SpawnGiantElectro()
{
	local Rotator Rot;

	if( Level.NetMode==NM_DedicatedServer )
		return;

	Spawn(class'HunterInvulBigProjErupt',self,,Location - vect(0,0,0.7)*CollisionHeight);
	Rot.Roll = -20000;
	Rot.Yaw = -3000;
	HBeams[0] = Spawn(class'HunterInvulHandBeams',self,,);
	AttachToBone(HBeams[0] ,'rwrist');
	HBeams[0].SetRelativeRotation(Rot);
	Rot.Roll = -18000;
	HBeams[1] = Spawn(class'HunterInvulHandBeams',self,,);
	AttachToBone(HBeams[1] ,'lwrist');
	HBeams[1].SetRelativeRotation(Rot);
}

simulated function FireHMissile()
{
	local HunterInvulBigProjectile Proj;

	if( Level.NetMode!=NM_Client )
	{
		RangedProjectile = SecondaryProjectile;
		Proj = HunterInvulBigProjectile(FireProj(GetBoneCoords('rmissile').Origin));
		RangedProjectile = Default.RangedProjectile;
		if( Proj!=None )
			Proj.Seeking = Controller.Target;
	}
	if( Level.NetMode!=NM_DedicatedServer )
		PlaySound(FireSound,SLOT_Interact);
}

simulated function ElectroWave()
{
	local xPawn P;
	local vector dir;
	local float damageScale, dist, Momentum;

	NextRangedAttack = Level.TimeSeconds + 8.0 + 4.0*frand();
	bIsInvulnerable = false;
	SetInvulnerability();
	if( Level.NetMode!=NM_DedicatedServer )
		Spawn(class'HunterInvulElectroWave',self,,Location - vect(0,0,0.8)*CollisionHeight);
	if( Level.NetMode==NM_Client )
		return;

	foreach VisibleCollidingActors(class'xPawn', P, ShockRadius, Location)
	{
		if( P.Health>0 && HunterInvul(P)==None && (P.Physics==PHYS_Walking || P.Physics==PHYS_Swimming) )
		{
			Momentum = 100 * P.CollisionRadius;
			dir = P.Location - Location;
			dist = FMax(1,VSize(dir));
			dir = dir/dist;
			damageScale = 1 - FMax(0,(dist - P.CollisionRadius)/ShockRadius);
			P.TakeDamage(damageScale * ShockDamage,self,P.Location - 0.5 * (P.CollisionHeight + P.CollisionRadius) * dir,(damageScale * Momentum * dir), ShockWaveDamageType);
		}
	}
}

simulated function Charge()
{
	local Rotator Rot;

	bIsInvulnerable = true;
	SetInvulnerability();
	NextShockwaveTime = Level.TimeSeconds + 30.f + 15.0*frand();

	if( Level.NetMode==NM_DedicatedServer )
		return;
	Rot.Roll = -20000;
	Rot.Yaw = -3000;

	HBeams[0] = Spawn(class'HunterInvulHandBeams',self);
	AttachToBone(HBeams[0] ,'rwrist');
	HBeams[0].SetRelativeRotation(Rot);
	Rot.Roll = -18000;
	HBeams[1] = Spawn(class'HunterInvulHandBeams',self);
	AttachToBone(HBeams[1] ,'lwrist');
	HBeams[1].SetRelativeRotation(Rot);
}

simulated function RangedShock()
{
	if( Level.NetMode!=NM_Client )
	{
		RangedProjectile = Class'HunterInvulShockProj';
		FireProj(GetBoneCoords('Rpalm').Origin);
		FireProj(GetBoneCoords('Lpalm').Origin);
		RangedProjectile = Default.RangedProjectile;
	}
	if( Level.NetMode!=NM_DedicatedServer )
		PlaySound(FireSound,SLOT_Interact);
}

simulated function SpawnHandBeams()
{
	local Rotator Rot;

	if( Level.NetMode==NM_DedicatedServer )
		return;
	Rot.Roll = -20000;
	Rot.Yaw = -3000;

	HBeams[0] = Spawn(class'HunterInvulHandBeams',self,,);
	AttachToBone(HBeams[0] ,'rwrist');
	HBeams[0].SetRelativeRotation(Rot);
	Rot.Roll = -18000;
	HBeams[1] = Spawn(class'HunterInvulHandBeams',self,,);
	AttachToBone(HBeams[1] ,'lwrist');
	HBeams[1].SetRelativeRotation(Rot);
}

simulated function RemoveEffects()
{
	local byte i;

	for(i=0;i<2;i++)
	{
		if(HBeams[i] != None)
		{
			DetachFromBone(HBeams[i]);
			HBeams[i].Destroy();
		}
		if(HBeamsLong[i] != None)
		{
			DetachFromBone(HBeamsLong[i]);
			HBeamsLong[i].Destroy();
		}
	}

	for(i=0;i<ArrayCount(ElecX);i++)
	{
		if(ElecX[i] != None)
		{
			DetachFromBone(ElecX[i]);
			ElecX[i].Destroy();
		}
	}
}

simulated function FadeSkins()
{
	Skins[0] = FadeFX;
	MakeBurnAway();
}

simulated function BurnAway()
{
	Skins[0] = BurnFX;
	Burning = true;
}

function TakeDamage( int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex )
{
	if (bIsInvulnerable) {
		PlaySound(ShieldedHit[Rand(4)],SLOT_Misc,0.8f);
		Damage *= ShieldDamageMult;
	}
	Super.TakeDamage(Damage,InstigatedBy,HitLocation,Momentum,DamageType,HitIndex);
}


defaultproperties
{
	PrecashedMaterials(0)=Texture'2009DoomMonstersTex.Effects.InvulLightning2'
	SecondaryProjectile=Class'ScrnDoom3KF.HunterInvulBigProjectile'
	PreFireSound=Sound'2009DoomMonstersSounds.Hunter.Hunter_fb_prefire_01'
	ShieldedHit(0)=Sound'KFWeaponSound.bullethitmetal'
	ShieldedHit(1)=Sound'KFWeaponSound.bullethitmetal2'
	ShieldedHit(2)=Sound'KFWeaponSound.bullethitmetal3'
	ShieldedHit(3)=Sound'KFWeaponSound.bullethitmetal4'
	RangedAttacks(0)="Attack1"
	RangedAttacks(1)="Attack2"
	RangedAttacks(2)="ShockAttack"
	ShockRadius=800.000000
	ShockDamage=75
	ShockWaveDamageType=Class'ScrnDoom3KF.DamTypeHunterInvulShockWave'
	DeathAnims(0)="DeathF"
	DeathAnims(1)="DeathB"
	DeathAnims(2)="DeathF"
	DeathAnims(3)="DeathB"
	SightAnim="Summon"
	HitAnimsX(0)="PainL"
	HitAnimsX(1)="PainR"
	HitAnimsX(2)="PainHead"
	HitAnimsX(3)="PainChest"
	MeleeAttackSounds(0)=Sound'2009DoomMonstersSounds.Hunter.Hunter_attack_01'
	MeleeAttackSounds(1)=Sound'2009DoomMonstersSounds.Hunter.Hunter_attack_07'
	MeleeAttackSounds(2)=Sound'2009DoomMonstersSounds.Hunter.Hunter_attack_09'
	MeleeAttackSounds(3)=Sound'2009DoomMonstersSounds.Hunter.Hunter_attack_11'
	SightSound=Sound'2009DoomMonstersSounds.Hunter.Hunter_sight_01'
	FadeClass=Class'ScrnDoom3KF.HunterInvulMaterialSequence'
	RangedProjectile=Class'ScrnDoom3KF.HunterInvulProjectile'
	DoomTeleportFXClass=Class'ScrnDoom3KF.BossDemonSpawn'
	HasHitAnims=True
	BigMonster=True
	BurnAnimTime=0.250000
	MeleeAnims(0)="Attack3"
	MeleeDamage=20
	bFatAss=True
	bUseExtendedCollision=True
	ColOffset=(Z=20,Y=0,Z=70)
	ColRadius=70
	ColHeight=70
	OnlineHeadshotOffset=(X=83.000000,Z=140.000000)
	FootStep(0)=Sound'2009DoomMonstersSounds.Hunter.Hunter_invul_fs_invul_01'
	FootStep(1)=Sound'2009DoomMonstersSounds.Hunter.Hunter_invul_fs_invul_02'
	bBoss=True
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
	FootstepVolume=1.400000
	WallDodgeAnims(0)="Walk"
	WallDodgeAnims(1)="Walk"
	WallDodgeAnims(2)="Walk"
	WallDodgeAnims(3)="Walk"
	IdleHeavyAnim="Idle"
	IdleRifleAnim="Idle"
	FireHeavyRapidAnim="Walk"
	FireHeavyBurstAnim="Walk"
	FireRifleRapidAnim="Walk"
	FireRifleBurstAnim="Walk"
	RagdollOverride="D3InvulHunter"
	bCanJump=False
	MeleeRange=150
	GroundSpeed=200.000000
	HealthMax=6500.000000
	Health=6500
	HeadRadius=20
	ShieldDamageMult=0.1
	MenuName="Electro Hunter"
	MovementAnims(0)="Walk1"
	MovementAnims(1)="Walk1"
	MovementAnims(2)="Walk1"
	MovementAnims(3)="Walk1"
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
	WalkAnims(0)="Walk1"
	WalkAnims(1)="Walk1"
	WalkAnims(2)="Walk1"
	WalkAnims(3)="Walk1"
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
	IdleCrouchAnim="Idle"
	IdleSwimAnim="Idle"
	IdleWeaponAnim="Idle"
	IdleRestAnim="Idle"
	IdleChatAnim="Idle"
	HeadBone="HK_jaw_2"
	Mesh=SkeletalMesh'2009DoomMonstersAnims.HunterInvulnerableMesh'
	DrawScale=1.0
	PrePivot=(Z=15.000000)
	Skins(0)=Shader'2009DoomMonstersTex.HunterInvulnerable.HunterInvulFinalShader'
	Skins(1)=Texture'2009DoomMonstersTex.Revenant.InvisMat'
	CollisionRadius=26
	CollisionHeight=40
	Mass=3000.000000
	MaxMeleeAttacks=3
	ZapThreshold=3
	ZappedDamageMod=1.5
	RootBone="Hips"
}
