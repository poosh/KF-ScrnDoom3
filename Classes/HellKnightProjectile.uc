class HellKnightProjectile extends DoomProjectile;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	Velocity.Z -= 50;
}


defaultproperties
{
	TrailClass=class'ScrnDoom3KF.HellKnightTrail'
	SmokeTrailClass=class'ScrnDoom3KF.HellKnightProjExplosion'
	ExplodeProjClass=class'ScrnDoom3KF.HellKnightProjExplosion'
	ShakeRadius=300.0
	ShakeScale=2.0

	NewImpactSounds(0)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_ns1_v3'
	NewImpactSounds(1)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_ns2_v3'
	Speed=1500.000000
	MaxSpeed=1550.000000
	Damage=40.000000
	DamageRadius=160.000000
	MomentumTransfer=3000.000000
	MyDamageType=Class'ScrnDoom3KF.DamTypeHellKnightProj'
	LightType=LT_Steady
	LightEffect=LE_QuadraticNonIncidence
	LightHue=106
	LightSaturation=104
	LightBrightness=169.000000
	LightRadius=4.000000
	DrawType=DT_None
	CullDistance=4000.000000
	bDynamicLight=True
	Physics=PHYS_Falling
	AmbientSound=Sound'2009DoomMonstersSounds.Imp.imp_fireball_flight_04'
	LifeSpan=10.000000
	DrawScale=0.200000
	SoundVolume=255
	SoundRadius=150.000000
	CollisionRadius=10.000000
	CollisionHeight=10.000000
}
