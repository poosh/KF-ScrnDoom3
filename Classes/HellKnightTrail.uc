class HellKnightTrail extends DoomEmitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter12
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorMultiplierRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.240000,Max=0.240000),Z=(Min=0.190000,Max=0.190000))
         FadeOutStartTime=0.400000
         FadeInEndTime=0.400000
         CoordinateSystem=PTCS_Relative
         MaxParticles=12
         StartLocationRange=(X=(Min=-3.000000,Max=3.000000),Y=(Min=-3.000000,Max=3.000000),Z=(Min=-3.000000,Max=3.000000))
         StartSpinRange=(X=(Min=20.000000,Max=90.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.330000)
         StartSizeRange=(X=(Min=30.000000,Max=30.000000),Y=(Min=10.000000,Max=10.000000))
         UseSkeletalLocationAs=PTSU_Location
         SkeletalScale=(X=0.400000,Y=0.400000,Z=0.370000)
         Texture=Texture'2009DoomMonstersTex.Effects.barrelpoof'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.750000,Max=0.750000)
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.HellKnightTrail.SpriteEmitter12'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter13
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorScale(0)=(Color=(B=170,G=255,R=170))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=225,G=255,R=196))
         ColorMultiplierRange=(X=(Min=0.040000,Max=0.040000),Y=(Min=0.800000,Max=0.900000))
         FadeOutStartTime=0.800000
         FadeInEndTime=0.400000
         CoordinateSystem=PTCS_Relative
         MaxParticles=15
         StartLocationRange=(X=(Min=-2.000000,Max=2.000000),Y=(Min=-2.000000,Max=2.000000),Z=(Min=-2.000000,Max=2.000000))
         StartSpinRange=(X=(Max=90.000000))
         SizeScale(0)=(RelativeSize=25.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=3.000000,Max=3.000000),Y=(Min=10.000000,Max=10.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.Billow_Glow'
         LifetimeRange=(Min=0.200000,Max=0.200000)
     End Object
     Emitters(1)=SpriteEmitter'ScrnDoom3KF.HellKnightTrail.SpriteEmitter13'

     Physics=PHYS_Trailer
}
