class Bruiser extends DoomMonster;

var(Anims) name RangedAttacks[3];
var transient float NextAttackTime;
var(Sounds) Sound ProjFireSounds[5],ReloadSounds[4];

var Material ScreenImages[5];
var MaterialSequence FadeFXMouth;
var class<MaterialSequence> FadeScreenClass;
var MaterialSequence FadeFXScreen;
var class<MaterialSequence> FadeMouthClass;

function RangedAttack(Actor A)
{
	local byte i;

	if ( bShotAnim )
		return;

	if( !bHasRoamed )
		RoamAtPlayer();
	else if( IsInMeleeRange(A) )
	{
		PrepareMovingAttack(A,0.8);
		SetAnimAction(MeleeAnims[Rand(2)]);
	}
	else if ( NextAttackTime<Level.TimeSeconds )
	{
		NextAttackTime = Level.TimeSeconds+2+FRand()*2.f;
		i = Rand(ArrayCount(RangedAttacks));
		if( i==2 )
			PrepareStillAttack(A);
		else PrepareMovingAttack(A,0.8);
		SetAnimAction(RangedAttacks[i]);
	}
}

// While enemy is not in reach but still in sight.
function bool ShouldTryRanged( Actor A )
{
	return (NextAttackTime<Level.TimeSeconds && FRand()<0.5f);
}

simulated function FireProjectile()
{
	if ( Level.NetMode!=NM_Client )
		FireProj(GetBoneCoords('flame_l').Origin);
	if ( Level.NetMode!=NM_DedicatedServer )
		PlaySound(ProjFireSounds[Rand(5)],SLOT_Interact);
}
simulated function FireRProjectile()
{
	if ( Level.NetMode!=NM_Client )
		FireProj(GetBoneCoords('flame_r').Origin);
	if ( Level.NetMode!=NM_DedicatedServer )
		PlaySound(ProjFireSounds[Rand(5)],SLOT_Interact);
}

simulated function LFireGlow()
{
	local Coords BoneLocation;

	if( Level.NetMode==NM_DedicatedServer || (Level.TimeSeconds-LastRenderTime)>1.f )
		return;
	BoneLocation = GetBoneCoords('flame_l');
	Spawn(class'RevenantSmokePuffs',self,,BoneLocation.Origin);
}

simulated function RFireGlow()
{
	local Coords BoneLocation;

	if( Level.NetMode==NM_DedicatedServer || (Level.TimeSeconds-LastRenderTime)>1.f )
		return;
	BoneLocation = GetBoneCoords('flame_r');
	Spawn(class'RevenantSmokePuffs',self,,BoneLocation.Origin);
}

simulated function Reload()
{
	PlaySound(ReloadSounds[Rand(4)],SLOT_Talk);
}

simulated function SetAngryImage()
{
	local Shader Shad;

	Shad = Shader(Skins[2]);
	Shad.Diffuse = ScreenImages[0];
}

simulated function SetIdleImage()
{
	local Shader Shad;

	Shad = Shader(Skins[2]);
	Shad.Diffuse = ScreenImages[1];
}

simulated function SetPainImage()
{
	local Shader Shad;

	Shad = Shader(Skins[2]);
	Shad.Diffuse = ScreenImages[2];
}

simulated function SetSightImage()
{
	local Shader Shad;

	Shad = Shader(Skins[2]);
	Shad.Diffuse = ScreenImages[4];
}

simulated function SetDefaultImage()
{
	local Shader Shad;

	Shad = Shader(Skins[2]);
	Shad.Diffuse = ScreenImages[1];
}

simulated function PlayDirectionalDeath(Vector HitLoc)
{
	RemoveEffects();
	BurnFX = DoomBurnTex(Level.ObjectPool.AllocateObject(BurnClass));
	FadeFX = MaterialSequence(Level.ObjectPool.AllocateObject(FadeClass));
	FadeFXScreen = MaterialSequence(Level.ObjectPool.AllocateObject(FadeScreenClass));
	FadeFXMouth = MaterialSequence(Level.ObjectPool.AllocateObject(FadeMouthClass));

	if(FadeFX != None && BurnFX != None && FadeFXScreen != None && FadeFXMouth != None)
	{
		SetOverlayMaterial(None, 0.0f, true);
		SetCollision(false, false, false);
		Projectors.Remove(0, Projectors.Length);
		bAcceptsProjectors = false;
		if(PlayerShadow != None)
			PlayerShadow.bShadowActive = false;
		RemoveFlamingEffects();
 		PlayAnim(DeathAnims[Rand(4)],BurnAnimTime, 0.1);
	}
	else PlayAnim(DeathAnims[Rand(4)],, 0.1);
}

