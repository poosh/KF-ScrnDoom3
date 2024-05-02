class MaledictFireWallProj extends DoomProjectile;

var Sound AltAmbient;

simulated function PostBeginPlay()
{
	if ( Level.NetMode != NM_DedicatedServer )
	{
		if(fRand() > 0.5) {
			AmbientSound = AltAmbient;
		}
		else {
			TrailClass = none;
		}
	}

	super.PostBeginPlay();

	SetTimer(0.1, true);
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

simulated function Destroyed()
{
	if (Trail != None)
		Trail.Kill();
	Super.Destroyed();
}

simulated function ProcessTouch( actor Other, vector HitLocation );

simulated function HitWall( vector HitNormal, actor Wall );

simulated function Timer()
{
	ShakeView(ShakeRadius, ShakeScale);
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, Location );
}

simulated function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
	local actor Victims;
	local float damageScale, dist;
	local vector dir;

	if ( bHurtEntry )
		return;

	bHurtEntry = true;
	foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
	{
		if( (Victims != self) && Maledict(Victims)==None && (Victims.Role == ROLE_Authority) && !Victims.IsA('FluidSurfaceInfo') && ExtendedZCollision(Victims)==None )
		{
			dir = Victims.Location - HitLocation;
			dist = FMax(1,VSize(dir));
			dir = dir/dist;
			damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
			if ( Instigator == None || Instigator.Controller == None )
				Victims.SetDelayedDamageInstigatorController( InstigatorController );
			Victims.TakeDamage(damageScale * DamageAmount,Instigator,Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
				(damageScale * Momentum * dir),DamageType);
			if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
				Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);
		}
	}
	bHurtEntry = false;
}

defaultproperties
{
	TrailClass=class'ScrnDoom3KF.MaledictFireWallTrail'
	ShakeRadius=150
	ShakeScale=2.0

	Speed=900.000000
	MaxSpeed=1150.000000
	Damage=30 // 20
	DamageRadius=100.000000
	MyDamageType=Class'ScrnDoom3KF.DamTypeMaledict'
	InstigatorClass=class'Maledict'
	bHurtSameSpecies=false
	LightType=LT_Steady
	LightEffect=LE_QuadraticNonIncidence
	LightHue=28
	LightSaturation=127
	LightBrightness=255.000000
	LightRadius=4.000000
	DrawType=DT_None
	bDynamicLight=True
	Physics=PHYS_Falling
	AmbientSound=Sound'2009DoomMonstersSounds.Maledict.Maledict_flamewall_03'
	AltAmbient=Sound'2009DoomMonstersSounds.Maledict.Maledict_flamewall_04'
	LifeSpan=4.000000
	SoundVolume=255
	SoundRadius=150.000000
	CollisionRadius=15.000000
	CollisionHeight=13.000000
}
