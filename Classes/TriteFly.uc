// tick used as projectile by a Vagary
class TriteFly extends Trite;

var float FlyDmgMult;
var	float FlySpeed;
var bool bFlying; // spider is flying as projectile
var bool bReleased; // spider is released by Vagary
var vector FlyFrom, FlyTo, FlyVelocityXY;
var transient float FlyTime, FlyEnd;
var transient float MinDistFromMasterSq;


// replication {
// 	reliable if ( Role == ROLE_Authority )
// 		bReleased, FlyFrom, FlyTo;
// }

function Throw(vector dest)
{
	local Vector XY;
	local float dist;

	FlyFrom = Location;
	FlyTo = dest;
	SetRotation(rotator(FlyTo - FlyFrom));

	// slightly overshoot to prevent easy dodge by backpedaling
	FlyTo += vector(Rotation) * 50;
	XY = FlyTo - FlyFrom;
	XY.Z = 0;
	dist = vsize(XY);
	FlyTime = fclamp(dist / FlySpeed, 0.1, 1.0);
	FlySpeed = dist / FlyTime;

	Velocity = ComputeTrajectoryByTime(FlyFrom, FlyTo, FlyTime * Level.TimeDilation / 1.1);
	FlyVelocityXY = Velocity;
	FlyVelocityXY.Z = 0;
	Acceleration = vect(0,0,0);

	// log("FlyTime=" $ FlyTime @ "dist="$dist @ "FlySpeed="$FlySpeed @ "Velocity="$Velocity);
	GoToState('Flying');
}

function bool TestPlayerHit(KFHumanPawn P) { return false; }


auto state Arming
{
	ignores Landed, HitWall, Touch, TakeDamage, ModifyVelocity;

	function BeginState()
	{
		Doom3Controller(Controller).bUseFreezeHack = true;
		bReleased = false;
		bZedUnderControl = true;
	}

	function EndState()
	{
		bReleased = true;
		bZedUnderControl = false;
	}

	function bool CanSpeedAdjust()
	{
		return false;
	}

Begin:
	sleep(5.0);
	warn("Stuck in " @ GetStateName());
	Suicide();
}

state Flying
{
	ignores Throw;

	function BeginState()
	{
		if ( MonsterMaster == none || Controller == none ) {
			GotoState('');
			return;
		}
		Doom3Controller(Controller).bUseFreezeHack = true;
		bFlying = true;
		MinDistFromMasterSq = square(CollisionRadius + MonsterMaster.CollisionRadius);
	}

	function EndState()
	{
		// log(Level.TimeSeconds $ " ResetToNormalMonster");
		Doom3Controller(Controller).bUseFreezeHack = false;
		bFlying = false;
		SetCollision(true, true);
		if ( Physics == PHYS_Flying || Physics == PHYS_Projectile ) {
			SetPhysics(PHYS_Falling);
		}
	}

	function Tick(float dt)
	{
		local vector XY, MasterXY;

		global.Tick(dt);

		Velocity.X = FlyVelocityXY.X;
		Velocity.Y = FlyVelocityXY.Y;
		Acceleration.X = 0;
		Acceleration.Y = 0;

		if ( MonsterMaster == none ) {
			SetCollision(true, true);
		}

		if ( !bCollideActors ) {
			XY = Location;
			XY.Z = 0;
			MasterXY = MonsterMaster.Location;
			MasterXY.Z = 0;
			if ( VSizeSquared(XY - MasterXY) > MinDistFromMasterSq ) {
				// log(Level.TimeSeconds $ "  restore spider collision. Velocity="$Velocity @ "Acceleration="$Acceleration);
				SetCollision(true, true);
			}
		}
	}

	function bool CanSpeedAdjust()
	{
		return false;
	}

	function Touch(Actor Other)
	{
		if ( Other == MonsterMaster || Other.Base == MonsterMaster || Trite(Other) != none )
			return;
	}

	function bool TestPlayerHit(KFHumanPawn P)
	{
		if ( P == none )
			return false;

		P.TakeDamage(MeleeDamage * FlyDmgMult, self, Location, Velocity, CurrentDamType);
		if ( P.Health <= 0 ) {
			P.SpawnGibs(Rotation, 1);
		}
		else if ( Doom3Controller(Controller) != none ) {
			Doom3Controller(Controller).SetEnemy(P);
		}
		return true;
	}

	function Bump(actor Other)
	{
		if ( ROBulletWhipAttachment(Other) != none || ExtendedZCollision(Other) != none || Trite(Other) != none )
			return;

		// log(Level.TimeSeconds @ "Bump " $ Other);
		TestPlayerHit(KFHumanPawn(Other));
		GoToState('');
	}

	function BaseChange()
	{
		// log(Level.TimeSeconds @ "BaseChange " $ Base);
		TestPlayerHit(KFHumanPawn(Base));
		global.BaseChange();
		GoToState('');
	}

	simulated function HitWall(vector HitNormal, actor Wall)
	{
		// log(Level.TimeSeconds @ "HitWall");
		global.HitWall(HitNormal, Wall);
		GoToState('');
	}

	function Landed(vector HitNormal)
	{
		// log(Level.TimeSeconds @ "Landed");
		global.Landed(HitNormal);
		GoToState('');
	}

	function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
	{
		local class<KFWeaponDamageType> KFDamType;
		local int OldHealth;

		KFDamType = class<KFWeaponDamageType>(damageType);
		OldHealth = Health;
		global.TakeDamage(Damage, instigatedBy, hitLocation, momentum, damageType, HitIndex);

		Damage = OldHealth - Health;
		if ( Damage >= 40 && KFDamType != none && KFDamType.default.bCheckForHeadShots ) {
			// log(Level.TimeSeconds @ "TakeDamage " $ Damage);
			GotoState('');
		}
	}

Begin:
	sleep(10.0);
	warn("Stuck in " @ GetStateName());
	Suicide();
}

defaultproperties
{
	FlyDmgMult=3.0
	FlySpeed=1000
	bFlying=true
	bCollideActors=false
	bBlockActors=false
	bBlockZeroExtentTraces=true
	bBlockNonZeroExtentTraces=true
	bBlockHitPointTraces=true
	bProjTarget=true
}
