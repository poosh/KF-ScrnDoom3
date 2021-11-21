class CyberDemonProjectile extends DoomProjectile;

simulated function PostBeginPlay()
{
	local Rotator R;

	Super.PostBeginPlay();

	R = Rotation;
	R.Roll = 32768;
	SetRotation(R);
	SetTimer(0.1, true);
}

simulated function PostNetBeginPlay()
{
	Acceleration = Normal(Velocity)*800.f;
}


defaultproperties
{
	TrailClass=class'ScrnDoom3KF.CyberDemonRocketTrail'
	SmokeTrailClass=class'ScrnDoom3KF.RevenantProjSmokeTrail'
	ExplodeProjClass=class'ScrnDoom3KF.CyberDemonRocketExplosion'
	ShakeRadius=600.0
	ShakeScale=5.0

	ImpactSound=SoundGroup'KF_LAWSnd.Rocket_Explode'
	Speed=800.000000
	MaxSpeed=3150.000000
	Damage=65 // 90
	DamageRadius=240.000000
	MomentumTransfer=3000.000000
	MyDamageType=Class'ScrnDoom3KF.DamTypeCyberDemonRocket'
	LightType=LT_Steady
	LightEffect=LE_QuadraticNonIncidence
	LightHue=28
	LightSaturation=127
	LightBrightness=255.000000
	LightRadius=4.000000
	DrawType=DT_StaticMesh
	StaticMesh=StaticMesh'2009DoomMonstersSM.CyberDemonRocketMesh'
	CullDistance=4000.000000
	bDynamicLight=True
	AmbientSound=Sound'KF_LAWSnd.Rocket_Propel'
	LifeSpan=10.000000
	DrawScale=1.400000
	DrawScale3D=(X=2.000000)
	Skins(0)=Texture'2009DoomMonstersTex.CyberDemon.RocketTex'
	Skins(1)=Texture'2009DoomMonstersTex.CyberDemon.RocketFin'
	AmbientGlow=30
	bUnlit=False
	SoundVolume=255
	SoundRadius=420.000000
	TransientSoundVolume=2.000000
	TransientSoundRadius=1200.000000
	CollisionRadius=10.000000
	CollisionHeight=10.000000
}
