// Original for UT2004 by INI, edit for KF by Marco.
// further support by PooSH
class DoomMonster extends KFMonster
	abstract;

#exec obj load file="2009DoomMonstersSounds"
#exec obj load file="2009DoomMonstersTex"
#exec obj load file="2009DoomMonstersAnims"
#exec obj load file="2009DoomMonstersSM"

var DoomMonster MonsterMaster;
var array< class<DoomMonster> > ChildrenMonsters;
var byte ChildMonsterCounter;

var TriggerSpawnDemon SpawnFactory;

var(Anims) name DeathAnims[4],SightAnim;
var(Anims) array<name> HitAnimsX;
var(Anims) float MinHitAnimDelay;
var(Sounds) Sound MissSound[4],CollapseSound[2],MeleeAttackSounds[4],SightSound,DeResSound;
var(Sounds) array<Sound> RunStepSounds;
var(Burn) Material InvisMat,BurningMaterial;
var(Burn) class<DoomBurnTex> BurnClass;
var(Burn) class<MaterialSequence> FadeClass;
var(Burn) class<DoomDeResDustSmall> BurnDust;
var() float MeleeKnockBack,FootstepSndRadius;
var() class<DoomProjectile> RangedProjectile;
var() class<DoomProjectile> SecondaryProjectile;
var() class<DemonSpawnBase> DoomTeleportFXClass;
var() byte BurnedTextureNum[2];
var array<Material> PrecashedMaterials;
var array<StaticMesh> PrecashedStatics;

var(Anims) bool HasHitAnims;
var() bool bHasFireWeakness,BigMonster;
var bool Collapsing,bEndGameBoss;
var bool Burning;
var bool bHasRoamed;

var byte RagdollStateNum;
var DoomDeResDustSmall Sparks;
var Mesh SecondMesh;
var int AimError;
var float BurnAnimTime;
var int BurnSpeed;
var DoomBurnTex BurnFX;
var MaterialSequence FadeFX;
var Material FadingBurnMaterial;
var transient float nextHitAnimTime,nextChallengeVoice;

// (c) PooSH
var int BurnDuration; // tick count from ignition till the end of burning
var int BurnInCount; // tick count from ignition till reaching the maximum burn damage
//var int IgnitionTickCount; //how many tick zed needs to reach a full burn (when he starts to receive constant, average damage)
var int BurnedDamage; //how much zed has already received damage from fire

// Pipebomb attacking by PAT Replacement Bosses
// (c) PooSH
// Original Code was taken from Scary_ghost's SuperZombies mutator
var transient float NextPipeAttackTime; // when boss attack pipebomb last time
var float PipeAttackCooldown; // minimum time between pipebomb attacks. 0 - monster can't attack pipes.
var float PipeDetectRange; // distance in which boss can detect (and attack) pipebomb
var transient PipeBombProjectile LastShottedPipebomb; //store it to not shoot same pipe again
var bool bCanAttackPipebombs; // set it to true, if monster should attack pipebombs (and has a projectiles o explode them)
var array<localized string> strFUPiper;

var transient float NextProjTime; // time when monster can launch his next projectile

var BossExt PatExt; // PAT Replacement extension to spawn additional monsters in the final wave

var transient float NextChatTime; // avoid spamming players with messages
var array<localized string> strRetardedDemonsArray;

// v5.20
var bool bLastHeadshot; // was last damage received by a headshot?
var int MaxMeleeAttacks; // prevent melee-locking

// v8.11
var name HeadBone2;
var Vector HeadOffset, HeadOffset2;
// the animation frame to put on dedicated server for headshot detection.
// 0 - begining of the aniimation; 0.5 - middle, 1.0 - end
var float OnlineHeadAnimationPhase;

// v9.20
// Minimal headshot multiplier that can be applied on headshots. Used only if
// original multiplier > 1.0
var float MinHeadShotDamageMult;


simulated function PostNetBeginPlay()
{
	Super.PostNetBeginPlay();
	HealthMax = Max(HealthMax,Health); // Fix for commando healthbar with bosses.
}
simulated function RemoveFlamingEffects()
{
	local int i;

	if ( Level.NetMode == NM_DedicatedServer )
		return;

	for ( i = 0; i < Attached.length; i++ )
	{
		if ( xEmitter(Attached[i]) != none )
		{
			xEmitter(Attached[i]).mRegen = false;
			Attached[i].LifeSpan = 2;
		}
		else if ( Emitter(Attached[i]) != None && !Attached[i].IsA('DismembermentJet') && !Attached[i].IsA('DoomEmitter') )
		{
			Emitter(Attached[i]).Kill();
			Attached[i].LifeSpan = 2;
		}
	}
}

function PlayChallengeSound()
{
	if( nextChallengeVoice<Level.TimeSeconds )
	{
		PlaySound(ChallengeSound[Rand(4)],SLOT_Talk);
		nextChallengeVoice = Level.TimeSeconds+4.f+FRand()*6.f;
	}
}

function NotifyTeleport()
{
	local Doom3Controller D3C;
	local KFPawn P;
	local int c;

	// if monster see players, then rate teleportation spot, except when all monsters are spawned
	// already, i.e. players are probably moving to the trader
	D3C = Doom3Controller(Controller);
	if ( D3C != none && D3C.LastTeleportedTo != none && KFGameType(Level.Game).TotalMaxMonsters > 0) {
		foreach VisibleCollidingActors(class'KFMod.KFPawn', P, 1000) {
			c++;
		}
		if ( c > 0 )
			D3C.IncLastTeleportDestRaiting(0.05, true);
	}

	if( HasAnim('Teleport') ) {
		PrepareStillAttack(None);
		SetAnimAction('Teleport');
	}
}

simulated function PostNetReceive();

simulated function PreBeginPlay()
{
	// Doom monsters cannot be decapitated. Make head health the same as body
	HeadHealth = Health;
	PlayerNumHeadHealthScale = PlayerCountHealthScale;

	super.PreBeginPlay();
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if ( Role < ROLE_Authority ) {
		// spawn extended zed collision on client side for projector tracing (e.g., laser sights)
		if ( bUseExtendedCollision && MyExtCollision == none )
		{
			MyExtCollision = Spawn(class'ExtendedZCollision', self);
			MyExtCollision.SetCollisionSize(ColRadius, ColHeight);

			MyExtCollision.bHardAttach = true;
			MyExtCollision.SetLocation(Location + (ColOffset >> Rotation));
			MyExtCollision.SetPhysics(PHYS_None);
			MyExtCollision.SetBase(self);
			SavedExtCollision = MyExtCollision.bCollideActors;
		}
	}
}

