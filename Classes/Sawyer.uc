class Sawyer extends DoomMonster;

function RangedAttack(Actor A)
{
	if ( bShotAnim )
		return;
	if( !bHasRoamed )
		RoamAtPlayer();
	else if( IsInMeleeRange(A) )
	{
		PrepareMovingAttack(A,0.6);
		PlaySound(MeleeAttackSounds[Rand(4)], SLOT_Interact);
		SetAnimAction(MeleeAnims[Rand(2)]);
	}
}
simulated function FadeSkins()
{
	Skins[0] = FadeFX;
	MakeBurnAway();
}
simulated function BurnAway()
{
	Skins[0] = BurnFX;
	Skins[1] = InvisMat;
	Burning = true;
}

defaultproperties
{
     DeathAnims(0)="DeathF"
     DeathAnims(1)="DeathB"
     DeathAnims(2)="DeathF"
     DeathAnims(3)="DeathB"
     SightAnim="StartChainSaw"
     HitAnimsX(0)="PainL"
     HitAnimsX(1)="PainR"
     HitAnimsX(2)="PainHead"
     HitAnimsX(3)="PainChest"
     MeleeAttackSounds(0)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.chainsaw_attack_01'
     MeleeAttackSounds(1)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.chainsaw_attack_02'
     MeleeAttackSounds(2)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.chainsaw_attack_03'
     MeleeAttackSounds(3)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.chainsaw_attack_02'
     SightSound=Sound'2009DoomMonstersSounds.ZombieSoundSet02.sight_03'
     BurningMaterial=Texture'2009DoomMonstersTex.Sawyer.SawyerSkin'
     HasHitAnims=True
     BurnAnimTime=0.150000
     MeleeAnims(0)="MeleeWalk01"
     MeleeAnims(1)="MeleeWalk02"
     MeleeDamage=25
     FootStep(0)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.step1'
     FootStep(1)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.step2'
     DodgeSkillAdjust=1.000000
     HitSound(0)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.pain_01'
     HitSound(1)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.pain_02'
     HitSound(2)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.pain_03'
     HitSound(3)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.pain_04'
     DeathSound(0)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.death_01'
     DeathSound(1)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.death_03'
     DeathSound(2)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.death_04'
     DeathSound(3)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.death_03'
     ChallengeSound(0)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.chatter_03'
     ChallengeSound(1)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.chatter_combat_01'
     ChallengeSound(2)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.chatter_combat_02'
     ChallengeSound(3)=Sound'2009DoomMonstersSounds.ZombieSoundSet02.chatter_combat_03'
     ScoringValue=20
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
     RagdollOverride="D3Sawyer"
     bCanJump=False
     GroundSpeed=170.000000
     HealthMax=280.000000
     Health=280
     HeadRadius=12.000000
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
     Mesh=SkeletalMesh'2009DoomMonstersAnims.SawyerMesh'
     Skins(0)=Combiner'2009DoomMonstersTex.Sawyer.JSawyerSkin'
     Skins(1)=Shader'2009DoomMonstersTex.Sawyer.SawyerHairShader'
     Skins(2)=TexPanner'2009DoomMonstersTex.Sawyer.ChainPanner'
     Skins(3)=Texture'2009DoomMonstersTex.Sawyer.SawyerChainsaw'
     Skins(4)=Texture'2009DoomMonstersTex.Revenant.InvisMat'
     CollisionRadius=18
     CollisionHeight=44 //50

     MotionDetectorThreat=0.50 //5.14
     ZappedDamageMod=1.5
}
