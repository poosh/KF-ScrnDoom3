class ArchvileFlameAttackProjectile extends DoomProjectile;

var Sound BurnSound;
var class<DoomEmitter> AttackEffect;

static function PreCacheMaterials(LevelInfo Level)
{
	super.PreCacheMaterials(Level);
	default.AttackEffect.static.PreCacheMaterials(Level);
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetTimer(0.8, false);
	if( Level.NetMode == NM_DedicatedServer ) {
		Disable('Tick');
	}
	else {
		Spawn(AttackEffect);
		PlaySound(BurnSound, SLOT_Misc,2.f,,400.f);
	}
}

function ProcessTouch( actor Other, vector HitLocation );
function HitWall( vector HitNormal, actor Wall );

simulated function Timer()
{
	ShakeView(ShakeRadius, ShakeScale);
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, Location);
	if( LifeSpan>1.f )
		SetTimer(0.1, false);
	else if( Level.NetMode==NM_DedicatedServer )
		Destroy();
}

simulated function Tick( float Delta )
{
	if( LifeSpan<2.f )
		LightBrightness = Default.LightBrightness*(LifeSpan*0.5f);
}

defaultproperties
{
	ShakeRadius=180.0
	AttackEffect=class'ScrnDoom3KF.ArchvileFlameAttackEffect'
	BurnSound=Sound'2009DoomMonstersSounds.Archvile.Archvile_burn'
	MaxSpeed=0.000000
	Damage=5.000000
	DamageRadius=120.000000
	MomentumTransfer=20000.000000
	MyDamageType=Class'ScrnDoom3KF.DamTypeArchvileFlames'
	InstigatorClass=class'Archvile'
	bHurtSameSpecies=false
	LightType=LT_Steady
	LightEffect=LE_QuadraticNonIncidence
	LightHue=28
	LightSaturation=127
	LightBrightness=255.000000
	LightRadius=4.000000
	DrawType=DT_None
	CullDistance=4000.000000
	bDynamicLight=True
	Physics=PHYS_None
	LifeSpan=4.000000
	DrawScale=0.600000
	SoundVolume=255
	SoundRadius=150.000000
	CollisionRadius=15.000000
	CollisionHeight=13.000000
}
