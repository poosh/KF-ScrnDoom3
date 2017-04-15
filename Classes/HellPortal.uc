class HellPortal extends DoomEmitter;

simulated function PostBeginPlay()
{
	Spawn(class'WraithTeleportScorch',,,Location+vect(0,0,10));
	Super.PostBeginPlay();
	SetTimer(2.00,false);
}
simulated function Timer()
{
	Emitters[0].RespawnDeadParticles = false;
	Emitters[1].RespawnDeadParticles = false;
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseDirectionAs=PTDU_Scale
         UseColorScale=True
         UseRegularSizeScale=False
         ColorScale(0)=(Color=(B=255,G=255,R=255))
         ColorScale(1)=(RelativeTime=0.200000,Color=(G=255,R=255,A=255))
         ColorScale(2)=(RelativeTime=0.800000,Color=(G=128,R=255,A=255))
         ColorScale(3)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255))
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         StartSizeRange=(X=(Min=25.000000,Max=40.000000),Y=(Min=150.000000,Max=150.000000),Z=(Min=1.000000,Max=1.000000))
         Texture=Texture'2009DoomMonstersTex.Symbols.FlickerFlare'
         LifetimeRange=(Min=0.200000,Max=0.200000)
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.HellPortal.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorScale(1)=(RelativeTime=0.200000,Color=(G=128,R=255))
         ColorScale(2)=(RelativeTime=0.800000,Color=(R=255))
         ColorScale(3)=(RelativeTime=1.000000)
         CoordinateSystem=PTCS_Relative
         MaxParticles=6
         SpinsPerSecondRange=(X=(Max=0.100000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=75.000000,Max=75.000000))
         Texture=Texture'2009DoomMonstersTex.Sentry.BurnFlare'
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(1)=SpriteEmitter'ScrnDoom3KF.HellPortal.SpriteEmitter1'

     LifeSpan=4.200000
     AmbientGlow=150
     TransientSoundVolume=1.000000
     TransientSoundRadius=700.000000
}
