class ImpFireBallTrail extends DoomEmitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter22
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Acceleration=(Z=5.000000)
         ColorMultiplierRange=(X=(Min=0.970000,Max=0.970000),Y=(Min=0.500000,Max=0.500000),Z=(Min=0.180000,Max=0.180000))
         Opacity=0.500000
         FadeOutStartTime=1.000000
         CoordinateSystem=PTCS_Relative
         StartLocationRange=(X=(Min=-2.000000,Max=2.000000),Y=(Min=-2.000000,Max=2.000000),Z=(Min=-2.000000,Max=2.000000))
         StartSpinRange=(X=(Max=90.000000))
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=17.500000)
         StartSizeRange=(X=(Min=1.000000,Max=1.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.Smokepuff'
         LifetimeRange=(Min=0.350000,Max=0.350000)
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.ImpFireBallTrail.SpriteEmitter22'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter23
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorMultiplierRange=(X=(Min=0.320000,Max=0.320000),Y=(Min=0.040000,Max=0.040000),Z=(Min=0.040000,Max=0.040000))
         Opacity=0.500000
         FadeOutStartTime=0.200000
         FadeInEndTime=1.000000
         CoordinateSystem=PTCS_Relative
         StartSpinRange=(X=(Max=90.000000))
         SizeScale(0)=(RelativeSize=20.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=1.000000,Max=1.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.Billow_Glow'
         LifetimeRange=(Min=0.200000,Max=0.200000)
     End Object
     Emitters(1)=SpriteEmitter'ScrnDoom3KF.ImpFireBallTrail.SpriteEmitter23'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter24
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorMultiplierRange=(X=(Min=0.400000,Max=0.400000),Y=(Min=0.090000,Max=0.090000),Z=(Min=0.000000,Max=0.000000))
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         SizeScale(0)=(RelativeSize=27.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=22.000000)
         StartSizeRange=(X=(Min=1.000000,Max=1.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.FBeam'
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(2)=SpriteEmitter'ScrnDoom3KF.ImpFireBallTrail.SpriteEmitter24'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter25
         UniformSize=True
         ColorMultiplierRange=(X=(Min=0.400000,Max=0.400000),Y=(Min=0.090000,Max=0.090000),Z=(Min=0.000000,Max=0.000000))
         Opacity=0.400000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartSizeRange=(X=(Min=30.000000,Max=30.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.Vp1'
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(3)=SpriteEmitter'ScrnDoom3KF.ImpFireBallTrail.SpriteEmitter25'

     Physics=PHYS_Trailer
}
