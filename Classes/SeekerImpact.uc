class SeekerImpact extends DoomEmitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         ColorMultiplierRange=(Y=(Min=0.800000,Max=0.800000),Z=(Min=0.700000,Max=0.700000))
         MaxParticles=3
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Max=10.000000)
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=85.000000,Max=95.000000),Y=(Min=60.000000,Max=80.000000),Z=(Min=60.000000,Max=80.000000))
         InitialParticlesPerSecond=10.000000
         Texture=Texture'2009DoomMonstersTex.Effects.WhiteFlashStrip3'
         TextureUSubdivisions=32
         TextureVSubdivisions=1
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.600000,Max=0.800000)
         StartVelocityRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.SeekerImpact.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         FadeOut=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         MaxParticles=5
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=75.000000)
         StartSizeRange=(X=(Min=1.000000,Max=1.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.BFGBallBlast'
         LifetimeRange=(Min=0.600000,Max=0.800000)
     End Object
     Emitters(1)=SpriteEmitter'ScrnDoom3KF.SeekerImpact.SpriteEmitter1'

}
