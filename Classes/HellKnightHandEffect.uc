class HellKnightHandEffect extends DoomEmitter;

simulated function Tick( float Delta )
{
	LightBrightness = Min(169,LightBrightness+Delta*200.f);
	if( LightBrightness==169 )
		Disable('Tick');
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         UseRandomSubdivision=True
         ColorScale(0)=(Color=(B=255,G=223,R=140))
         ColorScale(1)=(RelativeTime=0.200000,Color=(B=206,G=255,R=254))
         ColorScale(2)=(RelativeTime=1.000000,Color=(B=151,G=232,R=255))
         FadeOutStartTime=0.200000
         FadeInEndTime=0.050000
         CoordinateSystem=PTCS_Relative
         MaxParticles=5
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=2.000000,Max=2.000000)
         StartSpinRange=(X=(Min=0.250000,Max=0.250000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.500000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=10.000000,Max=10.000000),Z=(Min=5.000000,Max=5.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.BFGGlowTex'
         LifetimeRange=(Min=0.400000,Max=0.800000)
         StartVelocityRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-20.000000,Max=20.000000),Z=(Min=-20.000000,Max=20.000000))
         StartVelocityRadialRange=(Min=-10.000000,Max=-10.000000)
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.HellKnightHandEffect.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=10.000000)
         ColorScale(0)=(Color=(B=128,G=255,R=255))
         ColorScale(1)=(RelativeTime=0.500000,Color=(B=176,G=223,R=255,A=190))
         FadeOutStartTime=0.050000
         FadeInEndTime=0.500000
         CoordinateSystem=PTCS_Relative
         StartLocationShape=PTLS_Sphere
         SpinsPerSecondRange=(X=(Min=-0.200000,Max=0.200000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=10.000000,Max=10.000000))
         InitialParticlesPerSecond=40.000000
         Texture=Texture'2009DoomMonstersTex.Effects.GreenFlashStrip'
         TextureUSubdivisions=32
         TextureVSubdivisions=1
         LifetimeRange=(Min=1.000000,Max=1.200000)
     End Object
     Emitters(1)=SpriteEmitter'ScrnDoom3KF.HellKnightHandEffect.SpriteEmitter1'

     Begin Object Class=BeamEmitter Name=BeamEmitter0
         BeamEndPoints(0)=(Weight=1.000000)
         UseHighFrequencyScale=True
         UseLowFrequencyScale=True
         UseColorScale=True
         RespawnDeadParticles=False
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=10,G=86,R=245))
         CoordinateSystem=PTCS_Relative
         StartSizeRange=(X=(Min=1.000000,Max=2.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.GreenBolt'
         LifetimeRange=(Min=0.500000,Max=1.000000)
         StartVelocityRange=(X=(Min=-25.000000,Max=25.000000),Y=(Min=-25.000000,Max=25.000000),Z=(Min=-25.000000,Max=25.000000))
     End Object
     Emitters(2)=BeamEmitter'ScrnDoom3KF.HellKnightHandEffect.BeamEmitter0'

     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=106
     LightSaturation=104
     LightRadius=4.000000
     bDynamicLight=True
     LifeSpan=3.000000
}
