class FatZombie extends DoomMonster;

var(Anims) name RandWalkAnims[4];

simulated function PostBeginPlay()
{
	local byte i;

	if( Level.NetMode!=NM_DedicatedServer )
	{
		for( i=0; i<ArrayCount(MovementAnims); i++ )
			MovementAnims[i] = RandWalkAnims[Rand(ArrayCount(RandWalkAnims))];
		TurnRightAnim = RandWalkAnims[Rand(ArrayCount(RandWalkAnims))];
		TurnLeftAnim = RandWalkAnims[Rand(ArrayCount(RandWalkAnims))];
	}
	Super.PostBeginPlay();
}

function RangedAttack(Actor A)
{
	if ( bShotAnim)
		return;

	if( !bHasRoamed )
		RoamAtPlayer();
	else if( IsInMeleeRange(A) )
	{
		PrepareMovingAttack(A,0.6);
		SetAnimAction(MeleeAnims[Rand(ArrayCount(MeleeAnims))]);
	}
}

// function SetOverlayMaterial(Material mat, float time, bool bOverride);

simulated function BurnAway()
{
	Burning = true;
	Skins[0] = BurnFX;
	Skins[2] = BurnFX;
}
simulated function FadeSkins()
{
	Skins[0] = FadeFX;
	Skins[1] = InvisMat;
	Skins[2] = FadeFX;
	Skins[3] = InvisMat;
	MakeBurnAway();
}

