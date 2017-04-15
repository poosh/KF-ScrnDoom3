class SeekerLightFXEmitter extends DoomEmitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter5
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         AutoReset=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Opacity=0.400000
         CoordinateSystem=PTCS_Relative
         MaxParticles=4
         SizeScale(0)=(RelativeSize=0.500000)
         SizeScale(1)=(RelativeTime=0.750000,RelativeSize=4.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=6.000000)
         StartSizeRange=(X=(Min=5.000000,Max=5.000000))
         DrawStyle=PTDS_Brighten
         Texture=Texture'2009DoomMonstersTex.Seeker.grey_ring'
         LifetimeRange=(Min=1.000000,Max=1.000000)
         VelocityScale(0)=(RelativeVelocity=(X=100.000000,Y=100.000000,Z=100.000000))
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.SeekerLightFXEmitter.SpriteEmitter5'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter6
         UseColorScale=True
         UniformSize=True
         Opacity=0.600000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartSizeRange=(X=(Min=50.000000,Max=50.000000))
         Texture=Texture'2009DoomMonstersTex.Seeker.SeekerFlareLightTex'
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(1)=SpriteEmitter'ScrnDoom3KF.SeekerLightFXEmitter.SpriteEmitter6'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter7
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         AutoReset=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Opacity=0.100000
         CoordinateSystem=PTCS_Relative
         MaxParticles=4
         SizeScale(0)=(RelativeSize=0.500000)
         SizeScale(1)=(RelativeTime=0.750000,RelativeSize=4.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=6.000000)
         StartSizeRange=(X=(Min=5.000000,Max=5.000000))
         Texture=Texture'2009DoomMonstersTex.Seeker.SmoothRing'
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(2)=SpriteEmitter'ScrnDoom3KF.SeekerLightFXEmitter.SpriteEmitter7'

}
