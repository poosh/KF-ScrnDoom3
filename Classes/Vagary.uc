class Vagary extends DoomMonster;

var Emitter Jet,HandTrail;
var transient float NextRangedTime;
var(Sounds) Sound PreFireSound;

var class<TriteFly> MonsterProjClass; //  monster class, which is used as projectile to throw at the enemy
var transient TriteFly SpiderProj;
var transient float SpiderThrowTime; //time when vagary should release spider from her arm and throw it at player
var byte PendingSpiders;


function RangedAttack(Actor A)
{
	local float r;

	if ( bShotAnim )
		return;

    r = float(Health) / HealthMax;
    if ( PendingSpiders > 0 )
    {
		PrepareStillAttack(A);
        SetAnimAction('RangedAttack2');
        SpawnSpider(A);
        PendingSpiders--;
        NextRangedTime = Level.TimeSeconds + 1.0 + 2.0*r + frand() * ( 1.5 + 1.5*r);
		PlaySound(PreFireSound,SLOT_Misc,2,,500.f);
    }
	else if( !bHasRoamed )
		RoamAtPlayer();
	else if( IsInMeleeRange(A) && (MaxMeleeAttacks > 0 || NextRangedTime >= Level.TimeSeconds) )
	{
		MaxMeleeAttacks--;

		PrepareStillAttack(A);
		SetAnimAction('Melee1');
	}
	else if( NextRangedTime<Level.TimeSeconds )
	{
		if ( MaxMeleeAttacks <= 0)
			MaxMeleeAttacks = rand(default.MaxMeleeAttacks+1);

		PrepareStillAttack(A);

		if ( frand() < 0.50 - 0.05*ChildMonsterCounter ) {
            if ( r < 0.75 )
                PendingSpiders = min(5, rand( int((1.0 - r) * 10) ));
			SetAnimAction('RangedAttack2');
			SpawnSpider(A);
		}
		else if( frand() < 0.5 )
			SetAnimAction('RangedAttack2');
		else
			SetAnimAction('RangedAttack1');

        NextRangedTime = Level.TimeSeconds + 0.5 + 2.0*r + frand() * ( 1.5 + 1.5*r);

		PlaySound(PreFireSound,SLOT_Misc,2,,500.f);

		if ( SpiderProj == none )
			SpawnProject(A);
	}
}
function bool ShouldTryRanged( Actor A )
{
	return (NextRangedTime<Level.TimeSeconds && FRand()<0.8f);
}

function SpawnSpider( Actor A )
{
	local vector NDir,Point,HL,HN;
	local byte i;

	// try to spawn inside the arm first
	Point = GetBoneCoords('Lmid1').Origin;
	if ( ChildMonsterCounter < 16) {
		SpiderProj = Spawn(MonsterProjClass,self,,Point,rotator(A.Location-Point));
		// if can't spawn inside the arm, then look for some place around
		if ( SpiderProj == none ) {
			NDir = Location-A.Location;
			NDir.Z = 0;
			NDir = A.Location+Normal(NDir)*400.f;
			while( ++i<20 )
			{
				Point = NDir;
				Point.X+=(500.f*FRand()-250.f);
				Point.Y+=(500.f*FRand()-250.f);
				if( Trace(HL,HN,Point-vect(0,0,600.f),Point,false)==None )
					continue;
				Point = HL+HN*4.f;
				if( FastTrace(A.Location,Point+vect(0,0,100)) )
					break;
			}
			SpiderProj = Spawn(MonsterProjClass,self,,Point,rotator(A.Location-Point));
		}
	}
	else
		SpiderProj = FindNearestSpider();

	if ( SpiderProj != none ) {
		SpiderProj.SetCollision(false);
		AttachToBone(SpiderProj, 'Lmid1');
		SpiderThrowTime = Level.TimeSeconds + 0.55;
		SpiderProj.Controller.Target = A;
		SpiderProj.Controller.Enemy = Pawn(A);
	}
}

