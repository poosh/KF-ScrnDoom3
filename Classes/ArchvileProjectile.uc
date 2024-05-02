class ArchvileProjectile extends DoomProjectile;

var vector OldPos;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	Velocity.Z = 50.f;
	SetTimer(0.1f, true);
}

simulated event PhysicsVolumeChange( PhysicsVolume NewVolume )
{
	if (NewVolume.bWaterVolume)
		Destroy();
	Super.PhysicsVolumeChange(NewVolume);
}

simulated function Landed( vector HitNormal )
{
	SetPhysics(PHYS_Walking);
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
	Destroy();
}

simulated function ProcessTouch( actor Other, vector HitLocation );
simulated function HitWall( vector HitNormal, actor Wall );

simulated function Timer()
{
	ShakeView(ShakeRadius, ShakeScale);
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, Location );
	if( Level.NetMode!=NM_Client )
	{
		if( VSizeSquared(Location-OldPos)<100.f )
			Destroy();
		else OldPos = Location;
	}
}


defaultproperties
{
	TrailClass=class'ScrnDoom3KF.ArchvileFireWallEffect'
	ShakeRadius=200.0

	Speed=900.000000
	MaxSpeed=1150.000000
	Damage=35.000000
	DamageRadius=100.000000
	MyDamageType=Class'ScrnDoom3KF.DamTypeArchvileFireWall'
	InstigatorClass=class'Archvile'
	bHurtSameSpecies=false
	LightType=LT_Steady
	LightEffect=LE_QuadraticNonIncidence
	LightHue=28
	LightSaturation=127
	LightBrightness=255.000000
	LightRadius=4.000000
	DrawType=DT_None
	CullDistance=4000.000000
	bDynamicLight=True
	Physics=PHYS_Falling
	AmbientSound=Sound'2009DoomMonstersSounds.Archvile.Archvile_fire_02'
	LifeSpan=4.000000
	DrawScale=0.600000
	SoundVolume=255
	SoundRadius=150.000000
	CollisionRadius=15.000000
	CollisionHeight=13.000000
}
