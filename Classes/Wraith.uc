class Wraith extends DoomMonster;

var() float TeleportInterval;
var() float TeleportRadius;
var transient float NextTeleTime;

var(Sounds) Sound TeleportIn;
var(Sounds) Sound TeleportOut;

var vector RepTeleport;
var float RepResetTime;
var bool bResetRepT;

replication
{
	reliable if( Role==ROLE_Authority )
		RepTeleport;
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
		SetAnimAction(MeleeAnims[Rand(3)]);
	}
	else if( VSizeSquared(A.Location-Location)>30000.f && NextTeleTime<Level.TimeSeconds )
	{
		if( FRand()<0.5f )
		{
			NextTeleTime = Level.TimeSeconds+0.5f;
			return;
		}
		if( FRand()<0.5f )
			NextTeleTime = Level.TimeSeconds+0.1;
		else NextTeleTime = Level.TimeSeconds+0.5f+FRand();
		TeleportTo(FindTeleSpot(A));
	}
}

simulated function SpawnTeleEffects(vector OldLoc, vector NewLoc)
{
	local xEmitter xBeam;

	xBeam = Spawn(class'PortalBeam',,,OldLoc);
	xBeam.mSpawnVecA = NewLoc;
	Spawn(class'HellPortalFlare',,,OldLoc).PlaySound(TeleportOut);
	Spawn(class'HellPortal',,,NewLoc).PlaySound(TeleportIn);
}
final function vector FindTeleSpot( Actor A )
{
	local vector HL,HN,End;
	local byte i;
	local bool bFarDist;
	local float Dist,ADist;

	ADist = VSizeSquared(A.Location-Location)*1.4f;
	bFarDist = (ADist>640000.f);
	while( ++i<7 )
	{
		if( bFarDist )
			End = Normal(A.Location-Location)*300.f+VRand()*200.f+Location;
		else End = Location+VRand()*300.f;
		if( Trace(HL,HN,End,Location,false,GetCollisionExtent())!=None )
			End = HL;
		if( Trace(HL,HN,End-vect(0,0,700),End,false,GetCollisionExtent())!=None )
			End = HL;
		else End.Z-=700.f;
		Dist = VSizeSquared(End-Location);
		if( Dist<640000.f && Dist>40000.f && ADist>=VSizeSquared(A.Location-End) && FastTrace(End,Location) && FastTrace(End,A.Location) )
			return End;
	}
	return Location;
}
function TeleportTo( vector Point )
{
	local vector OlPoint;

	OlPoint = Location;
	if( VSizeSquared(Point-Location)<2500.f || !SetLocation(Point) )
		return;
	RepTeleport = OlPoint;
	RepResetTime = Level.TimeSeconds+0.6f;
	bResetRepT = true;
	SetPhysics(PHYS_Falling);
	Velocity = vect(0,0,0);
	if( Level.NetMode!=NM_DedicatedServer )
		SpawnTeleEffects(OlPoint,Location);
	//PrepareStillAttack(None);
	//SetAnimAction('Teleport');
}
simulated function Tick( float Delta )
{
	if( bResetRepT && RepResetTime<Level.TimeSeconds )
	{
		bResetRepT = false;
		RepTeleport = vect(0,0,0);
	}
	Super.Tick(Delta);
}
simulated function PostNetReceive()
{
	if( RepTeleport!=vect(0,0,0) )
	{
		if( VSize(Location-RepTeleport)>50.f )
			SpawnTeleEffects(RepTeleport,Location);
		RepTeleport = vect(0,0,0);
	}
}

// function SetOverlayMaterial(Material mat, float time, bool bOverride);

simulated function FadeSkins()
{
	MakeBurnAway();
	Skins[0] = FadeFX;
	Skins[2] = FadeFX;
}

simulated function BurnAway()
{
	local int i;

	for(i=0;i<Skins.Length;i++)
		Skins[i] = BurnFX;
	Burning = true;
}

