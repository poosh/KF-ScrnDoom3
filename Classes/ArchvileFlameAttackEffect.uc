class ArchvileFlameAttackEffect extends DoomEmitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter8
         UseDirectionAs=PTDU_Normal
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(1)=(RelativeTime=0.500000,Color=(B=23,G=91,R=232))
         ColorScale(2)=(RelativeTime=1.000000)
         MaxParticles=1
         StartLocationOffset=(Z=-30.000000)
         StartLocationShape=PTLS_All
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeTime=2.000000)
         StartSizeRange=(X=(Min=125.000000,Max=125.000000))
         InitialParticlesPerSecond=5000.000000
         Texture=Texture'2009DoomMonstersTex.Symbols.SpawnBurn'
         LifetimeRange=(Min=1.000000,Max=2.000000)
         InitialDelayRange=(Min=1.500000,Max=1.500000)
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.ArchvileFlameAttackEffect.SpriteEmitter8'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter9
         FadeOut=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         UseRandomSubdivision=True
         ColorMultiplierRange=(Y=(Min=0.500000,Max=0.800000),Z=(Min=0.000000,Max=0.000000))
         FadeOutStartTime=0.200000
         MaxParticles=3
         SpinsPerSecondRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.500000,Max=0.500000))
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=15.000000,Max=15.000000),Y=(Min=15.000000,Max=15.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.FlashStrip2'
         TextureUSubdivisions=12
         TextureVSubdivisions=1
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(1)=SpriteEmitter'ScrnDoom3KF.ArchvileFlameAttackEffect.SpriteEmitter9'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter10
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         UseRevolution=True
         UseRevolutionScale=True
         SpinParticles=True
         UniformSize=True
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=22,G=106,R=233))
         FadeOutStartTime=1.000000
         StartLocationOffset=(Z=75.000000)
         RevolutionsPerSecondRange=(X=(Min=1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=10.000000,Max=10.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.HellFlare1'
         LifetimeRange=(Min=2.000000,Max=2.000000)
         StartVelocityRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         RotateVelocityLossRange=True
         VelocityScale(0)=(RelativeTime=1.000000)
     End Object
     Emitters(2)=SpriteEmitter'ScrnDoom3KF.ArchvileFlameAttackEffect.SpriteEmitter10'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter11
         FadeOut=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         UseRandomSubdivision=True
         Acceleration=(Z=25.000000)
         ColorScale(0)=(Color=(B=71,G=190,R=248))
         ColorScale(1)=(RelativeTime=1.000000)
         FadeOutStartTime=0.300000
         SizeScale(0)=(RelativeSize=1.500000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=25.000000,Max=25.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.FlashStrip2'
         TextureUSubdivisions=12
         TextureVSubdivisions=1
         LifetimeRange=(Min=0.500000,Max=1.000000)
         InitialDelayRange=(Min=1.500000,Max=1.700000)
     End Object
     Emitters(3)=SpriteEmitter'ScrnDoom3KF.ArchvileFlameAttackEffect.SpriteEmitter11'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseDirectionAs=PTDU_Up
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         UseVelocityScale=True
         ColorScale(0)=(Color=(B=5,G=134,R=250))
         ColorScale(1)=(RelativeTime=1.000000,Color=(G=255,R=255))
         FadeOutStartTime=0.120000
         FadeInEndTime=0.050000
         CoordinateSystem=PTCS_Relative
         StartLocationRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-30.000000,Max=30.000000))
         StartSizeRange=(X=(Min=5.000000,Max=10.000000),Y=(Min=25.000000,Max=50.000000),Z=(Min=25.000000,Max=50.000000))
         ScaleSizeByVelocityMax=5000.000000
         InitialParticlesPerSecond=60.000000
         Texture=Texture'2009DoomMonstersTex.Archvile.PC_buildStreaks'
         LifetimeRange=(Min=1.000000,Max=1.500000)
         StartVelocityRange=(Z=(Min=1.000000,Max=5.000000))
         VelocityScale(1)=(RelativeTime=1.000000,RelativeVelocity=(X=10.000000,Y=10.000000,Z=500.000000))
     End Object
     Emitters(4)=SpriteEmitter'ScrnDoom3KF.ArchvileFlameAttackEffect.SpriteEmitter1'

}
