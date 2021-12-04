//-----------------------------------------------------------
// Written by Marco
// Further development by PooSH
//-----------------------------------------------------------
class Doom3Mutator extends ScrnMutator
	Config(ScrnDoom3KF);

var config float MinDoomPct,MaxDoomPct;
var transient int TotalMonsters, DoomMonsters;
var float DoomPct;
var float WaveSpawnRate;
var transient int SquadCounter;
var config float MinSpawnDelay,MaxSpawnDelay;
var config float BossWaveReduction,BossWaveRate,BossStartWaves,EndGameBossHealthMult;
var config bool bSpawnDemons, bSpawnBosses, bReplaceEndGameBoss;
var config array<string> Demons, MidGameBosses, EndGameBosses;

var int LastScannedWave;
var array< class<DoomMonster> > DemonClasses, BossClasses;
var float ProgressPct;

var Doom3GameRules GameRules;
var Doom3ReplicationInfo RI;

var transient bool bDemonsEnabled, bBossesEnabled, bEndGameBossEnabled;
var transient bool bBegunPlay;


function PostBeginPlay()
{
	local int i;
	local class<DoomMonster> M;

	super.PostBeginPlay();
	if ( bDeleteMe )
		return;

	GameRules = Spawn(Class'Doom3GameRules', self);
	GameRules.Mut = self;
	RI = spawn(Class'Doom3ReplicationInfo', self);
	RI.PrecacheMonsterMask = 0;
	class'ScrnDoom3KF.Doom3Controller'.default.TeleportDestinations.length = 0; // reset navigation points

	bDemonsEnabled = bSpawnDemons;
	bBossesEnabled = bSpawnBosses;
	bEndGameBossEnabled = bReplaceEndGameBoss;
	log("Config Demons="$bDemonsEnabled @ "Bosses="$bBossesEnabled
			@ "EndGameBoss="$bEndGameBossEnabled, 'Doom3');
	PublishValue('GetSpawnDoom3Monsters', int(bDemonsEnabled)
			| (int(bBossesEnabled) << 1)
			| (int(bEndGameBossEnabled) << 2) );
	// PublishValue() might trigger SetCustomValue() here

	// REGULAR DEMONS
	if ( bDemonsEnabled ) {
		LoadClassArray(Demons, DemonClasses);
		bDemonsEnabled = DemonClasses.length > 0;
	}
	// MID-GAME BOSSES
	if( bBossesEnabled ) {
		LoadClassArray(MidGameBosses, BossClasses);
		bBossesEnabled = BossClasses.length > 0;
	}
	// END-GAME BOSS
	if ( bEndGameBossEnabled ) {
		bEndGameBossEnabled = false;
		while ( EndGameBosses.length > 0 ) {
			i = rand(EndGameBosses.Length);
			M = LoadClass(EndGameBosses[i]);
			if ( M != none ) {
				KF.EndGameBossClass = string(M);
				KF.MonsterCollection.default.EndGameBossClass = KF.EndGameBossClass;
				bEndGameBossEnabled = true;
				break;
			}
			EndGameBosses.remove(i, 1);
		}
	}

	log("Actual Demons="$bDemonsEnabled @ "Bosses="$bBossesEnabled
			@ "EndGameBoss="$bEndGameBossEnabled, 'Doom3');

	// Always precache boss aids
	for ( i = 0; i < class'BossExt'.default.BossAidArray.length; ++i ) {
		RI.PrecacheMonster(class'BossExt'.default.BossAidArray[i].MonsterClass);
	}
	if ( Level.NetMode != NM_DedicatedServer ) {
		RI.UpdatePrecacheMaterials();
	}

	// XXX: Do not use self.GotoState() in PostBeginPlay() because after returning from the PostBeginPlay(), the
	// actor goes into its auto state ('' if the auto state is not set).

	bBegunPlay = true;
}

function Destroyed()
{
	if ( RI != none ) {
		RI.Destroy();
		RI = none;
	}
	super.Destroyed();
}

function bool SetCustomValue(name Key, int Value, optional ScrnMutator Publisher)
{
	switch (Key) {
		case 'SpawnDoom3Monsters':
			// Bit mask:
			// 1 - regular monsters
			// 2 - mid-game BossClasses
			// 4 - end-game boss
			if ( bBegunPlay ) {
				bDemonsEnabled = (Value & 1) != 0 && Demons.length > 0;
				bBossesEnabled = (Value & 2) != 0 && MidGameBosses.length > 0;
				OnStateChange();
			}
			else {
				bDemonsEnabled      = (Value & 1) != 0;
				bBossesEnabled      = (Value & 2) != 0;
				bEndGameBossEnabled = (Value & 4) != 0;
			}
			return true;
	}
	return false;
}

