class HellKnightProjSmokeTrail extends DoomEmitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter16
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Acceleration=(Z=8.000000)
         ColorMultiplierRange=(X=(Min=0.160000,Max=0.160000),Y=(Min=0.200000,Max=0.200000),Z=(Min=0.180000,Max=0.180000))
         Opacity=0.200000
         FadeOutStartTime=0.800000
         FadeInEndTime=0.250000
         MaxParticles=30
         StartSpinRange=(X=(Min=6.000000,Max=12.000000))
         SizeScale(0)=(RelativeSize=10.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=23.000000)
         StartSizeRange=(X=(Min=1.000000,Max=1.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.barrelpoof'
         LifetimeRange=(Min=0.900000,Max=0.900000)
         StartVelocityRange=(X=(Min=-13.000000,Max=-21.000000))
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.HellKnightProjSmokeTrail.SpriteEmitter16'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter17
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Acceleration=(Z=8.000000)
         ColorMultiplierRange=(X=(Min=0.067000,Max=0.067000),Y=(Min=0.231000,Max=0.231000),Z=(Min=0.125000,Max=0.125000))
         FadeOutStartTime=0.500000
         FadeInEndTime=0.050000
         MaxParticles=12
         StartSpinRange=(X=(Max=90.000000))
         SizeScale(0)=(RelativeSize=10.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=20.000000)
         StartSizeRange=(X=(Min=1.000000,Max=1.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.rocketbacklit'
         LifetimeRange=(Min=0.900000,Max=0.900000)
         StartVelocityRange=(X=(Min=-13.000000,Max=-21.000000))
     End Object
     Emitters(1)=SpriteEmitter'ScrnDoom3KF.HellKnightProjSmokeTrail.SpriteEmitter17'

     Physics=PHYS_Trailer
}
