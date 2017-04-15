class RevenantSmokePuffs extends DoomEmitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         Acceleration=(Z=75.000000)
         ColorScale(0)=(Color=(B=4,G=95,R=155))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=128,G=128,R=128))
         MaxParticles=6
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Max=24.000000)
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=10.000000,Max=20.000000),Y=(Min=60.000000,Max=80.000000),Z=(Min=60.000000,Max=80.000000))
         InitialParticlesPerSecond=10.000000
         Texture=Texture'2009DoomMonstersTex.Effects.FlashStrip3'
         TextureUSubdivisions=32
         TextureVSubdivisions=1
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.600000,Max=0.800000)
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.RevenantSmokePuffs.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         UseRandomSubdivision=True
         Acceleration=(Z=20.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255))
         ColorScale(1)=(RelativeTime=0.125000,Color=(B=255,G=255,R=255))
         ColorScale(2)=(RelativeTime=0.330000,Color=(B=255,G=255,R=255,A=255))
         ColorScale(3)=(RelativeTime=0.750000,Color=(B=128,G=128,R=128,A=255))
         ColorScale(4)=(RelativeTime=1.000000,Color=(B=64,G=64,R=64))
         MaxParticles=5
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=-20.000000,Max=20.000000)
         StartLocationPolarRange=(Y=(Min=-32768.000000,Max=32768.000000),Z=(Min=10.000000,Max=10.000000))
         UseRotationFrom=PTRS_Actor
         RotationOffset=(Yaw=-16384)
         SpinsPerSecondRange=(X=(Max=0.100000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.200000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.500000)
         StartSizeRange=(X=(Min=30.000000,Max=50.000000))
         InitialParticlesPerSecond=500.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'2009DoomMonstersTex.Imp.SmokeReOrdered'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=2.000000,Max=2.000000)
         StartVelocityRadialRange=(Min=200.000000,Max=200.000000)
         VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
         VelocityScale(1)=(RelativeTime=0.300000,RelativeVelocity=(X=0.100000,Y=0.100000,Z=0.100000))
         VelocityScale(2)=(RelativeTime=1.000000)
     End Object
     Emitters(1)=SpriteEmitter'ScrnDoom3KF.RevenantSmokePuffs.SpriteEmitter1'

     LifeSpan=2.000000
}
