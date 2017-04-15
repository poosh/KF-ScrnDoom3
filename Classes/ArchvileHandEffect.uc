class ArchvileHandEffect extends DoomEmitter;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetTimer(1.00,false);
}
simulated function Timer()
{
	local byte i;

	for(i=0;i<4;i++)
		Emitters[i].RespawnDeadParticles = false;
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter51
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorMultiplierRange=(Z=(Min=0.990000,Max=0.990000))
         FadeOutStartTime=0.300000
         CoordinateSystem=PTCS_Relative
         StartLocationRange=(X=(Min=-3.000000,Max=3.000000),Y=(Min=-3.000000,Max=3.000000),Z=(Min=-3.000000,Max=3.000000))
         StartSpinRange=(X=(Max=90.000000))
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=26.500000)
         StartSizeRange=(X=(Min=1.000000,Max=1.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.FireSmall'
         LifetimeRange=(Min=0.200000,Max=0.200000)
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.ArchvileHandEffect.SpriteEmitter51'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter52
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorMultiplierRange=(X=(Min=0.580000,Max=0.580000),Y=(Min=0.530000,Max=0.530000),Z=(Min=0.310000,Max=0.310000))
         Opacity=0.350000
         FadeOutStartTime=0.600000
         CoordinateSystem=PTCS_Relative
         StartLocationRange=(X=(Min=-3.000000,Max=3.000000),Y=(Min=-3.000000,Max=3.000000),Z=(Min=-3.000000,Max=3.000000))
         StartSpinRange=(X=(Max=90.000000))
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=31.000000)
         StartSizeRange=(X=(Min=1.000000,Max=1.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.Smokepuff'
         LifetimeRange=(Min=0.200000,Max=0.200000)
     End Object
     Emitters(1)=SpriteEmitter'ScrnDoom3KF.ArchvileHandEffect.SpriteEmitter52'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter54
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorMultiplierRange=(Y=(Min=0.569000,Max=0.569000),Z=(Min=0.114000,Max=0.114000))
         Opacity=0.600000
         FadeOutStartTime=0.650000
         CoordinateSystem=PTCS_Relative
         MaxParticles=3
         StartSpinRange=(X=(Max=26.000000))
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=20.000000)
         StartSizeRange=(X=(Min=1.000000,Max=1.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.BFGBallBlast'
         LifetimeRange=(Min=0.100000,Max=0.100000)
     End Object
     Emitters(2)=SpriteEmitter'ScrnDoom3KF.ArchvileHandEffect.SpriteEmitter54'

     Begin Object Class=BeamEmitter Name=BeamEmitter11
         LowFrequencyPoints=4
         HighFrequencyNoiseRange=(X=(Min=-2.000000,Max=2.000000),Y=(Min=-2.000000,Max=2.000000),Z=(Min=-2.000000,Max=2.000000))
         HighFrequencyPoints=4
         HFScaleFactors(0)=(FrequencyScale=(X=2.000000,Y=2.000000,Z=2.000000))
         HFScaleFactors(1)=(FrequencyScale=(X=8.000000,Y=8.000000),RelativeLength=0.700000)
         HFScaleFactors(2)=(FrequencyScale=(X=1.000000,Y=1.000000,Z=1.000000),RelativeLength=1.000000)
         UseHighFrequencyScale=True
         FadeOut=True
         FadeIn=True
         ColorMultiplierRange=(X=(Min=0.800000,Max=0.800000),Y=(Min=0.500000,Max=0.500000),Z=(Min=0.000000,Max=0.000000))
         Opacity=0.800000
         FadeOutStartTime=0.600000
         FadeInEndTime=0.200000
         CoordinateSystem=PTCS_Relative
         StartLocationRange=(X=(Min=-7.500000,Max=7.500000),Y=(Min=-7.500000,Max=7.500000),Z=(Min=-7.500000,Max=7.500000))
         StartLocationShape=PTLS_Sphere
         StartSizeRange=(X=(Min=0.500000,Max=0.500000))
         Texture=Texture'2009DoomMonstersTex.Effects.FBeam'
         LifetimeRange=(Min=0.200000,Max=0.200000)
         StartVelocityRange=(Z=(Min=-200.000000,Max=-375.000000))
     End Object
     Emitters(3)=BeamEmitter'ScrnDoom3KF.ArchvileHandEffect.BeamEmitter11'

     LifeSpan=3.000000
}
