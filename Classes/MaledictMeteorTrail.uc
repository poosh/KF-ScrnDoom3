class MaledictMeteorTrail extends DoomEmitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter42
         FadeOut=True
         FadeIn=True
         UniformSize=True
         Acceleration=(Z=-500.000000)
         ColorMultiplierRange=(Y=(Min=0.530000,Max=0.530000),Z=(Min=0.120000,Max=0.120000))
         FadeOutStartTime=0.250000
         FadeInEndTime=0.100000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartLocationRange=(X=(Min=-8.000000,Max=8.000000),Y=(Min=-8.000000,Max=8.000000))
         StartSizeRange=(X=(Min=0.500000,Max=0.500000))
         Texture=Texture'2009DoomMonstersTex.Effects.Spark_White'
         LifetimeRange=(Min=0.350000,Max=0.350000)
         StartVelocityRange=(Z=(Max=-200.000000))
         VelocityScale(1)=(RelativeTime=1.000000)
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.MaledictMeteorTrail.SpriteEmitter42'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter43
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorMultiplierRange=(Y=(Min=0.500000,Max=0.650000),Z=(Min=0.180000,Max=0.180000))
         Opacity=0.800000
         FadeOutFactor=(X=0.200000,Y=0.200000,Z=0.000000)
         FadeOutStartTime=0.200000
         FadeInFactor=(X=0.200000,Y=0.000000,Z=0.000000)
         CoordinateSystem=PTCS_Relative
         MaxParticles=7
         StartLocationRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=-5.000000,Max=5.000000))
         StartSpinRange=(X=(Min=50.000000,Max=360.000000))
         SizeScale(0)=(RelativeSize=10.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=30.000000)
         StartSizeRange=(X=(Min=1.000000,Max=1.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.CacoFlare1'
         LifetimeRange=(Min=0.750000,Max=0.750000)
         StartVelocityRange=(X=(Min=-70.000000,Max=-70.000000))
     End Object
     Emitters(1)=SpriteEmitter'ScrnDoom3KF.MaledictMeteorTrail.SpriteEmitter43'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter44
         FadeOut=True
         FadeIn=True
         UniformSize=True
         ColorMultiplierRange=(Y=(Min=0.790000,Max=0.790000),Z=(Min=0.231000,Max=0.231000))
         FadeOutStartTime=0.500000
         FadeInEndTime=0.100000
         CoordinateSystem=PTCS_Relative
         MaxParticles=3
         StartLocationRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=8.000000,Max=8.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.Dot'
         LifetimeRange=(Min=0.300000,Max=0.300000)
         StartVelocityRange=(X=(Min=-150.000000,Max=-150.000000))
     End Object
     Emitters(2)=SpriteEmitter'ScrnDoom3KF.MaledictMeteorTrail.SpriteEmitter44'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter45
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Acceleration=(Z=50.000000)
         ColorMultiplierRange=(Y=(Min=0.565000,Max=0.565000),Z=(Min=0.102000,Max=0.102000))
         Opacity=0.100000
         FadeOutFactor=(X=0.060000,Y=0.040000,Z=0.020000)
         FadeOutStartTime=1.000000
         FadeInFactor=(X=0.060000,Y=0.040000,Z=0.020000)
         FadeInEndTime=0.600000
         MaxParticles=25
         StartSpinRange=(X=(Max=90.000000))
         SizeScale(0)=(RelativeSize=10.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=40.000000)
         StartSizeRange=(X=(Min=1.000000,Max=1.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.Smokepuff3'
         LifetimeRange=(Min=0.650000,Max=0.650000)
         StartVelocityRange=(X=(Max=-300.000000))
     End Object
     Emitters(3)=SpriteEmitter'ScrnDoom3KF.MaledictMeteorTrail.SpriteEmitter45'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter15
         UseDirectionAs=PTDU_Up
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         UseVelocityScale=True
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         StartLocationRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=-5.000000,Max=5.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=0.800000,RelativeSize=0.600000)
         SizeScale(2)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=2.000000,Max=2.000000),Y=(Min=2.000000,Max=2.000000),Z=(Min=2.000000,Max=2.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.SmallTracer'
         LifetimeRange=(Min=0.400000,Max=0.400000)
         StartVelocityRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
         VelocityScale(0)=(RelativeVelocity=(X=75.000000,Y=5.000000,Z=5.000000))
         VelocityScale(1)=(RelativeTime=1.000000,RelativeVelocity=(X=-200.000000))
     End Object
     Emitters(4)=SpriteEmitter'ScrnDoom3KF.MaledictMeteorTrail.SpriteEmitter15'

     Physics=PHYS_Trailer
}
