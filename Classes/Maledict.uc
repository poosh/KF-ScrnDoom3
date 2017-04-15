class Maledict extends DoomMonster;

var(Anims) Name SummonAnims[3];
var(Sounds) Sound ChargeSound[2],AsteroidSpawnSounds[2],OtherSpawnSpawns[4];
var() float ChargeSoundInterval;
var transient float NextChargeSound,NextRangedAttack;
var vector ForgottenPos;
var bool bSoulIsOK;

var transient ExtendedHeadCollision MyHeadCollision;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if ( Role == ROLE_Authority ) {
        // use ExtendedZCollision for the head detection
        bUseExtendedCollision = true;
        MyHeadCollision = Spawn(class 'ExtendedHeadCollision',self);
        MyHeadCollision.SetCollisionSize(HeadRadius,HeadRadius*2);
        MyHeadCollision.bHardAttach = true;
        AttachToBone(MyHeadCollision, HeadBone);
    }
}

function RangedAttack(Actor A)
{
	if ( bShotAnim )
		return;

	if( !bHasRoamed )
		RoamAtPlayer();
	else if( IsInMeleeRange(A) )
	{
		if ( MaxMeleeAttacks > 0) {
			PrepareStillAttack(A);
			SetAnimAction(MeleeAnims[0]);
			MaxMeleeAttacks--;
		}
		else {
			NextRangedAttack = Level.TimeSeconds - 1;
		}
	}

	if( NextRangedAttack<Level.TimeSeconds )
	{
		if (MaxMeleeAttacks <= 0)
			MaxMeleeAttacks = rand(default.MaxMeleeAttacks+1);

		NextRangedAttack = Level.TimeSeconds+2+FRand()*4.f;
		if( FRand()<0.25f )
			return;
		PrepareStillAttack(A);

		if(A.Location.Z <= (Location.Z + 100))
		{
			Controller.Destination = Location + 110 * (Normal(Location - A.Location) + VRand());
			Controller.Destination.Z = Location.Z + 500;
			Velocity = AirSpeed * normal(Controller.Destination - Location);
		}
		SetAnimAction(SummonAnims[Rand(3)]);
		bShotAnim = true;
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

function PlayChargeSound()
{
	if( NextChargeSound<Level.TimeSeconds )
	{
		NextChargeSound = Level.TimeSeconds+ChargeSoundInterval+ChargeSoundInterval*FRand();
		PlaySound(ChargeSound[Rand(2)],SLOT_Talk,3);
	}
}

// function SetOverlayMaterial(Material mat, float time, bool bOverride);

simulated function SpawnBigMeteor() //or firewall
{
	local class<Projectile> OriginalProj;

	if( Level.NetMode!=NM_Client )
	{
		OriginalProj = RangedProjectile;
		if( FRand()<0.5 )
			RangedProjectile = Class'MaledictMeteorBigProj';
		FireProj(Location);
		RangedProjectile = OriginalProj;
	}
	if( Level.NetMode!=NM_DedicatedServer )
		PlaySound(Sound'Maledict_flamewall_03',SLOT_Misc);
}

function SummonMeteors()
{
	local vector TargetDir,Pos,HL,HN;
	local int i;

	if( Controller!=None && Controller.Target!=None )
	{
		TargetDir = Normal(Controller.Target.Location-Location);
		if( TargetDir.Z>-0.6 )
		{
			TargetDir.Z = -0.6;
			TargetDir = Normal(TargetDir);
		}

		for( i=Rand(3); i<8; i++ )
		{
			Pos = Location;
			Pos.X+=(2000*FRand()-1000);
			Pos.Y+=(2000*FRand()-1000);
			Pos.Z+=(2000*FRand()-1000);
			if( Trace(HL,HN,Pos,Location,false,vect(12,12,12))!=None )
				Pos = HL+HN*4.f;
			if( Trace(HL,HN,Pos-TargetDir*8000.f,Pos,false,vect(10,10,10))==None )
				HL = Pos-TargetDir*8000.f;
			else HL+=HN*15.f;
			Spawn(class'MaledictMeteorProj',,,HL,rotator(TargetDir+VRand()*0.01f));
		}
	}
}

function SummonSouls()
{
	local byte i;

    if( ChildMonsterCounter>5 )
    {
        SpawnBigMeteor();
        return;
    }
    while( ++i<10 )
    {
        ForgottenPos = Location;
        ForgottenPos.X+=FRand()*700.f-350.f;
        ForgottenPos.Y+=FRand()*700.f-350.f;
        ForgottenPos.Z+=FRand()*400.f-200.f;
        if( FastTrace(ForgottenPos,Location) && VSizeSquared(ForgottenPos-Location)>10000.f )
            break;
    }
    Spawn(Class'DemonSpawnB',,,ForgottenPos);
    SetTimer(0.8,false);
    bSoulIsOK = true;
}

function Timer()
{
	if( !bSoulIsOK )
	{
		Super.Timer();
		return;
	}
	bSoulIsOK = false;
	SpawnChild(Class'Forgotten',ForgottenPos);
	if( BurnDown>0 ) // Keep burning...
		SetTimer(1,true);
}

simulated function FadeSkins()
{
}

simulated function BurnAway()
{
	Skins[0] = BurnFX;
	Skins[4] = BurnFX;
	Burning = true;
}

simulated function AnimEnd( int Channel )
{
	Super.AnimEnd(Channel);
	if( Level.NetMode!=NM_DedicatedServer )
	{
		if( VSizeSquared(Velocity)<40000.f || (Normal(Velocity) Dot vector(Rotation))<0.f )
			LoopAnim(DodgeAnims[0],,0.1f);
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
     SummonAnims(0)="Summon"
     SummonAnims(1)="Attack01"
     SummonAnims(2)="SummonLostSouls"
     ChargeSound(0)=Sound'2009DoomMonstersSounds.Maledict.Maledict_whoosh_01'
     ChargeSound(1)=Sound'2009DoomMonstersSounds.Maledict.Maledict_whoosh_02'
     AsteroidSpawnSounds(0)=Sound'2009DoomMonstersSounds.Maledict.Maledict_fire_05'
     AsteroidSpawnSounds(1)=Sound'2009DoomMonstersSounds.Maledict.Maledict_fire_02'
     OtherSpawnSpawns(0)=Sound'2009DoomMonstersSounds.Maledict.Maledict_firestarter_01'
     OtherSpawnSpawns(1)=Sound'2009DoomMonstersSounds.Maledict.Maledict_firestarter_02'
     OtherSpawnSpawns(2)=Sound'2009DoomMonstersSounds.Maledict.Maledict_firestarter_03'
     OtherSpawnSpawns(3)=Sound'2009DoomMonstersSounds.Maledict.Maledict_firestarter_04'
     ChargeSoundInterval=4.000000
     DeathAnims(0)="DeathB"
     DeathAnims(1)="DeathF"
     DeathAnims(2)="DeathB"
     DeathAnims(3)="DeathF"
     SightAnim="Sight"
     HitAnimsX(0)="Pain"
     MeleeAttackSounds(0)=Sound'2009DoomMonstersSounds.Maledict.Maledict_whoosh_01'
     MeleeAttackSounds(1)=Sound'2009DoomMonstersSounds.Maledict.Maledict_whoosh_02'
     MeleeAttackSounds(2)=Sound'2009DoomMonstersSounds.Maledict.Maledict_whoosh_01'
     MeleeAttackSounds(3)=Sound'2009DoomMonstersSounds.Maledict.Maledict_whoosh_02'
     SightSound=Sound'2009DoomMonstersSounds.Maledict.Maledict_Scream_01'
     BurnClass=Class'ScrnDoom3KF.MaledictBurnTex'
     RangedProjectile=Class'ScrnDoom3KF.MaledictFireWallProj'
     DoomTeleportFXClass=Class'ScrnDoom3KF.BossDemonSpawn'
     HasHitAnims=True
     BigMonster=True
     aimerror=100
     BurnAnimTime=0.500000
     MeleeAnims(0)="MeleeAttack01"
     MeleeDamage=55 //down from 85 in beta 11
     bBoss=True
     DodgeSkillAdjust=4.000000
     HitSound(0)=Sound'2009DoomMonstersSounds.Maledict.Maledict_scream_05'
     HitSound(1)=Sound'2009DoomMonstersSounds.Maledict.Maledict_scream_05'
     HitSound(2)=Sound'2009DoomMonstersSounds.Maledict.Maledict_scream_05'
     HitSound(3)=Sound'2009DoomMonstersSounds.Maledict.Maledict_scream_05'
     DeathSound(0)=Sound'2009DoomMonstersSounds.Maledict.Maledict_scream_10'
     DeathSound(1)=Sound'2009DoomMonstersSounds.Maledict.Maledict_scream_14'
     DeathSound(2)=Sound'2009DoomMonstersSounds.Maledict.Maledict_scream_18'
     DeathSound(3)=Sound'2009DoomMonstersSounds.Maledict.Maledict_scream_19'
     ChallengeSound(0)=Sound'2009DoomMonstersSounds.Maledict.Maledict_Scream_01'
     ChallengeSound(1)=Sound'2009DoomMonstersSounds.Maledict.Maledict_scream_04'
     ChallengeSound(2)=Sound'2009DoomMonstersSounds.Maledict.Maledict_scream_07'
     ChallengeSound(3)=Sound'2009DoomMonstersSounds.Maledict.Maledict_scream_09'
     ScoringValue=900
     WallDodgeAnims(0)="FlapFast"
     WallDodgeAnims(1)="FlapFast"
     WallDodgeAnims(2)="FlapFast"
     WallDodgeAnims(3)="FlapFast"
     IdleHeavyAnim="Idle"
     IdleRifleAnim="Idle"
     FireHeavyRapidAnim="FlapFast"
     FireHeavyBurstAnim="FlapFast"
     FireRifleRapidAnim="FlapFast"
     FireRifleBurstAnim="FlapFast"
     RagdollOverride="D3Maledict"
     bCanFly=True
     bCanStrafe=True
     MeleeRange=100.000000
     GroundSpeed=700.000000
     AirSpeed=500.000000
     HealthMax=4000.000000
     Health=4000
     HeadRadius=50
     MenuName="Maledict"
     bPhysicsAnimUpdate=False
     MovementAnims(0)="GlideIdle"
     MovementAnims(1)="GlideIdle"
     MovementAnims(2)="GlideIdle"
     MovementAnims(3)="GlideIdle"
     TurnLeftAnim="GlideIdle"
     TurnRightAnim="GlideIdle"
     SwimAnims(0)="GlideIdle"
     SwimAnims(1)="GlideIdle"
     SwimAnims(2)="GlideIdle"
     SwimAnims(3)="GlideIdle"
     CrouchAnims(0)="GlideIdle"
     CrouchAnims(1)="GlideIdle"
     CrouchAnims(2)="GlideIdle"
     CrouchAnims(3)="GlideIdle"
     WalkAnims(0)="GlideIdle"
     WalkAnims(1)="GlideIdle"
     WalkAnims(2)="GlideIdle"
     WalkAnims(3)="GlideIdle"
     AirAnims(0)="GlideIdle"
     AirAnims(1)="GlideIdle"
     AirAnims(2)="GlideIdle"
     AirAnims(3)="GlideIdle"
     TakeoffAnims(0)="GlideIdle"
     TakeoffAnims(1)="GlideIdle"
     TakeoffAnims(2)="GlideIdle"
     TakeoffAnims(3)="GlideIdle"
     LandAnims(0)="GlideIdle"
     LandAnims(1)="GlideIdle"
     LandAnims(2)="GlideIdle"
     LandAnims(3)="GlideIdle"
     DoubleJumpAnims(0)="FlapFast"
     DoubleJumpAnims(1)="FlapFast"
     DoubleJumpAnims(2)="FlapFast"
     DoubleJumpAnims(3)="FlapFast"
     DodgeAnims(0)="FlapNormal"
     DodgeAnims(1)="FlapNormal"
     DodgeAnims(2)="FlapNormal"
     DodgeAnims(3)="FlapNormal"
     AirStillAnim="GlideIdle"
     TakeoffStillAnim="GlideIdle"
     CrouchTurnRightAnim="GlideIdle"
     CrouchTurnLeftAnim="GlideIdle"
     IdleCrouchAnim="Idle"
     IdleSwimAnim="Idle"
     IdleWeaponAnim="Idle"
     IdleRestAnim="Idle"
     IdleChatAnim="Idle"
     AmbientSound=Sound'2009DoomMonstersSounds.LostSoul.LostSoul_idle_01'
     Mesh=SkeletalMesh'2009DoomMonstersAnims.MaledictMesh'
     DrawScale=0.800000
     Skins(0)=Shader'2009DoomMonstersTex.Maledict.MaledictShader'
     Skins(1)=Texture'2009DoomMonstersTex.Revenant.InvisMat'
     Skins(2)=Texture'2009DoomMonstersTex.Revenant.InvisMat'
     Skins(3)=Shader'2009DoomMonstersTex.Maledict.MaledictTeethShader'
     Skins(4)=Texture'2009DoomMonstersTex.Maledict.MaledictNewTongue'
	 MaxMeleeAttacks=2

     CollisionRadius=60.000000
     CollisionHeight=50.000000

     bUseExtendedCollision=True
     ColRadius=180
     ColHeight=100
}
