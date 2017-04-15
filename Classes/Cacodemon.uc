class Cacodemon extends DoomMonster;

var transient float NextRangedTime;

var Sound RangedAttackSounds[3];
var Sound RandomSounds[4];
var float RangedAttackInterval;
var float LastRangedAttack;
var CacodemonMouthTorch Vents[2];
var CacodemonMouthFlare MouthFlare;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	if( Level.NetMode!=NM_DedicatedServer )
	{
		Vents[0] = Spawn(class'CacodemonMouthTorch');
		AttachToBone(Vents[0],'LVent');
		Vents[1] = Spawn(class'CacodemonMouthTorch');
		AttachToBone(Vents[1],'RVent');
	}
}

function ZombieMoan()
{
	PlaySound(RandomSounds[Rand(ArrayCount(RandomSounds))], SLOT_Interact);
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
		SetAnimAction(MeleeAnims[0]);
	}
	else if( NextRangedTime<Level.TimeSeconds )
	{
		NextRangedTime = Level.TimeSeconds+1.f+FRand()*3.f;
		PrepareStillAttack(A);
		SetAnimAction('RangedAttack');
	}
}

simulated function FireProjectile()
{
	if ( Level.NetMode!=NM_Client && Controller!=None )
		FireProj(GetBoneCoords('caco_mouthfire').Origin);
	PlaySound(RangedAttackSounds[Rand(3)],SLOT_Interact);
	if( Level.NetMode!=NM_DedicatedServer )
	{
		MouthFlare = Spawn(class'CacodemonMouthFlare');
		AttachToBone(MouthFlare,'caco_mouthfire');
	}
}

simulated function RemoveEffects()
{
	if(Vents[0] != None)
	{
		DetachFromBone(Vents[0]);
		Vents[0].Kill();
	}
	if(Vents[1] != None)
	{
		DetachFromBone(Vents[1]);
		Vents[1].Kill();
	}
	if(MouthFlare != None)
	{
		DetachFromBone(MouthFlare);
		MouthFlare.Kill();
	}
}
function SetMovementPhysics()
{
	SetPhysics(PHYS_Flying);
}
singular function Falling()
{
	SetPhysics(PHYS_Flying);
}

// function SetOverlayMaterial(Material mat, float time, bool bOverride);

simulated function FadeSkins()
{
	Skins[0] = FadeFX;
	Skins[1] = InvisMat;
	Skins[2] = FadeFX;
	Skins[3] = InvisMat;
	Skins[4] = InvisMat;
	MakeBurnAway();
}

simulated function BurnAway()
{
	Skins[0] = BurnFX;
	Skins[2] = BurnFX;
	Burning = true;
	PlaySound(DeResSound,SLOT_Misc,2,,500.f);
}

/*
function bool IsHeadShot(vector loc, vector ray, float AdditionalScale)
{
	return false;
}
*/

