class CyberDemonMouthEffect extends DoomEmitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         UseRandomSubdivision=True
         ColorMultiplierRange=(X=(Min=0.920000,Max=0.920000),Y=(Min=0.900000,Max=0.900000))
         FadeOutStartTime=0.065000
         CoordinateSystem=PTCS_Relative
         MaxParticles=15
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=-2.000000,Max=2.000000)
         StartSpinRange=(X=(Min=8.000000,Max=13.000000))
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=15.000000)
         StartSizeRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=10.000000,Max=10.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.boomboom3'
         LifetimeRange=(Min=0.250000,Max=0.250000)
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.CyberDemonMouthEffect.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         UseRandomSubdivision=True
         ColorMultiplierRange=(Y=(Min=0.840000,Max=0.840000),Z=(Min=0.820000,Max=0.820000))
         Opacity=0.800000
         FadeOutFactor=(X=0.000000,Y=0.000000,Z=0.000000)
         FadeOutStartTime=0.450000
         CoordinateSystem=PTCS_Relative
         MaxParticles=3
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=-2.000000,Max=2.000000)
         StartSpinRange=(X=(Min=61.000000,Max=50.000000))
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=14.500000)
         StartSizeRange=(X=(Min=1.500000,Max=1.500000))
         Texture=Texture'2009DoomMonstersTex.Effects.Explosion2'
         LifetimeRange=(Min=0.250000,Max=0.250000)
     End Object
     Emitters(1)=SpriteEmitter'ScrnDoom3KF.CyberDemonMouthEffect.SpriteEmitter1'

}
