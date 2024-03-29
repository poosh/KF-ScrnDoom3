class VulgarProjectile extends DoomProjectile;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	Velocity.z += TossZ;
}


defaultproperties
{
	TrailClass=class'ScrnDoom3KF.VulgarProjTrail'
	ExplodeProjClass=class'ScrnDoom3KF.VulgarProjExplosion'
	NewImpactSounds(0)=Sound'2009DoomMonstersSounds.Imp.imp_exp_03'
	NewImpactSounds(1)=Sound'2009DoomMonstersSounds.Imp.imp_exp_05'
	Speed=900.000000
	MaxSpeed=1150.000000
	TossZ=10.000000
	Damage=20.000000
	DamageRadius=150.000000
	MomentumTransfer=3000.000000
	MyDamageType=Class'ScrnDoom3KF.DamTypeVulgarProj'
	LightType=LT_Steady
	LightEffect=LE_QuadraticNonIncidence
	LightHue=127
	LightSaturation=85
	LightBrightness=171.000000
	LightRadius=4.000000
	DrawType=DT_None
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
