class HunterBerserkEffect extends DoomEmitter;

simulated function PostBeginPlay()
{
	Emitters[0].SkeletalMeshActor = Owner;
}
simulated final function OwnerGone()
{
	Emitters[0].SkeletalMeshActor = None;
	Kill();
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         FadeOutStartTime=0.700000
         FadeInEndTime=0.100000
         MaxParticles=50
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=5.000000)
         StartSizeRange=(X=(Min=10.000000,Max=15.000000))
         UseSkeletalLocationAs=PTSU_SpawnOffset
         InitialParticlesPerSecond=100.000000
         Texture=Texture'2009DoomMonstersTex.Effects.HellCircle'
         LifetimeRange=(Min=2.000000,Max=1.000000)
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.HunterBerserkEffect.SpriteEmitter0'

     LifeSpan=5.000000
}