simulated function FadeSkins()
{
	FadeFXMouth.Reset();
	FadeFXScreen.Reset();
	Skins[0] = FadeFX;
	Skins[1] = FadeFXMouth;
	Skins[2] = FadeFXScreen;
	MakeBurnAway();
}

simulated function BurnAway()
{
	local byte i;

	if(BurnFX != None)
	{
		for( i=0; i<Skins.Length; i++ )
			Skins[i] = BurnFX;
		Burning = true;
	}
}

simulated function FreeFXObjects()
{
	if(FadeFXScreen != None)
	{
		Level.ObjectPool.FreeObject(FadeFXScreen);
		FadeFXScreen = None;
	}
	if(FadeFXMouth != None)
	{
		Level.ObjectPool.FreeObject(FadeFXMouth);
		FadeFXMouth = None;
	}
	Super.FreeFXObjects();
}

defaultproperties
{
     RangedAttacks(0)="RangedAttack1"
     RangedAttacks(1)="RangedAttack2"
     RangedAttacks(2)="RangedAttack3"
     ProjFireSounds(0)=Sound'2009DoomMonstersSounds.Bruiser.Bruiser_fire_01'
     ProjFireSounds(1)=Sound'2009DoomMonstersSounds.Bruiser.Bruiser_fire_02'
     ProjFireSounds(2)=Sound'2009DoomMonstersSounds.Bruiser.Bruiser_fire_03'
     ProjFireSounds(3)=Sound'2009DoomMonstersSounds.Bruiser.Bruiser_fire_04'
     ProjFireSounds(4)=Sound'2009DoomMonstersSounds.Bruiser.Bruiser_fire_05'
     ReloadSounds(0)=Sound'2009DoomMonstersSounds.Bruiser.Bruiser_reload_01'
     ReloadSounds(1)=Sound'2009DoomMonstersSounds.Bruiser.Bruiser_reload_02'
     ReloadSounds(2)=Sound'2009DoomMonstersSounds.Bruiser.Bruiser_reload_03'
     ReloadSounds(3)=Sound'2009DoomMonstersSounds.Bruiser.Bruiser_reload_04'
     ScreenImages(0)=Texture'2009DoomMonstersTex.Bruiser.BruiserAngryTex'
     ScreenImages(1)=Texture'2009DoomMonstersTex.Bruiser.BruiserIdleTex'
     ScreenImages(2)=Texture'2009DoomMonstersTex.Bruiser.BruiserPainTex'
     ScreenImages(3)=Texture'2009DoomMonstersTex.Bruiser.BruiserScreen'
     ScreenImages(4)=Texture'2009DoomMonstersTex.Bruiser.BruiserSightTex'
     FadeScreenClass=Class'ScrnDoom3KF.BruiserScreenMaterialSequence'
     FadeMouthClass=Class'ScrnDoom3KF.BruiserMouthMaterialSequence'
     DeathAnims(0)="DeathF"
     DeathAnims(1)="DeathB"
     DeathAnims(2)="DeathF"
     DeathAnims(3)="DeathB"
     SightAnim="Sight"
     HitAnimsX(0)="PainL"
     HitAnimsX(1)="PainR"
     HitAnimsX(2)="PainL"
     HitAnimsX(3)="PainR"
     MinHitAnimDelay=2.500000
     MeleeAttackSounds(0)=Sound'2009DoomMonstersSounds.Bruiser.Bruiser_melee_01'
     MeleeAttackSounds(1)=Sound'2009DoomMonstersSounds.Bruiser.Bruiser_melee_02'
     MeleeAttackSounds(2)=Sound'2009DoomMonstersSounds.Bruiser.Bruiser_combat_chatter_02'
     MeleeAttackSounds(3)=Sound'2009DoomMonstersSounds.Bruiser.Bruiser_combat_chatter_01'
     SightSound=Sound'2009DoomMonstersSounds.Bruiser.Bruiser_sight_01'
     BurningMaterial=Texture'2009DoomMonstersTex.Bruiser.BruiserSkin'
     BurnClass=Class'ScrnDoom3KF.BruiserBurnTex'
     FadeClass=Class'ScrnDoom3KF.BruiserMaterialSequence'
     MeleeKnockBack=26000.000000
     RangedProjectile=Class'ScrnDoom3KF.BruiserProjectile'
     HasHitAnims=True
     BigMonster=True
     aimerror=100
     BurnAnimTime=0.250000
     MeleeAnims(0)="Attack1"
     MeleeAnims(1)="Attack2"
     MeleeDamage=34
     bFatAss=True
     bUseExtendedCollision=True
     ColOffset=(X=6.000000,Z=48.000000)
     ColRadius=40.000000
     ColHeight=38.000000
     PlayerCountHealthScale=0.080000
     FootStep(0)=Sound'2009DoomMonstersSounds.Bruiser.Bruiser_fs_01'
     FootStep(1)=Sound'2009DoomMonstersSounds.Bruiser.Bruiser_fs_02'
     DodgeSkillAdjust=1.000000
     HitSound(0)=Sound'2009DoomMonstersSounds.Bruiser.Bruiser_pain_01'
     HitSound(1)=Sound'2009DoomMonstersSounds.Bruiser.Bruiser_pain_02'
     HitSound(2)=Sound'2009DoomMonstersSounds.Bruiser.Bruiser_pain_03'
     HitSound(3)=Sound'2009DoomMonstersSounds.Bruiser.Bruiser_pain_01'
     DeathSound(0)=Sound'2009DoomMonstersSounds.Bruiser.Bruiser_death_03'
     DeathSound(1)=Sound'2009DoomMonstersSounds.Bruiser.Bruiser_death_01'
     DeathSound(2)=Sound'2009DoomMonstersSounds.Bruiser.Bruiser_death_03'
     DeathSound(3)=Sound'2009DoomMonstersSounds.Bruiser.Bruiser_death_01'
     ChallengeSound(0)=Sound'2009DoomMonstersSounds.Bruiser.Bruiser_combat_chatter_02'
     ChallengeSound(1)=Sound'2009DoomMonstersSounds.Bruiser.Bruiser_combat_chatter_01'
     ChallengeSound(2)=Sound'2009DoomMonstersSounds.Bruiser.Bruiser_sight_03'
     ChallengeSound(3)=Sound'2009DoomMonstersSounds.Bruiser.Bruiser_sight_02'
     ScoringValue=150
     WallDodgeAnims(0)="DodgeL"
     WallDodgeAnims(1)="DodgeR"
     WallDodgeAnims(2)="DodgeL"
     WallDodgeAnims(3)="DodgeR"
     IdleHeavyAnim="Idle"
     IdleRifleAnim="Idle"
     FireHeavyRapidAnim="Walk"
     FireHeavyBurstAnim="Walk"
     FireRifleRapidAnim="Walk"
     FireRifleBurstAnim="Walk"
     RagdollOverride="D3Bruiser"
     bCanJump=False
     MeleeRange=120.000000
     GroundSpeed=120.000000
     HealthMax=1000.000000
     Health=1000
     HeadRadius=14.000000
     MenuName="Bruiser"
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
     DodgeAnims(0)="DodgeL"
     DodgeAnims(1)="DodgeR"
     AirStillAnim="Walk"
     TakeoffStillAnim="Walk"
     CrouchTurnRightAnim="Walk"
     CrouchTurnLeftAnim="Walk"
     IdleCrouchAnim="Idle"
     IdleSwimAnim="Idle"
     IdleWeaponAnim="Idle"
     IdleRestAnim="Idle"
     IdleChatAnim="Idle"
     HeadBone="neck_6"
     Mesh=SkeletalMesh'2009DoomMonstersAnims.BruiserMesh'
     DrawScale=1.300000
     Skins(0)=Combiner'2009DoomMonstersTex.Bruiser.JBruiserSkin'
     Skins(1)=Shader'2009DoomMonstersTex.Bruiser.BruiserSkinShader'
     Skins(2)=Shader'2009DoomMonstersTex.Bruiser.BruiserScreenShader'
     CollisionHeight=44 //55
     Mass=4000.000000
     ZapThreshold=1.750000
}
