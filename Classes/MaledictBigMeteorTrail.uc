class MaledictBigMeteorTrail extends DoomEmitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=True
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=106,G=155,R=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(R=255))
         CoordinateSystem=PTCS_Relative
         MaxParticles=5
         StartLocationRange=(X=(Min=-3.000000,Max=3.000000),Y=(Min=-3.000000,Max=3.000000),Z=(Min=-3.000000,Max=3.000000))
         SpinsPerSecondRange=(X=(Min=1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=60.000000,Max=75.000000),Y=(Min=10.000000,Max=10.000000))
         UseSkeletalLocationAs=PTSU_Location
         SkeletalScale=(X=0.400000,Y=0.400000,Z=0.370000)
         InitialParticlesPerSecond=5000.000000
         Texture=Texture'2009DoomMonstersTex.Effects.rocketbacklit'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.500000,Max=1.000000)
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.MaledictBigMeteorTrail.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=True
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         UseRandomSubdivision=True
         ColorScale(0)=(Color=(B=21,G=21,R=221))
         ColorScale(1)=(RelativeTime=1.000000,Color=(G=255,R=255))
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         SpinsPerSecondRange=(X=(Min=0.200000,Max=0.200000))
         SizeScale(0)=(RelativeSize=0.005000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.200000)
         StartSizeRange=(X=(Min=110.000000,Max=200.000000),Y=(Min=10.000000,Max=10.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.rocketbacklit'
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(1)=SpriteEmitter'ScrnDoom3KF.MaledictBigMeteorTrail.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorScale(0)=(Color=(B=70,G=70,R=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(G=64,R=128))
         FadeInEndTime=0.100000
         MaxParticles=20
         SpinsPerSecondRange=(X=(Min=10.000000,Max=10.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=70.000000,Max=90.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.FlashStrip2'
         TextureUSubdivisions=12
         TextureVSubdivisions=1
         LifetimeRange=(Min=0.150000,Max=0.150000)
         StartVelocityRange=(Z=(Min=20.000000,Max=50.000000))
     End Object
     Emitters(2)=SpriteEmitter'ScrnDoom3KF.MaledictBigMeteorTrail.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         UseColorScale=True
         UniformSize=True
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=15,G=111,R=240))
         CoordinateSystem=PTCS_Relative
         MaxParticles=5
         StartSizeRange=(X=(Min=90.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.WhiteFlashStrip3'
         TextureUSubdivisions=32
         TextureVSubdivisions=1
         LifetimeRange=(Min=0.500000,Max=1.000000)
     End Object
     Emitters(3)=SpriteEmitter'ScrnDoom3KF.MaledictBigMeteorTrail.SpriteEmitter3'

     Physics=PHYS_Trailer
}
