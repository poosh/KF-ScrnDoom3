class Seeker extends DoomMonster;

var Guardian Mother;
var Emitter SeekerEffect;
var Actor SeekerBeamEffect;
var bool ShouldExplode;

var float InvulnerableTimer;
var float DeathTimer;
var transient float NextTargetDetectTime;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	InvulnerableTimer += Level.TimeSeconds;
	DeathTimer += 15.0 * frand();
	DeathTimer += Level.TimeSeconds;

	if( Level.NetMode!=NM_DedicatedServer )
	{
		SeekerEffect = Spawn(class'SeekerLightFXEmitter',self);
		AttachToBone(SeekerEffect, 'LightFX');
		SeekerBeamEffect = Spawn(class'SeekerTorchMesh',self);
		AttachToBone(SeekerBeamEffect, 'LightFX');
	}
}

function TakeDamage( int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex )
{
    if ( Level.TimeSeconds < InvulnerableTimer )
        return;

	Super.TakeDamage(Damage,InstigatedBy,HitLocation,Momentum,DamageType,HitIndex);
}

function RangedAttack(Actor A)
{
	if ( bShotAnim )
		return;

	if( !bHasRoamed )
		RoamAtPlayer();

	if ( Mother != none && Level.TimeSeconds > NextTargetDetectTime && Pawn(A) != none && IsInMeleeRange(A) ) {
		Mother.TargetDetected(Pawn(A));
		NextTargetDetectTime = Level.TimeSeconds + 1;
	}
}

event bool EncroachingOn( actor Other )
{
	if( Guardian(Other)!=None || Seeker(Other)!=None )
		return false;
	return Super.EncroachingOn(Other);
}
event EncroachedBy( actor Other )
{
	if( Seeker(Other)==None )
		Super.EncroachedBy(Other);
}

function SetMovementPhysics()
{
	SetPhysics(PHYS_Flying);
}
singular function Falling()
{
	SetPhysics(PHYS_Flying);
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	if( Mother!=None )
	{
		Mother.SeekersCount--;
		Mother = None;
	}
	Super.Died(Killer,damageType,HitLocation);
}
simulated function PlayDirectionalDeath(Vector HitLoc)
{
	if(FastTrace(Location + vect(0,0,-300), Location) && fRand() > 0.5)
	{
		Super.PlayDirectionalDeath(HitLoc);
		PlayAnim('DeathFall');
		LifeSpan = 6.f;
		ShouldExplode = true;
	}
	else Super.PlayDirectionalDeath(HitLoc);
}

simulated function HeadExplode()
{
	if( Level.NetMode!=NM_DedicatedServer )
	{
		Velocity+=vect(0,0,300);
		PlayAnim('DeathF',1.0);
		Spawn(class'SeekerImpact',,, GetBoneCoords('head').Origin);
		if(SeekerBeamEffect != None)
			SeekerBeamEffect.Destroy();
		if(SeekerEffect != None)
			SeekerEffect.Destroy();
		SetBoneScale(4, , );
		HideBone('head');
		SetPhysics(PHYS_Falling);
		RandSpin(10000);
	}
}

State Dying
{
	simulated function Landed(vector HitNormal)
	{
		if( ShouldExplode && Level.NetMode!=NM_DedicatedServer )
		{
			bHidden = true;
			Spawn(class'SeekerImpact',,, Location);
			LifeSpan = 0.1f;
		}
		SetPhysics(PHYS_None);
		if ( !IsAnimating(0) )
			LandThump();
		Super.Landed(HitNormal);
	}
}

