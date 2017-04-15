class HunterChargeEffect extends DoomEmitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseDirectionAs=PTDU_Normal
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         UseVelocityScale=True
         Opacity=0.400000
         FadeOutStartTime=0.500000
         FadeInEndTime=1.000000
         CoordinateSystem=PTCS_Relative
         MaxParticles=50
         SpinsPerSecondRange=(X=(Max=10.000000))
         SizeScale(0)=(RelativeSize=10.000000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=40.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.HellCircle'
         LifetimeRange=(Min=0.200000,Max=2.000000)
         StartVelocityRange=(Z=(Min=1.000000,Max=1.000000))
         VelocityScale(1)=(RelativeTime=1.000000,RelativeVelocity=(Z=50.000000))
         WarmupTicksPerSecond=5.000000
         RelativeWarmupTime=1.000000
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.HunterChargeEffect.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         UseDirectionAs=PTDU_Right
         UseColorScale=True
         RespawnDeadParticles=False
         UseRevolution=True
         UseRegularSizeScale=False
         UniformSize=True
         DetermineVelocityByLocationDifference=True
         ScaleSizeXByVelocity=True
         UseVelocityScale=True
         ColorScale(1)=(RelativeTime=0.400000,Color=(G=128,R=255))
         ColorScale(2)=(RelativeTime=0.600000,Color=(R=255))
         ColorScale(3)=(RelativeTime=1.000000)
         Opacity=0.300000
         MaxParticles=300
         StartLocationShape=PTLS_Polar
         StartLocationPolarRange=(Y=(Min=16834.000000,Max=16384.000000),Z=(Min=30.000000,Max=30.000000))
         RevolutionsPerSecondRange=(Z=(Min=-1.000000,Max=1.000000))
         SpinCCWorCW=(X=0.000000,Y=0.000000,Z=0.000000)
         SpinsPerSecondRange=(X=(Min=10.000000,Max=10.000000))
         SizeScale(0)=(RelativeSize=0.500000)
         SizeScale(1)=(RelativeTime=0.200000,RelativeSize=1.000000)
         SizeScale(2)=(RelativeTime=0.400000,RelativeSize=0.800000)
         SizeScale(3)=(RelativeTime=0.600000,RelativeSize=1.000000)
         SizeScale(4)=(RelativeTime=0.800000,RelativeSize=3.000000)
         SizeScale(5)=(RelativeTime=1.000000,RelativeSize=0.800000)
         StartSizeRange=(X=(Min=5.000000,Max=5.000000))
         ScaleSizeByVelocityMultiplier=(X=0.010000)
         Texture=Texture'2009DoomMonstersTex.Effects.WhiteBurn'
         TextureUSubdivisions=1
         TextureVSubdivisions=1
         LifetimeRange=(Min=0.500000,Max=1.000000)
         StartVelocityRange=(Z=(Min=0.500000,Max=1.200000))
         StartVelocityRadialRange=(Min=5.000000,Max=-5.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
         VelocityScale(0)=(RelativeVelocity=(Z=1.000000))
         VelocityScale(1)=(RelativeTime=0.600000,RelativeVelocity=(Z=50.000000))
         VelocityScale(2)=(RelativeTime=1.000000,RelativeVelocity=(Z=-500.000000))
     End Object
     Emitters(1)=SpriteEmitter'ScrnDoom3KF.HunterChargeEffect.SpriteEmitter3'

     LifeSpan=5.000000
}
