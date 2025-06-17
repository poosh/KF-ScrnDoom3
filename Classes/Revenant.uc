class Revenant extends DoomMonster;

var Material WeaponFlashLight[3];
var(Anims) name RangedAnims[3];
var byte MultiFiresLeft;
var float ExplosiveDamageMult;

//Beta6-: shoot random rocket count in row from 1 to 4
//Beta7: shoot 2 rockets. If raged (health < 75%) - shoot 4 rockets
function RangedAttack(Actor A)
{
	if ( bShotAnim )
		return;
	if( !bHasRoamed )
	{
		if( FRand()<0.5 )
			SightAnim = 'Sight2';
		RoamAtPlayer();
	}
	else if( IsInMeleeRange(A) && (MaxMeleeAttacks > 0 || NextProjTime >= Level.TimeSeconds) )
	{
		MaxMeleeAttacks--;
		PrepareStillAttack(A);
		SetAnimAction(MeleeAnims[Rand(3)]);
	}
	else if( NextProjTime < Level.TimeSeconds )
	{
		if (MaxMeleeAttacks <= 0)
			MaxMeleeAttacks = rand(default.MaxMeleeAttacks+1);

		NextProjTime = Level.TimeSeconds+2.5f+FRand()*2.f;
		if ( Health > HealthMax*0.9 )
			NextProjTime += 2.f; // when Rev is full of health, shoot rarer
		PrepareStillAttack(A);
		SetAnimAction(RangedAnims[Rand(3)]);
	}
}

//Beta7
state PissedOff
{
	// Don't override speed in this state
    function bool CanSpeedAdjust()
    {
        return false;
    }

	function BeginState()
	{
		GroundSpeed = OriginalGroundSpeed * 3.5;

		if ( bBurnified || bCrispified )
			GroundSpeed *= 0.8;

		if( Level.NetMode!=NM_DedicatedServer )
			PostNetReceive();

		NetUpdateTime = Level.TimeSeconds - 1;
	}

	//fire projectiles more often
	function RangedAttack(Actor A)
	{
		if ( bShotAnim )
			return;
		if( !bHasRoamed )
		{
			if( FRand()<0.5 )
				SightAnim = 'Sight2';
			RoamAtPlayer();
		}
		else if( IsInMeleeRange(A) )
		{
			SetAnimAction(MeleeAnims[Rand(3)]);
			PrepareStillAttack(A);
		}
		else if( NextProjTime < Level.TimeSeconds )
		{
			if( MultiFiresLeft==0 )
				MultiFiresLeft = 1+rand(3);
			else if( --MultiFiresLeft==0) {
				NextProjTime = Level.TimeSeconds + 0.5 + FRand()*3.0;
			}
			else if ( VSizeSquared(A.Location-Location) < 122500 && frand() < 0.5 ) {
				MultiFiresLeft = 0;
				NextProjTime = Level.TimeSeconds + 1.0 + FRand()*2.0;
			}
			PrepareStillAttack(A);
			SetAnimAction(RangedAnims[Rand(3)]);
		}
		//restore raged speed
		GroundSpeed = OriginalGroundSpeed * 3.5;
		if ( bBurnified || bCrispified )
			GroundSpeed *= 0.8;
		if( Level.NetMode!=NM_DedicatedServer )
			PostNetReceive();
		NetUpdateTime = Level.TimeSeconds - 1;
	}

	/*
	function bool ShouldTryRanged( Actor A )
	{
		if (NextProjTime > Level.TimeSeconds )
			return false;

		// better try to get to the melle range, if distance to the player is less than 7m
		if ( VSizeSquared(A.Location-Location) < 122500 )
			return frand() < 0.2;

		return frand() < 0.4;
	}
	*/

	function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
	{
		if ( class<KFWeaponDamageType>(damageType) != none && class<KFWeaponDamageType>(damageType).default.bIsExplosive )
			Damage *= ExplosiveDamageMult;

		Super.takeDamage(Damage, instigatedBy, hitLocation, momentum, damageType, HitIndex);
	}

	simulated function FireProjectile()
	{
		FireRightProjectile();
		FireLeftProjectile();
	}

}

// rage him same way as Scrake
function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
	if ( class<KFWeaponDamageType>(damageType) != none && class<KFWeaponDamageType>(damageType).default.bIsExplosive )
		Damage *= ExplosiveDamageMult;

	Super.takeDamage(Damage, instigatedBy, hitLocation, momentum, damageType, HitIndex);

	if ( Health < HealthMax * 0.5 || (Level.Game.GameDifficulty >= 5.0 && Health < HealthMax * 0.75 ) )
		GotoState('PissedOff');
}


// While enemy is not in reach but still in sight.
function bool ShouldTryRanged( Actor A )
{
	return (NextProjTime<Level.TimeSeconds && FRand() < 0.3);
}

