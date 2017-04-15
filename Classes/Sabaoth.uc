class Sabaoth extends DoomMonster;

var transient float MultiAttackTime;
var(Sounds) Sound Laughs[3],PreFireSound;
var SabaothChargeEffect Charge;

function PlayChallengeSound()
{
	if( nextChallengeVoice<Level.TimeSeconds )
	{
		PlaySound(ChallengeSound[Rand(4)],SLOT_Talk);
		nextChallengeVoice = Level.TimeSeconds+8.f+FRand()*20.f;
	}
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	bHasRoamed = false;
}

function RangedAttack(Actor A)
{
	if ( bShotAnim )
		return;
	if( !bHasRoamed )
		RoamAtPlayer();
	else if( IsInMeleeRange(A) && (MaxMeleeAttacks > 0 || NextProjTime >= Level.TimeSeconds) )
	{
		MaxMeleeAttacks--;
		PrepareMovingAttack(A,0.8);
		SetAnimAction('Attack2');
	}
	else if( NextProjTime<Level.TimeSeconds || MultiAttackTime>Level.TimeSeconds )
	{
		if (MaxMeleeAttacks <= 0)
			MaxMeleeAttacks = rand(default.MaxMeleeAttacks+1);	
	
		if( MultiAttackTime>Level.TimeSeconds )
			NextProjTime = Level.TimeSeconds+4.f;
		else
		{
			if( FRand()<0.2f )
				MultiAttackTime = Level.TimeSeconds+2.f+FRand()*5.f;
			NextProjTime = Level.TimeSeconds+2.f+FRand()*5.f;
		}
		PrepareStillAttack(A);
		SetAnimAction('Attack1');
		PlaySound(PreFireSound,SLOT_Interact);
	}
}

// While enemy is not in reach but still in sight.
function bool ShouldTryRanged( Actor A )
{
	return (NextProjTime<Level.TimeSeconds && FRand()<0.7f);
}

simulated function FireProjectile()
{
	if ( Level.NetMode!=NM_Client && Controller!=None )
		FireProj(GetBoneCoords('mech_bfg').Origin);
	if( Level.NetMode!=NM_DedicatedServer )
		PlaySound(FireSound,SLOT_Interact);
	if( Charge!=None )
		Charge.Kill();
}

simulated function ChargeBFG()
{
	if( Level.NetMode!=NM_DedicatedServer )
	{
		Charge = Spawn(class'SabaothChargeEffect',,,GetBoneCoords('mech_bfg').Origin);
		AttachToBone(Charge,'mech_bfg');
	}
}

// function SetOverlayMaterial(Material mat, float time, bool bOverride);

simulated function RemoveEffects()
{
	if(Charge != None)
		Charge.Kill();
}

simulated function FadeSkins()
{
	Skins[5] = FadeFX;
	MakeBurnAway();
}

simulated function BurnAway()
{
	Skins[0] = BurnFX;
	Skins[1] = BurnFX;
	Skins[2] = BurnFX;
	Skins[3] = BurnFX;
	Skins[4] = InvisMat;
	Skins[5] = BurnFX;
	Skins[6] = BurnFX;
	Skins[7] = InvisMat;
	Skins[8] = InvisMat;
	Burning = true;
}

