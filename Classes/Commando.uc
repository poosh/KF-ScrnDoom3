class Commando extends DoomMonster;

var() float TentacleRange;
var(Anims) name RangedMelee[3],NormalMeleeAnims[4];
var transient float NextRangedMelee;

var(Sounds) Sound RandomTaunts[8];
var(Sounds) Sound MeleeSound[5];

var MaterialSequence FadeFXTentacle;
var class<MaterialSequence> FadeTentacleClass;

var bool bDoingRanged;

function ZombieMoan()
{
	local byte i;

	i = Rand(ArrayCount(RandomTaunts));
	PlaySound(RandomTaunts[i], SLOT_Interact, 2);
	PlaySound(RandomTaunts[i], SLOT_Talk, 2);
}
final function bool CanDoRangedAttack( Actor A )
{
	local vector D;

	if( A.IsA('KFDoorMover') )
		return false;
	D = A.Location-Location;
	if( Abs(D.Z)>(CollisionHeight*0.7f+A.CollisionHeight) )
		return false;
	D.Z = 0;
	return (VSize(D)<(CollisionRadius+A.CollisionRadius+TentacleRange));
}
function MeleeAttack()
{
	if( bDoingRanged )
		MeleeRange = TentacleRange;
	Super.MeleeAttack();
	MeleeRange = Default.MeleeRange;
}
function RangedAttack(Actor A)
{
	local byte i;

	if ( bShotAnim )
		return;
	if( !bHasRoamed )
		RoamAtPlayer();
	else if( IsInMeleeRange(A) )
	{
		i = Rand(ArrayCount(NormalMeleeAnims));
		if( i==3 )
			PrepareStillAttack(A);
		else PrepareMovingAttack(A,0.5);
		PlaySound(MeleeSound[Rand(5)], SLOT_Talk);
		SetAnimAction(NormalMeleeAnims[i]);
		bDoingRanged = false;
	}
	else if( NextRangedMelee<Level.TimeSeconds && CanDoRangedAttack(A) )
	{
		NextRangedMelee = Level.TimeSeconds+3.f+FRand()*3.f;
		i = Rand(ArrayCount(RangedMelee));
		if( i!=1 )
			PrepareStillAttack(A);
		else PrepareMovingAttack(A,0.65f);
		PlaySound(MeleeSound[Rand(5)], SLOT_Talk);
		SetAnimAction(RangedMelee[i]);
		bDoingRanged = true;
	}
}
simulated function PlayDirectionalDeath(Vector HitLoc)
{
	RemoveEffects();
	BurnFX = DoomBurnTex(Level.ObjectPool.AllocateObject(BurnClass));
	FadeFX = MaterialSequence(Level.ObjectPool.AllocateObject(FadeClass));
	FadeFXTentacle = MaterialSequence(Level.ObjectPool.AllocateObject(FadeTentacleClass));

	if(FadeFX != None && BurnFX != None && FadeFXTentacle != None)
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
	FadeFXTentacle.Reset();
	Skins[0] = FadeFX;
	Skins[1] = FadeFXTentacle;
	Skins[2] = InvisMat;
	Skins[3] = InvisMat;
	MakeBurnAway();
}

simulated function BurnAway()
{
	Skins[0] = BurnFX;
	Skins[1] = BurnFX;
	Burning = true;
}

simulated function FreeFXObjects()
{
	if(FadeFXTentacle != None)
	{
		Level.ObjectPool.FreeObject(FadeFXTentacle);
		FadeFXTentacle = None;
	}
	Super.FreeFXObjects();
}

