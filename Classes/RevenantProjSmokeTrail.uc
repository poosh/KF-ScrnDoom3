class RevenantProjSmokeTrail extends DoomEmitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter6
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Acceleration=(Z=8.000000)
         ColorMultiplierRange=(X=(Min=0.040000,Max=0.040000),Y=(Min=0.035000,Max=0.035000),Z=(Min=0.030000,Max=0.030000))
         FadeOutFactor=(X=0.100000,Y=0.100000,Z=0.100000)
         FadeOutStartTime=1.000000
         FadeInFactor=(X=0.100000,Y=0.100000,Z=0.100000)
         FadeInEndTime=0.750000
         MaxParticles=30
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=2.000000,Max=2.000000)
         StartSpinRange=(X=(Max=10.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=24.000000)
         StartSizeRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=10.000000,Max=10.000000),Z=(Min=5.000000,Max=5.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.barrelpoof'
         LifetimeRange=(Min=1.200000,Max=1.200000)
         StartVelocityRange=(X=(Min=-31.000000,Max=-13.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartVelocityRadialRange=(Min=-10.000000,Max=-10.000000)
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.RevenantProjSmokeTrail.SpriteEmitter6'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter7
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseVelocityScale=True
         Acceleration=(Z=8.000000)
         ColorMultiplierRange=(X=(Min=0.280000,Max=0.280000),Y=(Min=0.027000,Max=0.027000),Z=(Min=0.000000,Max=0.000000))
         Opacity=0.600000
         FadeOutStartTime=0.500000
         FadeInEndTime=0.100000
         MaxParticles=40
         StartLocationRange=(X=(Min=-3.000000,Max=3.000000),Y=(Min=-3.000000,Max=3.000000),Z=(Min=-3.000000,Max=3.000000))
         SpinsPerSecondRange=(X=(Min=-0.200000,Max=0.200000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=5.000000,Max=5.000000),Y=(Min=20.000000,Max=20.000000))
         InitialParticlesPerSecond=40.000000
         Texture=Texture'2009DoomMonstersTex.Effects.rocketbacklit'
         TextureUSubdivisions=1
         TextureVSubdivisions=1
         LifetimeRange=(Min=1.200000,Max=1.200000)
         StartVelocityRange=(X=(Min=-13.000000,Max=-13.000000))
         VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
         VelocityScale(1)=(RelativeTime=1.000000,RelativeVelocity=(X=5.000000,Y=1.000000,Z=1.000000))
     End Object
     Emitters(1)=SpriteEmitter'ScrnDoom3KF.RevenantProjSmokeTrail.SpriteEmitter7'

     Physics=PHYS_Trailer
}