defaultproperties
{
     Laughs(0)=Sound'2009DoomMonstersSounds.Sabaoth.Sabaoth_taunt_01'
     Laughs(1)=Sound'2009DoomMonstersSounds.Sabaoth.Sabaoth_taunt_02'
     Laughs(2)=Sound'2009DoomMonstersSounds.Sabaoth.Sabaoth_taunt_03'
     PreFireSound=Sound'2009DoomMonstersSounds.BFG.bfg_firebegin'
     DeathAnims(0)="Death"
     DeathAnims(1)="Death"
     DeathAnims(2)="Death"
     DeathAnims(3)="Death"
     SightAnim="Sight"
     MinHitAnimDelay=4.000000
     MeleeAttackSounds(0)=Sound'2009DoomMonstersSounds.Sabaoth.Sabaoth_melee_attack'
     MeleeAttackSounds(1)=Sound'2009DoomMonstersSounds.Sabaoth.Sabaoth_melee_attack'
     MeleeAttackSounds(2)=Sound'2009DoomMonstersSounds.Sabaoth.Sabaoth_melee_attack'
     MeleeAttackSounds(3)=Sound'2009DoomMonstersSounds.Sabaoth.Sabaoth_melee_attack'
     SightSound=Sound'2009DoomMonstersSounds.Sabaoth.Sabaoth_SightEnglish'
     FadeClass=Class'ScrnDoom3KF.SabaothMaterialSequence'
     RangedProjectile=Class'ScrnDoom3KF.SabaothProjectile'
     DoomTeleportFXClass=Class'ScrnDoom3KF.BossDemonSpawn'
     BurnedTextureNum(0)=5
     BigMonster=True
     aimerror=100
     BurnAnimTime=1.400000
     bCanAttackPipebombs=True
     MeleeDamage=90
     bFatAss=True
     bBoss=True
     DeathSound(0)=Sound'2009DoomMonstersSounds.Sabaoth.Sabaoth_Death'
     DeathSound(1)=Sound'2009DoomMonstersSounds.Sabaoth.Sabaoth_Death'
     DeathSound(2)=Sound'2009DoomMonstersSounds.Sabaoth.Sabaoth_Death'
     DeathSound(3)=Sound'2009DoomMonstersSounds.Sabaoth.Sabaoth_Death'
     ChallengeSound(0)=Sound'2009DoomMonstersSounds.Sabaoth.Sabaoth_taunt_04English'
     ChallengeSound(1)=Sound'2009DoomMonstersSounds.Sabaoth.Sabaoth_taunt_05English'
     ChallengeSound(2)=Sound'2009DoomMonstersSounds.Sabaoth.Sabaoth_taunt_06English'
     ChallengeSound(3)=Sound'2009DoomMonstersSounds.Sabaoth.Sabaoth_taunt_03'
     FireSound=Sound'2009DoomMonstersSounds.BFG.bfg_fire'
     ScoringValue=900
     WallDodgeAnims(0)="Travel"
     WallDodgeAnims(1)="Travel"
     WallDodgeAnims(2)="Travel"
     WallDodgeAnims(3)="Travel"
     IdleHeavyAnim="Idle"
     IdleRifleAnim="Idle"
     FireHeavyRapidAnim="Travel"
     FireHeavyBurstAnim="Travel"
     FireRifleRapidAnim="Travel"
     FireRifleBurstAnim="Travel"
     RagdollOverride="D3Sabaoth"
     bCanJump=False
     MeleeRange=100.000000
     GroundSpeed=170.000000
     HealthMax=7500.000000
     Health=7500
     HeadRadius=15.000000
     MenuName="Sabaoth"
     ControllerClass=Class'ScrnDoom3KF.SabaothAI'
     MovementAnims(0)="Travel"
     MovementAnims(1)="Travel"
     MovementAnims(2)="Travel"
     MovementAnims(3)="Travel"
     TurnLeftAnim="Travel"
     TurnRightAnim="Travel"
     SwimAnims(0)="Travel"
     SwimAnims(1)="Travel"
     SwimAnims(2)="Travel"
     SwimAnims(3)="Travel"
     CrouchAnims(0)="Travel"
     CrouchAnims(1)="Travel"
     CrouchAnims(2)="Travel"
     CrouchAnims(3)="Travel"
     WalkAnims(0)="Travel"
     WalkAnims(1)="Travel"
     WalkAnims(2)="Travel"
     WalkAnims(3)="Travel"
     AirAnims(0)="Travel"
     AirAnims(1)="Travel"
     AirAnims(2)="Travel"
     AirAnims(3)="Travel"
     TakeoffAnims(0)="Travel"
     TakeoffAnims(1)="Travel"
     TakeoffAnims(2)="Travel"
     TakeoffAnims(3)="Travel"
     LandAnims(0)="Travel"
     LandAnims(1)="Travel"
     LandAnims(2)="Travel"
     LandAnims(3)="Travel"
     DoubleJumpAnims(0)="Travel"
     DoubleJumpAnims(1)="Travel"
     DoubleJumpAnims(2)="Travel"
     DoubleJumpAnims(3)="Travel"
     DodgeAnims(0)="Travel"
     DodgeAnims(1)="Travel"
     DodgeAnims(2)="Travel"
     DodgeAnims(3)="Travel"
     AirStillAnim="Travel"
     TakeoffStillAnim="Travel"
     CrouchTurnRightAnim="Travel"
     CrouchTurnLeftAnim="Travel"
     IdleCrouchAnim="Idle"
     IdleSwimAnim="Idle"
     IdleWeaponAnim="Idle"
     IdleRestAnim="Idle"
     IdleChatAnim="Idle"
     HeadBone="organic_head"
     AmbientSound=Sound'2009DoomMonstersSounds.Sabaoth.Sabaoth_Walk'
     Mesh=SkeletalMesh'2009DoomMonstersAnims.SabaothMesh'
     DrawScale=1.200000
     Skins(0)=Shader'2009DoomMonstersTex.Sabaoth.Gear2Shader'
     Skins(1)=Shader'2009DoomMonstersTex.Sabaoth.Gear2Shader'
     Skins(2)=Shader'2009DoomMonstersTex.Sabaoth.Gear3Shader'
     Skins(3)=Shader'2009DoomMonstersTex.Sabaoth.TreadShader'
     Skins(4)=Texture'2009DoomMonstersTex.Revenant.InvisMat'
     Skins(5)=Combiner'2009DoomMonstersTex.Sabaoth.JSabaothSkin'
     Skins(6)=Texture'2009DoomMonstersTex.Sabaoth.BFGSkin'
     Skins(7)=Shader'2009DoomMonstersTex.Sabaoth.SabaothEyesShader'
     Skins(8)=Shader'2009DoomMonstersTex.Sabaoth.SabaothEyesShader'
     
     CollisionRadius=26 //44
     CollisionHeight=40 // 60
     bUseExtendedCollision=True
     ColOffset=(Z=30.000000)
     ColRadius=60.000000
     ColHeight=65.000000

     Mass=6000.000000
     RotationRate=(Yaw=100000)
	 FireRootBone="mech_spine_5"
}
