class VagaryClassicProj extends DoomProjectile;

var Material NewSkins[3];
var vector RepTargetVel;
var Actor Target;
var bool bHadDeathFX;

replication
{
	reliable if( Role==ROLE_Authority && bNetDirty )
		RepTargetVel;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	Skins[1] = NewSkins[Rand(3)];
	Velocity = vect(0,0,180);
	RandSpin(25000);
	SetRotation(RotRand(true));
	if( Level.NetMode!=NM_Client )
	{
		Target = Instigator.Controller.Target;
		SetTimer(0.6,false);
	}
	if( Level.NetMode!=NM_DedicatedServer )
		SetDrawScale(0.5+FRand()*1.25f);
}

function Timer()
{
	local float Dist;

	Dist = 100.f;
	if( Target==None )
		Velocity = vect(0,0,50);
	else
	{
		Dist = VSize(Target.Location-Location)*(0.8+FRand()*0.4);
		Velocity = Normal(Target.Location+(Target.Velocity*Dist/Speed)-Location)*Speed;
		Velocity.Z+=10.f+FMin(Dist*Abs(PhysicsVolume.Gravity.Z)/Speed,200.f);
	}
	RepTargetVel = Velocity*2.f;
	SetPhysics(PHYS_Falling);
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
	if( bHadDeathFX )
		return;
	bHadDeathFX = true;

	super.Explode(HitLocation, HitNormal);
}

simulated function PostNetBeginPlay()
{
	if( Physics==PHYS_Projectile && Level.NetMode!=NM_DedicatedServer )
	{
		Spawn(Class'VagaryProjEmitter');
		bNetNotify = true;
	}
}

simulated function PostNetReceive()
{
	if( RepTargetVel!=vect(0,0,0) )
	{
		SetPhysics(PHYS_Falling);
		Velocity = RepTargetVel*0.5f;
		bNetNotify = false;
	}
}

simulated function Destroyed()
{
	if( !bHadDeathFX && Level.NetMode==NM_Client )
		Explode(Location,Normal(-Velocity));
	Super.Destroyed();
}

function ProcessTouch(Actor Other, Vector HitLocation)
{
	if ( Other != Instigator && ExtendedZCollision(Other)==None )
		Explode(HitLocation,Normal(HitLocation-Other.Location));
}

function HitWall(vector HitNormal, actor Wall)
{
	if ( !Wall.bStatic && !Wall.bWorldGeometry )
	{
		if ( Instigator == None || Instigator.Controller == None )
			Wall.SetDelayedDamageInstigatorController( InstigatorController );
		Wall.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
		if (DamageRadius > 0 && Vehicle(Wall) != None && Vehicle(Wall).Health > 0)
			Vehicle(Wall).DriverRadiusDamage(Damage, DamageRadius, InstigatorController, MyDamageType, MomentumTransfer, Location);
		HurtWall = Wall;
	}
	MakeNoise(1.0);
	Explode(Location + ExploWallOut * HitNormal, HitNormal);
	HurtWall = None;
}

static function PreCacheMaterials(LevelInfo Level)
{
	local int i;

	super.PreCacheMaterials(Level);
	for ( i = 0; i < 3; ++i ) {
		Level.AddPrecacheMaterial(default.NewSkins[i]);
	}
}

defaultproperties
{
	ExplodeProjClass=class'ScrnDoom3KF.VagaryClassicProjExplosion'
	NewSkins(0)=Texture'2009DoomMonstersTex.Vagary.VagSpikeTex4'
	NewSkins(1)=Texture'2009DoomMonstersTex.Vagary.VagSpikeTex3'
	NewSkins(2)=Texture'2009DoomMonstersTex.Vagary.VagSpikeTex2'
	Speed=1000.000000
	MaxSpeed=1500.000000
	Damage=38.000000
	DamageRadius=120.000000
	MomentumTransfer=3000.000000
	MyDamageType=Class'ScrnDoom3KF.DamTypeVagaryClassicProj'
	ImpactSound=Sound'2009DoomMonstersSounds.Imp.imp_exp_05'
	LightEffect=LE_QuadraticNonIncidence
	LightHue=8
	LightSaturation=90
	LightBrightness=255.000000
	LightRadius=4.000000
	DrawType=DT_StaticMesh
	StaticMesh=StaticMesh'2009DoomMonstersSM.VagarySpike'
	bDynamicLight=True
	bNetTemporary=False
	LifeSpan=10.000000
	Skins(0)=Texture'2009DoomMonstersTex.Vagary.VagSpikeTex1'
	Skins(1)=Texture'2009DoomMonstersTex.Vagary.VagSpikeTex2'
	AmbientGlow=40
	bUnlit=False
	SoundVolume=255
	SoundRadius=150.000000
	CollisionRadius=10.000000
	CollisionHeight=10.000000
	bFixedRotationDir=True
	DesiredRotation=(Pitch=12000,Yaw=5666,Roll=2334)
}