function class<DoomMonster> LoadClass(string S)
{
	local class<DoomMonster> DM;
	local int i;

	if( InStr(S,".")==-1 )
		S = string(Class.Outer.Name)$"."$S;
	DM = Class<DoomMonster>(DynamicLoadObject(S, Class'Class'));
	if ( DM != none ) {
		RI.PrecacheMonster(DM);
		for ( i = 0; i < DM.default.ChildrenMonsters.length; ++i ) {
			RI.PrecacheMonster(DM.default.ChildrenMonsters[i]);
		}
	}
	else {
		log("Failed to load DoomMonster class: " $ S, 'Doom3');
	}
	return DM;
}

function LoadClassArray(array<string> Strings, out array< class<DoomMonster> > MonsterClasses)
{
	local int i;

	MonsterClasses.length = Strings.length;
	for( i = 0; i < Strings.Length; ++i ) {
		MonsterClasses[i] = LoadClass(Strings[i]);
	}
	for ( i = MonsterClasses.Length-1; i >=0; --i ) {
		if ( MonsterClasses[i] == none )
			MonsterClasses.remove(i, 1);
	}
}

function rotator GetRandDir()
{
	local rotator R;

	R.Yaw = Rand(65536);
	return R;
}

function bool TestSpot( out VolumeColTester T, vector P, class<Actor> A )
{
	if( T==None )
	{
		T = Spawn(Class'VolumeColTester',,,P);
		if( T==None ) return false;
		T.SetCollisionSize(A.Default.CollisionRadius,A.Default.CollisionHeight);
		T.bCollideWhenPlacing = True;
	}
	return T.SetLocation(P);
}

function TryToAddBoss()
{
	local NavigationPoint N;
	local array<NavigationPoint> Candinates;
	local byte i;
	local int j;
	local class<DoomMonster> TryMonster;
	local VolumeColTester Tst;
	local BossDemonSpawn BoosSpawn;

	if( BossClasses.Length == 0 )
		return;
	for( N=Level.NavigationPointList; N!=None; N=N.NextNavigationPoint )
	{
		if( FRand()<0.5 && PathNode(N)!=None )
			Candinates[Candinates.Length] = N;
	}
	if( Candinates.Length==0 )
		return;
	i = Rand(BossClasses.Length);
	TryMonster = BossClasses[i];
	BossClasses.Remove(i,1);
	for( i=0; i<30; i++ ) // Give it 30 tries
	{
		j = Rand(Candinates.Length);
		N = Candinates[j];

		// Try twice..
		if( TestSpot(Tst,N.Location,TryMonster) || TestSpot(Tst,N.Location+vect(0,0,1)*(TryMonster.Default.CollisionHeight-N.CollisionHeight),TryMonster) )
		{
			BoosSpawn = Spawn(Class'BossDemonSpawn',,,Tst.Location,GetRandDir());
			if ( BoosSpawn != none ) {
				BoosSpawn.DM = TryMonster;
				KF.TotalMaxMonsters *= BossWaveReduction;
				KFGameReplicationInfo(KF.GameReplicationInfo).MaxMonsters = KF.TotalMaxMonsters;
				break;
			}
		}

		// Remove candinate entry, and try random next...
		Candinates.Remove(j,1);
		if( Candinates.Length==0 )
			break;
	}
	Tst.Destroy();
}
static function FillPlayInfo(PlayInfo PlayInfo)
{
	Super.FillPlayInfo(PlayInfo);

	PlayInfo.AddSetting(default.RulesGroup, "bSpawnDemons", "Demons", 0, 0, "Check");
	PlayInfo.AddSetting(default.RulesGroup, "MinDoomPct", "Doom Percentage Min", 0, 1, "Text", "8;0.01:1.0.0");
	PlayInfo.AddSetting(default.RulesGroup, "MaxDoomPct", "Doom Percentage Max", 0, 1, "Text", "8;0.01:1.0.0");
	PlayInfo.AddSetting(default.RulesGroup, "MinSpawnDelay", "Spawn Delay Min", 0, 1, "Text", "8;0.01:800.0");
	PlayInfo.AddSetting(default.RulesGroup, "MaxSpawnDelay", "Spawn Delay Max", 0, 1, "Text", "8;0.01:800.0");

	PlayInfo.AddSetting(default.RulesGroup, "bSpawnBosses", "Mid-game bosses", 0, 0, "Check");
	PlayInfo.AddSetting(default.RulesGroup, "BossWaveReduction", "BossWave Reduction", 0, 1, "Text", "6;0.0:1.0");
	PlayInfo.AddSetting(default.RulesGroup, "BossWaveRate", "BossWave rate", 0, 1, "Text", "6;0.0:1.0");
	PlayInfo.AddSetting(default.RulesGroup, "BossStartWaves", "BossWaves start", 0, 1, "Text", "6;0.0:1.0");

	PlayInfo.AddSetting(default.RulesGroup, "bReplaceEndGameBoss", "End game boss", 0, 0, "Check");
	PlayInfo.AddSetting(default.RulesGroup, "EndGameBossHealthMult", "End game boss HP mult.", 0, 1, "Text", "6;1.0:100.0");
}
static event string GetDescriptionText(string PropName)
{
	switch(PropName)
	{
		case "bSpawnDemons":          return "Spawn regular doom demons.";
		case "MinDoomPct":            return "Minimum percentage of Doom 3 monsters in the game (0.1 - 10% of total monster count).";
		case "MaxDoomPct":            return "Maximum percentage of Doom 3 monsters in the game (0.5 - 50% of total monster count).";
		case "MinSpawnDelay":         return "Minimum time delay between Doom 3 monster squads.";
		case "MaxSpawnDelay":         return "Maximum time delay between Doom 3 monster squads.";

		case "bSpawnBosses":          return "In later waves, add sometimes a boss monster.";
		case "BossWaveReduction":     return "Reduced percent in wave size on a boss wave (0.0 = no other zeds, 1.0 = full wave).";
		case "BossWaveRate":          return "In percent, how big chance in later waves the wave is a boss wave (1.0 = always).";
		case "BossStartWaves":        return "In percent, how many waves until boss waves start (1.0 = final wave, 0.0 = first wave).";

		case "bReplaceEndGameBoss":   return "Replace Patriarch with a Doom boss";
		case "EndGameBossHealthMult": return "How many times end-game boss's HP is bigger than mid-game (1.0 = same, 2.0 = double)";
	}
	return Super.GetDescriptionText(PropName);
}

