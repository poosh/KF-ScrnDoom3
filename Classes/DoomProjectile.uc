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

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	if ( (Other != instigator) && (!Other.IsA('Projectile') || Other.bProjTarget) && ExtendedZCollision(Other)==None )
		Explode(HitLocation, vect(0,0,1));
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
	TransientSoundVolume=1.0
	ShakeScale=1.0
}
