class LostSoulExplodeDust extends DoomEmitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter36
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Acceleration=(Z=25.000000)
         ColorMultiplierRange=(X=(Min=0.210000,Max=0.210000),Y=(Min=0.180000,Max=0.180000),Z=(Min=0.130000,Max=0.130000))
         Opacity=0.100000
         FadeOutStartTime=1.000000
         FadeInEndTime=0.250000
         CoordinateSystem=PTCS_Relative
         MaxParticles=30
         StartLocationRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=-5.000000,Max=5.000000))
         StartSpinRange=(X=(Max=90.000000))
         SizeScale(0)=(RelativeSize=14.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=35.500000)
         StartSizeRange=(X=(Min=1.000000,Max=1.000000))
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'2009DoomMonstersTex.Effects.barrelpoof'
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(Z=(Min=2.000000,Max=2.000000))
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.LostSoulExplodeDust.SpriteEmitter36'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter37
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         UniformSize=True
         Acceleration=(Z=-156.000000)
         FadeOutStartTime=0.100000
         FadeInEndTime=0.100000
         MaxParticles=5
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=10.000000,Max=10.000000)
         StartSizeRange=(X=(Min=1.000000,Max=1.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.GlowSmall'
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(1)=SpriteEmitter'ScrnDoom3KF.LostSoulExplodeDust.SpriteEmitter37'

}
