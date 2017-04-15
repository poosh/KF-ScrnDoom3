class CyberDemon extends DoomMonster;

var() Material WeaponFlashLight[4];
var(Anims) name RangedAttackAnims[3];
var(Sounds) Sound RocketSounds[3];
var Emitter FireEffects[3];

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	if( Level.NetMode!=NM_DedicatedServer )
	{
		FireEffects[0] = Spawn(class'CyberDemonMouthEffect',self);
		AttachToBone(FireEffects[0],'cyber_mouth_fire');
		FireEffects[1] = Spawn(class'CyberDemonMouthSideFire',self);
		AttachToBone(FireEffects[1],'LFire');
		FireEffects[2] = Spawn(class'CyberDemonMouthSideFire',self);
		AttachToBone(FireEffects[2],'RFire');
	}
	bHasRoamed = false;
}

function ZombieMoan()
{
	PlaySound(ChallengeSound[Rand(4)],SLOT_Talk, 2);
}

function RangedAttack(Actor A)
{
	if ( bShotAnim )
		return;
	if( !bHasRoamed )
		RoamAtPlayer();
	else if( NextProjTime<Level.TimeSeconds || IsInMeleeRange(A) )
	{
		PrepareStillAttack(A);
		if( Health>1000 )
			NextProjTime = Level.TimeSeconds+2.f+FRand()*6.f;
		else NextProjTime = Level.TimeSeconds+0.6f+FRand()*3.f;
		SetAnimAction(RangedAttackAnims[Rand(ArrayCount(RangedAttackAnims))]);
	}
}

simulated function FireProjectile()
{
	local Coords BoneLocation;

	BoneLocation = GetBoneCoords('cyber_barrel_smoke');
	if ( Level.NetMode!=NM_Client && Controller!=None )
		FireProj(BoneLocation.Origin);
	if( Level.NetMode!=NM_DedicatedServer )
	{
		Spawn(class'RevenantSmokePuffs',,,BoneLocation.Origin);
		PlaySound(RocketSounds[Rand(3)],SLOT_Interact);
	}
}

simulated function RangedEffect()
{
}

simulated function RocketFlashOn()
{
	Skins[1] = WeaponFlashLight[0];
	Skins[2] = WeaponFlashLight[1];
	Skins[3] = WeaponFlashLight[2];
	Skins[4] = WeaponFlashLight[3];
}

simulated function RocketFlashOff()
{
	Skins[1] = default.Skins[1];
	Skins[2] = default.Skins[2];
	Skins[3] = default.Skins[3];
	Skins[4] = default.Skins[4];
}

function PlayTakeHit(vector HitLocation, int Damage, class<DamageType> DamageType)
{
	if ( Damage>50 )
		Super.PlayTakeHit(HitLocation,Damage,DamageType);
}

// function SetOverlayMaterial(Material mat, float time, bool bOverride);

simulated function RemoveEffects()
{
	local byte i;

	for(i=0;i<3;i++)
	{
		if(FireEffects[i] != None)
		{
			DetachFromBone(FireEffects[i]);
			FireEffects[i].Kill();
		}
	}
}

simulated function FadeSkins()
{
	Skins[0] = FadeFX;
	Skins[1] = InvisMat;
	Skins[2] = InvisMat;
	Skins[3] = InvisMat;
	Skins[4] = InvisMat;
	MakeBurnAway();
}

simulated function BurnAway()
{
	Skins[0] = BurnFX;
	Burning = true;
}

