class RevenantProjectile extends DoomProjectile;

var Actor Seeking;
var float SeekingRate;
var int Health;


replication
{
	reliable if( bNetInitial && (Role==ROLE_Authority) )
		Seeking;
}


simulated function PostBeginPlay()
{
	local rotator R;

	super.PostBeginPlay();

	if( Level.NetMode!=NM_Client && Instigator!=None && Instigator.Controller!=None ) {
		Seeking = Instigator.Controller.Target;
		R.Yaw = Rotation.Yaw+Rand(6000)-3000;
		R.Pitch = Rotation.Pitch+Rand(6000)-3000;
		R.Roll = Rand(65536);
		SetRotation(R);
	}
	Velocity = Speed * vector(Rotation);
	SetTimer(0.1, true);
}

simulated function vector GetImpactMomentum()
{
	return 10.0 * Velocity;
}

simulated function Timer()
{
	local vector ForceDir;
	local float VelMag;
	local rotator R;

	if(Seeking != None) {
		ForceDir = Normal(Seeking.Location - Location);
		if( (ForceDir Dot Velocity) > 0 )
		{
			VelMag = VSize(Velocity);
			ForceDir = Normal(ForceDir * SeekingRate * VelMag + Velocity);
			Velocity =  VelMag * ForceDir;
			Acceleration += 55 * ForceDir;
			R = rotator(Velocity);
			R.Roll = Rotation.Roll;
			SetRotation(R);
		}
		else Acceleration = vect(0,0,0);
	}
}

function TakeDamage(int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType,
		optional int HitIndex)
{
	local class<KFWeaponDamageType> KFWeapDam;

	if (bDeleteMe)
		return;

	KFWeapDam = class<KFWeaponDamageType>(damageType);
	if (KFWeapDam == none || KFWeapDam.default.bDealBurningDamage)
		return;

	if (damageType == class'SirenScreamDamage') {
		Destroy();
	}
	else {
		Health -= Damage;
		if ( Health <= 0 ) {
			Explode(HitLocation, vect(0,0,1));
		}
	}
}

defaultproperties
{
	TrailClass=class'ScrnDoom3KF.RevenantProjTrail'
	SmokeTrailClass=class'ScrnDoom3KF.RevenantProjSmokeTrail'
	ExplodeProjClass=class'ScrnDoom3KF.CyberDemonRocketExplosion'
	ShakeRadius=600.0
	ShakeScale=5.0

	bNetTemporary=false
	SeekingRate=0.8
	Health=150
	ImpactSound=SoundGroup'KF_LAWSnd.Rocket_Explode'
	Speed=500.000000
	MaxSpeed=800.000000
	Damage=16
	ImpactDamage=0
	DamageRadius=150.0
	MyDamageType=Class'ScrnDoom3KF.DamTypeRevenantProjectile'
	LightSaturation=127
	DrawType=DT_StaticMesh
	StaticMesh=StaticMesh'2009DoomMonstersSM.CyberDemonRocketMesh'
	CullDistance=4000.000000
	Skins(0)=Texture'2009DoomMonstersTex.CyberDemon.RocketTex'
	Skins(1)=Texture'2009DoomMonstersTex.CyberDemon.RocketFin'
	SoundRadius=150.000000
	TransientSoundRadius=500.000000
	CollisionRadius=10
	CollisionHeight=10
	bProjTarget=True
	bFixedRotationDir=True
	RotationRate=(Roll=12000)
}
