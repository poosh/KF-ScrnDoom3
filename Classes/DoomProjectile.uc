class DoomProjectile extends Projectile;

var DoomEmitter Trail;
var xEmitter xTrail;
var DoomEmitter SmokeTrail;

var class<DoomEmitter> TrailClass;
var class<xEmitter> xTrailClass;
var class<DoomEmitter> SmokeTrailClass;
var class<DoomEmitter> ExplodeProjClass;
var Array<Sound> NewImpactSounds;

var float ShakeRadius, ShakeScale;
var bool bSetVelocity;

var int ImpactDamage;  // additional damage on direct hits
var class<DamageType> ImpactDamageType;
var bool bDirectionalExplode;  // should projective velocity affect the explosion momentum?
var class<DoomMonster> InstigatorClass;
var bool bHurtSameSpecies;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if ( Level.NetMode != NM_DedicatedServer ) {
		if ( TrailClass != none ) {
			Trail = Spawn(TrailClass, self);
		}
		if ( xTrailClass != none ) {
			xTrail = Spawn(xTrailClass, self);
			xTrail.SetBase(self);
			xTrail.mSpawnVecA = Location;
		}
		if ( SmokeTrailClass != none ) {
			SmokeTrail = Spawn(SmokeTrailClass, self);
		}
	}
	Velocity = Vector(Rotation) * Speed;
}

simulated function Destroyed()
{
	if ( Trail != none )
		Trail.Kill();
	if ( xTrail != none )
		xTrail.Destroy();
	if ( SmokeTrail != none )
		SmokeTrail.Kill();
	Super.Destroyed();
}


simulated function HurtVictim(Actor Victim, int DamageAmount, vector HitLocation, vector Momentum,
		class<DamageType> DamageType)
{
	if (!bHurtSameSpecies && Victim.class == InstigatorClass)
		return;

	if (Instigator == None || Instigator.Controller == None) {
		Victim.SetDelayedDamageInstigatorController(InstigatorController);
	}

	Victim.TakeDamage(DamageAmount, Instigator, HitLocation, Momentum, DamageType);
}

simulated function HurtRadius(float DamageAmount, float DamageRadius, class<DamageType> DamageType,
		float Momentum, vector HitLocation)
{
	local actor Victim;
	local float damageScale, dist;
	local vector dir;

	if ( bHurtEntry )
		return;
	bHurtEntry = true;

	if (LastTouched != none) {
		// the one we touched gets full damage
		Victim = LastTouched;
		HurtVictim(Victim, DamageAmount, HitLocation, Momentum * Normal(Victim.Location - HitLocation), DamageType);

		if (Vehicle(Victim) != None && Vehicle(Victim).Health > 0)
			Vehicle(Victim).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum,
				HitLocation);
	}

	// optimization: CollidingActors vs. VisibleCollidingActors
	// https://wiki.beyondunreal.com/Legacy:Code_Optimization#Optimize_iterator_use
	// In short, we do "cheap" checks first, leaving the visibility check to the end.
	foreach CollidingActors( class 'Actor', Victim, DamageRadius, HitLocation ) {
		if (Victim.bStatic || Victim == Hurtwall || Victim == LastTouched
				|| Victim.Role != ROLE_Authority
				|| Victim.IsA('FluidSurfaceInfo') || Victim.IsA('ExtendedZCollision')
				|| !FastTrace(Victim.Location, HitLocation))
			continue;

		dir = Victim.Location - HitLocation;
		dist = fmax(0, VSize(dir) - Victim.CollisionRadius - CollisionRadius);
		if (dist > 1.0) {
			dir /= dist;
		}
		damageScale = 1.0 - dist / DamageRadius;

		HurtVictim(Victim, damageScale * DamageAmount,
				Victim.Location - 0.5 * (Victim.CollisionHeight + Victim.CollisionRadius) * dir,
				damageScale * Momentum * dir, DamageType);

		if (Vehicle(Victim) != None && Vehicle(Victim).Health > 0)
			Vehicle(Victim).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum,
				HitLocation);
	}

	bHurtEntry = false;
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);

	if ( NewImpactSounds.length != 0 ) {
		PlaySound(NewImpactSounds[Rand(NewImpactSounds.length)], SLOT_Misc);
	}
	else if ( ImpactSound != none ) {
		PlaySound(ImpactSound, SLOT_Misc);
	}

	if ( ExplodeProjClass != none && EffectIsRelevant(Location,false) ) {
		Spawn(ExplodeProjClass,,, Location, rotator(HitNormal));
	}
	ShakeView(ShakeRadius, ShakeScale);
	Destroy();
}

simulated function vector GetImpactMomentum()
{
	return MomentumTransfer * Normal(Velocity);
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	local vector HitNormal;

	if (bDeleteMe || Other == Instigator || Other.IsA('ExtendedZCollision') || Other.IsA('ROCollisionAttachment'))
		return;

	if (Role == ROLE_Authority && ImpactDamage > 0) {
		if (ImpactDamageType == none) {
			ImpactDamageType = MyDamageType;
		}
		Other.TakeDamage(ImpactDamage, Instigator, HitLocation, GetImpactMomentum(), ImpactDamageType);
	}

	if (bDirectionalExplode) {
		HitNormal = Normal(HitLocation - Other.Location);
	}
	else {
		HitNormal = vect(0, 0, 1);
	}

	Explode(HitLocation, HitNormal);
}

simulated function Landed( vector HitNormal )
{
	HitWall(HitNormal,Level);
}

simulated function ShakeView( float Radius, float ShakeScale )
{
	local PlayerController PC;
	local float D;

	if ( Radius == 0 )
		return;

	PC = Level.GetLocalPlayerController();
	if( PC != none && PC.Pawn != none ) {
		D = VSize(PC.Pawn.Location-Location);
		if( D < Radius ) {
			D = 1.f - (D/Radius);
			PC.ShakeView(vect(300,300,300)*ShakeScale*D, vect(12500,12500,12500), 4.f, vect(4,3,3)*ShakeScale*D,
					vect(300,300,300), 6.f);
		}
	}
}

static function PreCacheMaterials(LevelInfo Level)
{
	local int i;

	for ( i = 0; i < default.Skins.Length; ++i ) {
		Level.AddPrecacheMaterial(default.Skins[i]);
	}
	if ( default.TrailClass != none ) {
		default.TrailClass.static.PreCacheMaterials(Level);
	}
	if ( default.SmokeTrailClass != none ) {
		default.SmokeTrailClass.static.PreCacheMaterials(Level);
	}
	if ( default.ExplodeProjClass != none ) {
		default.ExplodeProjClass.static.PreCacheMaterials(Level);
	}
	if ( default.xTrailClass != none ) {
		for ( i = 0; i < default.xTrailClass.default.Skins.Length; ++i ) {
			Level.AddPrecacheMaterial(default.xTrailClass.default.Skins[i]);
		}
	}
}

defaultproperties
{
	bHurtSameSpecies=true
	TransientSoundVolume=1.0
	ShakeScale=1.0
}
