class BruiserProjectile extends DoomProjectile;

var BruiserProjTrail Trail;

simulated function PostBeginPlay()
{
	local Rotator R;

	Super.PostBeginPlay();

	if ( Level.NetMode != NM_DedicatedServer )
		Trail = Spawn(class'BruiserProjTrail', self);
	Velocity = Vector(Rotation) * Speed;
	R = Rotation;
	R.Roll = 32768;
	SetRotation(R);
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
	if ( Role == ROLE_Authority )
		HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );

	PlaySound(ImpactSound, SLOT_Misc);
	if ( EffectIsRelevant(Location,false) )
		Spawn(class'MancubusProjExplosion',,, Location);
	ShakeView(350.f,4.f);
	Destroy();
}

simulated function Destroyed()
{
	if (Trail != None)
		Trail.Kill();
	Super.Destroyed();
}

defaultproperties
{
     Speed=900.000000
     MaxSpeed=1150.000000
     Damage=15.000000 //25
     DamageRadius=190.000000
     MomentumTransfer=3000.000000
     MyDamageType=Class'ScrnDoom3KF.DamTypeBruiserProj'
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
     CollisionRadius=10.000000
     CollisionHeight=10.000000
}