simulated function Collapse()
{
	if(!bGibbed)
	{
		LinkMesh(SecondMesh,false);
		bWaitForAnim = false;
		PlayAnim('Collapse',,0.1);
		LifeSpan = 3.f;
	}
}

simulated function FireProjectile()
{
	if (frand() < 0.5) {
		FireRightProjectile();
	}
	else {
		FireLeftProjectile();
	}
}

simulated function FireRightProjectile()
{
	if ( Level.NetMode!=NM_Client && Controller!=None )
		FireProj(GetBoneCoords('r_gun').Origin);
	PlaySound(FireSound,SLOT_Interact);
}

function FireLeftProjectile()
{
	if ( Level.NetMode!=NM_Client && Controller!=None )
		FireProj(GetBoneCoords('l_gun').Origin);
	PlaySound(FireSound,SLOT_Misc);
}

simulated function RocketFlashOnL()
{
	if( Level.NetMode!=NM_DedicatedServer )
	{
		Spawn(class'RevenantSmokePuffs',self,,GetBoneCoords('LMissileBone').Origin);
		Skins[3] = WeaponFlashLight[0];
		Skins[4] = WeaponFlashLight[2];
		Skins[5] = WeaponFlashLight[1];
	}
}

simulated function RocketFlashOnR()
{
	if( Level.NetMode!=NM_DedicatedServer )
	{
		Spawn(class'RevenantSmokePuffs',self,,GetBoneCoords('RMissileBone').Origin);
		Skins[6] = WeaponFlashLight[0];
		Skins[7] = WeaponFlashLight[2];
		Skins[8] = WeaponFlashLight[1];
	}
}

simulated function RocketFlashOffL()
{
	if( Level.NetMode!=NM_DedicatedServer )
	{
		Skins[3] = InvisMat;
		Skins[4] = InvisMat;
		Skins[5] = InvisMat;
	}
}

simulated function RocketFlashOffR()
{
	if( Level.NetMode!=NM_DedicatedServer )
	{
		Skins[6] = InvisMat;
		Skins[7] = InvisMat;
		Skins[8] = InvisMat;
	}
}

simulated function RocketFlashOffBoth()
{
	RocketFlashOffL();
	RocketFlashOffR();
}

simulated function RocketFlashOnBoth()
{
	RocketFlashOnL();
	RocketFlashOnR();
}

// function SetOverlayMaterial(Material mat, float time, bool bOverride);

simulated function FadeSkins()
{
	Skins[1] = FadeFX;
	Skins[3] = InvisMat;
	Skins[4] = InvisMat;
	Skins[5] = InvisMat;
	Skins[6] = InvisMat;
	Skins[7] = InvisMat;
	Skins[8] = InvisMat;
	MakeBurnAway();
}

simulated function BurnAway()
{
	Skins[0] = InvisMat;
	Skins[1] = BurnFX;
	Skins[2] = InvisMat;
	Burning = true;
	PlaySound(DeResSound,SLOT_Misc,2,,600.f);
}

