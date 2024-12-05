class HellKnight extends DoomMonster;

var HellKnightHandEffect HandFX;
var transient float NextRangedTime;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	if( FRand()<0.5f )
		Skins[0] = Combiner'JHellKnightSkinB';
}

function RangedAttack(Actor A)
{
	local byte i;
	local float HealthPct;

	if ( bShotAnim )
		return;

	if (!bHasRoamed) {
		RoamAtPlayer();
		PrepareMovingAttack(A,0.6f);
		return;
	}

	HealthPct = Health / HealthMax;

	if (IsInMeleeRange(A) && (MaxMeleeAttacks > 0 || NextRangedTime >= Level.TimeSeconds))	{
		MaxMeleeAttacks--;
		i = Rand(3);
		if (i == 1) {
			PrepareMovingAttack(A, 0.45);
		}
		else {
			PrepareStillAttack(A);
		}
		SetAnimAction(MeleeAnims[i]);
	}
	else if (NextRangedTime < Level.TimeSeconds || MaxMeleeAttacks <= 0) {
		if (MaxMeleeAttacks <= 0) {
			MaxMeleeAttacks = rand(default.MaxMeleeAttacks+1);
		}
		else if ((HealthPct > 0.9 && frand() < 0.50) || VSizeSquared(A.Location - Location) > 2250000.0) {
			NextRangedTime = Level.TimeSeconds + 1.0 + 2.0*frand();
			return;
		}

		if (frand() < 0.5) {
			SetAnimAction('HighAttack');
		}
		else {
			SetAnimAction('RangedAttack');
		}
		PrepareStillAttack(A);
		NextRangedTime = Level.TimeSeconds + 2.0 + 4.0*HealthPct + (2.0 + 2.0*HealthPct)*frand();
	}
}

// While enemy is not in reach but still in sight.
function bool ShouldTryRanged(Actor A)
{
	return NextRangedTime < Level.TimeSeconds && frand() < 0.5f && VSizeSquared(A.Location-Location) < 2250000.0;
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> DamType,
		optional int HitIndex)
{
	super.TakeDamage(Damage, InstigatedBy, Hitlocation, Momentum, DamType, HitIndex);
	// Adjust NextRangedTime to the new HealthPct. The formula is from RangedAttack(), using the max frand value (1.0)
	NextRangedTime = fmin(NextRangedTime, Level.TimeSeconds + 4.0 + 6.0*Health/HealthMax);
}

simulated function FireProjectile()
{
	if ( Level.NetMode!=NM_Client )
		FireProj(GetBoneCoords('RHandBone').Origin);
	if( Level.NetMode!=NM_DedicatedServer )
	{
		PlaySound(FireSound,SLOT_Interact);
		if( HandFX!=None )
			HandFX.Destroy();
	}
}

simulated function RangedEffect()
{
	if( Level.NetMode!=NM_DedicatedServer )
	{
		HandFX = Spawn(class'HellKnightHandEffect',Self);
		AttachToBone(HandFX,'RHandBone');
	}
}

// function SetOverlayMaterial(Material mat, float time, bool bOverride);

simulated function RemoveEffects()
{
	if(HandFX != None)
		HandFX.Kill();
}

simulated function FadeSkins()
{
	Skins[0] = FadeFX;
	Skins[1] = InvisMat;
	Skins[2] = InvisMat;
	Skins[3] = InvisMat;
	MakeBurnAway();
}

simulated function BurnAway()
{
	Skins[0] = BurnFX;
	Burning = true;
	PlaySound(DeResSound,SLOT_Misc,2,,650.f);
}

defaultproperties
{
	DeathAnims(0)="DeathF"
	DeathAnims(1)="DeathB"
	DeathAnims(2)="DeathF"
	DeathAnims(3)="DeathB"
	SightAnim="Roar"
	HitAnimsX(0)="PainLeft"
	HitAnimsX(1)="PainHead"
	HitAnimsX(2)="PainRight"
	HitAnimsX(3)="PainChest"
	MinHitAnimDelay=4.000000
	MeleeAttackSounds(0)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_chomp1'
	MeleeAttackSounds(1)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_chomp2'
	MeleeAttackSounds(2)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_chomp3'
	MeleeAttackSounds(3)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_chomp2'
	SightSound=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_sight1_1'
	DeResSound=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_hk_burn'
	BurningMaterial=Texture'2009DoomMonstersTex.HellKnight.HellKnightSkin'
	BurnClass=Class'ScrnDoom3KF.HellknightBurnTex'
	FadeClass=Class'ScrnDoom3KF.HellknightMaterialSequence'
	RangedProjectile=Class'ScrnDoom3KF.HellKnightProjectile'
	BurnedTextureNum(1)=3
	HasHitAnims=True
	BigMonster=True
	aimerror=200
	BurnAnimTime=0.500000
	MeleeAnims(0)="Attack1"
	MeleeAnims(1)="Attack3"
	MeleeAnims(2)="Attack4"
	MeleeDamage=35
	bFatAss=True
	bUseExtendedCollision=True
	ColOffset=(X=30,Z=60)
	ColRadius=40.000000
	ColHeight=40.000000
	PlayerCountHealthScale=0.20
	FootStep(0)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_step1'
	FootStep(1)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_step1'
	DodgeSkillAdjust=0.100000
	HitSound(0)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_hk_pain_01'
	HitSound(1)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_hk_pain_02'
	HitSound(2)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_hk_pain_03'
	HitSound(3)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_hk_pain_03'
	DeathSound(0)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_die1'
	DeathSound(1)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_die2'
	DeathSound(2)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_die3'
	DeathSound(3)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_die2'
	ChallengeSound(0)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_sight1_2'
	ChallengeSound(1)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_sight2_1'
	ChallengeSound(2)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_sight3_1'
	ChallengeSound(3)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_hk_chatter_03'
	FireSound=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_fb_create_02'
	ScoringValue=200
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
	RagdollOverride="D3HellKnight"
	bCanJump=False
	GroundSpeed=120.000000
	HealthMax=1800.000000
	Health=1800
	HeadRadius=17.000000
	MenuName="Hell Knight"
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
	IdleCrouchAnim="Idle"
	IdleSwimAnim="Idle"
	IdleWeaponAnim="Idle"
	IdleRestAnim="Idle"
	IdleChatAnim="Idle"
	HeadBone="Jaw"
	Mesh=SkeletalMesh'2009DoomMonstersAnims.HellKnightMesh'
	DrawScale=1.200000
	Skins(0)=Combiner'2009DoomMonstersTex.HellKnight.JHellKnightSkin'
	Skins(1)=FinalBlend'2009DoomMonstersTex.HellKnight.GobFinal'
	Skins(2)=Shader'2009DoomMonstersTex.HellKnight.DroolShader'
	Skins(3)=Texture'2009DoomMonstersTex.HellKnight.HellKnightTongue'
	CollisionRadius=23.000000
	CollisionHeight=44  //50
	Mass=2000.000000
	MaxMeleeAttacks=3
	ZapThreshold=1.750000
	RootBone="Hips"
}