defaultproperties
{
     TentacleRange=250.000000
     RangedMelee(0)="RangedMelee01"
     RangedMelee(1)="RangedMelee02"
     RangedMelee(2)="LeapAttack"
     NormalMeleeAnims(0)="MeleeAttack01"
     NormalMeleeAnims(1)="MeleeAttack02"
     NormalMeleeAnims(2)="MeleeAttack03"
     NormalMeleeAnims(3)="MeleeAttack04"
     RandomTaunts(0)=Sound'2009DoomMonstersSounds.Commando.combat_01'
     RandomTaunts(1)=Sound'2009DoomMonstersSounds.Commando.combat_03'
     RandomTaunts(2)=Sound'2009DoomMonstersSounds.Commando.combat_04'
     RandomTaunts(3)=Sound'2009DoomMonstersSounds.Commando.combat_05'
     RandomTaunts(4)=Sound'2009DoomMonstersSounds.Commando.site11_youwilldie'
     RandomTaunts(5)=Sound'2009DoomMonstersSounds.Commando.site2'
     RandomTaunts(6)=Sound'2009DoomMonstersSounds.Commando.site3_you'
     RandomTaunts(7)=Sound'2009DoomMonstersSounds.Commando.site6_die'
     MeleeSound(0)=Sound'2009DoomMonstersSounds.Commando.melee1_1'
     MeleeSound(1)=Sound'2009DoomMonstersSounds.Commando.melee2_1'
     MeleeSound(2)=Sound'2009DoomMonstersSounds.Commando.melee3_1'
     MeleeSound(3)=Sound'2009DoomMonstersSounds.Commando.melee4_1'
     MeleeSound(4)=Sound'2009DoomMonstersSounds.Commando.melee5_1'
     FadeTentacleClass=Class'ScrnDoom3KF.CommandoTentacleMaterialSequence'
     DeathAnims(0)="DeathF"
     DeathAnims(1)="DeathB"
     DeathAnims(2)="DeathF"
     DeathAnims(3)="DeathB"
     SightAnim="Sight01"
     HitAnimsX(0)="PainL"
     HitAnimsX(1)="PainR"
     HitAnimsX(2)="PainHead"
     HitAnimsX(3)="PainChest"
     MissSound(0)=Sound'2009DoomMonstersSounds.Commando.whoosh1_deep'
     MissSound(1)=Sound'2009DoomMonstersSounds.Commando.whoosh11_light'
     MissSound(2)=Sound'2009DoomMonstersSounds.Commando.whoosh12_light'
     MissSound(3)=Sound'2009DoomMonstersSounds.Commando.whoosh2_deep'
     MeleeAttackSounds(0)=Sound'2009DoomMonstersSounds.Commando.squish10_impact'
     MeleeAttackSounds(1)=Sound'2009DoomMonstersSounds.Commando.squish11_impact'
     MeleeAttackSounds(2)=Sound'2009DoomMonstersSounds.Commando.squish12_impact'
     MeleeAttackSounds(3)=Sound'2009DoomMonstersSounds.Commando.squish14_impact'
     SightSound=Sound'2009DoomMonstersSounds.Commando.site3_you'
     BurningMaterial=Texture'2009DoomMonstersTex.Commando.CommandoSkin'
     FadeClass=Class'ScrnDoom3KF.CommandoMaterialSequence'
     MeleeKnockBack=22000.000000
     BurnedTextureNum(1)=1
     HasHitAnims=True
     BurnAnimTime=0.150000
     MeleeDamage=35
     PlayerCountHealthScale=0.100000
     FootStep(0)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.step1'
     FootStep(1)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.step2'
     DodgeSkillAdjust=1.000000
     HitSound(0)=Sound'2009DoomMonstersSounds.Commando.pain1'
     HitSound(1)=Sound'2009DoomMonstersSounds.Commando.pain2'
     HitSound(2)=Sound'2009DoomMonstersSounds.Commando.pain3'
     HitSound(3)=Sound'2009DoomMonstersSounds.Commando.pain4'
     DeathSound(0)=Sound'2009DoomMonstersSounds.Commando.death1'
     DeathSound(1)=Sound'2009DoomMonstersSounds.Commando.Death2'
     DeathSound(2)=Sound'2009DoomMonstersSounds.Commando.Death3'
     DeathSound(3)=Sound'2009DoomMonstersSounds.Commando.Death4'
     ChallengeSound(0)=Sound'2009DoomMonstersSounds.Commando.combat_01'
     ChallengeSound(1)=Sound'2009DoomMonstersSounds.Commando.combat_03'
     ChallengeSound(2)=Sound'2009DoomMonstersSounds.Commando.combat_04'
     ChallengeSound(3)=Sound'2009DoomMonstersSounds.Commando.combat_05'
     ScoringValue=80
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
     RagdollOverride="D3Commando"
     MeleeRange=60.000000
     GroundSpeed=370.000000
     HealthMax=465.000000
     Health=465
     HeadRadius=12.000000
     MenuName="Commando"
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
     Mesh=SkeletalMesh'2009DoomMonstersAnims.CommandoMesh'
     DrawScale=1.200000
     Skins(0)=Combiner'2009DoomMonstersTex.Commando.JCommandoSkin'
     Skins(1)=Texture'2009DoomMonstersTex.Commando.CommandoTentacle'
     Skins(2)=Shader'2009DoomMonstersTex.Commando.CommandoTeethShader'
     Skins(3)=Shader'2009DoomMonstersTex.Commando.CommandoEyeShader'
     TransientSoundVolume=2.000000
     CollisionRadius=20.000000
     CollisionHeight=44 // 45

     bUseExtendedCollision=True
     ColOffset=(X=20,Z=29)
     ColRadius=35
     ColHeight=35

     ZapThreshold=0.75
     ZappedDamageMod=1.5
	RootBone="Hips"
}
