class HunterHellTimePortal extends DoomEmitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter11
         UseDirectionAs=PTDU_Scale
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseRegularSizeScale=False
         ColorScale(0)=(Color=(G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=128,G=128,R=255,A=255))
         Opacity=0.800000
         CoordinateSystem=PTCS_Relative
         MaxParticles=5
         StartLocationOffset=(Z=70.000000)
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=-10.000000,Max=10.000000)
         SpinsPerSecondRange=(X=(Min=5.000000,Max=5.000000))
         StartSizeRange=(X=(Min=200.000000,Max=200.000000),Y=(Min=150.000000,Max=150.000000),Z=(Min=1.000000,Max=1.000000))
         Texture=Texture'2009DoomMonstersTex.Symbols.FlickerFlare'
         LifetimeRange=(Min=0.500000,Max=0.500000)
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.HunterHellTimePortal.SpriteEmitter11'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter12
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorScale(1)=(RelativeTime=0.200000,Color=(B=128,G=128,R=255))
         ColorScale(2)=(RelativeTime=0.800000,Color=(G=255,R=255))
         ColorScale(3)=(RelativeTime=1.000000)
         CoordinateSystem=PTCS_Relative
         MaxParticles=6
         StartLocationOffset=(Z=70.000000)
         SpinsPerSecondRange=(X=(Max=0.100000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=200.000000,Max=300.000000))
         Texture=Texture'2009DoomMonstersTex.Sentry.BurnFlare'
         LifetimeRange=(Min=0.500000,Max=0.500000)
     End Object
     Emitters(1)=SpriteEmitter'ScrnDoom3KF.HunterHellTimePortal.SpriteEmitter12'

     AmbientGlow=150
}
