class ArchvileFlameAttackProjectile extends DoomProjectile;

var Sound BurnSound;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetTimer(0.8, false);
	if( Level.NetMode!=NM_DedicatedServer )
	{
		Spawn(class'ArchvileFlameAttackEffect');
		PlaySound(BurnSound, SLOT_Misc,2.f,,400.f);
	}
	else Disable('Tick');
}

function ProcessTouch( actor Other, vector HitLocation );
function HitWall( vector HitNormal, actor Wall );

simulated function Timer()
{
	ShakeView(DamageRadius*1.5f,2.f);
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, Location);
	if( LifeSpan>1.f )
		SetTimer(0.1, false);
	else if( Level.NetMode==NM_DedicatedServer )
		Destroy();
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
		if( (Victims != self) && Archvile(Victims)==None && (Victims.Role == ROLE_Authority) && !Victims.IsA('FluidSurfaceInfo') && ExtendedZCollision(Victims)==None )
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
simulated function Tick( float Delta )
{
	if( LifeSpan<2.f )
		LightBrightness = Default.LightBrightness*(LifeSpan*0.5f);
}

defaultproperties
{
     BurnSound=Sound'2009DoomMonstersSounds.Archvile.Archvile_burn'
     MaxSpeed=0.000000
     Damage=5.000000
     DamageRadius=120.000000
     MomentumTransfer=20000.000000
     MyDamageType=Class'ScrnDoom3KF.DamTypeArchvileFlames'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=28
     LightSaturation=127
     LightBrightness=255.000000
     LightRadius=4.000000
     DrawType=DT_None
     CullDistance=4000.000000
     bDynamicLight=True
     Physics=PHYS_None
     LifeSpan=4.000000
     DrawScale=0.600000
     SoundVolume=255
     SoundRadius=150.000000
     CollisionRadius=15.000000
     CollisionHeight=13.000000
}
