class MancubusProjectile extends DoomProjectile;

var MancubusProjTrail Trail;
var MancubusSmokeTrail SmokeTrail;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if ( Level.NetMode != NM_DedicatedServer )
	{
		Trail = Spawn(class'MancubusProjTrail', self);
		SmokeTrail = Spawn(class'MancubusSmokeTrail',self);
	}
	Velocity = Vector(Rotation) * Speed;
}
simulated function PostNetBeginPlay()
{
	Acceleration = Normal(Velocity)*600.f;
}
simulated function Explode(vector HitLocation,vector HitNormal)
{
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
	PlaySound(ImpactSound, SLOT_Misc);
	if ( EffectIsRelevant(Location,false) )
		Spawn(class'MancubusProjExplosion',,, Location);
	ShakeView(400.f,3.f);
	Destroy();
}

simulated function Destroyed()
{
	if (Trail != None)
		Trail.Kill();
	if(SmokeTrail != None)
		SmokeTrail.Kill();
	Super.Destroyed();
}

defaultproperties
{
     Speed=900.000000
     MaxSpeed=1300.000000
     Damage=20.000000
     DamageRadius=180.000000
     MomentumTransfer=3000.000000
     MyDamageType=Class'ScrnDoom3KF.DamTypeMancubusProj'
     ImpactSound=Sound'2009DoomMonstersSounds.Imp.imp_exp_03'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=28
     LightSaturation=127
     LightBrightness=255.000000
     LightRadius=4.000000
     DrawType=DT_Sprite
     CullDistance=4000.000000
     bDynamicLight=True
     AmbientSound=Sound'2009DoomMonstersSounds.Imp.imp_fireball_flight_04'
     LifeSpan=10.000000
     Texture=Texture'2009DoomMonstersTex.Revenant.InvisMat'
     DrawScale=0.200000
     SoundVolume=255
     SoundRadius=150.000000
     TransientSoundRadius=400.000000
     CollisionRadius=10.000000
     CollisionHeight=10.000000
}
