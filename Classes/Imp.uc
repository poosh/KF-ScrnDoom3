class Imp extends DoomMonster;

var(Anims) name StandingRanged[5],JumpAttacks[3],CrouchHitAnims[4];
var() array<Material> RandSkins;
var bool bCrawlingNow,bClientCrawling;
var transient float NextRangedTime;

var(Sounds) Sound FireBallCreate,Squeals[12];
var ImpHandTrail FireTrail;

replication
{
	reliable if( Role == ROLE_Authority )
		bCrawlingNow;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	Skins[0] = RandSkins[Rand(RandSkins.Length)];
	BurningMaterial = Skins[0];
	if( Level.NetMode!=NM_Client && FRand()<0.4 )
		SetCrawling(true);
}

simulated function PostNetReceive()
{
	if( bClientCrawling!=bCrawlingNow )
		SetCrawling(bCrawlingNow);
}
simulated function PlayDeathAnim()
{
	if( !bCrawlingNow )
		PlayAnim(DeathAnims[Rand(4)],BurnAnimTime, 0.6f);
	else PlayAnim(DeathAnims[Rand(4)],BurnAnimTime, 0.1);
}

// While enemy is not in reach but still in sight.
function bool ShouldTryRanged( Actor A )
{
	return NextRangedTime < Level.TimeSeconds && FRand() < 0.5;
}

simulated function SetCrawling( bool bCrawl )
{
	local byte i;

	bClientCrawling = bCrawl;
	bCrawlingNow = bCrawl;
	if( bCrawl )
	{
		SightAnim = 'CrouchSight';
		for( i=0; i<ArrayCount(MovementAnims); i++ )
		{
			WalkAnims[i] = 'Scurry';
			MovementAnims[i] = 'Scurry';
		}
		TurnRightAnim = 'CrouchSight';
		TurnLeftAnim = 'CrouchSight';
		IdleRestAnim = 'CrouchSight';
		IdleWeaponAnim = 'CrouchSight';
		// if( MyExtCollision!=None )
			// MyExtCollision.SetCollision(false);
	}
	else
	{
		SightAnim = Default.SightAnim;
		for( i=0; i<ArrayCount(MovementAnims); i++ )
		{
			WalkAnims[i] = Default.WalkAnims[i];
			MovementAnims[i] = Default.MovementAnims[i];
		}
		TurnRightAnim = Default.TurnRightAnim;
		TurnLeftAnim = Default.TurnLeftAnim;
		IdleRestAnim = Default.IdleRestAnim;
		IdleWeaponAnim = Default.IdleWeaponAnim;
		// if( MyExtCollision!=None )
			// MyExtCollision.SetCollision(true);
	}
}

function RangedAttack(Actor A)
{
	local byte i;
	local float D;

	if (bShotAnim)
		return;

	if (!bHasRoamed) {
		RoamAtPlayer();
		return;
	}

	D = VSizeSquared(A.Location-Location);

	if( bCrawlingNow ) {
		if( !A.IsA('KFDoorMover') && FRand()<0.2 &&  D<250000.f )
		{
			PrepareMovingAttack(A,0.1);
			SetAnimAction('JumpStart');
		}
		else if( IsInMeleeRange(A) )
		{
			if( FRand()<0.5 )
			{
				PrepareStillAttack(A);
				SetAnimAction('CrouchAttack1');
			}
			else
			{
				PrepareMovingAttack(A,0.6);
				SetAnimAction('CrouchAttack2');
			}
		}
		else if( NextRangedTime<Level.TimeSeconds )
		{
			if( D < 1000000.f )
			{
				PrepareMovingAttack(A,0.3);
				SetAnimAction(StandingRanged[0]);
			}
			NextRangedTime = Level.TimeSeconds+2.f+FRand()*3.f;
		}
	}
	else if( IsInMeleeRange(A) )
	{
		PrepareMovingAttack(A,0.25);
		SetAnimAction(MeleeAnims[Rand(ArrayCount(MeleeAnims))]);
	}
	else if (NextRangedTime < Level.TimeSeconds) {
		if (D < 1000000.f) {
			i = Rand(4)+1;
			if( i==1 || i==2 ) {
				PrepareMovingAttack(A, 0.6);
			}
			else {
				PrepareStillAttack(A);
			}
			SetAnimAction(StandingRanged[i]);
			if (D < 360000.f) {
				NextRangedTime = Level.TimeSeconds + 0.5 + 1.5*frand();
			}
			else {
				NextRangedTime = Level.TimeSeconds + 2.0 + 3.0*frand();
			}
		}
		else {
			NextRangedTime = Level.TimeSeconds + 1.0 + 1.0*frand();
		}
	}
}

