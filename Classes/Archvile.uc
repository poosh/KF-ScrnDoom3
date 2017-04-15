class Archvile extends DoomMonster;

var() array< class<DoomMonster> > ArchvileSummonMonsters;
var() byte MaxMonsters;
var transient float nextFireAttackTime,nextSummonTime;
var ArchvileHandEffect LeftHandTrail, RightHandTrail;
var vector SummonPos;
var class<DoomMonster> SpawningNow;

var(Sounds) Sound ResurrectionSound,BreatheSound[2],BurnSounds[5];

function RangedAttack(Actor A)
{
	if ( bShotAnim )
		return;

	Controller.Target = A;
	if( !bHasRoamed )
		RoamAtPlayer();
	else if( IsInMeleeRange(A) && MaxMeleeAttacks > 0 )
	{
		MaxMeleeAttacks--;
		PrepareStillAttack(A);
		SetAnimAction(MeleeAnims[Rand(3)]);
	}
	else {
		if (MaxMeleeAttacks <= 0)
			MaxMeleeAttacks = rand(default.MaxMeleeAttacks+1);
	
		if( nextFireAttackTime<Level.TimeSeconds )
		{
				
			nextFireAttackTime = Level.TimeSeconds+2.f+FRand()*5.f;
			if( FRand()<0.25f )
				return;
			nextSummonTime = FMax(nextFireAttackTime-0.5f,nextSummonTime);
			PrepareStillAttack(A);
			if( VSizeSquared(A.Location-Location)<1440000.f && A.Location.Z<(Location.Z+30.f) && FRand()<0.8f ) // Near distance and lower altitude.
				SetAnimAction('RangedAttack2');
			else SetAnimAction('RangedAttack1');
		}
		else if( MaxMonsters > ChildMonsterCounter && nextSummonTime<Level.TimeSeconds && ArchvileSummonMonsters.Length>0 )
		{
			nextSummonTime = Level.TimeSeconds+3+FRand()*6.f;
			if( ChildMonsterCounter > 0 && FRand()<0.5f )
				return;
			SpawningNow = ArchvileSummonMonsters[Rand(ArchvileSummonMonsters.Length)];
			if( SpawningNow==None )
				return;
			if( !FindSummonPoint(A) )
				SummonPos = Location + (10.f+CollisionRadius+SpawningNow.Default.CollisionRadius) * vector(Rotation);
			PrepareStillAttack(A);
			SetAnimAction('Resurrection');
			Spawn(SpawningNow.Default.DoomTeleportFXClass,,,SummonPos).PlaySound(ResurrectionSound,SLOT_Misc,1.5f,,600.f);
			SetTimer(SpawningNow.Default.DoomTeleportFXClass.Default.TeleportInTime,false);
		}
	}
}

final function bool FindSummonPoint( Actor A )
{
	local NavigationPoint N;
	local float Dist;

	for( N=Level.NavigationPointList; N!=None; N=N.nextNavigationPoint )
	{
		Dist = VSizeSquared(N.Location-A.Location);
		if( Dist<1000000 && Dist>10000 && FRand()<0.5f && FastTrace(N.Location,Location) && FastTrace(N.Location,A.Location) )
		{
			SummonPos = N.Location;
			return true;
		}
	}
	return false;
}

// While enemy is not in reach but still in sight.
function bool ShouldTryRanged( Actor A )
{
	return ((nextFireAttackTime<Level.TimeSeconds || nextSummonTime<Level.TimeSeconds) && FRand()<0.4f);
}

simulated function FireProjectile()
{
	if ( Level.NetMode!=NM_DedicatedServer )
		PlaySound(FireSound,SLOT_Misc);
	if( Level.NetMode!=NM_Client && Controller!=None && Controller.Target!=None )
		Spawn(class'ArchvileFlameAttackProjectile',,,Controller.Target.Location);
}

simulated function LightUp()
{
	if ( Level.NetMode!=NM_DedicatedServer )
	{
		LeftHandTrail = Spawn(class'ArchvileHandEffect');
		AttachToBone(LeftHandTrail, 'LBulb');
		RightHandTrail = Spawn(class'ArchvileHandEffect');
		AttachToBone(RightHandTrail, 'RBulb');
	}
}

