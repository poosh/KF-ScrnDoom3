class HunterProjectile extends DoomProjectile;

var HunterProjTrail Trail;
var Sound NewImpactSounds[2];

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if ( Level.NetMode != NM_DedicatedServer )
	{
		Trail = Spawn(class'HunterProjTrail', self);
		Trail.SetBase(self);
	}
	Velocity = Vector(Rotation) * Speed;
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
	local byte i;

	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );

	if( Level.NetMode!=NM_DedicatedServer )
	{
		i = Rand(2);
		PlaySound(NewImpactSounds[i], SLOT_Misc);
		PlaySound(NewImpactSounds[i], SLOT_Pain);
		if ( EffectIsRelevant(Location,false) )
			Spawn(class'HunterProjExplosion',,, Location);
		ShakeView(180.f,1.f);
	}
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
     NewImpactSounds(0)=Sound'2009DoomMonstersSounds.Imp.imp_exp_03'
     NewImpactSounds(1)=Sound'2009DoomMonstersSounds.Imp.imp_exp_05'
     Speed=1500.000000
     MaxSpeed=1800.000000
     Damage=25.000000
     DamageRadius=150.000000
     MomentumTransfer=3000.000000
     MyDamageType=Class'ScrnDoom3KF.DamTypeHunterProj'
     ImpactSound=Sound'2009DoomMonstersSounds.Imp.imp_exp_03'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=8
     LightSaturation=90
     LightBrightness=255.000000
     LightRadius=4.000000
     DrawType=DT_Sprite
     CullDistance=4000.000000
     bDynamicLight=True
     bNetTemporary=False
     Physics=PHYS_Falling
     AmbientSound=Sound'2009DoomMonstersSounds.Imp.imp_fireball_flight_04'
     LifeSpan=10.000000
     Texture=Shader'2009DoomMonstersTex.Effects.ImpFireBallTexture'
     DrawScale=0.400000
     SoundVolume=255
     SoundRadius=150.000000
     TransientSoundVolume=2.000000
     TransientSoundRadius=500.000000
     CollisionRadius=10.000000
     CollisionHeight=10.000000
}
