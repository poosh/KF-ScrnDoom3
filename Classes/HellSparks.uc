class HellSparks extends DoomEmitter;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetTimer(2.00,false);
}
simulated function Timer()
{
	Emitters[0].RespawnDeadParticles = false;
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=True
         FadeIn=True
         SpinParticles=True
         UseSizeScale=True
         UniformSize=True
         UseRandomSubdivision=True
         UseVelocityScale=True
         Acceleration=(Z=-100.000000)
         ColorScale(1)=(RelativeTime=0.200000,Color=(G=128,R=255))
         ColorScale(2)=(RelativeTime=0.500000,Color=(G=255,R=255))
         ColorScale(3)=(RelativeTime=1.000000)
         MaxParticles=50
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=-20.000000,Max=20.000000)
         SpinsPerSecondRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=2.000000,Max=2.000000))
         Texture=Texture'2009DoomMonstersTex.Symbols.SpawnSymbols'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=2.000000,Max=2.000000)
         StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=-50.000000,Max=150.000000))
         StartVelocityRadialRange=(Min=1000.000000,Max=1000.000000)
         VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=2.000000))
         VelocityScale(1)=(RelativeTime=1.000000,RelativeVelocity=(X=1.500000,Y=1.500000,Z=-5.000000))
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.HellSparks.SpriteEmitter0'

     LifeSpan=4.000000
     AmbientGlow=150
}
