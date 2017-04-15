class MaledictFireWallTrail extends DoomEmitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         ColorScale(0)=(Color=(B=255,G=255,R=255))
         ColorScale(1)=(RelativeTime=0.050000,Color=(B=255,G=255,R=255,A=128))
         ColorScale(2)=(RelativeTime=0.800000,Color=(B=128,G=255,R=255,A=128))
         ColorScale(3)=(RelativeTime=1.000000,Color=(G=255,R=255))
         FadeOutStartTime=1.000000
         MaxParticles=300
         StartLocationRange=(X=(Min=-15.000000,Max=15.000000),Y=(Min=-5.000000,Max=5.000000))
         SphereRadiusRange=(Min=1.000000,Max=4.000000)
         UseRotationFrom=PTRS_Actor
         StartSpinRange=(X=(Min=0.550000,Max=0.450000))
         SizeScale(0)=(RelativeSize=0.100000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=25.000000,Max=40.000000),Y=(Min=50.000000,Max=50.000000))
         ParticlesPerSecond=200.000000
         InitialParticlesPerSecond=200.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'2009DoomMonstersTex.Effects.FlashStrip4'
         TextureUSubdivisions=8
         TextureVSubdivisions=1
         LifetimeRange=(Min=1.500000,Max=2.000000)
         StartVelocityRange=(Z=(Min=1.000000,Max=1.000000))
         VelocityScale(0)=(RelativeTime=0.500000)
         VelocityScale(1)=(RelativeTime=1.000000,RelativeVelocity=(Z=1000.000000))
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.MaledictFireWallTrail.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Acceleration=(X=-20.000000,Z=10.000000)
         ColorScale(1)=(RelativeTime=0.200000,Color=(B=64,G=128,R=255))
         ColorScale(2)=(RelativeTime=0.600000,Color=(B=128,G=255,R=255))
         ColorScale(3)=(RelativeTime=1.000000)
         MaxParticles=100
         StartLocationOffset=(Z=10.000000)
         StartLocationRange=(Y=(Min=-20.000000,Max=20.000000))
         UseRotationFrom=PTRS_Actor
         SizeScale(0)=(RelativeSize=0.100000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=50.000000,Max=50.000000),Y=(Min=10.000000,Max=10.000000))
         DrawStyle=PTDS_Brighten
         Texture=Texture'2009DoomMonstersTex.Effects.FlameStrip5'
         TextureUSubdivisions=32
         TextureVSubdivisions=1
         LifetimeRange=(Min=1.500000,Max=2.000000)
     End Object
     Emitters(1)=SpriteEmitter'ScrnDoom3KF.MaledictFireWallTrail.SpriteEmitter1'

     Physics=PHYS_Trailer
}