function float DifficultyHeadHealthModifer()
{
	return DifficultyHealthModifer();  // scale head the same as body
}

function float NumPlayersHeadHealthModifer()
{
	return NumPlayersHealthModifer();  // scale head the same as body
}

function bool IsInMeleeRange( Actor A, optional float ExtendedRange )
{
	local vector D;

	if( A.IsA('KFDoorMover') )
		return true;
	D = A.Location-Location;
	if( Abs(D.Z)>(CollisionHeight+A.CollisionHeight+MeleeRange) )
		return false;
	D.Z = 0;
	return (VSize(D)<(CollisionRadius+A.CollisionRadius+(MeleeRange+ExtendedRange)));
}
function bool MeleeDamageTarget(int hitdamage, vector pushdir)
{
	local Actor A;

	if( Level.NetMode==NM_Client || Controller==None || Controller.Target==None )
		Return False;
	A = Controller.Target;
	if ( IsInMeleeRange(A,0.5f) )
	{
		A.TakeDamage(hitdamage,self,Normal(Location-A.Location)*A.CollisionRadius+A.Location,pushdir,CurrentDamType);
		Return True;
	}
	return false;
}

// While enemy is not in reach but still in sight.
function bool ShouldTryRanged( Actor A )
{
	return false;
}

function bool ShouldChargeAtPlayer()
{
	return true;
}

function PrepareStillAttack( Actor A )
{
	if( A!=None )
		Controller.Target = A;
	bShotAnim = true;
	Controller.bPreparingMove = true;
	Acceleration = vect(0,0,0);
}
function PrepareMovingAttack( Actor A, float MoveSpeed )
{
	Controller.Target = A;
	DesiredSpeed = Abs(MoveSpeed); // Slow down...
	Acceleration = Normal(A.Location-Location)*GroundSpeed;
	if( MoveSpeed<0 )
	{
		Controller.MoveTarget = None;
		Acceleration = -Acceleration;
	}
	else Controller.MoveTarget = A;
	bShotAnim = true;
}
simulated function name GetCurrentAnim()
{
	local name Anim;
	local float frame,rate;

	GetAnimParams(0, Anim,frame,rate);
	return Anim;
}
simulated function AnimEnd(int Channel)
{
	AnimAction = '';
	if ( bShotAnim && Channel==ExpectingChannel )
	{
		bShotAnim = false;
		if( Controller!=None )
			Controller.bPreparingMove = false;
		if( DesiredSpeed>0 )
			DesiredSpeed = MaxDesiredSpeed; // Reset movement speed.
	}
	if( !bPhysicsAnimUpdate && Channel==0 )
		bPhysicsAnimUpdate = Default.bPhysicsAnimUpdate;
	Super(xPawn).AnimEnd(Channel);
}

simulated function RemoveEffects();

simulated function Tick(float DeltaTime)
{
	if ( bResetAnimAct && ResetAnimActTime<Level.TimeSeconds )
	{
		AnimAction = '';
		bResetAnimAct = False;
	}

	if ( Level.NetMode!=NM_DedicatedServer ) {

		TickFX(DeltaTime);

		if ( bBurnified && !bBurnApplied )
		{
			if ( !bGibbed )
				StartBurnFX();
		}
		else if ( !bBurnified && bBurnApplied )
		{
			StopBurnFX();
		}
		if ( bAshen && Level.NetMode == NM_Client && !class'GameInfo'.static.UseLowGore() )
		{
			ZombieCrispUp();
			bAshen = False;
		}
	}
	if ( BileCount > 0 && NextBileTime<level.TimeSeconds )
	{
		--BileCount;
		NextBileTime+=BileFrequency;
		TakeBileDamage();
	}
}

function bool SayToPlayers(string msg, optional bool ForceSay)
{
	local Controller C;

	if ( !ForceSay && NextChatTime > Level.TimeSeconds )
		return false;

	ReplaceText(msg, "%n", MenuName);

	for (C = Level.ControllerList; C != None; C = C.NextController) {
		if (PlayerController(C) != None) {
			PlayerController(C).ClientMessage(msg);
		}
	}
	NextChatTime = Level.TimeSeconds + 15;

	return true;
}

// Allow monster to detonate visible pipeboms from range
function bool AttackPipebombs()
{
	local PipeBombProjectile CheckProjectile, Pipe2Attack;

	if ( bShotAnim || RangedProjectile == none || NextPipeAttackTime > Level.TimeSeconds || NextProjTime > Level.TimeSeconds)
		return false;

	// look for pipes in range to attack
	foreach VisibleCollidingActors( class 'PipeBombProjectile', CheckProjectile, PipeDetectRange, Location ) {
		//Log("Found Pipebomb @ distance " $ VSize(CheckProjectile.Location - Location) );
		//Don't shoot same pipe again or if monster is inside damage radius
		if ( CheckProjectile != LastShottedPipebomb
				&& VSizeSquared(CheckProjectile.Location - Location) > CheckProjectile.DamageRadius**2 ) {
			Pipe2Attack = CheckProjectile;
			break;
		}
	}

	if ( Pipe2Attack != none ) {
		LastShottedPipebomb = Pipe2Attack;

		SayToPlayers(strFUPiper[Rand(strRetardedDemonsArray.Length)]);

		Controller.Target= Pipe2Attack;
		Controller.Focus= Pipe2Attack;
		FireProjectile();

		NextPipeAttackTime = Level.TimeSeconds + PipeAttackCooldown;
		NextProjTime = NextPipeAttackTime;
		return true;
	}
	return false;
}

function bool FlipOver()
{
	return false;
}
simulated function FreeFXObjects()
{
	if(FadeFX != None)
	{
		Level.ObjectPool.FreeObject(FadeFX);
		FadeFX = None;
	}
	if(BurnFX != None)
	{
		BurnFX.AlphaRef = 0;
		Level.ObjectPool.FreeObject(BurnFX);
		BurnFX = None;
	}
}

function MeleeAttack()
{
	if( Controller!=None && Controller.Target!=None ) {
		if (MeleeDamageTarget(MeleeDamage, (MeleeKnockBack * Normal(Controller.Target.Location - Location))) )
			PlaySound(MeleeAttackSounds[Rand(ArrayCount(MeleeAttackSounds))], SLOT_Interact);
		else
			PlaySound(MissSound[Rand(ArrayCount(MissSound))], SLOT_Interact);
	}
}

