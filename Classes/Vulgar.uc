class Vulgar extends DoomMonster;

var(Sounds) Sound FireBallCreate;
var(Anims) name RangedAttackAnims[2];
var() byte LungeAttackDamage;

var transient float NextRangedTime,NextLungeTime;
var bool bLunging;

var VulgarHandTrail FireTrail;
var MaterialSequence FadeFXTail;
var class<MaterialSequence> FadeTailClass;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	if( FRand()<0.25f )
	{
		Skins[0] = Texture'VulgarDarkSkin';
		Skins[2] = Texture'VulgarDarkTail';
	}
}

function bool ShouldTryRanged( Actor A )
{
	return (NextRangedTime<Level.TimeSeconds && FRand()<0.4f);
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
		SetAnimAction(MeleeAnims[Rand(3)]);
	}
	else if( NextLungeTime<Level.TimeSeconds && VSize(A.Location-Location)<600.f )
	{
		NextLungeTime = Level.TimeSeconds+2.f+FRand()*6.f;
		if( FRand()<0.3f )
			return;
		PrepareStillAttack(A);
		SetAnimAction('JumpStart');
	}
	else if( NextRangedTime<Level.TimeSeconds )
	{
		PrepareStillAttack(A);
		SetAnimAction(RangedAttackAnims[Rand(2)]);
		NextRangedTime = Level.TimeSeconds+2.f+FRand()*3.f;
	}
}
simulated function AnimEnd(int Channel)
{
	local name N;

	if( Level.NetMode!=NM_Client && bShotAnim )
	{
		N = GetCurrentAnim();
		if( N=='JumpStart' )
		{
			bLunging = true;
			SetAnimAction('JumpMid');
			if( Controller.Target==None )
				Velocity = vector(Rotation)*1400.f;
			else Velocity = Normal(Controller.Target.Location-Location)*1400.f;
			Controller.FocalPoint = Velocity*50.f+Location;
			Controller.Focus = None;
			Velocity.Z+=140.f;
			SetPhysics(PHYS_Falling);
			return;
		}
		else if( N=='JumpMid' || N=='Lunge' )
		{
			SetAnimAction('Lunge');
			return;
		}
	}
	Super.AnimEnd(Channel);
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
function Landed(vector HitNormal)
{
	if( bLunging )
	{
		SetAnimAction('JumpEnd');
		bLunging = false;
		return;
	}
	Super.Landed(HitNormal);
}

simulated function FireProjectile()
{
	if( FireTrail!=None )
		FireTrail.Destroy();
	if ( Level.NetMode!=NM_Client && Controller!=None )
		FireProj(GetBoneCoords('l_fireball').Origin);
	PlaySound(FireSound,SLOT_Interact);
}

simulated function FireRProjectile()
{
	if( FireTrail!=None )
		FireTrail.Destroy();
	if ( Level.NetMode!=NM_Client && Controller!=None )
		FireProj(GetBoneCoords('r_fireball').Origin);
	PlaySound(FireSound,SLOT_Interact);
}

simulated function OutGoingSmallFireBall()
{
	if( Level.NetMode!=NM_DedicatedServer )
	{
		FireTrail = Spawn(class'VulgarHandTrail', self);
		AttachToBone(FireTrail, 'l_fireball');
		PlaySound(FireBallCreate,SLOT_Interact);
	}
}

simulated function OutGoingRSmallFireBall()
{
	if( Level.NetMode!=NM_DedicatedServer )
	{
		FireTrail = Spawn(class'VulgarHandTrail', self);
		AttachToBone(FireTrail, 'r_fireball');
		PlaySound(FireBallCreate,SLOT_Interact);
	}
}

function PlayDirectionalHit(Vector HitLoc)
{
	if( HasHitAnims && !bShotAnim && nextHitAnimTime<Level.TimeSeconds && HitAnimsX.Length>0 && Acceleration!=vect(0,0,0) )
	{
		nextHitAnimTime = Level.TimeSeconds+1.f+FRand()*1.5f;
		bShotAnim = true;
 		SetAnimAction(HitAnimsX[Rand(HitAnimsX.Length)]);
	}
}

simulated function RemoveEffects()
{
	if(FireTrail != None)
		FireTrail.Kill();
}

simulated function FadeSkins()
{
	Skins[0] = FadeFX;
	Skins[2] = FadeFXTail;
	MakeBurnAway();
}

simulated function BurnAway()
{
	Skins[0] = BurnFX;
	Skins[1] = InvisMat;
	Skins[2] = BurnFX;
	Burning = true;
}

simulated function FreeFXObjects()
{
	if(FadeFXTail != None)
	{
		Level.ObjectPool.FreeObject(FadeFXTail);
		FadeFXTail = None;
	}
	Super.FreeFXObjects();
}

simulated function PlayDirectionalDeath(Vector HitLoc)
{
	RemoveEffects();
	BurnFX = DoomBurnTex(Level.ObjectPool.AllocateObject(BurnClass));
	FadeFX = MaterialSequence(Level.ObjectPool.AllocateObject(FadeClass));
	FadeFXTail = MaterialSequence(Level.ObjectPool.AllocateObject(FadeTailClass));

	if(FadeFX != None && BurnFX != None && FadeFXTail != None)
	{
		SetOverlayMaterial(None, 0.0f, true);
		SetCollision(false, false, false);
		Projectors.Remove(0, Projectors.Length);
		bAcceptsProjectors = false;
		if(PlayerShadow != None)
		{
			PlayerShadow.bShadowActive = false;
		}
		RemoveFlamingEffects();
 		PlayAnim(DeathAnims[Rand(4)],BurnAnimTime, 0.1);
	}
	else
	{
		PlayAnim(DeathAnims[Rand(4)],, 0.1);
	}
}

defaultproperties
{
     FireBallCreate=Sound'2009DoomMonstersSounds.Vulgar.Vulgar_fireball_create_01'
     RangedAttackAnims(0)="RangedAttack1"
     RangedAttackAnims(1)="RangedAttack2"
     LungeAttackDamage=18
     FadeTailClass=Class'ScrnDoom3KF.VulgarTailMaterialSequence'
     DeathAnims(0)="DeathF"
     DeathAnims(1)="DeathB"
     DeathAnims(2)="DeathF"
     DeathAnims(3)="DeathB"
     SightAnim="Sight"
     HitAnimsX(0)="RunPainL"
     HitAnimsX(1)="RunPainR"
     HitAnimsX(2)="RunPainL"
     HitAnimsX(3)="RunPainR"
     MeleeAttackSounds(0)=Sound'2009DoomMonstersSounds.Vulgar.Vulgar_melee_01'
     MeleeAttackSounds(1)=Sound'2009DoomMonstersSounds.Vulgar.Vulgar_melee_02'
     MeleeAttackSounds(2)=Sound'2009DoomMonstersSounds.Vulgar.Vulgar_melee_04'
     MeleeAttackSounds(3)=Sound'2009DoomMonstersSounds.Vulgar.Vulgar_melee_05'
     SightSound=Sound'2009DoomMonstersSounds.Vulgar.Vulgar_sight_01'
     RangedProjectile=Class'ScrnDoom3KF.VulgarProjectile'
     DoomTeleportFXClass=Class'ScrnDoom3KF.VulgarSpawn'
     BurnedTextureNum(1)=2
     HasHitAnims=True
     aimerror=5
     BurnAnimTime=0.250000
     MeleeAnims(0)="Attack1"
     MeleeAnims(1)="Attack2"
     MeleeAnims(2)="Attack3"
     MeleeDamage=8
     FootStep(0)=Sound'2009DoomMonstersSounds.Vulgar.Vulgar_step_01a'
     FootStep(1)=Sound'2009DoomMonstersSounds.Vulgar.Vulgar_step_02a'
     DodgeSkillAdjust=4.000000
     HitSound(0)=Sound'2009DoomMonstersSounds.Vulgar.Vulgar_pain_03a'
     HitSound(1)=Sound'2009DoomMonstersSounds.Vulgar.Vulgar_pain_05'
     HitSound(2)=Sound'2009DoomMonstersSounds.Vulgar.Vulgar_pain_08'
     HitSound(3)=Sound'2009DoomMonstersSounds.Vulgar.Vulgar_pain_09'
     DeathSound(0)=Sound'2009DoomMonstersSounds.Vulgar.Vulgar_death_01'
     DeathSound(1)=Sound'2009DoomMonstersSounds.Vulgar.Vulgar_death_02'
     DeathSound(2)=Sound'2009DoomMonstersSounds.Vulgar.Vulgar_death_03'
     DeathSound(3)=Sound'2009DoomMonstersSounds.Vulgar.Vulgar_death_04'
     ChallengeSound(0)=Sound'2009DoomMonstersSounds.Vulgar.Vulgar_cc_03'
     ChallengeSound(1)=Sound'2009DoomMonstersSounds.Vulgar.Vulgar_sight_03'
     ChallengeSound(2)=Sound'2009DoomMonstersSounds.Vulgar.Vulgar_sight_04'
     ChallengeSound(3)=Sound'2009DoomMonstersSounds.Vulgar.Vulgar_sight_05'
     FireSound=Sound'2009DoomMonstersSounds.Vulgar.Vulgar_fireball_create_02'
     ScoringValue=40
     WallDodgeAnims(0)="DodgeL"
     WallDodgeAnims(1)="DodgeR"
     WallDodgeAnims(2)="DodgeL"
     WallDodgeAnims(3)="DodgeR"
     IdleHeavyAnim="Idle2"
     IdleRifleAnim="Idle1"
     FireHeavyRapidAnim="Run"
     FireHeavyBurstAnim="Run"
     FireRifleRapidAnim="Run"
     FireRifleBurstAnim="Run"
     bCanJump=False
     GroundSpeed=130.000000
     HealthMax=320.000000
     Health=320
     HeadRadius=12.000000
     MenuName="Vulgar"
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
     AirAnims(0)="Lunge"
     AirAnims(1)="Lunge"
     AirAnims(2)="Lunge"
     AirAnims(3)="Lunge"
     TakeoffAnims(0)="JumpStart"
     TakeoffAnims(1)="JumpStart"
     TakeoffAnims(2)="JumpStart"
     TakeoffAnims(3)="JumpStart"
     LandAnims(0)="JumpEnd"
     LandAnims(1)="JumpEnd"
     LandAnims(2)="JumpEnd"
     LandAnims(3)="JumpEnd"
     DoubleJumpAnims(0)="Run"
     DoubleJumpAnims(1)="Run"
     DoubleJumpAnims(2)="Run"
     DoubleJumpAnims(3)="Run"
     DodgeAnims(0)="DodgeL"
     DodgeAnims(1)="DodgeR"
     AirStillAnim="Lunge"
     TakeoffStillAnim="JumpStart"
     CrouchTurnRightAnim="Run"
     CrouchTurnLeftAnim="Run"
     IdleCrouchAnim="Idle1"
     IdleSwimAnim="Idle2"
     IdleWeaponAnim="Idle1"
     IdleRestAnim="Idle2"
     IdleChatAnim="Idle1"
     HeadBone="head_1"
     Mesh=SkeletalMesh'2009DoomMonstersAnims.VulgarMesh'
     Skins(0)=Combiner'2009DoomMonstersTex.Vulgar.JVulgarSkin'
     Skins(1)=Shader'2009DoomMonstersTex.Vulgar.VulgarEyeShader'
     Skins(2)=Texture'2009DoomMonstersTex.Vulgar.VulgarTail'
     CollisionRadius=20.000000
     CollisionHeight=30.000000
     bUseExtendedCollision=True
     ColOffset=(Z=30)
     ColRadius=25
     ColHeight=40.000000

     MotionDetectorThreat=0.50 //5.14

     ZapThreshold=0.75
     ZappedDamageMod=1.5
}