simulated function RemoveEffects()
{
	if(SeekerBeamEffect != None)
		SeekerBeamEffect.Destroy();
	if(SeekerEffect != None)
		SeekerEffect.Destroy();
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

simulated function AnimEnd( int Channel )
{
	Super.AnimEnd(Channel);
	if( VSizeSquared(Velocity)<800.f )
		LoopAnim(IdleRestAnim,,0.1f);
	else LoopAnim(MovementAnims[0],,0.1f);
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
     DeathAnims(0)="DeathF"
     DeathAnims(1)="DeathB"
     DeathAnims(2)="DeathF"
     DeathAnims(3)="DeathB"
     SightAnim="Sight"
     HitAnimsX(0)="Pain"
     SightSound=Sound'2009DoomMonstersSounds.Seeker.seeker3'
     HasHitAnims=True
     DodgeSkillAdjust=3.000000
     HitSound(0)=Sound'2009DoomMonstersSounds.Seeker.seeker1'
     HitSound(1)=Sound'2009DoomMonstersSounds.Seeker.seeker2'
     HitSound(2)=Sound'2009DoomMonstersSounds.Seeker.seeker2'
     HitSound(3)=Sound'2009DoomMonstersSounds.Seeker.seeker1'
     DeathSound(0)=Sound'2009DoomMonstersSounds.Seeker.seeker_die1'
     DeathSound(1)=Sound'2009DoomMonstersSounds.Seeker.seeker_die2'
     DeathSound(2)=Sound'2009DoomMonstersSounds.Seeker.seeker_die3'
     DeathSound(3)=Sound'2009DoomMonstersSounds.Seeker.seeker_die3'
     ChallengeSound(0)=Sound'2009DoomMonstersSounds.Seeker.seeker3'
     ChallengeSound(1)=Sound'2009DoomMonstersSounds.Seeker.seeker4'
     ChallengeSound(2)=Sound'2009DoomMonstersSounds.Seeker.seeker4'
     ChallengeSound(3)=Sound'2009DoomMonstersSounds.Seeker.seeker3'
     WallDodgeAnims(0)="Travel"
     WallDodgeAnims(1)="Travel"
     WallDodgeAnims(2)="Travel"
     WallDodgeAnims(3)="Travel"
     IdleHeavyAnim="Idle"
     IdleRifleAnim="Idle"
     FireHeavyRapidAnim="Idle"
     FireHeavyBurstAnim="Idle"
     FireRifleRapidAnim="Idle"
     FireRifleBurstAnim="Idle"
     RagdollOverride="D3Seeker"
     bCanJump=False
     bCanFly=True
     bCanStrafe=True
     MeleeRange=300.000000
     GroundSpeed=400.000000
     AirSpeed=400.000000
     HealthMax=100
     Health=100
     HeadRadius=25.000000
     MenuName="Seeker"
     ControllerClass=Class'ScrnDoom3KF.SeekerAI'
     bPhysicsAnimUpdate=False
     MovementAnims(0)="Travel"
     MovementAnims(1)="Travel"
     MovementAnims(2)="Travel"
     MovementAnims(3)="Travel"
     TurnLeftAnim="Travel"
     TurnRightAnim="Travel"
     SwimAnims(0)="Travel"
     SwimAnims(1)="Travel"
     SwimAnims(2)="Travel"
     SwimAnims(3)="Travel"
     CrouchAnims(0)="Travel"
     CrouchAnims(1)="Travel"
     CrouchAnims(2)="Travel"
     CrouchAnims(3)="Travel"
     WalkAnims(0)="Travel"
     WalkAnims(1)="Travel"
     WalkAnims(2)="Travel"
     WalkAnims(3)="Travel"
     AirAnims(0)="Travel"
     AirAnims(1)="Travel"
     AirAnims(2)="Travel"
     AirAnims(3)="Travel"
     TakeoffAnims(0)="Travel"
     TakeoffAnims(1)="Travel"
     TakeoffAnims(2)="Travel"
     TakeoffAnims(3)="Travel"
     LandAnims(0)="Travel"
     LandAnims(1)="Travel"
     LandAnims(2)="Travel"
     LandAnims(3)="Travel"
     DoubleJumpAnims(0)="Travel"
     DoubleJumpAnims(1)="Travel"
     DoubleJumpAnims(2)="Travel"
     DoubleJumpAnims(3)="Travel"
     DodgeAnims(0)="Travel"
     DodgeAnims(1)="Travel"
     DodgeAnims(2)="Travel"
     DodgeAnims(3)="Travel"
     AirStillAnim="Travel"
     TakeoffStillAnim="Travel"
     CrouchTurnRightAnim="Travel"
     CrouchTurnLeftAnim="Travel"
     IdleCrouchAnim="Idle"
     IdleSwimAnim="Idle"
     IdleWeaponAnim="Idle"
     IdleRestAnim="Idle"
     IdleChatAnim="Idle"
     Mesh=SkeletalMesh'2009DoomMonstersAnims.SeekerMesh'
     DrawScale=0.800000
     Skins(0)=Combiner'2009DoomMonstersTex.Seeker.JSeeker'
     CollisionRadius=20.000000
     CollisionHeight=35.000000

     MotionDetectorThreat=0 //5.14
     InvulnerableTimer=2
     DeathTimer=30
}
