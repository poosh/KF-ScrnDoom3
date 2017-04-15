class SabaothProjArc extends xEmitter;

var Actor Target;

simulated function Tick( float Delta )
{
	if( Target==None || Target.bDeleteMe )
		Destroy();
	else mSpawnVecA = Target.Location;
}

defaultproperties
{
     mParticleType=PT_Beam
     mStartParticles=3
     mMaxParticles=3
     mLifeRange(0)=0.250000
     mLifeRange(1)=0.100000
     mSizeRange(0)=24.000000
     mSizeRange(1)=48.000000
     mAttenKa=0.100000
     mWaveFrequency=10.000000
     mWaveAmplitude=50.000000
     mWaveShift=10000.000000
     mBendStrength=1.800000
     Physics=PHYS_Trailer
     LifeSpan=0.250000
     Skins(0)=Texture'2009DoomMonstersTex.Effects.GreenBolt4'
     Style=STY_Additive
     SoundVolume=255
     SoundRadius=400.000000
}
