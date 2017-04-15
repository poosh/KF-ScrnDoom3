class HunterHellTimeFlare extends DoomEmitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter13
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorScale(1)=(RelativeTime=0.200000,Color=(B=128,G=128,R=255))
         ColorScale(2)=(RelativeTime=0.800000,Color=(B=128,G=255,R=255))
         ColorScale(3)=(RelativeTime=1.000000)
         CoordinateSystem=PTCS_Relative
         StartLocationOffset=(Z=70.000000)
         SpinsPerSecondRange=(X=(Max=0.100000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=150.000000,Max=150.000000))
         Texture=Texture'2009DoomMonstersTex.Sentry.BurnFlare'
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.HunterHellTimeFlare.SpriteEmitter13'

     AmbientGlow=150
}
