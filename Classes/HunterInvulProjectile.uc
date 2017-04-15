class HunterInvulProjectile extends DoomProjectile;

var HunterInvulProjTrail Trail;
var HunterInvulProjSmokeTrail SmokeTrail;
var Sound NewImpactSounds[2];
var Actor Seeking;
var vector InitialDir;

replication
{
	reliable if( Role==ROLE_Authority )
		Seeking;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	Velocity = Vector(Rotation) * Speed;
	if ( Level.NetMode != NM_DedicatedServer )
	{
		Trail = Spawn(class'HunterInvulProjTrail', self);
		Trail.SetBase(self);
		SmokeTrail = Spawn(class'HunterInvulProjSmokeTrail',self);
		SmokeTrail.SetBase(Self);
	}
	Velocity.Z += 250;
	SetTimer(0.2,true);
}

simulated function Timer()
{
	local vector ForceDir;
	local float VelMag;

	if ( InitialDir == vect(0,0,0) )
		InitialDir = Normal(Velocity);

	Acceleration = vect(0,0,0);
	Super.Timer();
	if(Seeking != None)
	{
		ForceDir = Normal(Seeking.Location - Location);

		if( (ForceDir Dot InitialDir) > 0 )
		{
			VelMag = VSize(Velocity);

			if ( Seeking.Physics == PHYS_Karma )
				ForceDir = Normal(ForceDir * 0.8 * VelMag + Velocity);
			else ForceDir = Normal(ForceDir * 0.5 * VelMag + Velocity);
			Velocity =  VelMag * ForceDir;
			Acceleration += 5 * ForceDir;
		}
		SetRotation(rotator(Velocity));
	}
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
	if ( Role == ROLE_Authority )
		HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
	PlaySound(NewImpactSounds[Rand(2)], SLOT_Misc);
	if ( EffectIsRelevant(Location,false) )
		Spawn(class'HunterInvulProjExplosion',,,HitLocation+HitNormal);
	ShakeView(180.f,1.f);
	Destroy();
}

simulated function Destroyed()
{
	if (Trail != None)
		Trail.Kill();
	if (SmokeTrail != None)
		SmokeTrail.Kill();
	Super.Destroyed();
}

defaultproperties
{
     NewImpactSounds(0)=Sound'2009DoomMonstersSounds.Hunter.Hunter_helltime_exp_03'
     NewImpactSounds(1)=Sound'2009DoomMonstersSounds.Hunter.Hunter_helltime_exp_05'
     Speed=1000.000000
     MaxSpeed=1150.000000
     Damage=18.000000
     DamageRadius=150.000000
     MomentumTransfer=3000.000000
     MyDamageType=Class'ScrnDoom3KF.DamTypeHunterInvulShockWave'
     ImpactSound=Sound'2009DoomMonstersSounds.Imp.imp_exp_03'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=141
     LightSaturation=127
     LightBrightness=255.000000
     LightRadius=4.000000
     DrawType=DT_Sprite
     CullDistance=4000.000000
     bDynamicLight=True
     bNetTemporary=False
     AmbientSound=Sound'2009DoomMonstersSounds.Hunter.Hunter_helltime_flight1'
     LifeSpan=10.000000
     Texture=Shader'2009DoomMonstersTex.Effects.HunterInvulProjTex'
     DrawScale=0.300000
     SoundVolume=50
     SoundRadius=150.000000
     TransientSoundVolume=1.500000
     TransientSoundRadius=800.000000
}
