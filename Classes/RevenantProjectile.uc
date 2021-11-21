class RevenantProjectile extends DoomProjectile;

var Actor Seeking;
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

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	if(Other != instigator && !Other.IsA('Projectile') && ExtendedZCollision(Other)==None )
	{
		if( Other.Role==ROLE_Authority )
			Other.TakeDamage(Damage*0.6,Instigator,HitLocation,Velocity*10.f,MyDamageType);
		Explode(HitLocation, vect(0,0,1));
	}
}

simulated function Timer()
{
	local vector ForceDir;
	local float VelMag;
	local rotator R;

	if(Seeking != None)
	{
		ForceDir = Normal(Seeking.Location - Location);
		if( (ForceDir Dot Velocity) > 0 )
		{
			VelMag = VSize(Velocity);
			ForceDir = Normal(ForceDir * 0.4 * VelMag + Velocity);
			Velocity =  VelMag * ForceDir;
			Acceleration += 55 * ForceDir;
			R = rotator(Velocity);
			R.Roll = Rotation.Roll;
			SetRotation(R);
		}
		else Acceleration = vect(0,0,0);
	}
}

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
	local class<KFWeaponDamageType> KFWeapDam;

	if ( bDeleteMe)
		return;

	KFWeapDam = class<KFWeaponDamageType>(damageType);
	if ( KFWeapDam == none || KFWeapDam.default.bIsExplosive || KFWeapDam.default.bDealBurningDamage)
		return;

	if( damageType == class'SirenScreamDamage') {
		Destroy();
	}
	else {
		Health -= Damage;
		if ( Health <= 0 ) {
			Explode(HitLocation, vect(0,0,0));
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

	Health=150
	ImpactSound=SoundGroup'KF_LAWSnd.Rocket_Explode'
	Speed=500.000000
	MaxSpeed=800.000000
	Damage=16.000000
	DamageRadius=100.000000
	MyDamageType=Class'ScrnDoom3KF.DamTypeRevenantProjectile'
	LightSaturation=127
	DrawType=DT_StaticMesh
	StaticMesh=StaticMesh'2009DoomMonstersSM.CyberDemonRocketMesh'
	CullDistance=4000.000000
	Skins(0)=Texture'2009DoomMonstersTex.CyberDemon.RocketTex'
	Skins(1)=Texture'2009DoomMonstersTex.CyberDemon.RocketFin'
	SoundRadius=150.000000
	TransientSoundRadius=500.000000
	CollisionRadius=3.000000
	CollisionHeight=3.000000
	bProjTarget=True
	bFixedRotationDir=True
	RotationRate=(Roll=12000)
}
