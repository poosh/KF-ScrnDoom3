class HunterInvulBigProjectile extends HunterInvulProjectile;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	Velocity.Z -= 100;
}


defaultproperties
{
	TrailClass=class'ScrnDoom3KF.HunterInvulBigProjTrail'
	ShakeRadius=180.0
	ShakeScale=2.0

	Speed=900.000000
	MaxSpeed=1050.000000
	Damage=35.000000
	DamageRadius=150.000000
	MomentumTransfer=6000.000000
	DrawScale=0.600000
	SoundVolume=70
	SoundRadius=150.000000
	CollisionRadius=10.000000
	CollisionHeight=10.000000
}
