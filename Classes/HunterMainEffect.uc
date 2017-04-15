class HunterMainEffect extends DoomEmitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorScale(0)=(Color=(B=128,G=255,R=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(G=128,R=255))
         Opacity=0.200000
         FadeInEndTime=0.050000
         CoordinateSystem=PTCS_Relative
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=2.000000,Max=2.000000)
         SpinsPerSecondRange=(X=(Min=10.000000))
         StartSpinRange=(X=(Min=0.250000,Max=0.250000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=5.000000)
         StartSizeRange=(X=(Min=15.000000,Max=15.000000),Y=(Min=15.000000,Max=15.000000),Z=(Min=10.000000,Max=10.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.RedBurn'
         TextureUSubdivisions=1
         TextureVSubdivisions=1
         LifetimeRange=(Min=0.300000,Max=0.300000)
         StartVelocityRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
         StartVelocityRadialRange=(Min=-10.000000,Max=-10.000000)
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.HunterMainEffect.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         UseVelocityScale=True
         Acceleration=(Z=10.000000)
         ColorScale(0)=(Color=(B=176,G=223,R=255))
         ColorScale(1)=(RelativeTime=0.125000,Color=(B=176,G=223,R=255,A=190))
         ColorScale(2)=(RelativeTime=0.500000,Color=(B=200,G=200,R=200,A=255))
         ColorScale(3)=(RelativeTime=1.000000,Color=(B=80,G=80,R=80,A=255))
         Opacity=0.200000
         FadeInEndTime=0.500000
         CoordinateSystem=PTCS_Relative
         MaxParticles=3
         StartLocationOffset=(X=-16.000000)
         StartLocationRange=(X=(Min=-16.000000,Max=16.000000))
         SpinsPerSecondRange=(X=(Min=-0.200000,Max=0.200000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=20.000000,Max=20.000000),Y=(Min=20.000000,Max=20.000000))
         InitialParticlesPerSecond=40.000000
         Texture=Texture'2009DoomMonstersTex.Effects.BFGBlast3'
         TextureUSubdivisions=1
         TextureVSubdivisions=1
         LifetimeRange=(Min=1.000000,Max=1.000000)
         VelocityScale(1)=(RelativeTime=1.000000,RelativeVelocity=(Z=5.000000))
     End Object
     Emitters(1)=SpriteEmitter'ScrnDoom3KF.HunterMainEffect.SpriteEmitter1'

     AutoDestroy=False
}
