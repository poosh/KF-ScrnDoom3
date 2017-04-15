class HellKnightProjectile extends DoomProjectile;

var HellKnightTrail Trail;
var HellKnightProjSmokeTrail SmokeTrail;
var Sound NewImpactSounds[2];

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if ( Level.NetMode != NM_DedicatedServer )
	{
		Trail = Spawn(class'HellKnightTrail',self);
		SmokeTrail = Spawn(class'HellKnightProjSmokeTrail',self);
	}
	Velocity = Vector(Rotation) * Speed;
	Velocity.Z += -50;
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
	PlaySound(NewImpactSounds[Rand(2)], SLOT_Misc);
	if ( EffectIsRelevant(Location,false) )
		Spawn(class'HellKnightProjExplosion',,, Location, rotator(HitNormal));
	ShakeView(300.f,2.f);
	Destroy();
}

simulated function Destroyed()
{
	if( Trail!=None )
		Trail.Kill();
	if( SmokeTrail!=None )
		SmokeTrail.Kill();
	Super.Destroyed();
}

defaultproperties
{
     NewImpactSounds(0)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_ns1_v3'
     NewImpactSounds(1)=Sound'2009DoomMonstersSounds.HellKnight.HellKnight_ns2_v3'
     Speed=1500.000000
     MaxSpeed=1550.000000
     Damage=40.000000
     DamageRadius=160.000000
     MomentumTransfer=3000.000000
     MyDamageType=Class'ScrnDoom3KF.DamTypeHellKnightProj'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=106
     LightSaturation=104
     LightBrightness=169.000000
     LightRadius=4.000000
     DrawType=DT_None
     CullDistance=4000.000000
     bDynamicLight=True
     Physics=PHYS_Falling
     AmbientSound=Sound'2009DoomMonstersSounds.Imp.imp_fireball_flight_04'
     LifeSpan=10.000000
     DrawScale=0.200000
     SoundVolume=255
     SoundRadius=150.000000
     CollisionRadius=10.000000
     CollisionHeight=10.000000
}
