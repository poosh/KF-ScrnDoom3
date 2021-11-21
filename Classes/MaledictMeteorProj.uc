class MaledictMeteorProj extends MaledictMeteorBigProj;

simulated function PostNetBeginPlay()
{
	Acceleration = Normal(Velocity)*Speed;
}


defaultproperties
{
	TrailClass=class'ScrnDoom3KF.MaledictMeteorTrail'
	ExplodeProjClass=class'ScrnDoom3KF.HunterProjExplosion'
	Speed=1200.000000
	MaxSpeed=3500.000000
	Damage=50.000000 //down from 60 in beta 11
}