function PlayMoverHitSound()
{
	PlaySound(HitSound[0], SLOT_Interact);
}

function bool SameSpeciesAs(Pawn P)
{
	return (DoomMonster(P)!=None);
}

simulated function PlayDirectionalDeath(Vector HitLoc)
{
	if( Level.NetMode==NM_DedicatedServer )
	{
		SetCollision(false, false, false);
		return;
	}
	InitFX();
	SetCollision(false, false, false);
	PlayDeathAnim();
}
simulated function InitFX()
{
	BurnFX = DoomBurnTex(Level.ObjectPool.AllocateObject(BurnClass));
	FadeFX = MaterialSequence(Level.ObjectPool.AllocateObject(FadeClass));
	if( FadeFX!=None && BurnFX!=None)
	{
		FadeFX.SequenceItems[0].Material = BurningMaterial;
		SetOverlayMaterial(None, 0.0f, true);
		Projectors.Remove(0, Projectors.Length);
		bAcceptsProjectors = false;
		if(PlayerShadow != None)
			PlayerShadow.bShadowActive = false;
		RemoveFlamingEffects();
	}
}
simulated function PlayDeathAnim()
{
	PlayAnim(DeathAnims[Rand(4)],BurnAnimTime, 0.1);
}

function PlayDirectionalHit(Vector HitLoc)
{
	if( HasHitAnims && !bShotAnim && nextHitAnimTime<Level.TimeSeconds && HitAnimsX.Length>0 )
	{
		nextHitAnimTime = Level.TimeSeconds+MinHitAnimDelay+FRand()*MinHitAnimDelay;
		PrepareStillAttack(None);
		SetAnimAction(HitAnimsX[Rand(HitAnimsX.Length)]);
	}
}

function Sound GetSound(xPawnSoundGroup.ESoundType soundType)
{
	return None;
}

function PlayTakeHit(vector HitLocation, int Damage, class<DamageType> DamageType)
{
	if ( Damage > 35 && BigMonster)
		Super.PlayTakeHit(HitLocation,Damage,DamageType);
	else if(Damage > 20)
		Super.PlayTakeHit(HitLocation,Damage,DamageType);
}

simulated function RunStep()
{
	if( RunStepSounds.Length==0 )
		PlaySound(Footstep[Rand(ArrayCount(Footstep))], SLOT_Interact, 1,,FootstepSndRadius);
	else PlaySound(RunStepSounds[Rand(RunStepSounds.Length)], SLOT_Interact, 1,,FootstepSndRadius);
}

function AddVelocity( vector NewVelocity)
{
	if((Velocity.Z > 350) && (NewVelocity.Z > 1000))
		NewVelocity.Z *= 0.5;
	Velocity += NewVelocity;
}

simulated function SpawnSparksFX()
{
	if( Level.NetMode!=NM_DedicatedServer )
		Sparks = Spawn(BurnDust,Self);
}

simulated function Destroyed()
{
	if( SpawnFactory!=None )
	{
		SpawnFactory.NotifyMobDied();
		SpawnFactory = None;
	}
	if(Sparks != None)
		Sparks.KillFX();

	FreeFXObjects();
	RemoveEffects();
	Super.Destroyed();
}


function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	local Doom3Controller D3C;

	if( SpawnFactory!=None )
	{
		SpawnFactory.NotifyMobDied();
		SpawnFactory = None;
	}

	D3C = Doom3Controller(Controller);
	if ( D3C != none ) {
		if ( D3C.bRateTeleportDest && Level.TimeSeconds <= D3C.LastTeleportTime + 5 ) {
			D3C.IncLastTeleportDestRaiting(-0.2); // killed soon after teleportation
		}
	}

	if( MonsterMaster!=None ) {
		MonsterMaster.ChildMonsterCounter--;
		MonsterMaster = None;
	}
	if ( ChildMonsterCounter > 0 )
		KillChildren();

	Super.Died(Killer,damageType,HitLocation);

	if( bEndGameBoss )
	{
		KFGameType(Level.Game).DoBossDeath();
	}
}

simulated function Collapse()
{
	Collapsing = true;
	PlaySound(CollapseSound[Rand(2)], SLOT_Interact);
}

simulated function PlayCollapseSound()
{
	PlaySound(CollapseSound[Rand(2)], SLOT_Talk);
}

simulated function StartDeRes()
{
	if( Level.NetMode == NM_DedicatedServer )
		return;
	AmbientSound = None;
	bDeRes = true;
}

