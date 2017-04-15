class SabaothChargeEffect extends DoomEmitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter7
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         FadeOutStartTime=0.500000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         SpinsPerSecondRange=(X=(Max=10.000000))
         SizeScale(0)=(RelativeTime=0.100000,RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=0.600000,RelativeSize=50.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=40.000000)
         StartSizeRange=(X=(Min=1.000000,Max=1.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.BFGBlast1'
         LifetimeRange=(Min=0.500000,Max=1.000000)
         WarmupTicksPerSecond=5.000000
         RelativeWarmupTime=1.000000
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.SabaothChargeEffect.SpriteEmitter7'

     Begin Object Class=MeshEmitter Name=MeshEmitter0
         StaticMesh=StaticMesh'2009DoomMonstersSM.BFGChargeMesh'
         UseParticleColor=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         ColorMultiplierRange=(Z=(Min=0.800000))
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         SpinsPerSecondRange=(Y=(Min=1.000000,Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=0.800000,RelativeSize=10.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=10.000000)
         StartSizeRange=(X=(Min=0.100000,Max=0.100000),Y=(Min=0.100000,Max=0.100000),Z=(Min=0.100000,Max=0.100000))
         LifetimeRange=(Min=0.500000,Max=1.000000)
         WarmupTicksPerSecond=20.000000
         RelativeWarmupTime=1.000000
     End Object
     Emitters(1)=MeshEmitter'ScrnDoom3KF.SabaothChargeEffect.MeshEmitter0'

}
