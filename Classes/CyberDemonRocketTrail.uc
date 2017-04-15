class CyberDemonRocketTrail extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter10
         FadeOut=True
         FadeIn=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorMultiplierRange=(Y=(Min=0.720000,Max=0.720000),Z=(Min=0.550000,Max=0.550000))
         Opacity=0.600000
         FadeOutStartTime=0.650000
         FadeInEndTime=0.100000
         CoordinateSystem=PTCS_Relative
         MaxParticles=5
         StartLocationRange=(X=(Min=-2.000000,Max=2.000000),Y=(Min=-2.000000,Max=2.000000),Z=(Min=-2.000000,Max=2.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=9.000000)
         StartSizeRange=(X=(Min=1.000000,Max=1.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.Explosion2'
         LifetimeRange=(Min=0.300000,Max=0.300000)
         StartVelocityRange=(X=(Min=-21.000000,Max=-21.000000))
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.CyberDemonRocketTrail.SpriteEmitter10'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter11
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorMultiplierRange=(Y=(Min=0.960000,Max=0.960000))
         Opacity=0.300000
         FadeOutStartTime=1.000000
         FadeInEndTime=0.250000
         CoordinateSystem=PTCS_Relative
         MaxParticles=5
         StartLocationRange=(X=(Min=-2.000000,Max=2.000000),Y=(Min=-2.000000,Max=2.000000),Z=(Min=-2.000000,Max=2.000000))
         StartSpinRange=(X=(Max=100.000000))
         SizeScale(0)=(RelativeSize=1.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.500000)
         StartSizeRange=(X=(Min=6.500000,Max=6.500000))
         Texture=Texture'2009DoomMonstersTex.Effects.Explosion1'
         LifetimeRange=(Min=0.350000,Max=0.350000)
         StartVelocityRange=(X=(Min=-50.000000,Max=-50.000000))
     End Object
     Emitters(1)=SpriteEmitter'ScrnDoom3KF.CyberDemonRocketTrail.SpriteEmitter11'

     bNoDelete=False
     Physics=PHYS_Trailer
}
