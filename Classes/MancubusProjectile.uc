class MancubusProjectile extends DoomProjectile;

simulated function PostNetBeginPlay()
{
	Acceleration = Normal(Velocity)*600.f;
}


defaultproperties
{
	TrailClass=class'ScrnDoom3KF.MancubusProjTrail'
	SmokeTrailClass=class'ScrnDoom3KF.MancubusSmokeTrail'
	ExplodeProjClass=class'ScrnDoom3KF.MancubusProjExplosion'
	ShakeRadius=400.0
	ShakeScale=3.0

	Speed=1050
	MaxSpeed=1500
	ImpactDamage=15
	Damage=20
	DamageRadius=180
	MomentumTransfer=3000.000000
	MyDamageType=Class'ScrnDoom3KF.DamTypeMancubusProj'
	ImpactSound=Sound'2009DoomMonstersSounds.Imp.imp_exp_03'
	LightType=LT_Steady
	LightEffect=LE_QuadraticNonIncidence
	LightHue=28
	LightSaturation=127
	LightBrightness=255.000000
	LightRadius=4.000000
	DrawType=DT_Sprite
	CullDistance=4000.000000
	bDynamicLight=True
	AmbientSound=Sound'2009DoomMonstersSounds.Imp.imp_fireball_flight_04'
	LifeSpan=10.000000
	Texture=Texture'2009DoomMonstersTex.Revenant.InvisMat'
	DrawScale=0.200000
	SoundVolume=255
	SoundRadius=150.000000
	TransientSoundRadius=400.000000
	CollisionRadius=0
	CollisionHeight=0
}
