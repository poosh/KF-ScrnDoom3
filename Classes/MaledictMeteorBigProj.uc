class MaledictMeteorBigProj extends DoomProjectile;

var Emitter Trail;
var Sound NewImpactSounds[2];
var Sound SpawnSounds[2];
var StaticMesh SmallMeteorMesh[3];

simulated function PostBeginPlay()
{
	RandSpin(25000);
	PlaySound(SpawnSounds[Rand(2)],SLOT_Interact);
	if ( Level.NetMode != NM_DedicatedServer )
	{
		SetStaticMesh(SmallMeteorMesh[Rand(3)]);
		Trail = Spawn(class'MaledictBigMeteorTrail', self);
	}
	Velocity = Vector(Rotation) * Speed;
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
	ShakeView(DamageRadius*2.f,3.f);
	PlaySound(NewImpactSounds[Rand(2)], SLOT_Misc);
	if ( EffectIsRelevant(Location,false) )
		Spawn(class'MaledictBigProjExplosion',,, Location);
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
     NewImpactSounds(0)=Sound'2009DoomMonstersSounds.Maledict.Maledict_asteroid_03'
     NewImpactSounds(1)=Sound'2009DoomMonstersSounds.Maledict.Maledict_asteroid_01'
     SpawnSounds(0)=Sound'2009DoomMonstersSounds.Maledict.Maledict_fire_05'
     SpawnSounds(1)=Sound'2009DoomMonstersSounds.Maledict.Maledict_fire_02'
     SmallMeteorMesh(0)=StaticMesh'2009DoomMonstersSM.MMeteor01'
     SmallMeteorMesh(1)=StaticMesh'2009DoomMonstersSM.MMeteor02'
     SmallMeteorMesh(2)=StaticMesh'2009DoomMonstersSM.MMeteor03'
     Speed=900.000000
     MaxSpeed=1150.000000
     Damage=80.000000
     DamageRadius=150.000000
     MomentumTransfer=10000.000000
     MyDamageType=Class'ScrnDoom3KF.DamTypeMaledict'
     ImpactSound=Sound'2009DoomMonstersSounds.Imp.imp_exp_03'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=28
     LightSaturation=127
     LightBrightness=255.000000
     LightRadius=5.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'2009DoomMonstersSM.MMeteor01'
     CullDistance=4000.000000
     bDynamicLight=True
     AmbientSound=Sound'2009DoomMonstersSounds.Hunter.Hunter_helltime_flight1'
     LifeSpan=8.000000
     DrawScale=0.800000
     Skins(0)=Shader'2009DoomMonstersTex.Maledict.MeteorShader'
     SoundVolume=255
     SoundRadius=150.000000
     TransientSoundVolume=2.000000
     TransientSoundRadius=1000.000000
     CollisionRadius=13.000000
     CollisionHeight=10.000000
     bFixedRotationDir=True
     DesiredRotation=(Pitch=12000,Yaw=5666,Roll=2334)
}
