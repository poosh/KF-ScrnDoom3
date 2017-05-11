class BossDemonSpawn extends DemonSpawnBase;

var class<KFMonster> DM;

simulated function PostBeginPlay()
{
	if( Level.NetMode!=NM_DedicatedServer )
		Spawn(class'DoomSymbolProjector',,,Location + vect(0,0,10));
	if( Level.NetMode!=NM_Client )
		SetTimer(TeleportInTime,false);
}
function Timer()
{
	local KFMonster M;
    local float OriginalPlayerCountHealthScale;

	if( DM==None )
		return;

    OriginalPlayerCountHealthScale = DM.default.PlayerCountHealthScale;
    DM.default.PlayerCountHealthScale = Class'Doom3Mutator'.Default.BossPerPlayerHP;
	if( Class<DoomMonster>(DM)!=None ) {
		Class<DoomMonster>(DM).Default.bIsBossSpawn = true;
		M = Spawn(DM);
		Class<DoomMonster>(DM).Default.bIsBossSpawn = false;
	}
	else
        M = Spawn(DM);
    DM.default.PlayerCountHealthScale = OriginalPlayerCountHealthScale;
	if( M==None )
		return;
	KFGameType(Level.Game).TotalMaxMonsters*=Class'Doom3Mutator'.Default.BossWaveReduction; // Reduce monsters in wave because of boss.
	KFGameReplicationInfo(Level.Game.GameReplicationInfo).MaxMonsters = KFGameType(Level.Game).TotalMaxMonsters;
    //increase bounty for defeating the boss with same scale as increasing its health
    M.ScoringValue = 500 * (1.0 + Class'Doom3Mutator'.Default.BossPerPlayerHP * fmax(Level.Game.NumPlayers-1,0));
    M.default.ScoringValue = M.ScoringValue;
    M.ZapThreshold = 5;
	if( DoomMonster(M)!=None )
		DoomMonster(M).NotifyTeleport();
	if( Level.NetMode==NM_DedicatedServer )
		Destroy();
}

