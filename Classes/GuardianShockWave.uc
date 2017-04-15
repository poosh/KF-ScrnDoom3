class GuardianShockWave extends DoomEmitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseDirectionAs=PTDU_Normal
         UseColorScale=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         ColorScale(1)=(RelativeTime=0.200000,Color=(B=64,G=128,R=255))
         ColorScale(2)=(RelativeTime=1.000000)
         MaxParticles=2
         StartLocationShape=PTLS_Sphere
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=8.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=10.000000,Max=10.000000),Z=(Min=10.000000,Max=10.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.CacoFlare1'
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(Z=(Min=-10.000000,Max=-10.000000))
         WarmupTicksPerSecond=5.000000
         RelativeWarmupTime=0.300000
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.GuardianShockWave.SpriteEmitter0'

     Begin Object Class=MeshEmitter Name=MeshEmitter0
         StaticMesh=StaticMesh'SpecialEffectsSM.fx.fxgoal'
         UseParticleColor=True
         UseColorScale=True
         RespawnDeadParticles=False
         ZTest=False
         UseSizeScale=True
         UseRegularSizeScale=False
         ColorScale(1)=(RelativeTime=0.200000,Color=(B=98,G=176,R=255))
         ColorScale(2)=(RelativeTime=1.000000)
         FadeOutStartTime=0.500000
         MaxParticles=2
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=18.000000)
         StartSizeRange=(X=(Min=0.800000,Max=0.800000),Y=(Min=0.800000,Max=0.800000),Z=(Min=0.150000,Max=0.150000))
         LifetimeRange=(Min=1.000000,Max=1.500000)
         StartVelocityRange=(Z=(Min=-10.000000,Max=-10.000000))
         WarmupTicksPerSecond=5.000000
         RelativeWarmupTime=0.300000
     End Object
     Emitters(1)=MeshEmitter'ScrnDoom3KF.GuardianShockWave.MeshEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseDirectionAs=PTDU_Normal
         UseColorScale=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         ColorScale(1)=(RelativeTime=0.200000,Color=(B=60,G=69,R=242))
         ColorScale(2)=(RelativeTime=1.000000)
         MaxParticles=3
         StartLocationShape=PTLS_Sphere
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=15.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=10.000000,Max=10.000000),Z=(Min=10.000000,Max=10.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.BFGBlast2'
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(Z=(Min=-10.000000,Max=-10.000000))
         WarmupTicksPerSecond=5.000000
         RelativeWarmupTime=0.300000
     End Object
     Emitters(2)=SpriteEmitter'ScrnDoom3KF.GuardianShockWave.SpriteEmitter1'

     Begin Object Class=MeshEmitter Name=MeshEmitter1
         StaticMesh=StaticMesh'SpecialEffectsSM.fx.fxgoal'
         UseParticleColor=True
         UseColorScale=True
         RespawnDeadParticles=False
         ZTest=False
         UseSizeScale=True
         UseRegularSizeScale=False
         ColorScale(1)=(RelativeTime=0.200000,Color=(B=98,G=176,R=255))
         ColorScale(2)=(RelativeTime=1.000000)
         FadeOutStartTime=0.500000
         MaxParticles=2
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=10.000000)
         StartSizeRange=(X=(Min=0.100000,Max=0.100000),Y=(Min=0.100000,Max=0.100000),Z=(Min=0.050000,Max=0.050000))
         LifetimeRange=(Min=1.000000,Max=1.500000)
         StartVelocityRange=(Z=(Min=-10.000000,Max=-10.000000))
         WarmupTicksPerSecond=5.000000
         RelativeWarmupTime=0.300000
     End Object
     Emitters(3)=MeshEmitter'ScrnDoom3KF.GuardianShockWave.MeshEmitter1'

}
