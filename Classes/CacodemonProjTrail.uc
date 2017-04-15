class CacodemonProjTrail extends DoomEmitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseDirectionAs=PTDU_Scale
         UseColorScale=True
         FadeOut=True
         UseRevolution=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         ScaleSizeXByVelocity=True
         ScaleSizeYByVelocity=True
         UseRandomSubdivision=True
         UseVelocityScale=True
         ColorScale(0)=(Color=(B=128,G=255,R=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=128,G=255,R=255))
         Opacity=0.700000
         FadeOutFactor=(W=0.000000,X=0.500000,Y=0.600000,Z=0.200000)
         FadeOutStartTime=0.400000
         CoordinateSystem=PTCS_Relative
         MaxParticles=4
         RevolutionsPerSecondRange=(Y=(Min=-0.050000,Max=0.050000),Z=(Max=0.050000))
         SpinsPerSecondRange=(X=(Min=2.000000,Max=2.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.500000)
         StartSizeRange=(X=(Min=6.000000,Max=6.000000),Y=(Min=6.000000,Max=6.000000),Z=(Min=4.000000,Max=4.000000))
         ScaleSizeByVelocityMultiplier=(X=0.090000,Y=0.100000)
         Texture=Texture'2009DoomMonstersTex.Effects.CacoFlare1'
         TextureUSubdivisions=1
         TextureVSubdivisions=1
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(X=(Min=-8.000000,Max=-8.000000))
         VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
         VelocityScale(1)=(RelativeTime=1.000000,RelativeVelocity=(X=2.000000,Y=2.000000,Z=2.000000))
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=2.000000
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.CacodemonProjTrail.SpriteEmitter0'

     Begin Object Class=BeamEmitter Name=BeamEmitter0
         BeamDistanceRange=(Min=30.000000,Max=75.000000)
         DetermineEndPointBy=PTEP_Distance
         HighFrequencyNoiseRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-4.000000,Max=4.000000),Z=(Min=-4.000000,Max=4.000000))
         HighFrequencyPoints=4
         UseColorScale=True
         ColorScale(0)=(Color=(B=132,G=194,R=251))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=166,G=194,R=255))
         Opacity=0.500000
         CoordinateSystem=PTCS_Relative
         StartLocationRange=(Y=(Min=-5.000000,Max=5.000000),Z=(Min=-5.000000,Max=5.000000))
         StartSizeRange=(X=(Min=1.000000,Max=1.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.YellowLightning2'
         LifetimeRange=(Min=0.200000,Max=0.200000)
         StartVelocityRange=(X=(Max=-1.000000))
     End Object
     Emitters(1)=BeamEmitter'ScrnDoom3KF.CacodemonProjTrail.BeamEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseDirectionAs=PTDU_Up
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         UseVelocityScale=True
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         StartLocationRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=0.800000,RelativeSize=0.600000)
         SizeScale(2)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=10.000000,Max=6.000000),Y=(Min=2.000000,Max=2.000000),Z=(Min=2.000000,Max=2.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.SmallTracer'
         LifetimeRange=(Min=0.400000,Max=0.400000)
         StartVelocityRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
         VelocityScale(0)=(RelativeVelocity=(X=75.000000,Y=5.000000,Z=5.000000))
         VelocityScale(1)=(RelativeTime=1.000000,RelativeVelocity=(X=-200.000000))
     End Object
     Emitters(2)=SpriteEmitter'ScrnDoom3KF.CacodemonProjTrail.SpriteEmitter1'

     Physics=PHYS_Trailer
}
