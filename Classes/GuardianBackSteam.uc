Class GuardianBackSteam extends DoomEmitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         UseRandomSubdivision=True
         ColorScale(0)=(Color=(B=80,G=80,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.600000,Max=0.800000),Y=(Min=0.600000,Max=0.800000))
         FadeOutStartTime=0.500000
         FadeInEndTime=0.250000
         MaxParticles=17
         SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=50.000000,Max=60.000000))
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'Effects_Tex.BulletHits.snowfinal2'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         LifetimeRange=(Min=0.800000,Max=1.500000)
         StartVelocityRange=(X=(Min=-140.000000,Max=140.000000),Y=(Min=-140.000000,Max=140.000000),Z=(Min=300.000000,Max=450.000000))
         VelocityLossRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.GuardianBackSteam.SpriteEmitter0'

}
