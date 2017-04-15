class Mancubus extends DoomMonster;

var transient float NextRangedTime;
var(Sounds) Sound ProjFireSounds[2];
var byte MultiFires;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	if( FRand()<0.4f ) // Alt skin.
	{
		Skins[0] = Texture'MancubusSlimey';
		Skins[1] = Texture'MancubusSlimey';
	}
	BurningMaterial = Skins[0];
}

function RangedAttack(Actor A)
{
	if ( bShotAnim )
		return;

	if( !bHasRoamed )
		RoamAtPlayer();
	else if( IsInMeleeRange(A) && (MaxMeleeAttacks > 0 || NextRangedTime >= Level.TimeSeconds) )
	{
		MaxMeleeAttacks--;
		PrepareStillAttack(A);
		SetAnimAction('Attack1');
	}
	else if( NextRangedTime<Level.TimeSeconds )
	{
		if (MaxMeleeAttacks <= 0)
			MaxMeleeAttacks = 1 + rand(default.MaxMeleeAttacks+1);
			
		if( MultiFires==0 )
			MultiFires = 1+Rand(2);
		else if( --MultiFires==0 )
			NextRangedTime = Level.TimeSeconds+3.f+FRand()*6.f;
		PrepareStillAttack(A);
		SetAnimAction('MultiFire');
	}
}

// While enemy is not in reach but still in sight.
function bool ShouldTryRanged( Actor A )
{
	return (NextRangedTime<Level.TimeSeconds && FRand()<0.7f);
}

simulated function FireProjectile()
{
	if( Level.NetMode!=NM_Client && Controller!=None )
		FireProj(GetBoneCoords('lmissile').Origin);
	if( Level.NetMode!=NM_DedicatedServer )
		PlaySound(ProjFireSounds[Rand(2)],SLOT_Interact,2.f,,TransientSoundRadius*2.f);
}

function FireRProjectile()
{
	if( Level.NetMode!=NM_Client && Controller!=None )
		FireProj(GetBoneCoords('rmissile').Origin);
	if( Level.NetMode!=NM_DedicatedServer )
		PlaySound(ProjFireSounds[Rand(2)],SLOT_Misc,2.f,,TransientSoundRadius*2.f);
}

simulated function LFireGlow()
{
	if( Level.NetMode!=NM_DedicatedServer )
		Spawn(class'RevenantSmokePuffs',,,GetBoneCoords('lmissile').Origin);
}

simulated function RFireGlow()
{
	if( Level.NetMode!=NM_DedicatedServer )
		Spawn(class'RevenantSmokePuffs',,,GetBoneCoords('rmissile').Origin);
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
}

defaultproperties
{
     ProjFireSounds(0)=Sound'2009DoomMonstersSounds.Mancubus.Mancubus_ft_03'
     ProjFireSounds(1)=Sound'2009DoomMonstersSounds.Mancubus.Mancubus_ft_01'
     DeathAnims(0)="DeathF"
     DeathAnims(1)="DeathB"
     DeathAnims(2)="DeathF"
     DeathAnims(3)="DeathB"
     SightAnim="Sight"
     HitAnimsX(0)="Pain_L"
     HitAnimsX(1)="Pain_Head"
     HitAnimsX(2)="Pain_R"
     HitAnimsX(3)="Pain_Chest"
     MeleeAttackSounds(0)=Sound'2009DoomMonstersSounds.Mancubus.Mancubus_chatter_combat2'
     MeleeAttackSounds(1)=Sound'2009DoomMonstersSounds.Mancubus.Mancubus_chatter_combat2'
     MeleeAttackSounds(2)=Sound'2009DoomMonstersSounds.Mancubus.Mancubus_chatter_combat2'
     MeleeAttackSounds(3)=Sound'2009DoomMonstersSounds.Mancubus.Mancubus_chatter_combat2'
     SightSound=Sound'2009DoomMonstersSounds.Mancubus.Mancubus_sight1'
     BurnClass=Class'ScrnDoom3KF.MancubusBurnTex'
     FootstepSndRadius=800.000000
     RangedProjectile=Class'ScrnDoom3KF.MancubusProjectile'
     HasHitAnims=True
     BigMonster=True
     aimerror=200
     BurnAnimTime=0.200000
     MeleeDamage=50
     bFatAss=True
     bUseExtendedCollision=True
     ColOffset=(Z=38.000000)
     ColRadius=60.000000
     ColHeight=45.000000
     PlayerCountHealthScale=0.100000
     FootStep(0)=Sound'2009DoomMonstersSounds.Mancubus.Mancubus_step5'
     FootStep(1)=Sound'2009DoomMonstersSounds.Mancubus.Mancubus_step5'
     HitSound(0)=Sound'2009DoomMonstersSounds.Mancubus.Mancubus_pain5'
     HitSound(1)=Sound'2009DoomMonstersSounds.Mancubus.Mancubus_pain6'
     HitSound(2)=Sound'2009DoomMonstersSounds.Mancubus.Mancubus_pain5'
     HitSound(3)=Sound'2009DoomMonstersSounds.Mancubus.Mancubus_pain6'
     DeathSound(0)=Sound'2009DoomMonstersSounds.Mancubus.Mancubus_die3'
     DeathSound(1)=Sound'2009DoomMonstersSounds.Mancubus.Mancubus_die1'
     DeathSound(2)=Sound'2009DoomMonstersSounds.Mancubus.Mancubus_die3'
     DeathSound(3)=Sound'2009DoomMonstersSounds.Mancubus.Mancubus_die1'
     ChallengeSound(0)=Sound'2009DoomMonstersSounds.Mancubus.Mancubus_Chatter1'
     ChallengeSound(1)=Sound'2009DoomMonstersSounds.Mancubus.Mancubus_chatter2'
     ChallengeSound(2)=Sound'2009DoomMonstersSounds.Mancubus.Mancubus_sight2'
     ChallengeSound(3)=Sound'2009DoomMonstersSounds.Mancubus.Mancubus_sight3'
     ScoringValue=180
     WallDodgeAnims(0)="Walk"
     WallDodgeAnims(1)="Walk"
     WallDodgeAnims(2)="Walk"
     WallDodgeAnims(3)="Walk"
     IdleHeavyAnim="Idle"
     IdleRifleAnim="Idle"
     FireHeavyRapidAnim="Walk"
     FireHeavyBurstAnim="Walk"
     FireRifleRapidAnim="Walk"
     FireRifleBurstAnim="Walk"
     RagdollOverride="D3Mancubus"
     bCanJump=False
     MeleeRange=130.000000
     GroundSpeed=85.000000
     HealthMax=1600.000000
     Health=1600
     HeadRadius=16.000000
     MenuName="Mancubus"
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
     Mesh=SkeletalMesh'2009DoomMonstersAnims.MancubusMesh'
     DrawScale=1.200000
     Skins(0)=Combiner'2009DoomMonstersTex.Mancubus.JMancubusSkin'
     Skins(1)=Combiner'2009DoomMonstersTex.Mancubus.JMancubusSkin'
     Skins(2)=Shader'2009DoomMonstersTex.Mancubus.MancubusPipeShader'
     Skins(3)=Texture'2009DoomMonstersTex.Mancubus.MancubusPipe'
     CollisionRadius=26 // 30
     CollisionHeight=44 //48
     Mass=5000.000000
	 MaxMeleeAttacks=5
     ZapThreshold=1.750000
}
