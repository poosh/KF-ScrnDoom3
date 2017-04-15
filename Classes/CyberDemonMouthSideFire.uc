class CyberDemonMouthSideFire extends DoomEmitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UniformSize=True
         Acceleration=(Z=40.000000)
         ColorMultiplierRange=(X=(Min=0.300000,Max=0.300000),Y=(Min=0.200000,Max=0.200000),Z=(Min=0.100000,Max=0.100000))
         Opacity=0.600000
         FadeOutStartTime=0.400000
         FadeInEndTime=0.100000
         CoordinateSystem=PTCS_Relative
         MaxParticles=4
         StartLocationRange=(X=(Min=-2.000000,Max=2.000000),Y=(Min=-2.000000,Max=2.000000),Z=(Min=-2.000000,Max=2.000000))
         StartSpinRange=(X=(Min=-100.000000,Max=60.000000))
         StartSizeRange=(X=(Min=4.000000,Max=4.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.barrelpoof'
         LifetimeRange=(Min=0.700000,Max=0.700000)
         StartVelocityRange=(X=(Min=50.000000,Max=50.000000))
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.CyberDemonMouthSideFire.SpriteEmitter3'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UniformSize=True
         Acceleration=(Z=50.000000)
         Opacity=0.600000
         FadeOutStartTime=0.100000
         FadeInEndTime=0.900000
         CoordinateSystem=PTCS_Relative
         StartLocationRange=(X=(Min=-2.000000,Max=2.000000),Y=(Min=-2.000000),Z=(Min=-2.000000,Max=2.000000))
         StartSpinRange=(X=(Max=20.000000))
         StartSizeRange=(X=(Min=4.000000,Max=4.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.boomboom3'
         LifetimeRange=(Min=0.500000,Max=0.500000)
         StartVelocityRange=(X=(Min=50.000000,Max=50.000000))
     End Object
     Emitters(1)=SpriteEmitter'ScrnDoom3KF.CyberDemonMouthSideFire.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter4
         UseDirectionAs=PTDU_Up
         FadeOut=True
         FadeIn=True
         UniformSize=True
         ScaleSizeYByVelocity=True
         Acceleration=(Z=50.000000)
         FadeOutStartTime=0.100000
         FadeInEndTime=1.000000
         CoordinateSystem=PTCS_Relative
         MaxParticles=3
         StartSizeRange=(X=(Min=1.000000,Max=1.000000))
         ScaleSizeByVelocityMultiplier=(Y=0.070000)
         Texture=Texture'2009DoomMonstersTex.Effects.SmallTracer'
         LifetimeRange=(Min=0.300000,Max=0.300000)
         StartVelocityRange=(X=(Min=50.000000,Max=50.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
     End Object
     Emitters(2)=SpriteEmitter'ScrnDoom3KF.CyberDemonMouthSideFire.SpriteEmitter4'

}
