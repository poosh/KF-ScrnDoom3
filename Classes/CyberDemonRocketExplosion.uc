class CyberDemonRocketExplosion extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter55
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         ColorScale(0)=(Color=(B=128,G=255,R=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=128,G=255,R=255))
         MaxParticles=3
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Max=10.000000)
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=6.000000)
         StartSizeRange=(X=(Min=20.000000,Max=30.000000),Y=(Min=60.000000,Max=80.000000),Z=(Min=60.000000,Max=80.000000))
         InitialParticlesPerSecond=2500.000000
         Texture=Texture'2009DoomMonstersTex.Effects.WhiteFlashStrip3'
         TextureUSubdivisions=32
         TextureVSubdivisions=1
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.100000,Max=0.200000)
         StartVelocityRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.CyberDemonRocketExplosion.SpriteEmitter55'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter56
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         Acceleration=(Z=15.000000)
         ColorMultiplierRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.200000,Max=0.200000),Z=(Min=0.200000,Max=0.200000))
         FadeOutStartTime=0.200000
         FadeInEndTime=0.100000
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Max=50.000000)
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=40.000000,Max=50.000000))
         InitialParticlesPerSecond=500.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'kf_fx_trip_t.Misc.smoke_animated'
         TextureUSubdivisions=8
         TextureVSubdivisions=8
         LifetimeRange=(Max=6.000000)
         StartVelocityRange=(X=(Min=-80.000000,Max=80.000000),Y=(Min=-80.000000,Max=80.000000),Z=(Min=-80.000000,Max=80.000000))
         VelocityLossRange=(X=(Min=0.700000,Max=1.000000),Y=(Min=0.700000,Max=1.000000),Z=(Min=0.500000,Max=1.000000))
     End Object
     Emitters(1)=SpriteEmitter'ScrnDoom3KF.CyberDemonRocketExplosion.SpriteEmitter56'

     AutoDestroy=True
     bNoDelete=False
     LifeSpan=5.000000
}