function TriteFly FindNearestSpider()
{
	local TriteFly BestSpider, Spider;
	local float MinDistanceSqared, DistanceSqared;

	foreach VisibleCollidingActors( class 'ScrnDoom3KF.TriteFly', Spider, 1000, Location ) {
		DistanceSqared = VSizeSquared(Location - Spider.Location);
		if ( DistanceSqared < 5625 )
			return spider; // close than 1.5 meters
		if ( BestSpider == none || DistanceSqared < MinDistanceSqared ) {
			BestSpider = Spider;
			MinDistanceSqared = DistanceSqared;
		}
	}
	return BestSpider;
}

simulated function Tick(float DeltaTime)
{
	super.Tick(DeltaTime);

	if ( SpiderProj != none && SpiderThrowTime <= Level.TimeSeconds ) {
		if ( SpiderProj != none ) {
			DetachFromBone(SpiderProj);
			//log("SpiderProj.Controller.Enemy=" $ SpiderProj.Controller.Enemy, class.outer.name);
			if ( SpiderProj.Controller.Enemy != none ) {
				SpiderProj.TargetLocation = SpiderProj.Controller.Enemy.Location;
			}
			else {
				// no enemy just throw the spider
				SpiderProj.SetRotation(Rotation);
				SpiderProj.TargetLocation = Location + vector(Rotation) * 500;
			}
			SpiderProj.SetLocation(SpiderProj.Location + vector(SpiderProj.Rotation) * 50 + vect(0,0,50) ); // immediately push forward to avoid collision with Vagary
			SpiderProj.ReleaseLocation = SpiderProj.Location;
			SpiderProj.SetRotation(rotator(SpiderProj.TargetLocation - SpiderProj.Location));
			SpiderProj.FlyDirection = normal(SpiderProj.TargetLocation - SpiderProj.Location);
			SpiderProj.Velocity = SpiderProj.FlyDirection * SpiderProj.FlySpeed;
			SpiderProj.SetCollision(true);
			SpiderProj.bReleased = true;
			SpiderProj = none;
		}
	}
}


final function SpawnProject( Actor A )
{
	local vector NDir,Point,HL,HN;
	local byte i;

	NDir = Location-A.Location;
	NDir.Z = 0;
	NDir = A.Location+Normal(NDir)*400.f;
	while( ++i<20 )
	{
		Point = NDir;
		Point.X+=(500.f*FRand()-250.f);
		Point.Y+=(500.f*FRand()-250.f);
		if( Trace(HL,HN,Point-vect(0,0,600.f),Point,false)==None )
			continue;
		Point = HL+HN*4.f;
		if( FastTrace(A.Location,Point+vect(0,0,100)) )
			break;
	}

	Spawn(RangedProjectile,,,Point,rotator(A.Location-Point));
}
simulated function FireProjectile()
{
	if( HandTrail!=None )
		HandTrail.Kill();
}
simulated function FireLProjectile()
{
	if( HandTrail!=None )
		HandTrail.Kill();
}
simulated function int DoAnimAction( name AnimName )
{
	if( Level.NetMode!=NM_DedicatedServer )
	{
		if ( SpiderProj == none ) {
			if( AnimName=='RangedAttack2' )
			{
				HandTrail = Spawn(Class'VagaryHandTrail');
				AttachToBone(HandTrail, 'Lmid1');
			}
			else if( AnimName=='RangedAttack1' )
			{
				HandTrail = Spawn(Class'VagaryHandTrail');
				AttachToBone(HandTrail, 'Rmid1');
			}
		}
	}
	PlayAnim(AnimName,,0.1);
	return 0;
}



simulated function LeakSpawn()
{
	if( Level.NetMode != NM_DedicatedServer && Jet==None )
	{
		Jet = Spawn(class'ROBloodSpurt',self);
		AttachToBone(Jet,'Belly');
	}
}

simulated function RemoveEffects()
{
	if(Jet != None)
	{
		Jet.Kill();
		Jet.LifeSpan = 1.f;
	}
	if( HandTrail!=None )
		HandTrail.Kill();
}

simulated function FadeSkins()
{
	Skins[0] = FadeFX;
	Skins[1] = InvisMat;
	MakeBurnAway();
}

simulated function BurnAway()
{
	Skins[0] = BurnFX;
	Skins[2] = BurnFX;
	Burning = true;
}