simulated function Resurrect()
{
}

simulated function FireWall()
{
	if( Level.NetMode!=NM_Client && Controller!=None )
		FireProj(GetBoneCoords('WallBone').Origin);
	if ( Level.NetMode!=NM_DedicatedServer )
		PlaySound(BurnSounds[Rand(5)],SLOT_Misc);
}

simulated function RemoveEffects()
{
	if(LeftHandTrail != None)
		LeftHandTrail.Kill();
	if(RightHandTrail != None)
		RightHandTrail.Kill();
}

simulated function FadeSkins()
{
	Skins[0] = FadeFX;
	Skins[1] = FadeFX;
	MakeBurnAway();
}

simulated function BurnAway()
{
	local byte i;

	for(i=0;i<Skins.Length;i++)
		Skins[i] = BurnFX;
	Burning = true;
	PlaySound(DeResSound,SLOT_Misc,2,,500.f);
}
function Timer()
{
	if( SpawningNow==None )
	{
		Super.Timer();
		return;
	}
	SpawnChild(SpawningNow,SummonPos);
	SpawningNow = None;

	if( BurnDown>0 ) // Keep burning...
		SetTimer(1,true);
}

defaultproperties
{
     ArchvileSummonMonsters(0)=Class'ScrnDoom3KF.Imp'
     ArchvileSummonMonsters(1)=Class'ScrnDoom3KF.Vulgar'
     ArchvileSummonMonsters(2)=Class'ScrnDoom3KF.LostSoul'
     ArchvileSummonMonsters(3)=Class'ScrnDoom3KF.LostSoul' // forgotten replaced by LostSoul in v5.13. Now LostSoul have 2x chance to spawn
     ArchvileSummonMonsters(4)=Class'ScrnDoom3KF.Maggot'
     MaxMonsters=4
     ResurrectionSound=Sound'2009DoomMonstersSounds.Archvile.Archvile_Resurrection'
     BreatheSound(0)=Sound'2009DoomMonstersSounds.Archvile.Archvile_Breath2'
     BreatheSound(1)=Sound'2009DoomMonstersSounds.Archvile.Archvile_breath3'
     BurnSounds(0)=Sound'2009DoomMonstersSounds.Archvile.Archvile_fire_01'
     BurnSounds(1)=Sound'2009DoomMonstersSounds.Archvile.Archvile_fire_02'
     BurnSounds(2)=Sound'2009DoomMonstersSounds.Archvile.Archvile_fire_04'
     BurnSounds(3)=Sound'2009DoomMonstersSounds.Archvile.Archvile_fire_02'
     BurnSounds(4)=Sound'2009DoomMonstersSounds.Archvile.Archvile_fire_01'
     DeathAnims(0)="DeathF"
     DeathAnims(1)="DeathB"
     DeathAnims(2)="DeathF"
     DeathAnims(3)="DeathB"
     SightAnim="Sight"
     HitAnimsX(0)="PainUpperArm1L"
     HitAnimsX(1)="PainUpperArm1R"
     HitAnimsX(2)="PainUpperArm2L"
     HitAnimsX(3)="PainUpperArm2R"
     HitAnimsX(4)="PainChest1"
     HitAnimsX(5)="PainChest2"
     HitAnimsX(6)="PainHead1"
     HitAnimsX(7)="PainHead2"
     MinHitAnimDelay=4.000000
     MeleeAttackSounds(0)=Sound'2009DoomMonstersSounds.Archvile.Archvile_sight12'
     MeleeAttackSounds(1)=Sound'2009DoomMonstersSounds.Archvile.Archvile_sight12'
     MeleeAttackSounds(2)=Sound'2009DoomMonstersSounds.Archvile.Archvile_sight12'
     MeleeAttackSounds(3)=Sound'2009DoomMonstersSounds.Archvile.Archvile_sight12'
     SightSound=Sound'2009DoomMonstersSounds.Archvile.Archvile_cin_sight'
     DeResSound=Sound'2009DoomMonstersSounds.Archvile.Archvile_burn'
     BurningMaterial=Texture'2009DoomMonstersTex.Archvile.Archvileskin'
     BurnClass=Class'ScrnDoom3KF.ArchvileBurnTex'
     FadeClass=Class'ScrnDoom3KF.ArchvileMaterialSequence'
     RangedProjectile=Class'ScrnDoom3KF.ArchvileProjectile'
     HasHitAnims=True
     bHasFireWeakness=False
     BigMonster=True
     aimerror=600
     BurnAnimTime=0.250000
     MeleeAnims(0)="Attack1"
     MeleeAnims(1)="Attack2"
     MeleeAnims(2)="Attack3"
     MeleeDamage=30
     bUseExtendedCollision=True
     ColOffset=(Z=35.000000)
     ColRadius=30.000000
     ColHeight=30.000000
     PlayerCountHealthScale=0.100000
     FootStep(0)=Sound'2009DoomMonstersSounds.Archvile.Archvile_step4'
     FootStep(1)=Sound'2009DoomMonstersSounds.Archvile.Archvile_step2'
     DodgeSkillAdjust=1.000000
     HitSound(0)=Sound'2009DoomMonstersSounds.Archvile.Archvile_sight11'
     HitSound(1)=Sound'2009DoomMonstersSounds.Archvile.Archvile_sight11'
     HitSound(2)=Sound'2009DoomMonstersSounds.Archvile.Archvile_sight11'
     HitSound(3)=Sound'2009DoomMonstersSounds.Archvile.Archvile_sight11'
     DeathSound(0)=Sound'2009DoomMonstersSounds.Archvile.Archvile_die1'
     DeathSound(1)=Sound'2009DoomMonstersSounds.Archvile.Archvile_die2'
     DeathSound(2)=Sound'2009DoomMonstersSounds.Archvile.Archvile_die4'
     DeathSound(3)=Sound'2009DoomMonstersSounds.Archvile.Archvile_die1'
     ChallengeSound(0)=Sound'2009DoomMonstersSounds.Archvile.Archvile_sight12'
     ChallengeSound(1)=Sound'2009DoomMonstersSounds.Archvile.Archvile_sight13'
     ChallengeSound(2)=Sound'2009DoomMonstersSounds.Archvile.Archvile_sight2_1'
     ChallengeSound(3)=Sound'2009DoomMonstersSounds.Archvile.Archvile_sight2_2'
     FireSound=Sound'2009DoomMonstersSounds.Archvile.Archvile_burn'
     ScoringValue=220
     WallDodgeAnims(0)="EvadeL"
     WallDodgeAnims(1)="EvadeL"
     WallDodgeAnims(2)="EvadeR"
     WallDodgeAnims(3)="EvadeR"
     IdleHeavyAnim="Idle"
     IdleRifleAnim="Idle"
     FireHeavyRapidAnim="Walk"
     FireHeavyBurstAnim="Walk"
     FireRifleRapidAnim="Walk"
     FireRifleBurstAnim="Walk"
     bCanJump=False
     MeleeRange=85.000000
     GroundSpeed=180.000000
     HealthMax=1000.000000
     Health=1000
     HeadRadius=12.000000
     MenuName="ArchVile"
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
     DodgeAnims(0)="EvadeL"
     DodgeAnims(1)="EvadeR"
     DodgeAnims(2)="EvadeL"
     DodgeAnims(3)="EvadeR"
     AirStillAnim="Walk"
     TakeoffStillAnim="Walk"
     CrouchTurnRightAnim="Walk"
     CrouchTurnLeftAnim="Walk"
     IdleCrouchAnim="Idle"
     IdleSwimAnim="Idle"
     IdleWeaponAnim="Idle"
     IdleRestAnim="Idle"
     IdleChatAnim="Idle"
     Mesh=SkeletalMesh'2009DoomMonstersAnims.ArchvileMesh'
     DrawScale=1.200000
     Skins(0)=Combiner'2009DoomMonstersTex.Archvile.JArchvileSkin'
     Skins(1)=Shader'2009DoomMonstersTex.Archvile.HandsShader'
     CollisionRadius=20.000000
     CollisionHeight=44 //50
     ZapThreshold=1.50
}