defaultproperties
{
     WeaponFlashLight(0)=Shader'2009DoomMonstersTex.CyberDemon.WeaponTipGlow'
     WeaponFlashLight(1)=Shader'2009DoomMonstersTex.CyberDemon.WeaponFlash'
     WeaponFlashLight(2)=Shader'2009DoomMonstersTex.CyberDemon.WeaponTipGlow'
     WeaponFlashLight(3)=Shader'2009DoomMonstersTex.Revenant.WeaponFlash2'
     RangedAttackAnims(0)="Shot1"
     RangedAttackAnims(1)="Shot2"
     RangedAttackAnims(2)="Shot3"
     RocketSounds(0)=Sound'2009DoomMonstersSounds.CyberDemon.CyberDemon_rocket_fire_01'
     RocketSounds(1)=Sound'2009DoomMonstersSounds.CyberDemon.CyberDemon_rocket_fire_03'
     RocketSounds(2)=Sound'2009DoomMonstersSounds.CyberDemon.CyberDemon_rocket_fire_04'
     DeathAnims(0)="DeathF"
     DeathAnims(1)="DeathB"
     DeathAnims(2)="DeathF"
     DeathAnims(3)="DeathB"
     SightAnim="Sight"
     HitAnimsX(0)="Pain"
     HitAnimsX(1)="Pain"
     HitAnimsX(2)="Pain"
     HitAnimsX(3)="Pain"
     MinHitAnimDelay=4.000000
     SightSound=Sound'2009DoomMonstersSounds.CyberDemon.CyberDemon_sight1'
     BurningMaterial=Texture'2009DoomMonstersTex.CyberDemon.CyberDemonSkin1'
     FootstepSndRadius=1100.000000
     RangedProjectile=Class'ScrnDoom3KF.CyberDemonProjectile'
     DoomTeleportFXClass=Class'ScrnDoom3KF.BossDemonSpawn'
     HasHitAnims=True
     BigMonster=True
     BurnAnimTime=0.150000
     bCanAttackPipebombs=True
     bFatAss=True
     FootStep(0)=Sound'2009DoomMonstersSounds.CyberDemon.CyberDemon_step2'
     FootStep(1)=Sound'2009DoomMonstersSounds.CyberDemon.CyberDemon_step3'
     bMeleeFighter=False
     bBoss=True
     DodgeSkillAdjust=0.100000
     HitSound(0)=Sound'2009DoomMonstersSounds.CyberDemon.CyberDemon_pain1'
     HitSound(1)=Sound'2009DoomMonstersSounds.CyberDemon.CyberDemon_pain2'
     HitSound(2)=Sound'2009DoomMonstersSounds.CyberDemon.CyberDemon_pain3'
     HitSound(3)=Sound'2009DoomMonstersSounds.CyberDemon.CyberDemon_pain4'
     DeathSound(0)=Sound'2009DoomMonstersSounds.CyberDemon.CyberDemon_sight3'
     DeathSound(1)=Sound'2009DoomMonstersSounds.CyberDemon.CyberDemon_sight2'
     DeathSound(2)=Sound'2009DoomMonstersSounds.CyberDemon.CyberDemon_sight3'
     DeathSound(3)=Sound'2009DoomMonstersSounds.CyberDemon.CyberDemon_sight2'
     ChallengeSound(0)=Sound'2009DoomMonstersSounds.CyberDemon.CyberDemon_sight1'
     ChallengeSound(1)=Sound'2009DoomMonstersSounds.CyberDemon.CyberDemon_chatter2'
     ChallengeSound(2)=Sound'2009DoomMonstersSounds.CyberDemon.CyberDemon_chatter1'
     ChallengeSound(3)=Sound'2009DoomMonstersSounds.CyberDemon.CyberDemon_sight1'
     ScoringValue=1000
     FootstepVolume=2.000000
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
     RagdollOverride="D3CyberDemon"
     bCanJump=False
     GroundSpeed=210.000000
     HealthMax=7000.000000
     Health=7000
     HeadRadius=24.000000
     MenuName="CyberDemon"
     ControllerClass=Class'ScrnDoom3KF.CyberDemonAI'
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
     Mesh=SkeletalMesh'2009DoomMonstersAnims.CyberDemonMesh'
     DrawScale=0.8
     PrePivot=(Z=-32)
     Skins(0)=Combiner'2009DoomMonstersTex.CyberDemon.JCyberDemonSkin'
     Skins(1)=Texture'2009DoomMonstersTex.Revenant.InvisMat'
     Skins(2)=Texture'2009DoomMonstersTex.Revenant.InvisMat'
     Skins(3)=Texture'2009DoomMonstersTex.Revenant.InvisMat'
     Skins(4)=Texture'2009DoomMonstersTex.Revenant.InvisMat'
     TransientSoundVolume=2.000000
     TransientSoundRadius=1000.000000
     CollisionRadius=26
     CollisionHeight=44
     bUseExtendedCollision=True
     ColOffset=(X=20,Z=60)
     ColRadius=80
     ColHeight=80
     Mass=8000.000000
}
