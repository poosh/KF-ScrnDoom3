class GuardianFireBallTrail extends DoomEmitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter6
         FadeOut=True
         FadeIn=True
         UseRevolution=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         UseRandomSubdivision=True
         Acceleration=(Z=50.000000)
         FadeOutStartTime=0.200000
         FadeInEndTime=0.100000
         CoordinateSystem=PTCS_Relative
         MaxParticles=20
         StartLocationPolarRange=(Y=(Min=20.000000),Z=(Min=20.000000,Max=20.000000))
         RevolutionsPerSecondRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000))
         SpinsPerSecondRange=(X=(Min=0.500000,Max=0.500000))
         StartSpinRange=(X=(Min=120.000000,Max=50.000000))
         SizeScale(0)=(RelativeSize=0.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=40.000000,Max=40.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.BigFire2'
         TextureUSubdivisions=1
         TextureVSubdivisions=1
         LifetimeRange=(Min=0.750000,Max=0.750000)
         StartVelocityRadialRange=(Min=-50.000000,Max=50.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.GuardianFireBallTrail.SpriteEmitter6'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter8
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Acceleration=(Z=31.000000)
         Opacity=0.400000
         FadeOutStartTime=0.650000
         FadeInEndTime=1.000000
         MaxParticles=12
         StartLocationOffset=(Z=-10.000000)
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=-20.000000,Max=20.000000)
         StartSpinRange=(X=(Min=85.000000,Max=50.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=19.000000,Max=19.000000))
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'2009DoomMonstersTex.Effects.Dust01'
         LifetimeRange=(Min=1.550000,Max=1.550000)
     End Object
     Emitters(1)=SpriteEmitter'ScrnDoom3KF.GuardianFireBallTrail.SpriteEmitter8'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter9
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         FadeOutStartTime=0.150000
         FadeInEndTime=0.200000
         CoordinateSystem=PTCS_Relative
         MaxParticles=15
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=-10.000000,Max=10.000000)
         StartSpinRange=(X=(Min=2.000000,Max=100.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=5.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.BigFire2'
         LifetimeRange=(Min=1.200000,Max=1.200000)
     End Object
     Emitters(2)=SpriteEmitter'ScrnDoom3KF.GuardianFireBallTrail.SpriteEmitter9'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter10
         FadeOut=True
         FadeIn=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Acceleration=(Z=38.000000)
         FadeOutStartTime=0.400000
         FadeInEndTime=0.200000
         MaxParticles=20
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=-50.000000,Max=50.000000)
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=1.000000,Max=1.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.GlowSmall'
         LifetimeRange=(Min=2.000000,Max=2.000000)
         StartVelocityRange=(Z=(Min=0.700000,Max=0.700000))
     End Object
     Emitters(3)=SpriteEmitter'ScrnDoom3KF.GuardianFireBallTrail.SpriteEmitter10'

     Physics=PHYS_Trailer
}
