class DoomDeResDustSmall extends DoomEmitter;

simulated function PostBeginPlay()
{
	local int i;

	if( Owner!=None )
	{
		for( i=0; i<Emitters.Length; ++i )
		{
			Emitters[i].UseSkeletalLocationAs = PTSU_SpawnOffset;
			Emitters[i].SkeletalMeshActor = Owner;
		}
	}
}
simulated final function KillFX()
{
	local int i;

	for( i=0; i<Emitters.Length; ++i )
		Emitters[i].SkeletalMeshActor = None;
	Kill();
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Acceleration=(Z=8.000000)
         ColorMultiplierRange=(X=(Min=0.070000,Max=0.070000),Y=(Min=0.070000,Max=0.070000),Z=(Min=0.090000,Max=0.090000))
         Opacity=0.200000
         FadeOutStartTime=0.900000
         FadeInEndTime=0.100000
         MaxParticles=8
         StartSpinRange=(X=(Max=50.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.330000)
         StartSizeRange=(X=(Min=20.000000,Max=25.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.barrelpoof'
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.DoomDeResDustSmall.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=True
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Acceleration=(Z=10.000000)
         ColorScale(0)=(Color=(G=128,R=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(G=255,R=255))
         ColorMultiplierRange=(X=(Min=0.540000,Max=0.540000),Y=(Min=0.300000,Max=0.300000),Z=(Min=0.100000,Max=0.100000))
         FadeOutStartTime=0.100000
         StartLocationRange=(X=(Min=-15.000000,Max=15.000000),Y=(Min=-15.000000,Max=15.000000),Z=(Min=-10.000000,Max=10.000000))
         StartSpinRange=(X=(Max=-50.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.300000)
         StartSizeRange=(X=(Min=10.000000,Max=15.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.rocketbacklit'
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(Z=(Min=50.000000,Max=50.000000))
     End Object
     Emitters(1)=SpriteEmitter'ScrnDoom3KF.DoomDeResDustSmall.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         UseVelocityScale=True
         Acceleration=(Z=-100.000000)
         MaxParticles=20
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=-10.000000,Max=10.000000)
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=1.000000,Max=1.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.GlowSmall'
         LifetimeRange=(Min=2.500000,Max=3.000000)
         StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=-50.000000,Max=150.000000))
         VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=2.000000))
         VelocityScale(1)=(RelativeTime=1.000000,RelativeVelocity=(X=1.500000,Y=1.500000,Z=-5.000000))
     End Object
     Emitters(2)=SpriteEmitter'ScrnDoom3KF.DoomDeResDustSmall.SpriteEmitter2'

     Physics=PHYS_Trailer
     LifeSpan=8.000000
}