defaultproperties
{
     RandWalkAnims(0)="Walk01"
     RandWalkAnims(1)="Walk02"
     RandWalkAnims(2)="Walk03"
     RandWalkAnims(3)="Walk04"
     DeathAnims(0)="DeathF"
     DeathAnims(1)="DeathB"
     DeathAnims(2)="DeathF"
     DeathAnims(3)="DeathB"
     SightAnim="Sight"
     HitAnimsX(0)="PainL"
     HitAnimsX(1)="PainR"
     HitAnimsX(2)="PainHead"
     HitAnimsX(3)="PainBelly"
     MissSound(0)=Sound'2009DoomMonstersSounds.ZombieSoundSet01.zombie_whoosh1'
     MissSound(1)=Sound'2009DoomMonstersSounds.ZombieSoundSet01.zombie_whoosh2'
     MissSound(2)=Sound'2009DoomMonstersSounds.ZombieSoundSet01.zombie_whoosh3'
     MissSound(3)=Sound'2009DoomMonstersSounds.ZombieSoundSet01.zombie_whoosh2'
     MeleeAttackSounds(0)=Sound'KFPawnDamageSound.MeleeDamageSounds.bathitflesh'
     MeleeAttackSounds(1)=Sound'KFPawnDamageSound.MeleeDamageSounds.bathitflesh2'
     MeleeAttackSounds(2)=Sound'KFPawnDamageSound.MeleeDamageSounds.bathitflesh3'
     MeleeAttackSounds(3)=Sound'KFPawnDamageSound.MeleeDamageSounds.bathitflesh'
     SightSound=Sound'2009DoomMonstersSounds.ZombieSoundSet02.zombie_sight2'
     RunStepSounds(0)=Sound'2009DoomMonstersSounds.ZombieSoundSet01.fs_01'
     RunStepSounds(1)=Sound'2009DoomMonstersSounds.ZombieSoundSet01.fs_02'
     RunStepSounds(2)=Sound'2009DoomMonstersSounds.ZombieSoundSet01.fs_03'
     RunStepSounds(3)=Sound'2009DoomMonstersSounds.ZombieSoundSet01.fs_04'
     MeleeKnockBack=26000.000000
     BurnedTextureNum(0)=2
     HasHitAnims=True
     aimerror=100
     BurnAnimTime=0.500000
     MeleeAnims(0)="MeleeAttack01"
     MeleeAnims(1)="MeleeAttack01"
     MeleeAnims(2)="MeleeAttack01"
     MeleeDamage=20
     bUseExtendedCollision=True
     ColOffset=(Z=40.000000)
     ColRadius=25.000000
     ColHeight=24.000000
     HitSound(0)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.pain_01'
     HitSound(1)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.pain_02'
     HitSound(2)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.pain_03'
     HitSound(3)=Sound'2009DoomMonstersSounds.ZombieSoundSet01.zombie_pain5'
     DeathSound(0)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.zombie_death1'
     DeathSound(1)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.zombie_death2'
     DeathSound(2)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.zombie_death3'
     DeathSound(3)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.zombie_death4'
     ChallengeSound(0)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.chatter_01'
     ChallengeSound(1)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.chatter_02'
     ChallengeSound(2)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.chatter_03'
     ChallengeSound(3)=Sound'2009DoomMonstersSounds.ZombieSoundSet01.chatter_04'
     ScoringValue=8
     WallDodgeAnims(0)="Walk01"
     WallDodgeAnims(1)="Walk01"
     WallDodgeAnims(2)="Walk01"
     WallDodgeAnims(3)="Walk01"
     IdleHeavyAnim="Idle"
     IdleRifleAnim="Idle"
     FireHeavyRapidAnim="Idle"
     FireHeavyBurstAnim="Idle"
     FireRifleRapidAnim="Idle"
     FireRifleBurstAnim="Idle"
     RagdollOverride="D3FatZombie"
     bCanJump=False
     GroundSpeed=105.000000
     HeadRadius=12.000000
     MenuName="Fat Zombie"
     MovementAnims(0)="Walk01"
     MovementAnims(1)="Walk01"
     MovementAnims(2)="Walk01"
     MovementAnims(3)="Walk01"
     TurnLeftAnim="Walk01"
     TurnRightAnim="Walk01"
     SwimAnims(0)="Walk01"
     SwimAnims(1)="Walk01"
     SwimAnims(2)="Walk01"
     SwimAnims(3)="Walk01"
     CrouchAnims(0)="Walk01"
     CrouchAnims(1)="Walk01"
     CrouchAnims(2)="Walk01"
     CrouchAnims(3)="Walk01"
     WalkAnims(0)="Walk01"
     WalkAnims(1)="Walk01"
     WalkAnims(2)="Walk01"
     WalkAnims(3)="Walk01"
     AirAnims(0)="Walk01"
     AirAnims(1)="Walk01"
     AirAnims(2)="Walk01"
     AirAnims(3)="Walk01"
     TakeoffAnims(0)="Walk01"
     TakeoffAnims(1)="Walk01"
     TakeoffAnims(2)="Walk01"
     TakeoffAnims(3)="Walk01"
     LandAnims(0)="Walk01"
     LandAnims(1)="Walk01"
     LandAnims(2)="Walk01"
     LandAnims(3)="Walk01"
     DoubleJumpAnims(0)="Walk01"
     DoubleJumpAnims(1)="Walk01"
     DoubleJumpAnims(2)="Walk01"
     DoubleJumpAnims(3)="Walk01"
     DodgeAnims(0)="Walk01"
     DodgeAnims(1)="Walk01"
     DodgeAnims(2)="Walk01"
     DodgeAnims(3)="Walk01"
     AirStillAnim="Walk01"
     TakeoffStillAnim="Walk01"
     CrouchTurnRightAnim="Walk01"
     CrouchTurnLeftAnim="Walk01"
     IdleCrouchAnim="Idle"
     IdleSwimAnim="Idle"
     IdleWeaponAnim="Idle"
     IdleRestAnim="Idle"
     IdleChatAnim="Idle"
     Mesh=SkeletalMesh'2009DoomMonstersAnims.FatZombieMesh'
     Skins(0)=FinalBlend'2009DoomMonstersTex.FatZombie.FattySkinFB'
     Skins(1)=Shader'2009DoomMonstersTex.FatZombie.MonkeyWrenchShader'
     Skins(2)=Combiner'2009DoomMonstersTex.FatZombie.JFattySkin'
     Skins(3)=none
     //Skins(3)=Texture'2009DoomMonstersTex.Revenant.InvisMat'
     CollisionRadius=20.000000
     CollisionHeight=38.000000

     MotionDetectorThreat=0.26 //5.14
     ZappedDamageMod=2.0
     ZapThreshold=0.25
}