defaultproperties
{
     PreFireSound=Sound'2009DoomMonstersSounds.Vagary.Vagary_Pickup'
     DeathAnims(0)="DeathF"
     DeathAnims(1)="DeathB"
     DeathAnims(2)="DeathCurl"
     DeathAnims(3)="DeathB"
     SightAnim="Sight"
     HitAnimsX(0)="Pain_L"
     HitAnimsX(1)="Pain_R"
     HitAnimsX(2)="Pain_Head"
     HitAnimsX(3)="Pain_Chest"
     MeleeAttackSounds(0)=Sound'2009DoomMonstersSounds.Vagary.Vagary_Attack1'
     MeleeAttackSounds(1)=Sound'2009DoomMonstersSounds.Vagary.Vagary_Attack2'
     MeleeAttackSounds(2)=Sound'2009DoomMonstersSounds.Vagary.Vagary_Attack3'
     MeleeAttackSounds(3)=Sound'2009DoomMonstersSounds.Vagary.Vagary_Attack2'
     SightSound=Sound'2009DoomMonstersSounds.Vagary.Vagary_Stand'
     BurnClass=Class'ScrnDoom3KF.VagaryBurnTex'
     FadeClass=Class'ScrnDoom3KF.VagaryMaterialSequence'
     MeleeKnockBack=25000.000000
     RangedProjectile=Class'ScrnDoom3KF.VagaryClassicProj'
     DoomTeleportFXClass=Class'ScrnDoom3KF.BossDemonSpawn'
     HasHitAnims=True
     BigMonster=True
     aimerror=10
     BurnAnimTime=0.500000
     MeleeDamage=70
     bFatAss=True
     bUseExtendedCollision=True
     ColOffset=(X=13.000000,Z=41.000000)
     ColRadius=45.000000
     ColHeight=30.000000
     FootStep(0)=Sound'2009DoomMonstersSounds.Vagary.Vagary_footstep1'
     FootStep(1)=Sound'2009DoomMonstersSounds.Vagary.Vagary_footstep2'
     DodgeSkillAdjust=1.000000
     HitSound(0)=Sound'2009DoomMonstersSounds.Vagary.Vagary_pain_right_arm'
     HitSound(1)=Sound'2009DoomMonstersSounds.Vagary.Vagary_pain_left_arm'
     HitSound(2)=Sound'2009DoomMonstersSounds.Vagary.Vagary_Pain_Head'
     HitSound(3)=Sound'2009DoomMonstersSounds.Vagary.Vagary_Pain'
     DeathSound(0)=Sound'2009DoomMonstersSounds.Vagary.Vagary_Death'
     DeathSound(1)=Sound'2009DoomMonstersSounds.Vagary.Vagary_Death'
     DeathSound(2)=Sound'2009DoomMonstersSounds.Vagary.Vagary_Death'
     DeathSound(3)=Sound'2009DoomMonstersSounds.Vagary.Vagary_Death'
     ChallengeSound(0)=Sound'2009DoomMonstersSounds.Vagary.Vagary_caverns_scream'
     ChallengeSound(1)=Sound'2009DoomMonstersSounds.Vagary.Vagary_chatter_combat2'
     ChallengeSound(2)=Sound'2009DoomMonstersSounds.Vagary.Vagary_chatter_combat3'
     ChallengeSound(3)=Sound'2009DoomMonstersSounds.Vagary.Vagary_wake_solo'
     FireSound=Sound'2009DoomMonstersSounds.Vagary.Vagary_range_attack'
     ScoringValue=750
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
     RagdollOverride="D3Vagary"
     bCanJump=False
     MeleeRange=60.000000
     GroundSpeed=250.000000
     HealthMax=7000
     Health=7000
     HeadRadius=10
     MenuName="Vagary"
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
     Mesh=SkeletalMesh'2009DoomMonstersAnims.VagaryMesh'
     DrawScale=1.0
     PrePivot=(Z=-5)
     Skins(0)=Combiner'2009DoomMonstersTex.Vagary.JVagarySkin'
     Skins(1)=Shader'2009DoomMonstersTex.Vagary.TeethShader'
     Skins(2)=Shader'2009DoomMonstersTex.Vagary.VagarySacShader'
     CollisionRadius=26 // 30
     CollisionHeight=44 // 50
     Mass=1000.000000
	 MonsterProjClass=Class'ScrnDoom3KF.TriteFly'
	 MaxMeleeAttacks=2

	 FireRootBone="BabySpine1"
}
