class BruiserProjTrail extends DoomEmitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         UseColorScale=True
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(RelativeTime=0.800000,Color=(B=64,G=128,R=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=64,G=128,R=255))
         ColorMultiplierRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.200000,Max=0.200000),Z=(Min=0.200000,Max=0.200000))
         FadeOutStartTime=0.800000
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         SpinsPerSecondRange=(X=(Min=1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=40.000000,Max=50.000000),Y=(Min=10.000000,Max=10.000000))
         UseSkeletalLocationAs=PTSU_Location
         SkeletalScale=(X=0.400000,Y=0.400000,Z=0.370000)
         InitialParticlesPerSecond=5000.000000
         Texture=Texture'2009DoomMonstersTex.Effects.Flare1'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.500000,Max=0.500000)
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.BruiserProjTrail.SpriteEmitter3'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter4
         SpinParticles=True
         UniformSize=True
         CoordinateSystem=PTCS_Relative
         SpinsPerSecondRange=(X=(Min=5.000000,Max=5.000000))
         StartSpinRange=(X=(Min=1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=15.000000,Max=25.000000),Y=(Min=10.000000,Max=10.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.FlashStrip3'
         TextureUSubdivisions=32
         TextureVSubdivisions=1
         LifetimeRange=(Min=0.200000,Max=0.200000)
     End Object
     Emitters(1)=SpriteEmitter'ScrnDoom3KF.BruiserProjTrail.SpriteEmitter4'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter5
         UseColorScale=True
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         UseRandomSubdivision=True
         ColorScale(0)=(Color=(B=128,G=128,R=128))
         ColorScale(1)=(RelativeTime=1.000000,Color=(G=64,R=128))
         FadeOutStartTime=0.100000
         FadeInEndTime=0.100000
         MaxParticles=30
         SpinsPerSecondRange=(X=(Min=5.000000,Max=5.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=18.000000,Max=20.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.FlashStrip3'
         TextureUSubdivisions=32
         TextureVSubdivisions=1
         LifetimeRange=(Min=0.100000,Max=0.200000)
     End Object
     Emitters(2)=SpriteEmitter'ScrnDoom3KF.BruiserProjTrail.SpriteEmitter5'

     Physics=PHYS_Trailer
}
