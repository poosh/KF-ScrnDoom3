class Boney extends DoomMonster;

var(Sounds) Sound GroanSounds[12];

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	if( FRand()<0.33 )
		Skins[0] = Material'JBoneyHell';
	else if( FRand()<0.33 )
		Skins[0] = Combiner'JSkeletonSkin';
	BurningMaterial = Skins[0];
}

function ZombieMoan()
{
	PlaySound(GroanSounds[Rand(ArrayCount(GroanSounds))], SLOT_Interact,2);
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
	Burning = true;
}

defaultproperties
{
     GroanSounds(0)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.mmboy_01'
     GroanSounds(1)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.mmboy_02'
     GroanSounds(2)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.zombie_sight1'
     GroanSounds(3)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.zombie_sight2'
     GroanSounds(4)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.zombie_sight3'
     GroanSounds(5)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.zombie_sight4'
     GroanSounds(6)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.zombie_sight5'
     GroanSounds(7)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.zombie_sight6'
     GroanSounds(8)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.zombie_sight7'
     GroanSounds(9)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.chatter_01'
     GroanSounds(10)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.chatter_02'
     GroanSounds(11)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.chatter_03'
     DeathAnims(0)="DeathF"
     DeathAnims(1)="DeathB"
     DeathAnims(2)="DeathF"
     DeathAnims(3)="DeathB"
     SightAnim="Sight"
     HitAnimsX(0)="PainL01"
     HitAnimsX(1)="PainR01"
     HitAnimsX(2)="PainChest01"
     HitAnimsX(3)="PainHead01"
     MeleeAttackSounds(0)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.zombie_attack1'
     MeleeAttackSounds(1)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.zombie_attack2'
     MeleeAttackSounds(2)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.zombie_attack3'
     MeleeAttackSounds(3)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.zombie_attack3'
     SightSound=Sound'2009DoomMonstersSounds.ZombieSoundSet02.zombie_sight3'
     BurningMaterial=Combiner'2009DoomMonstersTex.Boney.JBoneySkin'
     HasHitAnims=True
     BurnAnimTime=0.500000
     MeleeAnims(0)="MeleeAttack01"
     MeleeDamage=22
     FootStep(0)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.step1'
     FootStep(1)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.step2'
     DodgeSkillAdjust=1.000000
     HitSound(0)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.zombie_pain1'
     HitSound(1)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.zombie_pain2'
     HitSound(2)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.zombie_pain3'
     HitSound(3)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.zombie_pain1'
     DeathSound(0)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.zombie_death1'
     DeathSound(1)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.zombie_death2'
     DeathSound(2)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.zombie_death3'
     DeathSound(3)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.zombie_death4'
     ChallengeSound(0)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.chatter_combat_01'
     ChallengeSound(1)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.chatter_combat_02'
     ChallengeSound(2)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.chatter_combat_03'
     ChallengeSound(3)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.chatter_combat_02'
     ScoringValue=8
     WallDodgeAnims(0)="Walk"
     WallDodgeAnims(1)="Walk"
     WallDodgeAnims(2)="Walk"
     WallDodgeAnims(3)="Walk"
     IdleHeavyAnim="Idle"
     IdleRifleAnim="Idle"
     FireHeavyRapidAnim="Idle"
     FireHeavyBurstAnim="Idle"
     FireRifleRapidAnim="Idle"
     FireRifleBurstAnim="Idle"
     RagdollOverride="D3Boney"
     MeleeRange=6.000000
     GroundSpeed=100.000000
     HealthMax=220.000000
     Health=220
     MenuName="Boney"
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
     Mesh=SkeletalMesh'2009DoomMonstersAnims.BoneyMesh'
     Skins(0)=Combiner'2009DoomMonstersTex.Boney.JBoneySkin'
     Skins(1)=Texture'2009DoomMonstersTex.Revenant.InvisMat'
     CollisionRadius=15.000000
     CollisionHeight=40.000000

     bUseExtendedCollision=True
     ColOffset=(X=20.000000,Z=45)
     ColRadius=17.000000
     ColHeight=20.000000


     MotionDetectorThreat=0.26 //5.14
     HeadRadius=9
     HeadOffset=(X=-1,Y=1,Z=0)
     ZappedDamageMod=2.0
     ZapThreshold=0.25
}
