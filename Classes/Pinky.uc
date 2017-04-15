class Pinky extends DoomMonster;

var Sound MetalSteps[2];
var Sound IdleGrunts[4];

function ZombieMoan()
{
	PlaySound(IdleGrunts[Rand(4)], SLOT_Interact,8);
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
		SetAnimAction(MeleeAnims[Rand(ArrayCount(MeleeAnims))]);
	}
}

simulated function MetalStep()
{
	PlaySound(MetalSteps[Rand(2)], SLOT_Talk,8);
}

// function SetOverlayMaterial(Material mat, float time, bool bOverride);

simulated function FadeSkins()
{
	Skins[0] = FadeFX;
	Skins[1] = FadeFX;
	MakeBurnAway();
}

simulated function BurnAway()
{
	Skins[0] = BurnFX;
	Skins[1] = BurnFX;
	Skins[2] = BurnFX;
	Burning = true;
}

function bool IsHeadShot(vector loc, vector ray, float AdditionalScale)
{
	return false;
}

defaultproperties
{
     MetalSteps(0)=Sound'2009DoomMonstersSounds.Pinky.Pinky_metalstep_test24'
     MetalSteps(1)=Sound'2009DoomMonstersSounds.Pinky.Pinky_metalstep_test24'
     IdleGrunts(0)=Sound'2009DoomMonstersSounds.Pinky.Pinky_idle_test1'
     IdleGrunts(1)=Sound'2009DoomMonstersSounds.Pinky.Pinky_idle_test2'
     IdleGrunts(2)=Sound'2009DoomMonstersSounds.Pinky.Pinky_idle_test3'
     IdleGrunts(3)=Sound'2009DoomMonstersSounds.Pinky.Pinky_idle_test4'
     DeathAnims(0)="DeathF"
     DeathAnims(1)="DeathB"
     DeathAnims(2)="DeathF"
     DeathAnims(3)="DeathB"
     SightAnim="Roar3"
     HitAnimsX(0)="Pain_L"
     HitAnimsX(1)="Pain_R"
     HitAnimsX(2)="Pain_Head"
     HitAnimsX(3)="Pain_Head"
     MeleeAttackSounds(0)=Sound'2009DoomMonstersSounds.Pinky.Pinky_melee_test2'
     MeleeAttackSounds(1)=Sound'2009DoomMonstersSounds.Pinky.Pinky_melee_test2'
     MeleeAttackSounds(2)=Sound'2009DoomMonstersSounds.Pinky.Pinky_melee_test2'
     MeleeAttackSounds(3)=Sound'2009DoomMonstersSounds.Pinky.Pinky_melee_test2'
     SightSound=Sound'2009DoomMonstersSounds.Pinky.Pinky_sight_test22'
     BurningMaterial=Texture'2009DoomMonstersTex.Pinky.PinkySkin2'
     BurnClass=Class'ScrnDoom3KF.PinkyBurnTex'
     FadeClass=Class'ScrnDoom3KF.PinkyMaterialSequence'
     MeleeKnockBack=20000.000000
     BurnedTextureNum(0)=1
     HasHitAnims=True
     BurnAnimTime=0.250000
     MeleeAnims(0)="Attack1"
     MeleeAnims(1)="Attack2"
     MeleeAnims(2)="Attack3"
     MeleeDamage=30
     bFatAss=True
     FootStep(0)=Sound'2009DoomMonstersSounds.Pinky.Pinky_fleshstep_test12'
     FootStep(1)=Sound'2009DoomMonstersSounds.Pinky.Pinky_fleshstep_test12'
     DodgeSkillAdjust=1.000000
     HitSound(0)=Sound'2009DoomMonstersSounds.Pinky.Pinky_pain_test1'
     HitSound(1)=Sound'2009DoomMonstersSounds.Pinky.Pinky_pain_test1'
     HitSound(2)=Sound'2009DoomMonstersSounds.Pinky.Pinky_pain_test1'
     HitSound(3)=Sound'2009DoomMonstersSounds.Pinky.Pinky_pain_test1'
     DeathSound(0)=Sound'2009DoomMonstersSounds.Pinky.Pinky_death_test3'
     DeathSound(1)=Sound'2009DoomMonstersSounds.Pinky.Pinky_death_test5'
     DeathSound(2)=Sound'2009DoomMonstersSounds.Pinky.Pinky_death_test3'
     DeathSound(3)=Sound'2009DoomMonstersSounds.Pinky.Pinky_death_test5'
     ChallengeSound(0)=Sound'2009DoomMonstersSounds.Pinky.Pinky_sight2_test2'
     ChallengeSound(1)=Sound'2009DoomMonstersSounds.Pinky.Pinky_sight2_test3'
     ChallengeSound(2)=Sound'2009DoomMonstersSounds.Pinky.Pinky_sight3_test3'
     ChallengeSound(3)=Sound'2009DoomMonstersSounds.Pinky.Pinky_idle_test1'
     ScoringValue=40
     WallDodgeAnims(0)="Dodge_L"
     WallDodgeAnims(1)="Dodge_R"
     WallDodgeAnims(2)="Dodge_L"
     WallDodgeAnims(3)="Dodge_R"
     IdleHeavyAnim="Idle"
     IdleRifleAnim="Idle"
     FireHeavyRapidAnim="Idle"
     FireHeavyBurstAnim="Idle"
     FireRifleRapidAnim="Idle"
     FireRifleBurstAnim="Idle"
     RagdollOverride="D3Pinky"
     MeleeRange=100.000000
     GroundSpeed=300.000000
     HealthMax=550.000000
     Health=550
     MenuName="Pinky"
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
     DodgeAnims(0)="Dodge_L"
     DodgeAnims(1)="Dodge_R"
     DodgeAnims(2)="Dodge_L"
     DodgeAnims(3)="Dodge_R"
     AirStillAnim="Run"
     TakeoffStillAnim="Run"
     CrouchTurnRightAnim="Run"
     CrouchTurnLeftAnim="Run"
     IdleCrouchAnim="Idle"
     IdleSwimAnim="Idle"
     IdleWeaponAnim="Idle"
     IdleRestAnim="Idle"
     IdleChatAnim="Idle"
     Mesh=SkeletalMesh'2009DoomMonstersAnims.PinkyMesh'
     DrawScale=1.100000
     Skins(0)=Combiner'2009DoomMonstersTex.Pinky.JPinkySkin'
     Skins(1)=Combiner'2009DoomMonstersTex.Pinky.JPinkySkin'
     Skins(2)=Texture'2009DoomMonstersTex.Pinky.PinkyTeethDiffuseA'
     Skins(3)=Shader'2009DoomMonstersTex.Pinky.drool'
     Skins(4)=Shader'2009DoomMonstersTex.Pinky.drool'
     
     CollisionRadius=26 //30
     bUseExtendedCollision=True
     ColOffset=(Y=0,Z=0)
     ColRadius=42.000000
     ColHeight=30.000000          
}