defaultproperties
{
     TeleportInTime=3.000000
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseDirectionAs=PTDU_Up
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         UseVelocityScale=True
         ColorScale(0)=(Color=(B=5,G=134,R=250))
         ColorScale(1)=(RelativeTime=1.000000,Color=(G=255,R=255))
         FadeOutStartTime=0.120000
         FadeInEndTime=0.050000
         CoordinateSystem=PTCS_Relative
         MaxParticles=60
         StartLocationRange=(X=(Min=-90.000000,Max=90.000000),Y=(Min=-90.000000,Max=90.000000))
         StartSizeRange=(X=(Min=8.000000,Max=18.000000),Y=(Min=25.000000,Max=50.000000),Z=(Min=25.000000,Max=50.000000))
         ScaleSizeByVelocityMax=5000.000000
         InitialParticlesPerSecond=60.000000
         Texture=Texture'2009DoomMonstersTex.Archvile.PC_buildStreaks'
         LifetimeRange=(Min=1.000000,Max=1.500000)
         InitialDelayRange=(Min=2.800000,Max=2.800000)
         StartVelocityRange=(Z=(Min=1.000000,Max=5.000000))
         VelocityScale(1)=(RelativeTime=1.000000,RelativeVelocity=(X=10.000000,Y=10.000000,Z=500.000000))
     End Object
     Emitters(0)=SpriteEmitter'ScrnDoom3KF.BossDemonSpawn.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseDirectionAs=PTDU_Normal
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(1)=(RelativeTime=0.500000,Color=(B=255,G=113,R=152))
         ColorScale(2)=(RelativeTime=1.000000)
         MaxParticles=9
         StartLocationOffset=(Z=-70.000000)
         StartLocationShape=PTLS_All
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=80.000000,Max=120.000000))
         InitialParticlesPerSecond=5000.000000
         Texture=Texture'2009DoomMonstersTex.Symbols.Spawn3'
         LifetimeRange=(Min=1.000000,Max=1.500000)
         InitialDelayRange=(Min=3.000000,Max=3.000000)
     End Object
     Emitters(1)=SpriteEmitter'ScrnDoom3KF.BossDemonSpawn.SpriteEmitter1'

     Begin Object Class=BeamEmitter Name=BeamEmitter0
         BeamDistanceRange=(Min=100.000000,Max=200.000000)
         BeamEndPoints(0)=(offset=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-20.000000,Max=20.000000),Z=(Min=-300.000000,Max=-200.000000)),Weight=0.800000)
         BeamEndPoints(1)=(offset=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-250.000000,Max=-300.000000)),Weight=0.200000)
         DetermineEndPointBy=PTEP_Offset
         RotatingSheets=3
         HighFrequencyNoiseRange=(X=(Min=-9.000000,Max=9.000000),Y=(Min=-9.000000,Max=9.000000),Z=(Min=-7.000000,Max=7.000000))
         HighFrequencyPoints=5
         HFScaleFactors(0)=(FrequencyScale=(X=1.000000,Y=1.000000,Z=1.000000))
         HFScaleFactors(1)=(FrequencyScale=(X=10.000000,Y=10.000000,Z=10.000000),RelativeLength=0.500000)
         HFScaleFactors(2)=(FrequencyScale=(X=1.000000,Y=1.000000,Z=1.000000),RelativeLength=1.000000)
         UseHighFrequencyScale=True
         BranchProbability=(Min=1.000000,Max=1.000000)
         BranchSpawnAmountRange=(Min=10.000000,Max=10.000000)
         UseColorScale=True
         RespawnDeadParticles=False
         ColorScale(0)=(Color=(G=128,R=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=7,G=164,R=248))
         CoordinateSystem=PTCS_Relative
         MaxParticles=50
         StartLocationOffset=(Z=250.000000)
         StartLocationRange=(X=(Min=-8.000000,Max=8.000000),Y=(Min=-8.000000,Max=8.000000),Z=(Max=10.000000))
         StartSizeRange=(X=(Min=5.000000,Max=9.000000),Y=(Min=1.000000,Max=5.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.LightningBolt4'
         LifetimeRange=(Min=0.500000,Max=0.500000)
         InitialDelayRange=(Min=3.000000,Max=3.000000)
         StartVelocityRange=(Z=(Min=-1650.000000,Max=-1650.000000))
     End Object
     Emitters(2)=BeamEmitter'ScrnDoom3KF.BossDemonSpawn.BeamEmitter0'

     Begin Object Class=BeamEmitter Name=BeamEmitter1
         BeamDistanceRange=(Min=200.000000,Max=300.000000)
         BeamEndPoints(0)=(offset=(Z=(Min=-300.000000,Max=-350.000000)),Weight=0.800000)
         DetermineEndPointBy=PTEP_Offset
         RotatingSheets=2
         LowFrequencyNoiseRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=-5.000000,Max=5.000000))
         HighFrequencyNoiseRange=(X=(Min=-8.000000,Max=8.000000),Y=(Min=-3.000000,Max=8.000000),Z=(Min=-3.000000,Max=8.000000))
         LFScaleFactors(0)=(FrequencyScale=(X=1.000000,Y=1.000000,Z=1.000000),RelativeLength=1.000000)
         LFScaleFactors(1)=(FrequencyScale=(X=100.000000,Y=100.000000,Z=100.000000),RelativeLength=10.000000)
         HFScaleFactors(0)=(FrequencyScale=(X=1.000000,Y=1.000000,Z=1.000000))
         HFScaleFactors(1)=(FrequencyScale=(X=2.000000,Y=2.000000),RelativeLength=0.400000)
         HFScaleFactors(2)=(FrequencyScale=(X=5.000000,Y=5.000000,Z=5.000000),RelativeLength=0.500000)
         HFScaleFactors(3)=(FrequencyScale=(X=1.000000,Y=1.000000,Z=1.000000),RelativeLength=1.000000)
         UseHighFrequencyScale=True
         UseLowFrequencyScale=True
         RespawnDeadParticles=False
         ColorMultiplierRange=(X=(Min=3.000000,Max=3.000000),Y=(Min=0.200000,Max=0.800000),Z=(Min=0.000000,Max=0.000000))
         StartLocationOffset=(Z=250.000000)
         StartLocationRange=(X=(Min=-8.000000,Max=8.000000),Y=(Min=-8.000000,Max=8.000000))
         StartSizeRange=(X=(Min=1.000000,Max=5.000000),Y=(Min=10.000000,Max=10.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.LightningBolt3'
         LifetimeRange=(Min=1.000000,Max=1.000000)
         InitialDelayRange=(Min=2.700000,Max=2.700000)
     End Object
     Emitters(3)=BeamEmitter'ScrnDoom3KF.BossDemonSpawn.BeamEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         ZTest=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         UseRandomSubdivision=True
         ColorScale(0)=(Color=(B=64,G=128,R=255))
         ColorScale(1)=(RelativeTime=0.200000,Color=(B=13,G=99,R=242))
         ColorScale(2)=(RelativeTime=1.000000,Color=(B=74,G=198,R=251))
         FadeOutStartTime=0.200000
         MaxParticles=25
         StartLocationOffset=(Z=230.000000)
         SpinsPerSecondRange=(X=(Min=-5.000000,Max=-8.000000),Y=(Min=-5.000000,Max=-8.000000))
         SizeScale(1)=(RelativeTime=0.200000,RelativeSize=10.000000)
         SizeScale(2)=(RelativeTime=0.500000,RelativeSize=20.000000)
         SizeScale(3)=(RelativeTime=1.000000,RelativeSize=45.000000)
         StartSizeRange=(X=(Min=5.000000,Max=8.000000),Y=(Min=2.500000,Max=3.000000),Z=(Min=2.500000,Max=3.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.WhiteFlashStrip2'
         TextureUSubdivisions=12
         TextureVSubdivisions=1
         LifetimeRange=(Max=5.000000)
     End Object
     Emitters(4)=SpriteEmitter'ScrnDoom3KF.BossDemonSpawn.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         FadeOut=True
         RespawnDeadParticles=False
         ZTest=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         FadeOutStartTime=0.200000
         MaxParticles=3
         StartLocationOffset=(Z=230.000000)
         SpinsPerSecondRange=(X=(Min=5.000000,Max=5.000000),Y=(Min=0.200000,Max=0.200000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=80.000000)
         StartSizeRange=(X=(Min=2.000000,Max=3.000000),Y=(Min=1.000000,Max=1.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.BFGBlast2'
         LifetimeRange=(Min=0.500000,Max=0.500000)
         InitialDelayRange=(Min=2.900000,Max=2.900000)
     End Object
     Emitters(5)=SpriteEmitter'ScrnDoom3KF.BossDemonSpawn.SpriteEmitter3'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter4
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(1)=(RelativeTime=1.000000,Color=(G=128,R=255))
         FadeOutStartTime=0.500000
         MaxParticles=6
         StartLocationOffset=(Z=150.000000)
         SpinsPerSecondRange=(X=(Min=1.000000,Max=5.000000))
         StartSpinRange=(X=(Min=1.000000,Max=0.500000),Y=(Min=1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=30.000000,Max=40.000000),Y=(Min=30.000000,Max=40.000000))
         Sounds(0)=(Sound=Sound'2009DoomMonstersSounds.Misc.Misc_tele2_full3_1s',Radius=(Min=1800.000000,Max=2000.000000),Pitch=(Min=0.700000,Max=0.700000),Volume=(Min=1.000000,Max=2.000000),Probability=(Min=1.000000,Max=1.000000))
         SpawningSound=PTSC_LinearGlobal
         SpawningSoundIndex=(Max=1.000000)
         SpawningSoundProbability=(Min=1.000000,Max=1.000000)
         InitialParticlesPerSecond=250.000000
         Texture=Texture'2009DoomMonstersTex.Effects.Flare1'
         LifetimeRange=(Min=1.800000,Max=1.800000)
     End Object
     Emitters(6)=SpriteEmitter'ScrnDoom3KF.BossDemonSpawn.SpriteEmitter4'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter5
         FadeOut=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseRandomSubdivision=True
         ColorMultiplierRange=(Y=(Min=0.500000,Max=0.800000),Z=(Min=0.000000,Max=0.000000))
         FadeOutStartTime=0.200000
         MaxParticles=8
         StartLocationRange=(X=(Min=-25.000000,Max=25.000000),Y=(Min=-25.000000,Max=25.000000),Z=(Min=-100.000000,Max=200.000000))
         SpinsPerSecondRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.500000,Max=0.500000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=5.000000)
         StartSizeRange=(X=(Min=50.000000,Max=110.000000),Y=(Min=15.000000,Max=15.000000))
         InitialParticlesPerSecond=50.000000
         Texture=Texture'2009DoomMonstersTex.Effects.FlashStrip2'
         TextureUSubdivisions=12
         TextureVSubdivisions=1
         LifetimeRange=(Min=1.000000,Max=1.000000)
         InitialDelayRange=(Min=2.800000,Max=2.800000)
     End Object
     Emitters(7)=SpriteEmitter'ScrnDoom3KF.BossDemonSpawn.SpriteEmitter5'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter6
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         ZTest=False
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorScale(1)=(RelativeTime=0.200000,Color=(G=128,R=255))
         ColorScale(2)=(RelativeTime=0.800000,Color=(G=255,R=255))
         ColorScale(3)=(RelativeTime=1.000000,Color=(B=128,G=255,R=255))
         FadeOutStartTime=0.400000
         MaxParticles=1
         StartLocationOffset=(Z=90.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=100.000000)
         StartSizeRange=(X=(Min=3.000000,Max=3.000000),Y=(Min=1.000000,Max=1.000000))
         Texture=Texture'2009DoomMonstersTex.Effects.BFGBlast3'
         LifetimeRange=(Min=0.500000,Max=1.000000)
         InitialDelayRange=(Min=2.600000,Max=2.600000)
     End Object
     Emitters(8)=SpriteEmitter'ScrnDoom3KF.BossDemonSpawn.SpriteEmitter6'

     Begin Object Class=MeshEmitter Name=MeshEmitter0
         StaticMesh=StaticMesh'2009DoomMonstersSM.DemonSpawnSphere'
         UseParticleColor=True
         UseColorScale=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(G=128,R=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(G=128,R=255))
         Opacity=0.300000
         CoordinateSystem=PTCS_Relative
         MaxParticles=5
         StartLocationOffset=(Z=230.000000)
         SpinsPerSecondRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.500000,Max=0.500000),Z=(Min=1.000000,Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=1.500000,Max=3.000000),Y=(Min=0.500000,Max=0.500000),Z=(Min=0.500000,Max=0.500000))
         InitialParticlesPerSecond=50.000000
         LifetimeRange=(Max=5.000000)
         InitialDelayRange=(Min=0.700000,Max=0.800000)
     End Object
     Emitters(9)=MeshEmitter'ScrnDoom3KF.BossDemonSpawn.MeshEmitter0'

     bAlwaysRelevant=True
}