function AddDoom3Mobs(byte MaxAmmount) { }

state AddingSuperMonsters
{
	function BeginState()
	{
		log("Demon mid-game BossClasses spawning enabled", 'Doom3');
		SetTimer(3, true);
	}

	function EndState()
	{
		log("Demon spawning disabled", 'Doom3');
		SetTimer(0, false);
	}

	function Timer()
	{
		if( KF.bWaveInProgress && LastScannedWave != KF.WaveNum ) {
			LastScannedWave = KF.WaveNum;

			if( KF.WaveNum < KF.FinalWave ) {
				ProgressPct = FClamp(float(KF.WaveNum+2)/float(KF.FinalWave),0.1f,1.f);
			}
			else {
				ProgressPct = 2.f;
			}

			if( bBossesEnabled && KF.WaveNum < KF.FinalWave
					&& KF.WaveNum >= int(KF.FinalWave*BossStartWaves+0.01) && FRand() < BossWaveRate )
			{
				TryToAddBoss();
			}
		}
	}
}

state AddingD3Squads extends AddingSuperMonsters
{
	function BeginState()
	{
		log("Demon spawning enabled", 'Doom3');
		super.BeginState();
	}

	function AddDoom3Mobs(byte MaxAmmount)
	{
		local class<DoomMonster> DC;
		local byte i;

		if ( !bDemonsEnabled )
			return;

		// don't build squads larger than 6 mobs, because they may have trouble to spawn
		if ( KF.NextSpawnSquad.Length >= 6 )
			return;
		MaxAmmount = min(MaxAmmount, 6 - KF.NextSpawnSquad.Length);
		if ( MaxAmmount > 0 && SquadCounter != KF.SquadsToUse.Length ) {
			for( i=0; i<MaxAmmount; ++i ) {
				DC = DemonClasses[Min(FRand()*ProgressPct*(DemonClasses.Length+2),DemonClasses.Length-1)];
				if( DC!=None )
					KF.NextSpawnSquad[KF.NextSpawnSquad.Length] = DC;
			}
			KF.LastZVol = KF.FindSpawningVolume();
			if ( KF.LastZVol != none )
				KF.LastSpawningVolume = KF.LastZVol;
			// prevent adding doom mobs twice in the same squad
			SquadCounter = KF.SquadsToUse.Length;
		}
	}

Begin:
	while( ProgressPct<=1.f && !KF.bGameEnded ) {
		if ( !KF.bWaveInProgress || KF.TotalMaxMonsters <= 0 ) {
			sleep(1.0);
			continue;
		}

		WaveSpawnRate = KF.KFLRules.WaveSpawnPeriod / KF.KFLRules.default.WaveSpawnPeriod;
		if ( DoomPct < MinDoomPct && KF.WaveNum > 0 ) {
			// not enough doom monsters - spawn as fast as possible
			AddDoom3Mobs(2+rand(3));
			Sleep(MinSpawnDelay * fmax(1.0, WaveSpawnRate));
		}
		else if ( DoomPct > MaxDoomPct && KF.WaveNum > 0 ) {
			Sleep(MaxSpawnDelay);
			// too many doom monsters - do a maximum cooldown
			AddDoom3Mobs(1);
			Sleep(MinSpawnDelay);
		}
		else {
			AddDoom3Mobs(1+rand(4));
			Sleep(RandRange(MinSpawnDelay*WaveSpawnRate,MaxSpawnDelay));
		}
	}
}

