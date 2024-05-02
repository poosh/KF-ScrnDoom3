class Cherub extends DoomMonster;

var Sound FlutterSounds[2];
var Sound RandomTaunts[10];

function ZombieMoan()
{
	PlaySound(RandomTaunts[Rand(ArrayCount(RandomTaunts))], SLOT_Interact, 8);
}

function RangedAttack(Actor A)
{
	if ( bShotAnim )
		return;

	if( !bHasRoamed )
		RoamAtPlayer();
	else if( IsInMeleeRange(A) )
	{
		bLunging = false;
		PrepareMovingAttack(A,0.9);
		SetAnimAction('Attack');
	}
	else if( IsInMeleeRange(A,400.f) )
	{
		PrepareMovingAttack(A,1.f);
		Controller.Target = A;
		Enable('Bump');
		Velocity = Normal(A.Location-Location)*700.f;
		Velocity.Z = 300.f;
		SetPhysics(PHYS_Falling);
		SetAnimAction('Jump_Start');
		bLunging = true;
		Controller.Focus = None;
		Controller.FocalPoint = Normal(A.Location-Location)*10000.f+Location;
		Controller.GoToState('WaitForAnim');
	}
}
simulated function AnimEnd(int Channel)
{
	local name N;

	if( Level.NetMode!=NM_Client && bShotAnim )
	{
		N = GetCurrentAnim();
		if( N=='Jump_Start' || N=='Jump_Mid' )
		{
			SetAnimAction('Jump_Mid');
			return;
		}
		else if( N=='Sight' )
		{
			SetAnimAction('Jump_Land');
			return;
		}
	}
	Super.AnimEnd(Channel);
}
function Landed(vector HitNormal)
{
	if( Level.NetMode!=NM_Client && bShotAnim && (GetCurrentAnim()=='Jump_Start' || GetCurrentAnim()=='Jump_Mid') )
	{
		bLunging = false;
		SetAnimAction('Jump_Land');
		Velocity = vect(0,0,0);
		Acceleration = vect(0,0,0);
		return;
	}
	Super.Landed(HitNormal);
}

singular function Bump(actor Other)
{
	if ( bShotAnim && bLunging && Pawn(Other)!=None && Controller!=None && Other==Controller.Target )
	{
		bLunging = false;
		MeleeDamageTarget(LungeAttackDamage,Velocity*100.f);
	}
	Super.Bump(Other);
}

simulated function Flutter()
{
	PlaySound(FlutterSounds[Rand(2)], SLOT_Interact, 8);
}

// function SetOverlayMaterial(Material mat, float time, bool bOverride);

simulated function FadeSkins()
{
	Skins[0] = InvisMat;
	Skins[1] = InvisMat;
	Skins[2] = InvisMat;
	Skins[3] = FadeFX;
	Skins[4] = InvisMat;
	Skins[5] = InvisMat;
	MakeBurnAway();
}

simulated function BurnAway()
{
	Skins[3] = BurnFX;
	Burning = true;
}