defaultproperties
{
     TeleportInterval=0.600000
     TeleportRadius=600.000000
     TeleportIn=Sound'2009DoomMonstersSounds.Wraith.Wraith_teleport_in_01'
     TeleportOut=Sound'2009DoomMonstersSounds.Wraith.Wraith_teleport_out_01'
     DeathAnims(0)="DeathF"
     DeathAnims(1)="DeathB"
     DeathAnims(2)="DeathF"
     DeathAnims(3)="DeathB"
     SightAnim="Sight"
     HitAnimsX(0)="Pain_L"
     HitAnimsX(1)="Pain_Head"
     HitAnimsX(2)="Pain_R"
     HitAnimsX(3)="Pain_Chest"
     MeleeAttackSounds(0)=Sound'2009DoomMonstersSounds.Wraith.Wraith_Attack1'
     MeleeAttackSounds(1)=Sound'2009DoomMonstersSounds.Wraith.Wraith_Attack2'
     MeleeAttackSounds(2)=Sound'2009DoomMonstersSounds.Wraith.Wraith_Attack3'
     MeleeAttackSounds(3)=Sound'2009DoomMonstersSounds.Wraith.Wraith_Attack1'
     SightSound=Sound'2009DoomMonstersSounds.Wraith.Wraith_Sight'
     BurningMaterial=Texture'2009DoomMonstersTex.Wraith.WraithSkin'
     BurnClass=Class'ScrnDoom3KF.WraithBurnTex'
     FadeClass=Class'ScrnDoom3KF.WraithMaterialSequence'
     MeleeKnockBack=25000.000000
     FootstepSndRadius=400.000000
     HasHitAnims=True
     BurnAnimTime=0.250000
     MeleeAnims(0)="Attack1"
     MeleeAnims(1)="Attack2"
     MeleeAnims(2)="Attack3"
     MeleeDamage=14
     FootStep(0)=Sound'2009DoomMonstersSounds.Wraith.Wraith_footstep1'
     FootStep(1)=Sound'2009DoomMonstersSounds.Wraith.Wraith_footstep2'
     HitSound(0)=Sound'2009DoomMonstersSounds.Wraith.Wraith_Pain'
     HitSound(1)=Sound'2009DoomMonstersSounds.Wraith.Wraith_Pain_Chest'
     HitSound(2)=Sound'2009DoomMonstersSounds.Wraith.Wraith_pain_left_arm'
     HitSound(3)=Sound'2009DoomMonstersSounds.Wraith.Wraith_pain_right_arm'
     DeathSound(0)=Sound'2009DoomMonstersSounds.Wraith.Wraith_Death'
     DeathSound(1)=Sound'2009DoomMonstersSounds.Wraith.Wraith_death_04'
     DeathSound(2)=Sound'2009DoomMonstersSounds.Wraith.Wraith_death_03'
     DeathSound(3)=Sound'2009DoomMonstersSounds.Wraith.Wraith_death_02'
     ChallengeSound(0)=Sound'2009DoomMonstersSounds.Wraith.Wraith_chatter1'
     ChallengeSound(1)=Sound'2009DoomMonstersSounds.Wraith.Wraith_chatter2'
     ChallengeSound(2)=Sound'2009DoomMonstersSounds.Wraith.Wraith_chatter3'
     ChallengeSound(3)=Sound'2009DoomMonstersSounds.Wraith.Wraith_chatter4'
     ScoringValue=35
     WallDodgeAnims(0)="DodgeL"
     WallDodgeAnims(1)="DodgeR"
     WallDodgeAnims(2)="DodgeL"
     WallDodgeAnims(3)="DodgeR"
     IdleHeavyAnim="Idle"
     IdleRifleAnim="Idle"
     FireHeavyRapidAnim="Run"
     FireHeavyBurstAnim="Run"
     FireRifleRapidAnim="Run"
     FireRifleBurstAnim="Run"
     RagdollOverride="D3Wraith"
     bCanJump=False
     MeleeRange=80.000000
     GroundSpeed=350.000000
     AirSpeed=100.000000
     HealthMax=280.000000
     HeadBone="head_FK"
     Health=280
     HeadRadius=12.000000
     MenuName="Wraith"
     ControllerClass=Class'ScrnDoom3KF.WraithController'
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
     DodgeAnims(0)="DodgeL"
     DodgeAnims(1)="DodgeR"
     AirStillAnim="Run"
     TakeoffStillAnim="Run"
     CrouchTurnRightAnim="Run"
     CrouchTurnLeftAnim="Run"
     IdleCrouchAnim="Idle"
     IdleSwimAnim="Idle"
     IdleWeaponAnim="Idle"
     IdleRestAnim="Idle"
     IdleChatAnim="Idle"
     Mesh=SkeletalMesh'2009DoomMonstersAnims.WraithMesh'
     Skins(0)=Combiner'2009DoomMonstersTex.Wraith.JWraithSkin'
     Skins(1)=Shader'2009DoomMonstersTex.Wraith.EyeShader'
     Skins(2)=Shader'2009DoomMonstersTex.Wraith.WraithWingShader'
     CollisionRadius=20.000000
     CollisionHeight=35.000000

     MotionDetectorThreat=0.50 //5.14

     ZappedDamageMod=1.5
}
