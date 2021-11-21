class HunterInvulShockProj extends DoomProjectile;


defaultproperties
{
	xTrailClass=class'ScrnDoom3KF.HunterInvulBeam'
	ExplodeProjClass=class'ScrnDoom3KF.HunterInvulProjExplosion'
	ShakeRadius=220
	ShakeScale=1.0

	NewImpactSounds(0)=Sound'2009DoomMonstersSounds.Hunter.Hunter_helltime_exp_03'
	NewImpactSounds(1)=Sound'2009DoomMonstersSounds.Hunter.Hunter_helltime_exp_05'
	Speed=1100.000000
	MaxSpeed=1200.000000
	Damage=10.000000
	DamageRadius=200.000000
	MomentumTransfer=3000.000000
	MyDamageType=Class'ScrnDoom3KF.DamTypeHunterInvulShockWave'
	LightType=LT_Steady
	LightEffect=LE_QuadraticNonIncidence
	LightHue=28
	LightSaturation=127
	LightBrightness=169.000000
	LightRadius=4.000000
	DrawType=DT_StaticMesh
	CullDistance=4000.000000
	bDynamicLight=True
	bNetTemporary=False
	AmbientSound=Sound'2009DoomMonstersSounds.Imp.imp_fireball_flight_04'
	LifeSpan=10.000000
	DrawScale=0.200000
	SoundVolume=255
	SoundRadius=150.000000
	TransientSoundVolume=1.500000
	TransientSoundRadius=800.000000
	CollisionRadius=1.000000
	CollisionHeight=1.000000
}
