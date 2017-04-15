class HunterInvulBigProjErupt extends DoomEmitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter8
         FadeOut=True
         RespawnDeadParticles=False
         UniformSize=True
         UseVelocityScale=True
         StartLocationRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=-10.000000,Max=10.000000))
         StartLocationShape=PTLS_Sphere
         Texture=Texture'2009DoomMonstersTex.Effects.BlueExplosion'
         LifetimeRange=(Min=0.300000,Max=0.500000)
         StartVelocityRange=(Z=(Min=1.000000,Max=1.000000))
         VelocityScale(0)=(RelativeVelocity=(Z=1.000000))
         VelocityScale(1)=(RelativeTime=1.000000,RelativeVelocity=(Z=2000.000000))
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.HunterInvulBigProjErupt.SpriteEmitter8'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter9
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         UseRevolution=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         UseVelocityScale=True
         ColorScale(1)=(RelativeTime=0.125000)
         ColorScale(2)=(RelativeTime=0.330000,Color=(B=255,G=255,R=255,A=255))
         ColorScale(3)=(RelativeTime=0.750000,Color=(B=128,G=128,R=128,A=255))
         ColorScale(4)=(RelativeTime=1.000000,Color=(B=64,G=64,R=64))
         MaxParticles=100
         StartLocationShape=PTLS_Polar
         StartLocationPolarRange=(Y=(Min=-32768.000000,Max=32768.000000),Z=(Min=10.000000,Max=10.000000))
         RevolutionsPerSecondRange=(Z=(Min=0.500000,Max=1.000000))
         SpinsPerSecondRange=(X=(Min=1.000000,Max=1.000000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=0.400000,RelativeSize=3.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.500000)
         StartSizeRange=(X=(Min=20.000000,Max=20.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.BlueFlashStrip'
         TextureUSubdivisions=32
         TextureVSubdivisions=1
         LifetimeRange=(Min=0.500000,Max=0.500000)
         StartVelocityRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=10.000000,Max=10.000000))
         VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
         VelocityScale(1)=(RelativeTime=1.000000,RelativeVelocity=(Z=250.000000))
     End Object
     Emitters(1)=SpriteEmitter'ScrnDoom3KF.HunterInvulBigProjErupt.SpriteEmitter9'

}
