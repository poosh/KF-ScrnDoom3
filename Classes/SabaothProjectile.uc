class SabaothProjectile extends DoomProjectile;

var class<SabaothProjArc> GreenArcs[2];
var Sound ArcSounds[3];
var vector NormalDir;
var bool bHadDeathFX;
var int Health;
var float ChargeTime;

var transient int PlayerHits; //how many times arcs hit players
var transient bool bDestoyedByHuman;
var transient float FullChargeTime;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	FullChargeTime = Level.TimeSeconds + ChargeTime;
	SetTimer(ChargeTime, false);
}

simulated function Timer()
{
	local Actor A;
	local byte ArcCounter;
	local SabaothProjArc Arc;
	local int d;

	if (bDeleteMe)
		return;

	if( NormalDir==vect(0,0,0) )
		NormalDir = Normal(Velocity);
	d = Damage*0.1;

	// optimization: CollidingActors vs. VisibleCollidingActors
	// https://wiki.beyondunreal.com/Legacy:Code_Optimization#Optimize_iterator_use
	// In short, we do "cheap" checks first, leaving the visibility check to the end.
	foreach CollidingActors(class'Actor', A, 600) {
		if (A.bStatic || A == Instigator || A.class == self.class || (!A.bProjTarget && !A.bBlockActors)
				|| (NormalDir Dot Normal(A.Location-Location)) < 0.45
				|| !FastTrace(A.Location, Location))
			continue; // skip this actor

		if (Level.NetMode!=NM_DedicatedServer) {
			Arc = Spawn(GreenArcs[Rand(2)],Self);
			Arc.mSpawnVecA = A.Location;
			Arc.Target = A;
			Arc.AmbientSound = ArcSounds[Rand(3)];
		}
		if (A.IsA('KFPawn')) {
			++PlayerHits;
		}
		A.TakeDamage(d, Instigator, Location, 1000.0 * vRand(), MyDamageType);
		if( ++ArcCounter>=6 )
			break;
	}
	SetTimer(0.1, false);
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
	if( bHadDeathFX )
		return;
	bHadDeathFX = true;

	if ( Level.TimeSeconds < FullChargeTime ) {
		Damage *= fmax(0.2, 1.0 - ((FullChargeTime - Level.TimeSeconds) / ChargeTime));
	}
	super.Explode(HitLocation, HitNormal);
}

simulated function Destroyed()
{
	if( !bHadDeathFX && Level.NetMode==NM_Client )
		Explode(Location,Normal(-Velocity));
	Super.Destroyed();
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

function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
	local class<KFWeaponDamageType> KFDamType;

	KFDamType = class<KFWeaponDamageType>(DamageType);
	if (KFDamType != none && KFDamType.default.bCheckForHeadShots && KFDamType.default.HeadShotDamageMult > 1.0) {
		Damage *= KFDamType.default.HeadShotDamageMult;
	}

	Health -= Damage;
	if( Health <= 0 ) {
		bDestoyedByHuman = KFPawn(InstigatedBy) != none;
		Explode(Location, Normal(Location-HitLocation));
		// this added for achievement track - destory BFG cell before it hurts anyone
		if ( PlayerHits == 0 ) {
			Instigator.TakeDamage(666, InstigatedBy, Instigator.Location, vect(0,0,1), class'DamTypeBFG');
		}
	}
}

simulated function HurtVictim(Actor Victim, int DamageAmount, vector HitLocation, vector Momentum,
		class<DamageType> DamageType)
{
	if (Victim.IsA('KFPawn')) {
		if (bDestoyedByHuman)
			return;  // no damage to players if they destroyed the BFG cell in mid-air
		PlayerHits += 10;
	}
	super.HurtVictim(Victim, DamageAmount, HitLocation, Momentum, DamageType);
}


defaultproperties
{
	TrailClass=class'ScrnDoom3KF.SabaothProjTrail'
	ExplodeProjClass=class'ScrnDoom3KF.SabaothProjExplosion'
	ShakeRadius=180.0
	ShakeScale=2.0
	NewImpactSounds(0)=Sound'2009DoomMonstersSounds.BFG.bfg_explode1'
	NewImpactSounds(1)=Sound'2009DoomMonstersSounds.BFG.bfg_explode2'
	NewImpactSounds(2)=Sound'2009DoomMonstersSounds.BFG.bfg_explode3'
	NewImpactSounds(3)=Sound'2009DoomMonstersSounds.BFG.bfg_explode4'
	GreenArcs(0)=Class'ScrnDoom3KF.SabaothProjArc'
	GreenArcs(1)=Class'ScrnDoom3KF.SabaothProjArcFat'
	ArcSounds(0)=Sound'2009DoomMonstersSounds.BFG.arc_1'
	ArcSounds(1)=Sound'2009DoomMonstersSounds.BFG.arc_3'
	ArcSounds(2)=Sound'2009DoomMonstersSounds.BFG.arc_4'
	Speed=1000.000000
	MaxSpeed=1150.000000
	bDirectionalExplode=true
	Damage=50 // 60
	ImpactDamage=15
	DamageRadius=250.000000
	MomentumTransfer=10000.000000
	MyDamageType=Class'ScrnDoom3KF.DamTypeSabaothProj'
	ExplosionDecal=Class'ScrnDoom3KF.SabaothProjDecal'
	LightType=LT_Steady
	LightEffect=LE_QuadraticNonIncidence
	LightHue=106
	LightSaturation=104
	LightBrightness=169.000000
	LightRadius=4.000000
	DrawType=DT_None
	bDynamicLight=True
	bNetTemporary=False
	AmbientSound=Sound'2009DoomMonstersSounds.BFG.bfg_fly'
	LifeSpan=10.000000
	DrawScale=0.200000
	SoundVolume=255
	SoundRadius=250.000000
	TransientSoundVolume=1.500000
	TransientSoundRadius=450.000000
	CollisionRadius=20
	CollisionHeight=20
	bProjTarget=True
	Health=100
	ChargeTime=0.5
}
