class SabaothProjTrail extends DoomEmitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=130,G=20,R=91,A=255))
         ColorScale(1)=(RelativeTime=0.400000,Color=(B=145,G=80,R=110))
         ColorScale(2)=(RelativeTime=0.800000,Color=(B=72,G=50,R=133))
         ColorScale(3)=(RelativeTime=1.000000)
         ColorMultiplierRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.500000,Max=0.500000),Z=(Min=0.500000,Max=0.500000))
         FadeOutStartTime=0.005000
         CoordinateSystem=PTCS_Relative
         MaxParticles=3
         StartLocationRange=(X=(Min=-3.000000,Max=3.000000),Y=(Min=-3.000000,Max=3.000000),Z=(Min=-3.000000,Max=3.000000))
         RevolutionsPerSecondRange=(X=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
         SpinsPerSecondRange=(X=(Min=10.000000,Max=50.000000))
         StartSizeRange=(X=(Min=20.000000,Max=50.000000),Y=(Min=10.000000,Max=10.000000))
         UseSkeletalLocationAs=PTSU_Location
         SkeletalScale=(X=0.400000,Y=0.400000,Z=0.370000)
         InitialParticlesPerSecond=5000.000000
         Texture=Texture'2009DoomMonstersTex.Effects.BFGFlare2Tex'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=2.000000)
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.SabaothProjTrail.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         SpinParticles=True
         UniformSize=True
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartSpinRange=(X=(Min=-100.000000,Max=100.000000))
         StartSizeRange=(X=(Min=28.000000,Max=30.000000),Y=(Min=10.000000,Max=10.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.BFGFlare2Tex'
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(1)=SpriteEmitter'ScrnDoom3KF.SabaothProjTrail.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseColorScale=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorScale(0)=(Color=(B=20,G=100,R=100,A=100))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=50,G=50,R=100,A=100))
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         SpinsPerSecondRange=(X=(Min=1.000000,Max=2.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.850000)
         StartSizeRange=(X=(Min=20.000000,Max=20.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.Mystic'
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(2)=SpriteEmitter'ScrnDoom3KF.SabaothProjTrail.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         UniformSize=True
         ColorMultiplierRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.500000,Max=0.500000),Z=(Min=0.500000,Max=0.500000))
         MaxParticles=1
         StartSizeRange=(X=(Min=55.000000,Max=55.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.BFGGlowTex'
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(3)=SpriteEmitter'ScrnDoom3KF.SabaothProjTrail.SpriteEmitter3'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter4
         ProjectionNormal=(Z=0.000000)
         FadeOut=True
         UniformSize=True
         UseRandomSubdivision=True
         ColorMultiplierRange=(X=(Min=0.300000,Max=0.300000),Y=(Min=0.300000,Max=0.300000),Z=(Min=0.300000,Max=0.300000))
         CoordinateSystem=PTCS_Relative
         RevolutionCenterOffsetRange=(Z=(Min=-5.000000,Max=-5.000000))
         RevolutionsPerSecondRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000))
         SpinsPerSecondRange=(X=(Min=1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=46.000000,Max=46.000000),Y=(Min=45.000000,Max=45.000000),Z=(Min=45.000000,Max=45.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.BFGStrip'
         TextureUSubdivisions=12
         TextureVSubdivisions=1
         SubdivisionStart=1
         SubdivisionEnd=12
         LifetimeRange=(Min=0.300000,Max=0.500000)
         VelocityScale(1)=(RelativeTime=1.000000,RelativeVelocity=(X=100.000000,Y=10.000000,Z=10.000000))
     End Object
     Emitters(4)=SpriteEmitter'ScrnDoom3KF.SabaothProjTrail.SpriteEmitter4'

     Physics=PHYS_Trailer
}