// damage scaled by DifficultyDamageModifer() now
function Projectile FireProj( vector Position )
{
	local Projectile proj;

	if ( !SavedFireProperties.bInitialized )
	{
		SavedFireProperties.AmmoClass = Class'SkaarjAmmo';
		SavedFireProperties.ProjectileClass = RangedProjectile;
		SavedFireProperties.WarnTargetPct = 0.5f;
		SavedFireProperties.MaxRange = RangedProjectile.Default.Speed*RangedProjectile.Default.LifeSpan;
		SavedFireProperties.bTossed = (RangedProjectile.Default.Physics==PHYS_Falling);
		SavedFireProperties.bTrySplash = (RangedProjectile.Default.DamageRadius>20.f);
		SavedFireProperties.bLeadTarget = true;
		SavedFireProperties.bInstantHit = false;
		SavedFireProperties.bInitialized = true;
	}
	proj = Spawn(RangedProjectile,,,Position,Controller.AdjustAim(SavedFireProperties,Position,500.f));
	if ( proj != none ) {
		proj.Damage *= DifficultyDamageModifer();
	}
	return proj;
}
function DoorAttack(Actor A)
{
	RangedAttack(A);
}
simulated function PlayDyingAnimation(class<DamageType> DamageType, vector HitLoc)
{
	local vector shotDir, hitLocRel, deathAngVel, shotStrength;
	local float maxDim;
	local KarmaParamsSkel skelParams;
	local bool PlayersRagdoll;
	local PlayerController pc;

	if( MyExtCollision!=None )
		MyExtCollision.Destroy();

	RemoveEffects();
	if ( Level.NetMode!=NM_DedicatedServer && Class'D3Karma'.Static.UseRagdoll(Level) && Len(RagdollOverride)>0 )
	{
		// Is this the local player's ragdoll?
		if(OldController != None)
			pc = PlayerController(OldController);
		if( pc != None && pc.ViewTarget == self )
			PlayersRagdoll = true;

		// In low physics detail, if we were not just controlling this pawn,
		// and it has not been rendered in 3 seconds, just destroy it.

		if( Level.NetMode == NM_ListenServer )
		{
			// For a listen server, use LastSeenOrRelevantTime instead of render time so
			// monsters don't disappear for other players that the host can't see - Ramm
			if( Level.PhysicsDetailLevel != PDL_High && !PlayersRagdoll && ((Level.TimeSeconds-LastSeenOrRelevantTime)>3 || bGibbed) )
			{
				Destroy();
				return;
			}
		}
		else if( Level.PhysicsDetailLevel!=PDL_High && !PlayersRagdoll && ((Level.TimeSeconds-LastRenderTime)>3 || bGibbed) )
		{
			Destroy();
			return;
		}

		KMakeRagdollAvailable();
		if( KIsRagdollAvailable() )
		{
			skelParams = KarmaParamsSkel(KParams);
			skelParams.KSkeleton = RagdollOverride;

			// Stop animation playing.
			StopAnimating(true);

			// StopAnimating() resets the neck bone rotation, we have to set it again
			// if the zed was decapitated the cute way
			if ( class'GameInfo'.static.UseLowGore() && NeckRot != rot(0,0,0) )
				SetBoneRotation('neck', NeckRot);

			if( DamageType != none )
			{
				if ( DamageType.default.bLeaveBodyEffect )
					TearOffMomentum = vect(0,0,0);

				if ( DamageType.default.bKUseOwnDeathVel )
				{
					RagDeathVel = DamageType.default.KDeathVel;
					RagDeathUpKick = DamageType.default.KDeathUpKick;
					RagShootStrength = DamageType.default.KDamageImpulse;
				}
			}

			// Set the dude moving in direction he was shot in general
			shotDir = Normal(GetTearOffMomemtum());
			shotStrength = RagDeathVel * shotDir;

			// Calculate angular velocity to impart, based on shot location.
			hitLocRel = TakeHitLocation - Location;

			if( DamageType.default.bLocationalHit )
			{
				hitLocRel.X *= RagSpinScale;
				hitLocRel.Y *= RagSpinScale;

				if( Abs(hitLocRel.X)  > RagMaxSpinAmount )
				{
					if( hitLocRel.X < 0 )
					{
						hitLocRel.X = FMax((hitLocRel.X * RagSpinScale), (RagMaxSpinAmount * -1));
					}
					else
					{
						hitLocRel.X = FMin((hitLocRel.X * RagSpinScale), RagMaxSpinAmount);
					}
				}

				if( Abs(hitLocRel.Y)  > RagMaxSpinAmount )
				{
					if( hitLocRel.Y < 0 )
					{
						hitLocRel.Y = FMax((hitLocRel.Y * RagSpinScale), (RagMaxSpinAmount * -1));
					}
					else
					{
						hitLocRel.Y = FMin((hitLocRel.Y * RagSpinScale), RagMaxSpinAmount);
					}
				}

			}
			else
			{
				// We scale the hit location out sideways a bit, to get more spin around Z.
				hitLocRel.X *= RagSpinScale;
				hitLocRel.Y *= RagSpinScale;
			}

			// If the tear off momentum was very small for some reason, make up some angular velocity for the pawn
			if( VSize(GetTearOffMomemtum()) < 0.01 )
			{
				//Log("TearOffMomentum magnitude of Zero");
				deathAngVel = VRand() * 18000.0;
			}
			else
			{
				deathAngVel = RagInvInertia * (hitLocRel cross shotStrength);
			}

			// Set initial angular and linear velocity for ragdoll.
			// Scale horizontal velocity for characters - they run really fast!
			if ( DamageType.Default.bRubbery )
				skelParams.KStartLinVel = vect(0,0,0);
			if ( Damagetype.default.bKUseTearOffMomentum )
				skelParams.KStartLinVel = GetTearOffMomemtum() + Velocity;
			else
			{
				skelParams.KStartLinVel.X = 0.6 * Velocity.X;
				skelParams.KStartLinVel.Y = 0.6 * Velocity.Y;
				skelParams.KStartLinVel.Z = 1.0 * Velocity.Z;
				skelParams.KStartLinVel += shotStrength;
			}
			// If not moving downwards - give extra upward kick
			if( !DamageType.default.bLeaveBodyEffect && !DamageType.Default.bRubbery && (Velocity.Z > -10) )
				skelParams.KStartLinVel.Z += RagDeathUpKick;

			if ( DamageType.Default.bRubbery )
			{
				Velocity = vect(0,0,0);
				skelParams.KStartAngVel = vect(0,0,0);
			}
			else
			{
				skelParams.KStartAngVel = deathAngVel;

				// Set up deferred shot-bone impulse
				maxDim = Max(CollisionRadius, CollisionHeight);

				skelParams.KShotStart = TakeHitLocation - (1 * shotDir);
				skelParams.KShotEnd = TakeHitLocation + (2*maxDim*shotDir);
				skelParams.KShotStrength = RagShootStrength;
			}

			//log("RagDeathVel = "$RagDeathVel$" KShotStrength = "$skelParams.KShotStrength$" RagDeathUpKick = "$RagDeathUpKick);

			// If this damage type causes convulsions, turn them on here.
			if(DamageType != none && DamageType.default.bCauseConvulsions)
			{
				RagConvulseMaterial=DamageType.default.DamageOverlayMaterial;
				skelParams.bKDoConvulsions = true;
			}

			// Turn on Karma collision for ragdoll.
			KSetBlockKarma(true);

			// Set physics mode to ragdoll.
			// This doesn't actaully start it straight away, it's deferred to the first tick.
			SetPhysics(PHYS_KarmaRagdoll);

			// If viewing this ragdoll, set the flag to indicate that it is 'important'
			if( PlayersRagdoll )
				skelParams.bKImportantRagdoll = true;

			skelParams.bRubbery = DamageType.Default.bRubbery;
			bRubbery = DamageType.Default.bRubbery;
			skelParams.KActorGravScale = RagGravScale;
			return;
		}
	}

	// non-ragdoll death fallback
	Velocity += GetTearOffMomemtum();
	BaseEyeHeight = Default.BaseEyeHeight;
	SetTwistLook(0, 0);
	SetInvisibility(0.0);
	PlayDirectionalDeath(HitLoc);
	SetPhysics(PHYS_Falling);
}
function RoamAtPlayer()
{
	bHasRoamed = true;
	PlaySound(SightSound,SLOT_Talk,2);
	if( SightAnim!='' )
	{
		Controller.bPreparingMove = true;
		SetAnimAction(SightAnim);
		Acceleration = vect(0,0,0);
		bShotAnim = true;
	}
}
function RemoveHead();