simulated function AnimEnd( int Channel )
{
	Super.AnimEnd(Channel);
	if( Level.NetMode!=NM_DedicatedServer )
	{
		if( VSizeSquared(Velocity)<10000.f )
			LoopAnim(IdleRestAnim,,0.1f);
		else LoopAnim(MovementAnims[0],,0.1f);
	}
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
     RangedAttackSounds(0)=Sound'2009DoomMonstersSounds.Cacodemon.caco_fire_02'
     RangedAttackSounds(1)=Sound'2009DoomMonstersSounds.Cacodemon.caco_fire_03'
     RangedAttackSounds(2)=Sound'2009DoomMonstersSounds.Cacodemon.caco_fire_04'
     RandomSounds(0)=Sound'2009DoomMonstersSounds.Cacodemon.caco_breath2'
     RandomSounds(1)=Sound'2009DoomMonstersSounds.Cacodemon.caco_chatter1'
     RandomSounds(2)=Sound'2009DoomMonstersSounds.Cacodemon.caco_chatter2'
     RandomSounds(3)=Sound'2009DoomMonstersSounds.Cacodemon.caco_chatter5'
     DeathAnims(0)="DeathF"
     DeathAnims(1)="DeathB"
     DeathAnims(2)="DeathF"
     DeathAnims(3)="DeathB"
     SightAnim="Sight"
     HitAnimsX(0)="Pain"
     HitAnimsX(1)="Pain"
     HitAnimsX(2)="Pain"
     HitAnimsX(3)="Pain"
     SightSound=Sound'2009DoomMonstersSounds.Cacodemon.caco_sight2_2'
     DeResSound=Sound'2009DoomMonstersSounds.Cacodemon.caco_burn'
     BurningMaterial=Texture'2009DoomMonstersTex.Cacodemon.CacodemonSkin'
     BurnClass=Class'ScrnDoom3KF.CacodemonBurnTex'
     FadeClass=Class'ScrnDoom3KF.CacodemonMaterialSequence'
     RangedProjectile=Class'ScrnDoom3KF.CacodemonProjectile'
     DoomTeleportFXClass=Class'ScrnDoom3KF.DemonSpawnB'
     HasHitAnims=True
     aimerror=200
     BurnAnimTime=0.300000
     MeleeAnims(0)="melee"
     MeleeDamage=48
     DodgeSkillAdjust=3.000000
     HitSound(0)=Sound'2009DoomMonstersSounds.Cacodemon.caco_pain5'
     HitSound(1)=Sound'2009DoomMonstersSounds.Cacodemon.caco_pain5'
     HitSound(2)=Sound'2009DoomMonstersSounds.Cacodemon.caco_pain5'
     HitSound(3)=Sound'2009DoomMonstersSounds.Cacodemon.caco_pain5'
     DeathSound(0)=Sound'2009DoomMonstersSounds.Cacodemon.caco_death1'
     DeathSound(1)=Sound'2009DoomMonstersSounds.Cacodemon.caco_death2'
     DeathSound(2)=Sound'2009DoomMonstersSounds.Cacodemon.caco_death3'
     DeathSound(3)=Sound'2009DoomMonstersSounds.Cacodemon.caco_death1'
     ChallengeSound(0)=Sound'2009DoomMonstersSounds.Cacodemon.caco_sight2_4'
     ChallengeSound(1)=Sound'2009DoomMonstersSounds.Cacodemon.caco_sight5'
     ChallengeSound(2)=Sound'2009DoomMonstersSounds.Cacodemon.caco_sight6'
     ChallengeSound(3)=Sound'2009DoomMonstersSounds.Cacodemon.caco_sight5'
     ScoringValue=50
     WallDodgeAnims(0)="Run"
     WallDodgeAnims(1)="Run"
     WallDodgeAnims(2)="Run"
     WallDodgeAnims(3)="Run"
     IdleHeavyAnim="Idle"
     IdleRifleAnim="Idle"
     FireHeavyRapidAnim="Idle"
     FireHeavyBurstAnim="Idle"
     FireRifleRapidAnim="Idle"
     FireRifleBurstAnim="Idle"
     RagdollOverride="D3Cacodemon"
     bCanJump=False
     bCanFly=True
     bCanStrafe=True
     MeleeRange=30.000000
     GroundSpeed=100.000000
     AirSpeed=120.000000
     HealthMax=500.000000
     Health=500
     MenuName="Cacodemon"
     ControllerClass=Class'ScrnDoom3KF.CacodemonAI'
     bPhysicsAnimUpdate=False
     MovementAnims(0)="Run"
     MovementAnims(1)="Run"
     MovementAnims(2)="Run"
     MovementAnims(3)="Run"
     TurnLeftAnim="Run"
     TurnRightAnim="Run"
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
     AirAnims(0)="Run"
     AirAnims(1)="Run"
     AirAnims(2)="Run"
     AirAnims(3)="Run"
     TakeoffAnims(0)="Run"
     TakeoffAnims(1)="Run"
     TakeoffAnims(2)="Run"
     TakeoffAnims(3)="Run"
     LandAnims(0)="Run"
     LandAnims(1)="Run"
     LandAnims(2)="Run"
     LandAnims(3)="Run"
     DoubleJumpAnims(0)="Run"
     DoubleJumpAnims(1)="Run"
     DoubleJumpAnims(2)="Run"
     DoubleJumpAnims(3)="Run"
     DodgeAnims(0)="Run"
     DodgeAnims(1)="Run"
     DodgeAnims(2)="Run"
     DodgeAnims(3)="Run"
     AirStillAnim="Run"
     TakeoffStillAnim="Run"
     CrouchTurnRightAnim="Run"
     CrouchTurnLeftAnim="Run"
     IdleCrouchAnim="Idle"
     IdleSwimAnim="Idle"
     IdleWeaponAnim="Idle"
     IdleRestAnim="Idle"
     IdleChatAnim="Idle"
     AmbientSound=Sound'2009DoomMonstersSounds.Cacodemon.caco_flight_08'
     Mesh=SkeletalMesh'2009DoomMonstersAnims.CacodemonMesh'
     DrawScale=1.500000
     Skins(0)=Texture'2009DoomMonstersTex.Cacodemon.CacodemonSkin'
     Skins(1)=Shader'2009DoomMonstersTex.Cacodemon.EyeShader'
     Skins(2)=Texture'2009DoomMonstersTex.Cacodemon.CacodemonSkin'
     Skins(3)=Shader'2009DoomMonstersTex.Cacodemon.BrainShader'
     Skins(4)=FinalBlend'2009DoomMonstersTex.Cacodemon.CacoDemonMouthFB'
     SoundVolume=250
     SoundRadius=100.000000
     CollisionRadius=20.000000
     CollisionHeight=44 //50
     bUseExtendedCollision=True
     ColOffset=(Y=-1,Z=24)
     ColRadius=50
     ColHeight=40.000000

    HeadBone="Rtbrain" //7.00
    HeadBone2="Lftbrain" //8.11
    HeadOffset=(Z=-5)
    HeadRadius=12

    ZapThreshold=0.75
    ZappedDamageMod=1.5
}
