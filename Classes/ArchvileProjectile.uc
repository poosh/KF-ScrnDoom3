class ArchvileProjectile extends DoomProjectile;

var ArchvileFireWallEffect Trail;
var vector OldPos;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if ( Level.NetMode != NM_DedicatedServer )
		Trail = Spawn(class'ArchvileFireWallEffect',self);
	Velocity = Vector(Rotation) * Speed;
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
	ShakeView(DamageRadius*2.f,2.f);
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, Location );
	if( Level.NetMode!=NM_Client )
	{
		if( VSizeSquared(Location-OldPos)<100.f )
			Destroy();
		else OldPos = Location;
	}
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
		if( (Victims!=self) && Archvile(Victims)==None && (Victims.Role == ROLE_Authority) && !Victims.IsA('FluidSurfaceInfo') && ExtendedZCollision(Victims)==None )
		{
			dir = Victims.Location - HitLocation;
			dist = FMax(1,VSize(dir));
			dir = dir/dist;
			damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
			if ( Instigator == None || Instigator.Controller == None )
				Victims.SetDelayedDamageInstigatorController( InstigatorController );
			if ( Victims == LastTouched )
				LastTouched = None;
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
     Speed=900.000000
     MaxSpeed=1150.000000
     Damage=35.000000
     DamageRadius=100.000000
     MyDamageType=Class'ScrnDoom3KF.DamTypeArchvileFireWall'
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