auto state PrepareDemonSpawn
{
Begin:
	sleep(1.0);
	OnStateChange();
}

function OnStateChange()
{
	if (!bBegunPlay)
		return;

	if ( bDemonsEnabled ) {
		GotoState('AddingD3Squads');
	}
	else  if ( bBossesEnabled ) {
		GotoState('AddingSuperMonsters');
	}
	else {
		GotoState('');
	}
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	if ( KFMonsterController(Other) != none ) {
		TotalMonsters++;
		if( Doom3Controller(Other)!=None ) {
			DoomMonsters++;
		}
		DoomPct = float(DoomMonsters) / TotalMonsters;
	}
	return true;
}

function Mutate(string MutateString, PlayerController Sender)
{
	 if( MutateString~="DoomStat" || MutateString~="DoomStats" ) {
		Sender.ClientMessage("DooM monsters spawned in the game: " $ DoomMonsters$"/"$TotalMonsters
				$ ", " $ string(DoomPct*100)$"%. Demons="$bDemonsEnabled $ ", Bosses="$bBossesEnabled
				$ ", EndGameBoss="$bEndGameBossEnabled);
	}

	super.Mutate(MutateString, Sender);
}


defaultproperties
{
	VersionNumber=96909

	MinDoomPct=0.10
	MaxDoomPct=0.20
	WaveSpawnRate=1.0
	MinSpawnDelay=5.0
	MaxSpawnDelay=35.000000

	bSpawnDemons=true
	Demons(00)="Boney"
	Demons(01)="FatZombie"
	Demons(02)="Imp"
	Demons(03)="Tick"
	Demons(04)="Trite"
	Demons(05)="Sawyer"
	Demons(06)="Pinky"
	Demons(07)="Maggot"
	Demons(08)="LostSoul"
	Demons(09)="Cherub"
	Demons(10)="Cacodemon"
	Demons(11)="Wraith"
	Demons(12)="Revenant"
	Demons(13)="Vulgar"
	Demons(14)="Commando"
	Demons(15)="Mancubus"
	Demons(16)="Archvile"
	Demons(17)="Bruiser"
	Demons(18)="Forgotten"
	Demons(19)="HellKnight"

	bSpawnBosses=true
	BossWaveReduction=0.250000
	BossWaveRate=0.450000
	BossStartWaves=0.400000
	LastScannedWave=-1;
	MidGameBosses(0)="Cyberdemon"
	MidGameBosses(1)="Guardian"
	MidGameBosses(2)="HunterBerserk"
	MidGameBosses(3)="HunterHellTime"
	MidGameBosses(4)="HunterInvul"
	MidGameBosses(5)="Maledict"
	MidGameBosses(6)="Sabaoth"
	MidGameBosses(7)="Vagary"

	bReplaceEndGameBoss=true
	EndGameBossHealthMult=2.5
	EndGameBosses(2)="Cyberdemon"
	EndGameBosses(3)="Guardian"
	EndGameBosses(1)="Maledict"
	EndGameBosses(0)="Sabaoth"

	ProgressPct=0.100000

	bAddToServerPackages=True
	GroupName="KF-MonsterMut"
	FriendlyName="ScrN Doom3"
	Description="Doom3 demon invasion. Mod altered by [ScrN]PooSH. Original authors: Marco, INIQUITOUS."
	RulesGroup="DoomIII"
	bAlwaysRelevant=True
	RemoteRole=ROLE_SimulatedProxy
	NetUpdateFrequency=1.000000
}