function bool SetBossLaught()
{
	local Controller C;

	if( !bBoss )
		return false;
	GoToState('');
	RoamAtPlayer();
	For( C=Level.ControllerList; C!=None; C=C.NextController )
	{
		if( PlayerController(C)!=None )
		{
			PlayerController(C).SetViewTarget(Self);
			PlayerController(C).ClientSetViewTarget(Self);
			PlayerController(C).ClientSetBehindView(True);
		}
	}
	Return True;
}

//Allow server admin to configure different player scaling between in-game bosses and Pat replacement
function bool MakeGrandEntry()
{
	Health *= Class'Doom3Mutator'.Default.EndGameBossHealthMult;
	HealthMax = Health;
	HeadHealth = HealthMax;
	ZapThreshold=10;
	RoamAtPlayer();
	bEndGameBoss = true;
	PatExt = spawn(class'BossExt',self);
	if ( PatExt != none )
		PatExt.Boss = self;
		PatExt.DifficultyHealthModifer = DifficultyHealthModifer();

	return true;
}

simulated function MakeBurnAway()
{
	if( Level.NetMode==NM_DedicatedServer )
		return;
	Enable('Tick');
	if( FadeFX!=None )
		FadeFX.Reset();
}
simulated function BurnAway();
simulated function FadeSkins();

simulated event SetAnimAction(name NewAction)
{
	if( NewAction=='' )
		Return;
	ExpectingChannel = DoAnimAction(NewAction);

	if( AnimNeedsWait(NewAction) )
	{
		bPhysicsAnimUpdate = false; // Prevent movement animations to mess up me.
		bWaitForAnim = true;
	}
	else bWaitForAnim = false;

	if( Level.NetMode!=NM_Client )
	{
		AnimAction = NewAction;
		bResetAnimAct = True;
		ResetAnimActTime = Level.TimeSeconds+0.3;
	}
}
simulated function int DoAnimAction( name AnimName )
{
	PlayAnim(AnimName,,0.1);
	return 0;
}
function ZombieMoan();

// v9.64 - removed crispy effects as they look dumb
simulated function ZombieCrispUp()
{
	// local byte i;
	//
	// bAshen = true;
	// bCrispified = true;
	//
	// SetBurningBehavior();
	//
	// if ( Level.NetMode == NM_DedicatedServer || class'GameInfo'.static.UseLowGore() )
	// 	Return;
	//
	// for( i=0; i<ArrayCount(BurnedTextureNum); ++i )
	// 	if( BurnedTextureNum[i]<255 )
	// 		Skins[BurnedTextureNum[i]] = Texture'PatchTex.Common.ZedBurnSkin';
}

// Remove Burning walk animations, cuz Doom Monsters zeds don't have it
// (c) PooSH
simulated function SetBurningBehavior()
{
	if( Role == Role_Authority )
	{
		Intelligence = BRAINS_Retarded; // burning dumbasses!

		GroundSpeed = OriginalGroundSpeed * 0.8;
		AirSpeed *= 0.8;
		WaterSpeed *= 0.8;

		// Make them less accurate while they are burning
		if( Controller != none )
		{
		   MonsterController(Controller).Accuracy = -5;  // More chance of missing. (he's burning now, after all) :-D
		}
	}
/*
	// Set the forward movement anim to a random burning anim
	MovementAnims[0] = BurningWalkFAnims[Rand(3)];
	WalkAnims[0]     = BurningWalkFAnims[Rand(3)];

	// Set the rest of the movement anims to the headless anim (not sure if these ever even get played) - Ramm
	MovementAnims[1] = BurningWalkAnims[0];
	WalkAnims[1]     = BurningWalkAnims[0];
	MovementAnims[2] = BurningWalkAnims[1];
	WalkAnims[2]     = BurningWalkAnims[1];
	MovementAnims[3] = BurningWalkAnims[2];
	WalkAnims[3]     = BurningWalkAnims[2];
	*/
}

//return avarage burn damage per tick
// (c) PooSH
function int GetAvgBurnDamage(int InitialDamage)
{
	local float AvgTickInc;


	// Fire damage is increasing by (3-4 points per tick) * 1.5. 10 ticks total. Average = sum / 2 = 18.

	//try constant damage from the begining
	//AvgTickInc = 18;

	// Ignition takes 2 ticks, after that average, constant damage is applied till the end of burning process
	// Total DoT is weaker comparing to original game due to 2 less ticks and burn in damage decrement
	if ( BurnDown >= BurnDuration )
		AvgTickInc = 6;
	else if ( BurnDown > (BurnDuration - BurnInCount) )
		AvgTickInc = 12;
	else
		AvgTickInc = 18;

	// don't apply x1.5 multiplier here, because it will be applied in KFMonster.TakeDamage()
	// if ( !ClassIsChildOf(FireDamageClass, class'DamTypeMAC10MPInc') )
		// AvgTickInc *= 1.5; // all fire damage except MAC10 deals x1.5 damage

	return InitialDamage + AvgTickInc;
}

