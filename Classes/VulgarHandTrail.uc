class VulgarHandTrail extends DoomEmitter;

simulated function Tick( float Delta )
{
	LightBrightness = Min(171,LightBrightness+Delta*200.f);
	if( LightBrightness==171 )
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
         ColorScale(0)=(Color=(B=192,G=252,R=143))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=177,G=241,R=46))
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
         Texture=Texture'2009DoomMonstersTex.Effects.WhiteFlashStrip3'
         TextureUSubdivisions=32
         TextureVSubdivisions=1
         LifetimeRange=(Min=0.400000,Max=0.800000)
         StartVelocityRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-20.000000,Max=20.000000),Z=(Min=-20.000000,Max=20.000000))
         StartVelocityRadialRange=(Min=-10.000000,Max=-10.000000)
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.VulgarHandTrail.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=10.000000)
         ColorScale(0)=(Color=(B=217,G=254,R=129))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=170,G=251,R=117,A=190))
         FadeOutStartTime=0.050000
         FadeInEndTime=0.500000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartLocationShape=PTLS_Sphere
         SpinsPerSecondRange=(X=(Min=-0.200000,Max=0.200000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=10.000000,Max=10.000000))
         InitialParticlesPerSecond=40.000000
         Texture=Texture'2009DoomMonstersTex.Effects.WhiteFlashStrip2'
         TextureUSubdivisions=12
         TextureVSubdivisions=1
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(1)=SpriteEmitter'ScrnDoom3KF.VulgarHandTrail.SpriteEmitter1'

     Begin Object Class=BeamEmitter Name=BeamEmitter0
         BeamEndPoints(0)=(Weight=1.000000)
         UseHighFrequencyScale=True
         UseLowFrequencyScale=True
         UseColorScale=True
         RespawnDeadParticles=False
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=145,G=239,R=16))
         StartSizeRange=(X=(Min=1.000000,Max=2.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.LightningBolt4'
         LifetimeRange=(Min=0.500000,Max=1.000000)
         StartVelocityRange=(X=(Min=-25.000000,Max=25.000000),Y=(Min=-25.000000,Max=25.000000),Z=(Min=-25.000000,Max=25.000000))
     End Object
     Emitters(2)=BeamEmitter'ScrnDoom3KF.VulgarHandTrail.BeamEmitter0'

     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=127
     LightSaturation=85
     LightRadius=4.000000
     bDynamicLight=True
     LifeSpan=3.000000
}
