class HunterInvulElecAttachmentsMedium extends DoomEmitter;

defaultproperties
{
     Begin Object Class=BeamEmitter Name=BeamEmitter6
         BeamDistanceRange=(Min=15.000000,Max=15.000000)
         DetermineEndPointBy=PTEP_Distance
         RotatingSheets=2
         LowFrequencyNoiseRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=-5.000000,Max=5.000000))
         LowFrequencyPoints=2
         HighFrequencyNoiseRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=-5.000000,Max=5.000000))
         HighFrequencyPoints=4
         BranchProbability=(Min=100.000000,Max=100.000000)
         BranchEmitter=1
         BranchSpawnAmountRange=(Min=1.000000,Max=1.000000)
         FadeOut=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorMultiplierRange=(Z=(Max=1.500000))
         Opacity=0.700000
         FadeOutStartTime=0.010000
         CoordinateSystem=PTCS_Relative
         MaxParticles=20
         SphereRadiusRange=(Min=5.000000,Max=10.000000)
         StartLocationPolarRange=(Z=(Min=-10.000000,Max=10.000000))
         StartSizeRange=(X=(Min=0.700000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.InvulLightning2'
         LifetimeRange=(Min=0.100000,Max=0.100000)
         StartVelocityRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
         VelocityScale(1)=(RelativeTime=1.000000,RelativeVelocity=(X=100.000000,Y=100.000000,Z=100.000000))
     End Object
     Emitters(0)=BeamEmitter'ScrnDoom3KF.HunterInvulElecAttachmentsMedium.BeamEmitter6'

     Begin Object Class=BeamEmitter Name=BeamEmitter7
         BeamDistanceRange=(Min=15.000000,Max=15.000000)
         DetermineEndPointBy=PTEP_Distance
         LowFrequencyNoiseRange=(X=(Min=-2.000000,Max=2.000000),Y=(Min=-2.000000,Max=2.000000),Z=(Min=-2.000000,Max=2.000000))
         LowFrequencyPoints=2
         HighFrequencyNoiseRange=(X=(Min=-2.000000,Max=2.000000),Y=(Min=-2.000000,Max=2.000000),Z=(Min=-2.000000,Max=2.000000))
         HighFrequencyPoints=3
         UseRegularSizeScale=False
         UniformSize=True
         CoordinateSystem=PTCS_Relative
         MaxParticles=20
         StartLocationShape=PTLS_Sphere
         StartSizeRange=(X=(Min=0.600000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.InvulLightning2'
         LifetimeRange=(Min=0.200000,Max=0.200000)
         StartVelocityRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=-5.000000,Max=5.000000))
     End Object
     Emitters(1)=BeamEmitter'ScrnDoom3KF.HunterInvulElecAttachmentsMedium.BeamEmitter7'

     AutoDestroy=False
}