simulated function AnimEnd(int Channel)
{
	if( Level.NetMode!=NM_Client && bShotAnim && GetCurrentAnim()=='JumpStart' )
	{
		SetAnimAction(JumpAttacks[Rand(ArrayCount(JumpAttacks))]);
		if( Controller.Target==None )
			Velocity = vector(Rotation)*1400.f;
		else Velocity = Normal(Controller.Target.Location-Location)*1400.f;
		Controller.FocalPoint = Velocity*5.f+Location;
		Controller.Focus = None;
		Velocity.Z = FMax(Velocity.Z,140.f);
		SetPhysics(PHYS_Falling);
		return;
	}
	else if( bLunging && Physics==PHYS_Falling )
		return; // Keep animating...
	else if( bShotAnim && !bCrawlingNow && FRand()<0.1f )
	{
		Acceleration = vect(0,0,0);
		SetAnimAction('IdleCrouch');
		SetCrawling(true);
		return;
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

simulated function SetAnimAction(name NewAction)
{
	if( NewAction==JumpAttacks[0] || NewAction==JumpAttacks[1] || NewAction==JumpAttacks[2] )
		bLunging = true;
	Super.SetAnimAction(NewAction);
}
simulated function int DoAnimAction( name AnimName )
{
	if( AnimName=='IdleCrouch' )
		TweenAnim(AnimName,0.5f);
	else PlayAnim(AnimName,,0.1);
	return 0;
}

simulated function Landed(vector HitNormal)
{
	if( bLunging )
	{
		PlayAnim('JumpEnd');
		SetCrawling(false);
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
		FireProj(GetBoneCoords('rmissile').Origin);
	PlaySound(FireSound,SLOT_Interact);
}

simulated function PlayDirectionalHit(Vector HitLoc)
{
	if( bCrawlingNow )
		PlayAnim(CrouchHitAnims[Rand(4)],, 0.1);
	else Super.PlayDirectionalHit(HitLoc);
}

simulated function OutGoingSmallFireBall()
{
	if( Level.NetMode!=NM_DedicatedServer )
	{
		FireTrail = Spawn(class'ImpHandTrail');
		AttachToBone(FireTrail, 'rmissile');
		PlaySound(FireBallCreate,SLOT_Interact);
	}
}

simulated function TweenScurry()
{
	TweenAnim('Scurry',0.05);
}

simulated function Squeal()
{
	PlaySound(Squeals[Rand(12)],SLOT_Talk,2);
}

simulated function RemoveEffects()
{
	if(FireTrail != None)
		FireTrail.Kill();
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
	PlaySound(DeResSound,SLOT_Misc,2,,500.f);
}

defaultproperties
{
	StandingRanged(0)="RangedAttack1"
	StandingRanged(1)="RangedAttack2"
	StandingRanged(2)="RangedAttack3"
	StandingRanged(3)="RangedAttack4"
	StandingRanged(4)="RangedAttack5"
	JumpAttacks(0)="JumpMid"
	JumpAttacks(1)="JumpMid2"
	JumpAttacks(2)="JumpMid3"
	CrouchHitAnims(0)="CrouchPain"
	CrouchHitAnims(1)="CrouchPainHead"
	CrouchHitAnims(2)="CrouchPainL"
	CrouchHitAnims(3)="CrouchPainR"
	LungeAttackDamage=24
	RandSkins(0)=Combiner'2009DoomMonstersTex.Imp.JImpSkin1'
	RandSkins(1)=Combiner'2009DoomMonstersTex.Imp.JImpSkin2'
	RandSkins(2)=Combiner'2009DoomMonstersTex.Imp.JImpSkin3'
	RandSkins(3)=Combiner'2009DoomMonstersTex.Imp.JImpSkin4'
	RandSkins(4)=Combiner'2009DoomMonstersTex.Imp.JImpSkin5'
	RandSkins(5)=Combiner'2009DoomMonstersTex.Imp.JImpSkin6'
	RandSkins(6)=Combiner'2009DoomMonstersTex.Imp.JImpSkin7'
	FireBallCreate=Sound'2009DoomMonstersSounds.Imp.imp_fireball_create_02'
	Squeals(0)=Sound'2009DoomMonstersSounds.Imp.imp_1shot_attack_01'
	Squeals(1)=Sound'2009DoomMonstersSounds.Imp.imp_attack_test1'
	Squeals(2)=Sound'2009DoomMonstersSounds.Imp.imp_attack_test2'
	Squeals(3)=Sound'2009DoomMonstersSounds.Imp.imp_attack4'
	Squeals(4)=Sound'2009DoomMonstersSounds.Imp.imp_breath_test24'
	Squeals(5)=Sound'2009DoomMonstersSounds.Imp.imp_breath_test22'
	Squeals(6)=Sound'2009DoomMonstersSounds.Imp.imp_breath_test25'
	Squeals(7)=Sound'2009DoomMonstersSounds.Imp.imp_sight_02'
	Squeals(8)=Sound'2009DoomMonstersSounds.Imp.imp_sight_03'
	Squeals(9)=Sound'2009DoomMonstersSounds.Imp.imp_sight2_03'
	Squeals(10)=Sound'2009DoomMonstersSounds.Imp.imp_squeal_test12'
	Squeals(11)=Sound'2009DoomMonstersSounds.Imp.imp_squeal21'
	DeathAnims(0)="DeathB"
	DeathAnims(1)="DeathF"
	DeathAnims(2)="DeathB"
	DeathAnims(3)="DeathF"
	SightAnim="Sight"
	HitAnimsX(0)="PainL"
	HitAnimsX(1)="PainHead"
	HitAnimsX(2)="PainR"
	HitAnimsX(3)="PainHead"
	MeleeAttackSounds(0)=Sound'2009DoomMonstersSounds.Imp.imp_hit_05'
	MeleeAttackSounds(1)=Sound'2009DoomMonstersSounds.Imp.imp_hit_01'
	MeleeAttackSounds(2)=Sound'2009DoomMonstersSounds.Imp.imp_hit_05'
	MeleeAttackSounds(3)=Sound'2009DoomMonstersSounds.Imp.imp_hit_01'
	SightSound=Sound'2009DoomMonstersSounds.Imp.imp_sight_01'
	DeResSound=Sound'2009DoomMonstersSounds.Archvile.Archvile_burn'
	BurningMaterial=Texture'2009DoomMonstersTex.Imp.ImpSkin1'
	BurnClass=Class'ScrnDoom3KF.ImpBurnTex'
	FadeClass=Class'ScrnDoom3KF.ImpMaterialSequence'
	RangedProjectile=Class'ScrnDoom3KF.ImpProjectile'
	HasHitAnims=True
	bHasFireWeakness=False
	BigMonster=True
	aimerror=5
	BurnAnimTime=0.250000
	MeleeAnims(0)="Slash1"
	MeleeAnims(1)="Slash2"
	MeleeAnims(2)="Slash3"
	MeleeDamage=16
	FootStep(0)=Sound'2009DoomMonstersSounds.Imp.imp_footstep_01'
	FootStep(1)=Sound'2009DoomMonstersSounds.Imp.imp_footstep_03'
	DodgeSkillAdjust=4.000000
	HitSound(0)=Sound'2009DoomMonstersSounds.Imp.imp_pain_test3'
	HitSound(1)=Sound'2009DoomMonstersSounds.Imp.imp_pain_test5'
	HitSound(2)=Sound'2009DoomMonstersSounds.Imp.imp_pain_test5'
	HitSound(3)=Sound'2009DoomMonstersSounds.Imp.imp_pain_test3'
	DeathSound(0)=Sound'2009DoomMonstersSounds.Imp.imp_death_02'
	DeathSound(1)=Sound'2009DoomMonstersSounds.Imp.imp_death_03'
	DeathSound(2)=Sound'2009DoomMonstersSounds.Imp.imp_death_04'
	DeathSound(3)=Sound'2009DoomMonstersSounds.Imp.imp_death_03'
	ChallengeSound(0)=Sound'2009DoomMonstersSounds.Imp.imp_sight_02'
	ChallengeSound(1)=Sound'2009DoomMonstersSounds.Imp.imp_breath_test25'
	ChallengeSound(2)=Sound'2009DoomMonstersSounds.Imp.imp_sight_02'
	ChallengeSound(3)=Sound'2009DoomMonstersSounds.Imp.imp_boomer'
	FireSound=Sound'2009DoomMonstersSounds.Imp.imp_fireball_throw_01'
	ScoringValue=25
	WallDodgeAnims(0)="DodgeCrouchL"
	WallDodgeAnims(1)="DodgeCrouchR"
	WallDodgeAnims(2)="DodgeCrouchL"
	WallDodgeAnims(3)="DodgeCrouchR"
	IdleHeavyAnim="AttackIdle"
	IdleRifleAnim="AttackIdle"
	FireHeavyRapidAnim="Scurry"
	FireHeavyBurstAnim="Scurry"
	FireRifleRapidAnim="Scurry"
	FireRifleBurstAnim="Scurry"
	RagdollOverride="D3Imp"
	MeleeRange=40.000000
	GroundSpeed=200.000000
	HealthMax=200
	Health=200
	HeadRadius=12.000000
	MenuName="Imp"
	MovementAnims(0)="WalkFast"
	MovementAnims(1)="WalkFast"
	MovementAnims(2)="WalkFast"
	MovementAnims(3)="WalkFast"
	TurnLeftAnim="WalkFast"
	TurnRightAnim="WalkFast"
	SwimAnims(0)="Scurry"
	SwimAnims(1)="Scurry"
	SwimAnims(2)="Scurry"
	SwimAnims(3)="Scurry"
	CrouchAnims(0)="Scurry"
	CrouchAnims(1)="Scurry"
	CrouchAnims(2)="Scurry"
	CrouchAnims(3)="Scurry"
	WalkAnims(0)="Walk"
	WalkAnims(1)="Walk"
	WalkAnims(2)="Walk"
	WalkAnims(3)="Walk"
	AirAnims(0)="JumpMid"
	AirAnims(1)="JumpMid"
	AirAnims(2)="JumpMid"
	AirAnims(3)="JumpMid"
	TakeoffAnims(0)="JumpMid2"
	TakeoffAnims(1)="JumpMid2"
	TakeoffAnims(2)="JumpMid2"
	TakeoffAnims(3)="JumpMid2"
	LandAnims(0)="JumpEnd"
	LandAnims(1)="JumpEnd"
	LandAnims(2)="JumpEnd"
	LandAnims(3)="JumpEnd"
	DoubleJumpAnims(0)="JumpMid2"
	DoubleJumpAnims(1)="JumpMid2"
	DoubleJumpAnims(2)="JumpMid2"
	DoubleJumpAnims(3)="JumpMid2"
	DodgeAnims(0)="DodgeL"
	DodgeAnims(1)="DodgeR"
	AirStillAnim="JumpMid3"
	TakeoffStillAnim="JumpMid2"
	CrouchTurnRightAnim="Scurry"
	CrouchTurnLeftAnim="Scurry"
	IdleCrouchAnim="IdleCrouch"
	IdleSwimAnim="IdleCrouch"
	IdleWeaponAnim="AttackIdle"
	IdleRestAnim="AttackIdle"
	IdleChatAnim="AttackIdle"
	Mesh=SkeletalMesh'2009DoomMonstersAnims.ImpMesh'
	Skins(0)=Texture'2009DoomMonstersTex.Imp.ImpSkin1'
	CollisionRadius=26.000000
	CollisionHeight=30
	bUseExtendedCollision=True
	ColOffset=(X=8.000000,Z=28)
	ColRadius=35
	ColHeight=55

	MotionDetectorThreat=0.50 //5.14

	ZappedDamageMod=2.0

	LeftFArmBone="lhand"
	RightFArmBone="rhand"
	RootBone="Hips"
 }
