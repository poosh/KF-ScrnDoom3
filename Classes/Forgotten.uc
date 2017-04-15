class Forgotten extends LostSoul;

simulated function PostBeginPlay()
{
	Super(DoomMonster).PostBeginPlay();
 	if ( Level.NetMode != NM_DedicatedServer )
	{
		LostTrail = Spawn(class'ForgottenTrailEffect',Self);
		AttachToBone(LostTrail, 'headflame');
	}
}
simulated function PlayDirectionalDeath(Vector HitLoc)
{
	LifeSpan = 0.6f;
	Spawn(class'ForgottenExplosion');
	bHidden = true;
	if(LostTrail != None)
		LostTrail.Kill();
}

defaultproperties
{
     ChargeSound=Sound'2009DoomMonstersSounds.Forgotten.Forgotten_sight_01'
     ChargeHitDamage=38
     ChargeAnims(1)="Charge2"
     HitAnimsX(0)="pain1"
     MeleeAttackSounds(0)=Sound'2009DoomMonstersSounds.Forgotten.Forgotten_chomp_01'
     MeleeAttackSounds(1)=Sound'2009DoomMonstersSounds.Forgotten.Forgotten_chomp_02'
     MeleeAttackSounds(2)=Sound'2009DoomMonstersSounds.Forgotten.Forgotten_chomp_03'
     MeleeAttackSounds(3)=Sound'2009DoomMonstersSounds.Forgotten.Forgotten_chomp_01'
     SightSound=Sound'2009DoomMonstersSounds.Forgotten.Forgotten_sight_01'
     BurnedTextureNum(1)=2
     bHasFireWeakness=False
     MeleeDamage=27
     HitSound(0)=Sound'2009DoomMonstersSounds.Forgotten.Forgotten_pain_03'
     HitSound(1)=Sound'2009DoomMonstersSounds.Forgotten.Forgotten_pain_04'
     HitSound(2)=Sound'2009DoomMonstersSounds.Forgotten.Forgotten_pain_03'
     HitSound(3)=Sound'2009DoomMonstersSounds.Forgotten.Forgotten_pain_04'
     DeathSound(0)=Sound'2009DoomMonstersSounds.Forgotten.Forgotten_death_01'
     DeathSound(1)=Sound'2009DoomMonstersSounds.Forgotten.Forgotten_death_05'
     DeathSound(2)=Sound'2009DoomMonstersSounds.Forgotten.Forgotten_death_01'
     DeathSound(3)=Sound'2009DoomMonstersSounds.Forgotten.Forgotten_death_05'
     ChallengeSound(0)=Sound'2009DoomMonstersSounds.Forgotten.Forgotten_sight_02'
     ChallengeSound(1)=Sound'2009DoomMonstersSounds.Forgotten.Forgotten_sight_03'
     ChallengeSound(2)=Sound'2009DoomMonstersSounds.Forgotten.Forgotten_idle_01'
     ChallengeSound(3)=Sound'2009DoomMonstersSounds.Forgotten.Forgotten_idle_03'
     ScoringValue=20
     WallDodgeAnims(0)="Idle"
     WallDodgeAnims(1)="Idle"
     WallDodgeAnims(2)="Idle"
     WallDodgeAnims(3)="Idle"
     IdleHeavyAnim="Idle"
     IdleRifleAnim="Idle"
     FireHeavyRapidAnim="Idle"
     FireHeavyBurstAnim="Idle"
     FireRifleRapidAnim="Idle"
     FireRifleBurstAnim="Idle"
     AirSpeed=260.000000
     HealthMax=180.000000
     Health=180
     MenuName="Forgotten"
     MovementAnims(0)="Idle"
     MovementAnims(1)="Idle"
     MovementAnims(2)="Idle"
     MovementAnims(3)="Idle"
     TurnLeftAnim="Idle"
     TurnRightAnim="Idle"
     SwimAnims(0)="Idle"
     SwimAnims(1)="Idle"
     SwimAnims(2)="Idle"
     SwimAnims(3)="Idle"
     CrouchAnims(0)="Idle"
     CrouchAnims(1)="Idle"
     CrouchAnims(2)="Idle"
     CrouchAnims(3)="Idle"
     WalkAnims(0)="Idle"
     WalkAnims(1)="Idle"
     WalkAnims(2)="Idle"
     WalkAnims(3)="Idle"
     AirAnims(0)="Idle"
     AirAnims(1)="Idle"
     AirAnims(2)="Idle"
     AirAnims(3)="Idle"
     TakeoffAnims(0)="Idle"
     TakeoffAnims(1)="Idle"
     TakeoffAnims(2)="Idle"
     TakeoffAnims(3)="Idle"
     LandAnims(0)="Idle"
     LandAnims(1)="Idle"
     LandAnims(2)="Idle"
     LandAnims(3)="Idle"
     DoubleJumpAnims(0)="Idle"
     DoubleJumpAnims(1)="Idle"
     DoubleJumpAnims(2)="Idle"
     DoubleJumpAnims(3)="Idle"
     DodgeAnims(0)="Idle"
     DodgeAnims(1)="Idle"
     DodgeAnims(2)="Idle"
     DodgeAnims(3)="Idle"
     AirStillAnim="Idle"
     TakeoffStillAnim="Idle"
     CrouchTurnRightAnim="Idle"
     CrouchTurnLeftAnim="Idle"
     IdleCrouchAnim="Idle"
     IdleSwimAnim="Idle"
     IdleWeaponAnim="Idle"
     IdleRestAnim="Idle"
     IdleChatAnim="Idle"
     AmbientSound=Sound'2009DoomMonstersSounds.Forgotten.Forgotten_flight_02a'
     Mesh=SkeletalMesh'2009DoomMonstersAnims.ForgottenMesh'
     Skins(0)=Combiner'2009DoomMonstersTex.Forgotten.JForgottenSkin'
     Skins(1)=Shader'2009DoomMonstersTex.Forgotten.FlamesShader'
     Skins(2)=FinalBlend'2009DoomMonstersTex.Forgotten.ForgottenFB'
     CollisionRadius=20.000000

     MotionDetectorThreat=0.5 //5.14
}
