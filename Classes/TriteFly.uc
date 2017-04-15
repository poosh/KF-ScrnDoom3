// tick used as projectile by a Vagary
class TriteFly extends Trite;

var()	float   FlySpeed;               // Initial speed of projectile.
var transient vector FlyDirection;
var bool bFlying; // spider is flying as projectile
var bool bReleased; // spider is release by Vagary
var vector ReleaseLocation;
var vector TargetLocation;
var transient float TimeToFly;
var transient bool bTimeToFlyInit;

replication {
	reliable if ( Role == ROLE_Authority ) 
		bReleased, ReleaseLocation, TargetLocation;
}

simulated function HitWall(vector HitNormal, actor Wall)
{
	//log("TriteFly.HitWall("$HitNormal$", "$Wall$"). FlySpeed="$FlySpeed $ ", Physics="$Physics, class.outer.name);

	if ( bFlying )
		ResetToNormalMonster();
	super.HitWall(HitNormal, Wall);
}

function Landed(vector HitNormal)
{
	//log("TriteFly.Landed("$HitNormal$"). FlySpeed="$FlySpeed $ ", Physics="$Physics, class.outer.name);

	if( bFlying )
		ResetToNormalMonster();
	Super.Landed(HitNormal);
}

// stop flying as projectile and act as normal monster
simulated function ResetToNormalMonster()
{
	if ( Physics == PHYS_Flying || Physics == PHYS_Projectile ) 
		SetPhysics(PHYS_Falling);
	bFlying=false;
	SetCollision(true);
	//MeleeDamage = Max(DifficultyDamageModifer() * Class'ScrnDoom3KF.Tick'.default.MeleeDamage,1);
}

function bool CanSpeedAdjust()
{
	if ( bFlying )
		return false;
	
	return super.CanSpeedAdjust();
}


simulated event ModifyVelocity(float DeltaTime, vector OldVelocity)
{
	//log("TriteFly.ModifyVelocity("$DeltaTime$", "$OldVelocity$"). FlySpeed="$FlySpeed $ ", Physics="$Physics, class.outer.name);
	
	if ( bFlying ) {
		if ( bReleased ) {
			if ( !bCollideActors && vsize(Location - Owner.Location) > CollisionRadius + Owner.CollisionRadius )
				SetCollision(true); // enable collision after spider leaves Vagary

			if ( bTimeToFlyInit ) 
				TimeToFly -= DeltaTime;
			else {
				FlyDirection = normal(TargetLocation - ReleaseLocation);
				TimeToFly = (1.05 + 0.2*frand()) * vsize(TargetLocation - Location) / FlySpeed;
				bTimeToFlyInit = true;
			}

			if ( TimeToFly > 0 ) {
				Velocity = FlyDirection * FlySpeed;
				Velocity.Z = ComputeTrajectoryByTime(ReleaseLocation, TargetLocation, TimeToFly).Z;
			}
			else {
				SetPhysics(PHYS_Falling);
				ResetToNormalMonster();
			}
		}
	}
	else 
		super.ModifyVelocity(DeltaTime, OldVelocity);
}


simulated singular function Touch(Actor Other)
{
	// local Vector TempHitLocation, HitNormal;
	// local array<int>	HitPoints;
	
	if ( bFlying ) {
		//log("TriteFly.Touch("$Other$")", class.outer.name);
		
		if ( Other == Owner || Other.Base == Owner || Other.Owner == Owner )
			return; // don't touch Vagary 
			
		if ( TriteFly(Other) != none || TriteFly(Other.Owner) != none )
			return; // don't touch other spiders			
			
		if( ROBulletWhipAttachment(Other) != none && !Other.Base.bDeleteMe ) {
			if ( Other.Base.bDeleteMe )
				return;
				
			// Other = HitPointTrace(TempHitLocation, HitNormal, Location + (200 * FlyDirection), HitPoints, Location,, 1);
			// log("ROBulletWhipAttachment.Other="$Other, class.outer.name);

			// if( KFPawn(Other) == none || Other.bDeleteMe )
				// return;
				
			Other = Other.Base;

			if (Role == ROLE_Authority) {
				Other.TakeDamage(MeleeDamage * 3.0 * FlySpeed / default.FlySpeed, self, Location, Normal(Velocity), ZombieDamType[0]);
			}
			Controller.Target = Other;
			SetPhysics(PHYS_Falling);
			Velocity = PhysicsVolume.Gravity;
			ResetToNormalMonster();
		}
		else if ( Pawn(Other) != none ) {
			if (Role == ROLE_Authority) {
				Other.TakeDamage(MeleeDamage * 3.0 * FlySpeed / default.FlySpeed, self, Location, Normal(Velocity), ZombieDamType[0]);
			}
			Controller.Target = Other;
			SetPhysics(PHYS_Falling);
			Velocity = PhysicsVolume.Gravity;
			ResetToNormalMonster();
		}
	}
	else super.Touch(Other);
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> DamType, optional int HitIndex )
{
	if ( bFlying && !bReleased ) {
		// damage resistance while in Vagary's hands
		if ( class<KFWeaponDamageType>(DamType) != none && class<KFWeaponDamageType>(DamType).default.bCheckForHeadShots )
			Damage *= 0.1; // 90% resistance against bullets
		else
			return; // doesn't receive damage from explosives and fire
	}
	super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, DamType, HitIndex);
}

defaultproperties
{
	FlySpeed=1000
	bFlying=true
	bCollideActors=false
}