defaultproperties
{
	WeaponFlashLight(0)=Shader'2009DoomMonstersTex.Sentry.LowerWeaponFlash'
	WeaponFlashLight(1)=Shader'2009DoomMonstersTex.Revenant.NewRevenantFlash'
	WeaponFlashLight(2)=Shader'2009DoomMonstersTex.Revenant.WeaponFlash3'
	RangedAnims(0)="RangedAttackBoth"
	RangedAnims(1)="RangedAttackLeft"
	RangedAnims(2)="RangedAttackRight"
	DeathAnims(0)="DeathF"
	DeathAnims(1)="DeathB"
	DeathAnims(2)="DeathF"
	DeathAnims(3)="DeathB"
	SightAnim="Sight"
	HitAnimsX(0)="PainL"
	HitAnimsX(1)="PainL2"
	HitAnimsX(2)="PainR"
	HitAnimsX(3)="PainR2"
	MissSound(0)=Sound'2009DoomMonstersSounds.Revenant.Revenant_melee5'
	MissSound(1)=Sound'2009DoomMonstersSounds.Revenant.Revenant_melee5'
	MissSound(2)=Sound'2009DoomMonstersSounds.Revenant.Revenant_melee5'
	MissSound(3)=Sound'2009DoomMonstersSounds.Revenant.Revenant_melee5'
	MeleeAttackSounds(0)=Sound'2009DoomMonstersSounds.Revenant.Revenant_chatter_combat2'
	MeleeAttackSounds(1)=Sound'2009DoomMonstersSounds.Revenant.Revenant_chatter_combat3'
	MeleeAttackSounds(2)=Sound'2009DoomMonstersSounds.Revenant.Revenant_chatter_combat2'
	MeleeAttackSounds(3)=Sound'2009DoomMonstersSounds.Revenant.Revenant_chatter4'
	SightSound=Sound'2009DoomMonstersSounds.Revenant.Revenant_sight1_1'
	DeResSound=Sound'2009DoomMonstersSounds.Revenant.Revenant_burn'
	BurningMaterial=Shader'2009DoomMonstersTex.Revenant.RevenantShader'
	BurnClass=Class'ScrnDoom3KF.RevenantBurnTex'
	FadeClass=Class'ScrnDoom3KF.RevenantMaterialSequence'
	RangedProjectile=Class'ScrnDoom3KF.RevenantProjectile'
	BurnedTextureNum(0)=1
	HasHitAnims=True
	BigMonster=True
	SecondMesh=SkeletalMesh'2009DoomMonstersAnims.RevenantCollapse'
	aimerror=600
	BurnAnimTime=0.250000
	bCanAttackPipebombs=True
	MeleeAnims(0)="Attack1"
	MeleeAnims(1)="Attack2"
	MeleeAnims(2)="Attack3"
	MeleeDamage=24
	PlayerCountHealthScale=0.100000
	FootStep(0)=Sound'2009DoomMonstersSounds.Revenant.Revenant_step1'
	FootStep(1)=Sound'2009DoomMonstersSounds.Revenant.Revenant_step4'
	DodgeSkillAdjust=1.000000
	HitSound(0)=Sound'2009DoomMonstersSounds.Revenant.Revenant_pain1_alt1'
	HitSound(1)=Sound'2009DoomMonstersSounds.Revenant.Revenant_pain3_alt1'
	HitSound(2)=Sound'2009DoomMonstersSounds.Revenant.Revenant_pain1_alt1'
	HitSound(3)=Sound'2009DoomMonstersSounds.Revenant.Revenant_pain3_alt1'
	DeathSound(0)=Sound'2009DoomMonstersSounds.Revenant.Revenant_die2_alt1'
	DeathSound(1)=Sound'2009DoomMonstersSounds.Revenant.Revenant_die2_alt1'
	DeathSound(2)=Sound'2009DoomMonstersSounds.Revenant.Revenant_die2_alt1'
	DeathSound(3)=Sound'2009DoomMonstersSounds.Revenant.Revenant_die2_alt1'
	ChallengeSound(0)=Sound'2009DoomMonstersSounds.Revenant.Revenant_sight1_2_alt1'
	ChallengeSound(1)=Sound'2009DoomMonstersSounds.Revenant.Revenant_sight2_1_alt1'
	ChallengeSound(2)=Sound'2009DoomMonstersSounds.Revenant.revenant_1'
	ChallengeSound(3)=Sound'2009DoomMonstersSounds.Revenant.revenant_2'
	FireSound=Sound'2009DoomMonstersSounds.Revenant.revenant_rocket_fire'
	ScoringValue=130
	WallDodgeAnims(0)="DodgeL2"
	WallDodgeAnims(1)="DodgeR2"
	WallDodgeAnims(2)="DodgeL2"
	WallDodgeAnims(3)="DodgeR2"
	IdleHeavyAnim="Idle"
	IdleRifleAnim="Idle"
	FireHeavyRapidAnim="Walk"
	FireHeavyBurstAnim="Walk"
	FireRifleRapidAnim="Walk"
	FireRifleBurstAnim="Walk"
	RagdollOverride="D3Revenant"
	bCanJump=False
	GroundSpeed=100.000000
	HealthMax=600.000000
	Health=600
	ExplosiveDamageMult=0.80
	HeadRadius=13.000000
	MenuName="Revenant"
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
	DodgeAnims(0)="DodgeL2"
	DodgeAnims(1)="DodgeR2"
	DodgeAnims(2)="DodgeL2"
	DodgeAnims(3)="DodgeR2"
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
	Mesh=SkeletalMesh'2009DoomMonstersAnims.RevenantMesh'
	DrawScale=1.200000
	Skins(0)=Shader'2009DoomMonstersTex.Revenant.RevenantShader'
	Skins(1)=Combiner'2009DoomMonstersTex.Revenant.JRevenantSkin'
	Skins(2)=Shader'2009DoomMonstersTex.Revenant.RevenantEyesShader'
	Skins(3)=Texture'2009DoomMonstersTex.Revenant.InvisMat'
	Skins(4)=Texture'2009DoomMonstersTex.Revenant.InvisMat'
	Skins(5)=Texture'2009DoomMonstersTex.Revenant.InvisMat'
	Skins(6)=Texture'2009DoomMonstersTex.Revenant.InvisMat'
	Skins(7)=Texture'2009DoomMonstersTex.Revenant.InvisMat'
	Skins(8)=Texture'2009DoomMonstersTex.Revenant.InvisMat'
	CollisionRadius=20.000000
	CollisionHeight=44 // 50
	MaxMeleeAttacks=2

	ZapThreshold=0.75
	ZappedDamageMod=1.5

	bUseExtendedCollision=True
	ColOffset=(X=20,Z=35)
	ColRadius=30
	ColHeight=20
	RootBone="Hips"
}
