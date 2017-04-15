class HunterHellTimeProjectile extends DoomProjectile;

var HunterProjTrail Trail;
var Sound NewImpactSounds[2];

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	Velocity = Vector(Rotation) * Speed;
	Velocity.Z += -150;
	if ( Level.NetMode != NM_DedicatedServer )
		Trail = Spawn(class'HunterProjTrail', self);
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
	HurtRadius(Damage, DamageRadius, Class'DamTypeBruiserProj', MomentumTransfer, HitLocation );

	PlaySound(NewImpactSounds[Rand(2)], SLOT_Misc);
	if ( EffectIsRelevant(Location,false) )
		Spawn(class'HunterProjExplosion',,, Location);
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
     NewImpactSounds(0)=Sound'2009DoomMonstersSounds.Hunter.Hunter_helltime_exp_03'
     NewImpactSounds(1)=Sound'2009DoomMonstersSounds.Hunter.Hunter_helltime_exp_05'
     Speed=1700.000000
     Damage=15.000000
     DamageRadius=160.000000
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
     Physics=PHYS_Falling
     AmbientSound=Sound'2009DoomMonstersSounds.Hunter.Hunter_helltime_flight1'
     LifeSpan=10.000000
     Texture=Shader'2009DoomMonstersTex.Effects.ImpFireBallTexture'
     DrawScale=0.500000
     SoundVolume=50
     SoundRadius=150.000000
     CollisionRadius=10.000000
     CollisionHeight=10.000000
}