//overrided to implement different burn damage
simulated function Timer()
{
	bSTUNNED = false;

	if (BurnDown > 0) {
		//set damage to -1 to indicate zed is continuing previous burning, not receiving a new fire damage
		TakeFireDamage(-1, BurnInstigator);
		SetTimer(1.0,false);
	}
	else {
		UnSetBurningBehavior();

		RemoveFlamingEffects();
		StopBurnFX();
		SetTimer(0, false);
	}
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> DamType, optional int HitIndex )
{
	local bool bIncDamage, bIsFireDamage;
	local KFPlayerReplicationInfo KFPRI;
	local float HeadShotScale;
	local string msg;
	local class<KFWeaponDamageType> KFDamType;

	LastDamagedBy = instigatedBy;
	LastDamagedByType = DamType;
	HitMomentum = VSize(momentum);
	LastHitLocation = hitlocation;
	LastMomentum = momentum;
	bLastHeadshot = false;

	if( bZapped )
		Damage *= ZappedDamageMod;

	KFDamType = class<KFWeaponDamageType>(DamType);
	if ( KFDamType != none )
	{
		bIncDamage = class<DamTypeTrenchgun>(DamType) != none ||
					 class<DamTypeFlareRevolver>(DamType) != none ||
					 class<DamTypeMAC10MPInc>(DamType) != none;
		bIsFireDamage = KFDamType.default.bDealBurningDamage;
		// Zeds and fire dont mix.
		if ( bHasFireWeakness && bIsFireDamage )
		{
			if ( Damage != -1 && class<DamTypeMAC10MPInc>(DamType) == none )
				Damage *= 1.5;

			if( BurnDown<=0 ) {
				LastBurnDamage = Damage;
				//need to deal fire damage at least 3% of zed health  or 75 to set zed on fire
				if( Damage + BurnedDamage >= min(75, HealthMax * 0.03) ) {
					if ( bIncDamage )
						FireDamageClass = DamType;
					else
						FireDamageClass = class'DamTypeFlamethrower';

					bBurnified = true;
					BurnDown = BurnDuration;
					GroundSpeed *= 0.8;
					BurnInstigator = instigatedBy;
					SetTimer(1.0, false); //set it to execute only once. Reset in Timer(), if ticks are remaining
				}
			}
			else if ( Damage == -1) { //Fire damage received over time
				Damage = GetAvgBurnDamage(LastBurnDamage);
			}
			else if ( Damage >= LastBurnDamage) { //lower fire damage can't increase burn ticks, e.g. shooting with MAC10 after Husk gun
				//received extra burn damage while still burning
				BurnDown = max(BurnDown, BurnDuration - BurnInCount); //increase burn time to the maximum again (excluding burn-in ticks)
				LastBurnDamage = Damage;
				if ( bIncDamage )
					FireDamageClass = class'DamTypeMAC10MPInc';
				else
					FireDamageClass = class'DamTypeFlamethrower';
				BurnInstigator = instigatedBy;
			}
		}

		if ( KFDamType.default.bCheckForHeadShots ) {
			if ( HitIndex == 101 )
				bLastHeadshot = true;
			else {
				HeadShotScale = 1.0;

				// Do larger headshot checks if it is a melee attach
				if( class<DamTypeMelee>(DamType) != none )
					HeadShotScale *= 1.25;
				bLastHeadshot = IsHeadShot(hitlocation, normal(momentum), HeadShotScale);
			}
		}

		if ( KFPawn(instigatedBy) != none && instigatedBy.PlayerReplicationInfo != none )
			KFPRI = KFPlayerReplicationInfo(instigatedBy.PlayerReplicationInfo);

		if ( KFPRI!= none  )
		{
			if ( KFPRI.ClientVeteranSkill != none )
				Damage = KFPRI.ClientVeteranSkill.Static.AddDamage(KFPRI, self, KFPawn(instigatedBy), Damage, DamType);
		}

		if ( bLastHeadshot )
		{
			HeadShotScale = KFDamType.default.HeadShotDamageMult;
			//made compatible with 1035+ patch -- PooSH
			if ( class<DamTypeMelee>(DamType) == none && KFPRI != none && KFPRI.ClientVeteranSkill != none )
				HeadShotScale *= KFPRI.ClientVeteranSkill.Static.GetHeadShotDamMulti(KFPRI, KFPawn(instigatedBy), DamType);

			//add 25% resistance to crossbow/m99 shots for big Doom monsters on sui/hoe -- PooSH
			if (HealthMax >= 1000 && Level.Game.GameDifficulty >= 5.0
					&& (class<DamTypeCrossbow>(DamType) != none || class<DamTypeM99SniperRifle>(DamType) != none) ) {
				HeadShotScale *= 0.75;
			}
			else if ( KFDamType.default.HeadShotDamageMult > 1.0001 )
				HeadShotScale = fmax(HeadShotScale, MinHeadShotDamageMult);
			Damage *= HeadShotScale;

			LastDamageAmount = Damage;

			PlaySound(sound'KF_EnemyGlobalSndTwo.Impact_Skull', SLOT_None,2.0,true,500);

			HeadHealth -= LastDamageAmount;
		}

		if( (Health-Damage) > 0 && KFDamType.default.bIsExplosive )
			Momentum = vect(0,0,0);
		else if(class<DamTypeVomit>(DamType)!=none) // Same rules apply to zombies as players.
		{
			BileCount=7;
			BileInstigator = instigatedBy;
			LastBileDamagedByType=class<DamTypeVomit>(DamType); // support of BlowerThrower
			if(NextBileTime< Level.TimeSeconds )
				NextBileTime = Level.TimeSeconds+BileFrequency;
		}

		//count total damage received by fire - PooSH
		if (bIsFireDamage)
			BurnedDamage += Damage;
	} // end of if (KFDamType != none)
	else {
		// mark spot as bad, if monster took environmental damage
		if ( Doom3Controller(Controller) != none && Level.TimeSeconds < Doom3Controller(Controller).LastTeleportTime + 10 )
			Doom3Controller(Controller).IncLastTeleportDestRaiting(-0.5);
	}

	Super(Monster).TakeDamage(Damage, instigatedBy, hitLocation, momentum, DamType, HitIndex);

	// Beta8 - FIXED HUGE BUG
	// Players didn't get any money for killing doom monsters (earned only team score)
	// block below copy-pasted from KFMonster
	if ( DamType != none && LastDamagedBy != none && LastDamagedBy.IsPlayerPawn() && LastDamagedBy.Controller != none )
	{
		if ( KFMonsterController(Controller) != none )
		{
			KFMonsterController(Controller).AddKillAssistant(LastDamagedBy.Controller, Damage);
		}
	}

	if( bLastHeadshot && Health<=0 )
	{
		KFGameType(Level.Game).DramaticEvent(0.03);

		// Award headshot here.
		if( KFDamType!=None && instigatedBy!=None && KFPlayerController(instigatedBy.Controller)!=None )
		{
			bLaserSightedEBRM14Headshotted = M14EBRBattleRifle(instigatedBy.Weapon) != none && M14EBRBattleRifle(instigatedBy.Weapon).bLaserActive;
			KFDamType.Static.ScoredHeadshot(KFSteamStatsAndAchievements(PlayerController(instigatedBy.Controller).SteamStatsAndAchievements), self.class, bLaserSightedEBRM14Headshotted);
		}
	}

	if ( bEndGameBoss ) {

		// Boss whining about retarded demons :)
		if (instigatedBy != self && DoomMonster(instigatedBy) != none && Level.TimeSeconds > NextChatTime ) {
			msg = strRetardedDemonsArray[Rand(strRetardedDemonsArray.Length)];
			ReplaceText(msg, "%a", DoomMonster(instigatedBy).MenuName);
			SayToPlayers(msg);
		}
		else if ( PatExt != none ) {
			PatExt.TookDamage(Damage, instigatedBy, DamType);
		}
	}
}

