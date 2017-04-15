class MancubusSmokeTrail Extends DoomEmitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorMultiplierRange=(X=(Min=0.050000,Max=0.050000),Y=(Min=0.500000,Max=0.500000),Z=(Min=0.800000,Max=0.800000))
         FadeOutStartTime=0.200000
         MaxParticles=20
         StartSpinRange=(X=(Max=200.000000))
         SizeScale(0)=(RelativeSize=10.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=20.000000)
         StartSizeRange=(X=(Min=1.000000,Max=1.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.PlasmaBlast'
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.MancubusSmokeTrail.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorMultiplierRange=(X=(Min=0.670000,Max=0.670000),Y=(Min=0.980000,Max=0.980000),Z=(Min=0.890000,Max=0.890000))
         Opacity=0.300000
         FadeOutStartTime=0.200000
         MaxParticles=15
         StartSpinRange=(X=(Max=90.000000))
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=75.000000)
         StartSizeRange=(X=(Min=1.000000,Max=1.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.Flare2'
         LifetimeRange=(Min=0.500000,Max=0.500000)
     End Object
     Emitters(1)=SpriteEmitter'ScrnDoom3KF.MancubusSmokeTrail.SpriteEmitter3'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter4
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorMultiplierRange=(X=(Min=0.040000,Max=0.040000),Y=(Min=0.390000,Max=0.390000),Z=(Min=0.640000,Max=0.640000))
         Opacity=0.100000
         FadeOutStartTime=0.500000
         FadeInEndTime=0.200000
         StartSpinRange=(X=(Max=90.000000))
         SizeScale(0)=(RelativeSize=2.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=40.000000)
         StartSizeRange=(X=(Min=1.000000,Max=1.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.Billow_Glow'
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(Z=(Min=-50.000000,Max=-50.000000))
     End Object
     Emitters(2)=SpriteEmitter'ScrnDoom3KF.MancubusSmokeTrail.SpriteEmitter4'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter5
         FadeOut=True
         FadeIn=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorMultiplierRange=(X=(Min=0.500000,Max=0.500000),Z=(Min=0.700000,Max=0.700000))
         Opacity=0.100000
         FadeOutStartTime=0.500000
         FadeInEndTime=0.150000
         MaxParticles=5
         SizeScale(0)=(RelativeSize=10.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=1.000000,Max=1.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.FBeam'
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(Z=(Min=-10.000000,Max=-10.000000))
     End Object
     Emitters(3)=SpriteEmitter'ScrnDoom3KF.MancubusSmokeTrail.SpriteEmitter5'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter6
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorMultiplierRange=(X=(Min=0.500000,Max=0.500000),Z=(Min=0.770000,Max=0.770000))
         Opacity=0.500000
         FadeOutStartTime=0.500000
         FadeInEndTime=0.150000
         MaxParticles=5
         StartSpinRange=(X=(Max=90.000000))
         SizeScale(0)=(RelativeSize=10.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=1.000000,Max=1.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.Explosion2'
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(Z=(Min=-10.000000,Max=-10.000000))
     End Object
     Emitters(4)=SpriteEmitter'ScrnDoom3KF.MancubusSmokeTrail.SpriteEmitter6'

     Physics=PHYS_Trailer
}