defaultproperties
{
     FlutterSounds(0)=Sound'2009DoomMonstersSounds.Cherub.Cherub_flutter_01'
     FlutterSounds(1)=Sound'2009DoomMonstersSounds.Cherub.Cherub_flutter_02'
     RandomTaunts(0)=Sound'2009DoomMonstersSounds.Cherub.Cherub_evillaugh2'
     RandomTaunts(1)=Sound'2009DoomMonstersSounds.Cherub.Cherub_chatter_combat_01'
     RandomTaunts(2)=Sound'2009DoomMonstersSounds.Cherub.Cherub_chatter_combat_02'
     RandomTaunts(3)=Sound'2009DoomMonstersSounds.Cherub.Cherub_idle_01'
     RandomTaunts(4)=Sound'2009DoomMonstersSounds.Cherub.Cherub_idle_02'
     RandomTaunts(5)=Sound'2009DoomMonstersSounds.Cherub.Cherub_idle_03'
     RandomTaunts(6)=Sound'2009DoomMonstersSounds.Cherub.Cherub_oc_01'
     RandomTaunts(7)=Sound'2009DoomMonstersSounds.Cherub.Cherub_sight_01'
     RandomTaunts(8)=Sound'2009DoomMonstersSounds.Cherub.Cherub_sight_02'
     RandomTaunts(9)=Sound'2009DoomMonstersSounds.Cherub.Cherub_sight_03'
     LungeAttackDamage=18
     DeathAnims(0)="DeathF"
     DeathAnims(1)="DeathB"
     DeathAnims(2)="DeathF"
     DeathAnims(3)="DeathB"
     SightAnim="Sight"
     HitAnimsX(0)="CrawlPainL"
     HitAnimsX(1)="CrawlPainR"
     HitAnimsX(2)="CrawlPainChest"
     HitAnimsX(3)="CrawlPainChest"
     MeleeAttackSounds(0)=Sound'2009DoomMonstersSounds.Cherub.Cherub_attack_01'
     MeleeAttackSounds(1)=Sound'2009DoomMonstersSounds.Cherub.Cherub_attack_01'
     MeleeAttackSounds(2)=Sound'2009DoomMonstersSounds.Cherub.Cherub_attack_01'
     MeleeAttackSounds(3)=Sound'2009DoomMonstersSounds.Cherub.Cherub_attack_01'
     SightSound=Sound'2009DoomMonstersSounds.Cherub.Cherub_evillaugh2'
     BurningMaterial=Texture'2009DoomMonstersTex.Cherub.Cherub'
     BurnClass=Class'ScrnDoom3KF.CherubBurnTex'
     FadeClass=Class'ScrnDoom3KF.CherubMaterialSequence'
     BurnedTextureNum(0)=3
     HasHitAnims=True
     BurnAnimTime=0.150000
     MeleeDamage=12
     FootStep(0)=Sound'2009DoomMonstersSounds.Cherub.Cherub_step2'
     FootStep(1)=Sound'2009DoomMonstersSounds.Cherub.Cherub_step2'
     DodgeSkillAdjust=3.000000
     HitSound(0)=Sound'2009DoomMonstersSounds.Cherub.Cherub_pain_01a'
     HitSound(1)=Sound'2009DoomMonstersSounds.Cherub.Cherub_pain_02a'
     HitSound(2)=Sound'2009DoomMonstersSounds.Cherub.Cherub_pain_03a'
     HitSound(3)=Sound'2009DoomMonstersSounds.Cherub.Cherub_pain_04a'
     DeathSound(0)=Sound'2009DoomMonstersSounds.Cherub.Cherub_death_01'
     DeathSound(1)=Sound'2009DoomMonstersSounds.Cherub.Cherub_death_02'
     DeathSound(2)=Sound'2009DoomMonstersSounds.Cherub.Cherub_death_01'
     DeathSound(3)=Sound'2009DoomMonstersSounds.Cherub.Cherub_death_02'
     ChallengeSound(0)=Sound'2009DoomMonstersSounds.Cherub.Cherub_sight_01'
     ChallengeSound(1)=Sound'2009DoomMonstersSounds.Cherub.Cherub_sight_02'
     ChallengeSound(2)=Sound'2009DoomMonstersSounds.Cherub.Cherub_sight_03'
     ChallengeSound(3)=Sound'2009DoomMonstersSounds.Cherub.Cherub_evillaugh2'
     ScoringValue=15
     WallDodgeAnims(0)="DodgeL"
     WallDodgeAnims(1)="DodgeR"
     WallDodgeAnims(2)="DodgeL"
     WallDodgeAnims(3)="DodgeR"
     IdleHeavyAnim="Play_Dead"
     IdleRifleAnim="Play_Dead"
     FireHeavyRapidAnim="Play_Dead"
     FireHeavyBurstAnim="Play_Dead"
     FireRifleRapidAnim="Play_Dead"
     FireRifleBurstAnim="Play_Dead"
     MeleeRange=60.000000
     GroundSpeed=160.000000
     HealthMax=150.000000
     HeadRadius=10.000000
     MenuName="Cherub"
     MovementAnims(0)="Crawl1"
     MovementAnims(1)="Crawl1"
     MovementAnims(2)="Crawl2"
     MovementAnims(3)="Crawl2"
     TurnLeftAnim="Crawl2"
     TurnRightAnim="Crawl2"
     SwimAnims(0)="Crawl1"
     SwimAnims(1)="Crawl1"
     SwimAnims(2)="Crawl1"
     SwimAnims(3)="Crawl1"
     CrouchAnims(0)="Crawl1"
     CrouchAnims(1)="Crawl1"
     CrouchAnims(2)="Crawl1"
     CrouchAnims(3)="Crawl1"
     WalkAnims(0)="Crawl1"
     WalkAnims(1)="Crawl1"
     WalkAnims(2)="Crawl1"
     WalkAnims(3)="Crawl1"
     AirAnims(0)="Jump_Mid"
     AirAnims(1)="Jump_Mid"
     AirAnims(2)="Jump_Mid"
     AirAnims(3)="Jump_Mid"
     TakeoffAnims(0)="Jump_Start"
     TakeoffAnims(1)="Jump_Start"
     TakeoffAnims(2)="Jump_Start"
     TakeoffAnims(3)="Jump_Start"
     LandAnims(0)="Jump_Land"
     LandAnims(1)="Jump_Land"
     LandAnims(2)="Jump_Land"
     LandAnims(3)="Jump_Land"
     DoubleJumpAnims(0)="Jump_Start"
     DoubleJumpAnims(1)="Jump_Start"
     DoubleJumpAnims(2)="Jump_Start"
     DoubleJumpAnims(3)="Jump_Start"
     DodgeAnims(0)="DodgeL"
     DodgeAnims(1)="DodgeR"
     AirStillAnim="Jump_Mid"
     TakeoffStillAnim="Jump_Start"
     CrouchTurnRightAnim="Crawl1"
     CrouchTurnLeftAnim="Crawl1"
     IdleCrouchAnim="Play_Dead"
     IdleSwimAnim="Play_Dead"
     IdleWeaponAnim="Play_Dead"
     IdleRestAnim="Play_Dead"
     IdleChatAnim="Play_Dead"
     Mesh=SkeletalMesh'2009DoomMonstersAnims.CherubMesh'
     DrawScale=1.100000
     Skins(0)=Texture'2009DoomMonstersTex.Revenant.InvisMat'
     Skins(1)=Texture'2009DoomMonstersTex.Revenant.InvisMat'
     Skins(2)=Shader'2009DoomMonstersTex.Cherub.CherubTeeth'
     Skins(3)=Combiner'2009DoomMonstersTex.Cherub.JCherub'
     Skins(4)=Shader'2009DoomMonstersTex.Cherub.WingShader'
     Skins(5)=Shader'2009DoomMonstersTex.Cherub.WingShader'
     CollisionRadius=20.000000
     CollisionHeight=20.000000

     bUseExtendedCollision=True
     ColOffset=(X=20,Z=0)
     ColRadius=20
     ColHeight=20

     MotionDetectorThreat=0.34 //5.14
     ZappedDamageMod=2.0
}