function bool IsHeadShot(vector HitLoc, vector ray, float AdditionalScale)
{
	local coords C;
	local vector HeadLoc;
	local int look;
	local bool bWasAnimating, bResult;

	if (HeadBone == '')
		return False;

	// If we are a dedicated server estimate what animation is most likely playing on the client
	if( Level.NetMode == NM_DedicatedServer && !bShotAnim ) {
		if ( Physics == PHYS_Falling || Physics == PHYS_Flying )
			PlayAnim(AirAnims[0], 1.0, 0.0);
		else if( Physics == PHYS_Walking ) {
			if( !IsAnimating(0) && !IsAnimating(1) ) {
				if (bIsCrouched)
					PlayAnim(IdleCrouchAnim, 1.0, 0.0);
				else if( VSizeSquared(Acceleration)<150.f )
					PlayAnim(IdleRestAnim, 1.0, 0.0);
				else
					PlayAnim(MovementAnims[0], 1.0, 0.0);
			}
			else
				bWasAnimating = true;

			if ( bDoTorsoTwist ) {
				SmoothViewYaw = Rotation.Yaw;
				SmoothViewPitch = ViewPitch;

				look = (256 * ViewPitch) & 65535;
				if (look > 32768)
					look -= 65536;
				SetTwistLook(0, look);
			}
		}
		else if( Physics == PHYS_Swimming && !bShotAnim ) {
			PlayAnim(SwimAnims[0], 1.0, 0.0);
		}
		if( !bWasAnimating ) {
			SetAnimFrame(OnlineHeadAnimationPhase);
		}
		AdditionalScale *= OnlineHeadshotScale;
	}
	C = GetBoneCoords(HeadBone);
	HeadLoc = C.Origin + (HeadHeight * HeadScale * C.XAxis)
		+ (HeadOffset >> Rotation);
	bResult = class'ScrnF'.static.TestHitboxSphere(HitLoc, ray, HeadLoc,
			HeadRadius * HeadScale * AdditionalScale);

	if ( !bResult && HeadBone2 != '' ) {
		// second head
		C = GetBoneCoords(HeadBone2);
		HeadLoc = C.Origin + (HeadHeight * HeadScale * C.XAxis)
			+ (HeadOffset2 >> Rotation);
		bResult = class'ScrnF'.static.TestHitboxSphere(HitLoc, ray, HeadLoc,
				HeadRadius * HeadScale * AdditionalScale);
	}

	return bResult;
}

function DoomMonster SpawnChild(class<DoomMonster> SpawnClass, vector SpawnLoc, optional bool bNoTele)
{
	local DoomMonster child;

	child = spawn(SpawnClass,,,SpawnLoc);
	if ( child != none ) {
		ChildMonsterCounter++;
		child.MonsterMaster = self;
		if ( !bNoTele ) {
			child.NotifyTeleport();
		}
	}
	return child;
}

function KillChildren()
{
	local array<DoomMonster> Children;
	local DoomMonster DM;
	local int i;

	foreach DynamicActors(class'ScrnDoom3KF.DoomMonster', DM) {
		if ( DM.Health > 0 && DM.MonsterMaster == self )
			Children[Children.Length] = DM;
	}
	for ( i=0; i<Children.Length; ++i )
		Children[i].KilledBy(self);
}

State ZombieDying
{
ignores PostNetReceive;

	simulated function BeginState()
	{
		if ( bTearOff && ((Level.NetMode == NM_DedicatedServer) || class'GameInfo'.static.UseLowGore()) )
			LifeSpan = 1.0;
		else SetTimer(2.0, false);

		if( Physics!=PHYS_KarmaRagdoll )
			SetPhysics(PHYS_Falling);
		if ( Controller != None )
			Controller.Destroy();

		// disable further monster spawning when PAT replacement dies  -- PooSH
		if ( PatExt != none ) {
			PatExt.SetTimer(0, false);
			PatExt.Destroy();
		}
	}
	function Landed(vector HitNormal)
	{
		if ( !IsAnimating(0) )
			LandThump();
	}
	simulated function Timer()
	{
		if ( (Level.TimeSeconds-LastRenderTime)>3.f )
			Destroy();
		else
		{
			SetTimer(1.0, false);
			if( Physics==PHYS_KarmaRagdoll )
			{
				if( RagdollStateNum==0 )
				{
					InitFX();
					++RagdollStateNum;
					FadeSkins();
				}
				else if( RagdollStateNum==1 )
				{
					++RagdollStateNum;
					BurnAway();
					bUnlit = true;
					SpawnSparksFX();
				}
			}
		}
	}
	simulated function Tick( float deltatime )
	{
		if( Burning && BurnFX!=None )
		{
			if( !bUnlit )
			{
				bUnlit = true;
				SpawnSparksFX();
			}
			if( BurnFX.AlphaRef<255 )
				BurnFX.AlphaRef = Min(BurnFX.AlphaRef+BurnSpeed,255);
			else
			{
				bHidden = true;
				Disable('Tick');
				LifeSpan = 0.1f;
			}
		}
	}
	simulated function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex )
	{
		local Vector HitNormal, shotDir;
		local Vector PushLinVel, PushAngVel;
		local Name HitBone;
		local float HitBoneDist;
		local vector HitRay;

		if ( bFrozenBody || bRubbery || Physics!=PHYS_KarmaRagdoll || Burning )
			return;

		// Throw the body if its a rocket explosion or shock combo
		if( damageType.Default.bThrowRagdoll )
		{
			shotDir = Normal(Momentum);
			PushLinVel = (RagDeathVel * shotDir) +  vect(0, 0, 250);
			PushAngVel = Normal(shotDir Cross vect(0, 0, 1)) * -18000;
			KSetSkelVel( PushLinVel, PushAngVel );
		}
		else if( damageType.Default.bRagdollBullet )
		{
			if ( Momentum == vect(0,0,0) )
				Momentum = HitLocation - InstigatedBy.Location;
			if ( FRand() < 0.65 )
			{
				if ( Velocity.Z <= 0 )
					PushLinVel = vect(0,0,40);
				PushAngVel = Normal(Normal(Momentum) Cross vect(0, 0, 1)) * -8000 ;
				PushAngVel.X *= 0.5;
				PushAngVel.Y *= 0.5;
				PushAngVel.Z *= 4;
				KSetSkelVel( PushLinVel, PushAngVel );
			}
			PushLinVel = RagShootStrength*Normal(Momentum);
			KAddImpulse(PushLinVel, HitLocation);
			if ( (LifeSpan > 0) && (LifeSpan < DeResTime + 2) )
				LifeSpan += 0.2;
		}
		else
		{
			PushLinVel = RagShootStrength*Normal(Momentum);
			KAddImpulse(PushLinVel, HitLocation);
		}

			HitRay = vect(0,0,0);
			if( InstigatedBy != none )
				HitRay = Normal(HitLocation-(InstigatedBy.Location+(vect(0,0,1)*InstigatedBy.EyeHeight)));

		CalcHitLoc( HitLocation, HitRay, HitBone, HitBoneDist );

		if( InstigatedBy != None )
			HitNormal = Normal( Normal(InstigatedBy.Location-HitLocation) + VRand() * 0.2 + vect(0,0,2.8) );
		else
			HitNormal = Normal( Vect(0,0,1) + VRand() * 0.2 + vect(0,0,2.8) );

			// Actually do blood on a client
			PlayHit(Damage, InstigatedBy, hitLocation, damageType, Momentum);
		DoDamageFX( HitBone, Damage, DamageType, Rotator(HitNormal) );
	}
}

