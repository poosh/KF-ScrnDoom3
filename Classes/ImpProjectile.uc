class ImpProjectile extends DoomProjectile;

simulated function PostBeginPlay()
{
	local Rotator R;

	Super.PostBeginPlay();

	R = Rotation;
	R.Roll = 32768;
	SetRotation(R);
	Velocity.z += TossZ;
}


defaultproperties
{
	TrailClass=class'ScrnDoom3KF.ImpFireBallTrail'
	SmokeTrailClass=class'ScrnDoom3KF.ImpProjSmokeTrail'
	ExplodeProjClass=class'ImpFireBallExplosion'
	ShakeRadius=200.0
	ShakeScale=1.0
	NewImpactSounds(0)=Sound'2009DoomMonstersSounds.Imp.imp_exp_03'
	NewImpactSounds(1)=Sound'2009DoomMonstersSounds.Imp.imp_exp_05'

	Speed=900.000000
	MaxSpeed=1150.000000
	TossZ=10.000000
	Damage=10 // 15
	DamageRadius=150.000000
	MomentumTransfer=3000.000000
	MyDamageType=Class'ScrnDoom3KF.DamTypeImpFireBall'
	LightType=LT_Steady
	LightEffect=LE_QuadraticNonIncidence
	LightHue=8
	LightSaturation=90
	LightBrightness=255.000000
	LightRadius=4.000000
	DrawType=DT_Sprite
	CullDistance=4000.000000
	bDynamicLight=True
	Physics=PHYS_Falling
	AmbientSound=Sound'2009DoomMonstersSounds.Imp.imp_fireball_flight_04'
	LifeSpan=10.000000
	Texture=Shader'2009DoomMonstersTex.Effects.ImpFireBallTexture'
	DrawScale=0.200000
	SoundVolume=255
	SoundRadius=150.000000
	TransientSoundVolume=1.500000
	TransientSoundRadius=600.000000
	CollisionRadius=10.000000
	CollisionHeight=10.000000
}
