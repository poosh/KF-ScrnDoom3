class HunterInvulHandBeams extends DoomEmitter;

defaultproperties
{
     Begin Object Class=BeamEmitter Name=BeamEmitter0
         BeamDistanceRange=(Min=20.000000,Max=100.000000)
         DetermineEndPointBy=PTEP_Distance
         HighFrequencyNoiseRange=(X=(Max=8.000000),Y=(Max=8.000000),Z=(Max=8.000000))
         UseSizeScale=True
         UseRegularSizeScale=False
         CoordinateSystem=PTCS_Relative
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=5.000000,Max=10.000000)
         StartLocationPolarRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=0.500000,Max=1.500000),Y=(Min=0.500000,Max=0.500000),Z=(Min=0.500000,Max=0.500000))
         Texture=Texture'2009DoomMonstersTex.Effects.InvulLightning2'
         LifetimeRange=(Min=0.100000,Max=0.300000)
         StartVelocityRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=1.000000,Max=1.000000))
     End Object
     Emitters(0)=BeamEmitter'ScrnDoom3KF.HunterInvulHandBeams.BeamEmitter0'

     LifeSpan=1.000000
}