function float GetExposureTo(vector TestLocation)
{
	return 1.0;
}

static function PreCacheMaterialSequence(LevelInfo Level, class<MaterialSequence> MatSeq)
{
	local int i;

	if ( MatSeq == none )
		return;

	for ( i = 0; i < MatSeq.default.SequenceItems.length; ++i ) {
		Level.AddPrecacheMaterial(MatSeq.default.SequenceItems[i].Material);
	}
}

static function PreCacheMaterials(LevelInfo Level)
{
	local int i;

	for ( i = 0; i < default.Skins.Length; ++i ) {
		Level.AddPrecacheMaterial(default.Skins[i]);
	}
	Level.AddPrecacheMaterial(default.InvisMat);
	Level.AddPrecacheMaterial(default.BurningMaterial);
	if ( default.BurnClass != none ) {
		Level.AddPrecacheMaterial(default.BurnClass.default.Material);
	}
	PreCacheMaterialSequence(Level, default.FadeClass);
	if ( default.BurnDust != none ) {
		default.BurnDust.static.PreCacheMaterials(Level);
	}
	Level.AddPrecacheMaterial(default.BurnFX);
	Level.AddPrecacheMaterial(default.FadeFX);
	Level.AddPrecacheMaterial(default.FadingBurnMaterial);

	if ( default.RangedProjectile != none ) {
		default.RangedProjectile.static.PreCacheMaterials(Level);
	}
	if ( default.SecondaryProjectile != none ) {
		default.SecondaryProjectile.static.PreCacheMaterials(Level);
	}

	if ( default.DoomTeleportFXClass != none ) {
		default.DoomTeleportFXClass.static.PreCacheMaterials(Level);
	}

	for ( i = 0; i < default.PrecashedMaterials.Length; ++i ) {
		Level.AddPrecacheMaterial(default.PrecashedMaterials[i]);
	}
	for ( i = 0; i < default.PrecashedStatics.Length; ++i ) {
		Level.AddPrecacheStaticMesh(default.PrecashedStatics[i]);
	}
}


defaultproperties
{
     MinHitAnimDelay=1.250000
     MissSound(0)=Sound'2009DoomMonstersSounds.Imp.imp_miss_01'
     MissSound(1)=Sound'2009DoomMonstersSounds.Imp.imp_miss_03'
     MissSound(2)=Sound'2009DoomMonstersSounds.Imp.imp_miss_01'
     MissSound(3)=Sound'2009DoomMonstersSounds.Imp.imp_miss_03'
     CollapseSound(0)=Sound'2009DoomMonstersSounds.Trite.Trite_deathsplat_01'
     CollapseSound(1)=Sound'2009DoomMonstersSounds.Trite.Trite_deathsplat_04'
     InvisMat=Texture'2009DoomMonstersTex.Revenant.InvisMat'
     BurningMaterial=Texture'2009DoomMonstersTex.FatZombie.FattySkin'
     BurnClass=Class'ScrnDoom3KF.DoomBurnTex'
     FadeClass=Class'ScrnDoom3KF.DoomMaterialSequence'
     BurnDust=Class'ScrnDoom3KF.DoomDeResDustMedium'
     MeleeKnockBack=5000.000000
     FootstepSndRadius=600.000000
     DoomTeleportFXClass=Class'ScrnDoom3KF.DemonSpawn'
     BurnedTextureNum(1)=255
     bHasFireWeakness=True
     BurnAnimTime=1.000000
     BurnSpeed=1
     FadingBurnMaterial=Texture'2009DoomMonstersTex.Symbols.DoomFire'
     BurnDuration=8
     BurnInCount=2
     MinHeadShotDamageMult=1.5
     PipeAttackCooldown=5.000000
     PipeDetectRange=1000.000000
     strFUPiper(0)="%n: Setting landmines and hiding like a pussy? How 'bout to come out and fight face to face?"
     strFUPiper(1)="%n: Oh, another pipebomb. Do you really think I'm so stupid to walk on it?"
     strFUPiper(2)="%n: What's that interesting thing on the ground with blinking red light? Let's shoot it!"
     strRetardedDemonsArray(0)="%n: Damned retards, stop hitting me, attack those mortals!"
     strRetardedDemonsArray(1)="%n: Bad doggy, %a, bad!"
     strRetardedDemonsArray(2)="%n: %a, what the hell are you doing? You're supposed to help be, not kill me!"
     CurrentDamType=Class'ScrnDoom3KF.DamTypeD3Melee'
     DeResTime=2.000000
     DeResGravScale=10.000000
     bCanWalkOffLedges=True
     HeadScale=1.000000
     OnlineHeadAnimationPhase=0.5
     OnlineHeadshotScale=1.1
     ControllerClass=Class'ScrnDoom3KF.Doom3Controller'
     bDoTorsoTwist=False
     DrawScale=1.400000
     TransientSoundVolume=1.700000

     ZapThreshold=0.50
     ZappedDamageMod=1.25

     MaxMeleeAttacks=3
     FireRootBone="chest"
     CrispUpThreshhold=3
}
