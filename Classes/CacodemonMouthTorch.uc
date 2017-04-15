class CacodemonMouthTorch extends DoomEmitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         CoordinateSystem=PTCS_Relative
         MaxParticles=15
         SpinsPerSecondRange=(X=(Min=-5.000000,Max=5.000000))
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.500000)
         StartSizeRange=(X=(Min=8.000000,Max=16.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.FlashStrip3'
         TextureUSubdivisions=32
         TextureVSubdivisions=1
         LifetimeRange=(Min=0.400000,Max=0.400000)
         StartVelocityRange=(Y=(Max=80.000000),Z=(Min=-10.000000,Max=-10.000000))
         VelocityScale(0)=(RelativeVelocity=(Y=1.000000))
         VelocityScale(1)=(RelativeTime=0.800000,RelativeVelocity=(Y=1.000000))
         VelocityScale(2)=(RelativeTime=1.000000,RelativeVelocity=(Y=-10.000000))
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.CacodemonMouthTorch.SpriteEmitter3'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter4
         UseColorScale=True
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         UseVelocityScale=True
         ColorScale(0)=(Color=(B=48,G=65,R=78))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=128,G=128,R=128))
         FadeOutStartTime=0.250000
         MaxParticles=3
         SpinsPerSecondRange=(X=(Min=5.000000,Max=5.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=4.000000)
         StartSizeRange=(X=(Min=4.000000,Max=10.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.WhiteFlashStrip2'
         TextureUSubdivisions=12
         TextureVSubdivisions=1
         LifetimeRange=(Min=0.300000,Max=0.300000)
         StartVelocityRange=(X=(Min=50.000000,Max=50.000000),Y=(Min=-30.000000,Max=-30.000000),Z=(Min=10.000000,Max=10.000000))
         VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
         VelocityScale(1)=(RelativeTime=1.000000,RelativeVelocity=(X=-2.000000,Y=2.000000,Z=10.000000))
     End Object
     Emitters(1)=SpriteEmitter'ScrnDoom3KF.CacodemonMouthTorch.SpriteEmitter4'

}
