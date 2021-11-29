//-----------------------------------------------------------
// Written by Marco
// Further development by PooSH
//-----------------------------------------------------------
class Doom3Mutator extends ScrnMutator
	Config(Doom3KF);

var config float MinDoomPct,MaxDoomPct;
var transient int TotalMonsters, DoomMonsters;
var float DoomPct;
var float WaveSpawnRate;
var transient int SquadCounter;
var config float MinSpawnDelay,MaxSpawnDelay;
var config float BossWaveReduction,BossWaveRate,BossStartWaves,BossPerPlayerHP,PatBossMult;
var config bool bSpawnMonsters, bSpawnSuperMonsters, bReplaceEndGameBoss;
var config array<string> LargeMaps,LargeBosses,NormalBosses,MonsterClasses,PatReplacement,LargePatReplacement;
var bool bBigMap;

var int LastScannedWave;
var array< class<KFMonster> > Bosses,Doom3Mobs;
var float ProgressPct;

var Doom3GameRules GameRules;
var Doom3ReplicationInfo RI;

var transient bool bMonstersEnabled, bSuperMonstersEnabled;


function PostBeginPlay()
{
	local int i;
	local class<KFMonster> M;

	super.PostBeginPlay();
	if ( bDeleteMe )
		return;

	GameRules = Spawn(Class'Doom3GameRules', self);
	GameRules.Mut = self;
	RI = spawn(Class'Doom3ReplicationInfo', self);
	RI.PrecacheMonsterMask = 0;
	class'ScrnDoom3KF.Doom3Controller'.default.TeleportDestinations.length = 0; // reset navigation points

	bMonstersEnabled = bSpawnMonsters;
	bSuperMonstersEnabled = bSpawnSuperMonsters;

	bBigMap = false;
	if( LargeMaps.Length>0 ) {
		for( i=(LargeMaps.Length-1); i>=0; --i )
			if( LargeMaps[i]~=string(Outer.Name) ) {
				bBigMap = true;
				break;
			}
	}

	// END - GAME BOSS
	if( bReplaceEndGameBoss ) {
		if( !bBigMap ) {
			if( PatReplacement.Length>0 && PatReplacement[0]!="None" )
				KF.EndGameBossClass = PatReplacement[Rand(PatReplacement.Length)];
		}
		else {
			if( LargePatReplacement.Length>0 && LargePatReplacement[0]!="None" )
				KF.EndGameBossClass = LargePatReplacement[Rand(LargePatReplacement.Length)];
		}
		M = LoadClass(KF.EndGameBossClass);
		// if server admin specified boss class name wrong
		if ( M == none ) {
			log("Unable to load end game boss class: " $ KF.EndGameBossClass, class.outer.name);
			M = LoadClass("Sabaoth");
		}
		if ( M.outer.name == class.outer.name ) {
			for ( i = 0; i < class'BossExt'.default.BossAidArray.length; ++i ) {
				RI.PrecacheMonster(class'BossExt'.default.BossAidArray[i].MonsterClass);
			}
		}
		KF.EndGameBossClass = string(M);
		// new squad system
		KF.MonsterCollection.default.EndGameBossClass = KF.EndGameBossClass;
	}

	// MID-GAME BOSSES
	if( bSpawnSuperMonsters ) {
		for( i=0; i<NormalBosses.Length; ++i ) {
			M = LoadClass(NormalBosses[i]);
			if( M!=None )
				Bosses[Bosses.Length] = M;
		}
		if ( bBigMap ) {
			for( i=0; i<LargeBosses.Length; ++i ) {
				M = LoadClass(LargeBosses[i]);
				if( M!=None )
					Bosses[Bosses.Length] = M;
			}
		}
	}

	// REGULAR ZEDS
	for( i=0; i<MonsterClasses.Length; ++i ) {
		M = LoadClass(MonsterClasses[i]);
		if( M!=None )
			Doom3Mobs[Doom3Mobs.Length] = M;
	}

	if ( Level.NetMode != NM_DedicatedServer ) {
		RI.UpdatePrecacheMaterials();
	}

	// XXX: Do not use self.GotoState() in PostBeginPlay() because after returning from the PostBeginPlay(), the
	// actor goes into its auto state ('' if the auto state is not set).
}

function Destroyed()
{
	if ( RI != none ) {
		RI.Destroy();
		RI = none;
	}
	super.Destroyed();
}


function class<KFMonster> LoadClass(string S)
{
	local class<KFMonster> M;
	local class<DoomMonster> DM;
	local int i;

	if( InStr(S,".")==-1 )
		S = string(Class.Outer.Name)$"."$S;
	M = Class<KFMonster>(DynamicLoadObject(S, Class'Class'));
	if ( M != none ) {
		DM = class<DoomMonster>(M);
		if ( DM != none ) {
			RI.PrecacheMonster(DM);
			for ( i = 0; i < DM.default.ChildrenMonsters.length; ++i ) {
				RI.PrecacheMonster( DM.default.ChildrenMonsters[i]);
			}
		}
	}
	return M;
}

final function rotator GetRandDir()
{
	local rotator R;

	R.Yaw = Rand(65536);
	return R;
}
final function bool TestSpot( out VolumeColTester T, vector P, class<Actor> A )
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
final function TryToAddBoss()
{
	local NavigationPoint N;
	local array<NavigationPoint> Candinates;
	local byte i;
	local int j;
	local class<KFMonster> TryMonster;
	local VolumeColTester Tst;

	if( Bosses.Length == 0 )
		return;
	for( N=Level.NavigationPointList; N!=None; N=N.NextNavigationPoint )
	{
		if( FRand()<0.5 && PathNode(N)!=None )
			Candinates[Candinates.Length] = N;
	}
	if( Candinates.Length==0 )
		return;
	i = Rand(Bosses.Length);
	TryMonster = Bosses[i];
	Bosses.Remove(i,1);
	for( i=0; i<30; i++ ) // Give it 30 tries
	{
		j = Rand(Candinates.Length);
		N = Candinates[j];

		// Try twice..
		if( TestSpot(Tst,N.Location,TryMonster) || TestSpot(Tst,N.Location+vect(0,0,1)*(TryMonster.Default.CollisionHeight-N.CollisionHeight),TryMonster) )
		{
			Spawn(Class'BossDemonSpawn',,,Tst.Location,GetRandDir()).DM = TryMonster;
			break;
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
	PlayInfo.AddSetting(default.RulesGroup, "bSpawnSuperMonsters", "Super monsters", 0, 0, "Check");
	PlayInfo.AddSetting(default.RulesGroup, "MinDoomPct", "Doom Percentage Min", 0, 1, "Text", "8;0.01:1.0.0");
	PlayInfo.AddSetting(default.RulesGroup, "MaxDoomPct", "Doom Percentage Max", 0, 1, "Text", "8;0.01:1.0.0");
	PlayInfo.AddSetting(default.RulesGroup, "MinSpawnDelay", "Spawn Delay Min", 0, 1, "Text", "8;0.01:800.0");
	PlayInfo.AddSetting(default.RulesGroup, "MaxSpawnDelay", "Spawn Delay Max", 0, 1, "Text", "8;0.01:800.0");
	PlayInfo.AddSetting(default.RulesGroup, "BossWaveReduction", "BossWave Reduction", 0, 1, "Text", "6;0.0:1.0");
	PlayInfo.AddSetting(default.RulesGroup, "BossWaveRate", "BossWave rate", 0, 1, "Text", "6;0.0:1.0");
	PlayInfo.AddSetting(default.RulesGroup, "BossStartWaves", "BossWaves start", 0, 1, "Text", "6;0.0:1.0");
	PlayInfo.AddSetting(default.RulesGroup, "BossPerPlayerHP", "Boss Per Player HP", 0, 1, "Text", "6;0.0:1.0");
	PlayInfo.AddSetting(default.RulesGroup, "PatBossMult", "Patriarch Replacement HP multiplier", 0, 1, "Text", "6;1.0:100.0");
}
static event string GetDescriptionText(string PropName)
{
	switch(PropName)
	{
		case "bSpawnSuperMonsters": return "In later waves, add sometimes a boss monster.";
		case "MinDoomPct":          return "Minimum percentage of Doom 3 monsters in the game (0.1 - 10% of total monster count).";
		case "MaxDoomPct":          return "Maximum percentage of Doom 3 monsters in the game (0.5 - 50% of total monster count).";
		case "MinSpawnDelay":       return "Minimum time delay for adding in Doom 3 monster squads.";
		case "MaxSpawnDelay":       return "Maximum time delay for adding in Doom 3 monster squads.";
		case "BossWaveReduction":	return "Reduced percent in wave size on a boss wave (0.0 = no other zeds, 1.0 = full wave).";
		case "BossWaveRate":		return "In percent, how big chance in later waves the wave is a boss wave (1.0 = always).";
		case "BossStartWaves":		return "In percent, how many waves until boss waves start (1.0 = final wave, 0.0 = first wave).";
		case "BossPerPlayerHP":		return "In percent, how much additional health bosses get per additional player (0.0 = none, 1.0 = double).";
		case "PatBossMult": 		return "How many times Patriarch Replacement's HP is bigger than in-wave boss's (1.0 = same, 2.0 = double).";
	}
	return Super.GetDescriptionText(PropName);
}

function AddDoom3Mobs(byte MaxAmmount) { }

state AddingSuperMonsters
{
	function BeginState()
	{
		log("Demon mid-game bosses spawning enabled", 'Doom3');
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

			if( bSuperMonstersEnabled && KF.WaveNum < KF.FinalWave
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
		local class<KFMonster> DC;
		local byte i;

		if ( !bMonstersEnabled )
			return;

		// don't build squads larger than 6 mobs, because they may have trouble to spawn
		if ( KF.NextSpawnSquad.Length >= 6 )
			return;
		MaxAmmount = min(MaxAmmount, 6 - KF.NextSpawnSquad.Length);
		if ( MaxAmmount > 0 && SquadCounter != KF.SquadsToUse.Length ) {
			for( i=0; i<MaxAmmount; ++i ) {
				DC = Doom3Mobs[Min(FRand()*ProgressPct*(Doom3Mobs.Length+2),Doom3Mobs.Length-1)];
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
	if ( bMonstersEnabled ) {
		GotoState('AddingD3Squads');
	}
	else  if ( bSuperMonstersEnabled ) {
		GotoState('AddingSuperMonsters');
	}
	else {
		GotoState('');
	}
}

function bool SetCustomValue(name Key, int Value)
{
	switch (Key) {
		case 'SpawnDoom3Monsters':
			// 0 - disabled
			// 1 - only mid-game bosses
			// 2 - bosses + regular mobs
			bSuperMonstersEnabled = Value >= 1;
			bMonstersEnabled = Value >= 2;
			OnStateChange();
			return true;
	}
	return false;
}

function GetServerDetails( out GameInfo.ServerResponseLine ServerState )
{
	local int i;

	super.GetServerDetails(ServerState);

	i = ServerState.ServerInfo.Length;
	ServerState.ServerInfo.insert(i, 1);

	ServerState.ServerInfo[i].Key = "Doom 3 Bosses";
	ServerState.ServerInfo[i++].Value = Eval(bSpawnSuperMonsters,"True","False");
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
	if( MutateString~="BigMap" || MutateString~="LargeMap" ) {
		if( Level.NetMode==NM_StandAlone || Sender.PlayerReplicationInfo.bAdmin ) {
			MakeBigMap();
			bBigMap = true;
			Sender.ClientMessage(string(Outer.Name)@"has been made large map.");
		}
	}
	else if( MutateString~="SmallMap" ) {
		if( Level.NetMode==NM_StandAlone || Sender.PlayerReplicationInfo.bAdmin ) {
			MakeSmallMap();
			bBigMap = false;
			Sender.ClientMessage(string(Outer.Name)@"has been made small map.");
		}
	}
	else if( MutateString~="IsBigMap" || MutateString~="IsSmallMap" ) {
		Sender.ClientMessage(string(Outer.Name) $ " is a "$eval(bBigMap, "big", "small")$" map.");
	}
	else if( MutateString~="DoomStat" || MutateString~="DoomStats" ) {
		Sender.ClientMessage("DooM monsters spawned in the game: " $ DoomMonsters$"/"$TotalMonsters
		$ ", " $ string(DoomPct*100)$"%");
	}

	super.Mutate(MutateString, Sender);
}

final function MakeBigMap()
{
	local int i;

	for( i=(LargeMaps.Length-1); i>=0; --i )
		if( LargeMaps[i]~=string(Outer.Name) )
			return;
	LargeMaps[LargeMaps.Length] = string(Outer.Name);
	SaveConfig();
}
final function MakeSmallMap()
{
	local int i;

	for( i=(LargeMaps.Length-1); i>=0; --i )
		if( LargeMaps[i]~=string(Outer.Name) )
		{
			LargeMaps.Remove(i,1);
			SaveConfig();
			return;
		}
}


defaultproperties
{
	VersionNumber=96907

	MinDoomPct=0.10
	MaxDoomPct=0.20
	WaveSpawnRate=1.0
	MinSpawnDelay=5.0
	MaxSpawnDelay=35.000000
	BossWaveReduction=0.250000
	BossWaveRate=0.450000
	BossStartWaves=0.400000
	BossPerPlayerHP=0.75
	PatBossMult=2.5
	LastScannedWave=-1;
	bSpawnMonsters=true
	bSpawnSuperMonsters=true
	bReplaceEndGameBoss=true

	LargeMaps(00)="KF-AbusementPark"
	LargeMaps(01)="KF-Departed"
	LargeMaps(02)="KF-Farm"
	LargeMaps(03)="KF-FrightYard"
	LargeMaps(04)="KF-Hell"
	LargeMaps(05)="KF-HillbillyHorror"
	LargeMaps(06)="KF-Manor"
	LargeMaps(07)="KF-MountainPass"
	LargeMaps(08)="KF-MountainPassNight"
	LargeMaps(09)="KF-Steamland"
	LargeMaps(10)="KF-Suburbia"
	LargeMaps(11)="KF-ThrillsChills"
	LargeMaps(12)="KF-WestLondon"
	LargeMaps(13)="KF-Wyre"

	LargeBosses(0)="Cyberdemon"
	LargeBosses(1)="Guardian"

	NormalBosses(0)="Sabaoth"
	NormalBosses(1)="Vagary"
	NormalBosses(2)="Maledict"
	NormalBosses(3)="HunterInvul"
	NormalBosses(4)="HunterBerserk"
	NormalBosses(5)="HunterHellTime"

	MonsterClasses(0)="Boney"
	MonsterClasses(1)="FatZombie"
	MonsterClasses(2)="Imp"
	MonsterClasses(3)="Tick"
	MonsterClasses(4)="Trite"
	MonsterClasses(5)="Sawyer"
	MonsterClasses(6)="Pinky"
	MonsterClasses(7)="Maggot"
	MonsterClasses(8)="LostSoul"
	MonsterClasses(9)="Cherub"
	MonsterClasses(10)="Cacodemon"
	MonsterClasses(11)="Wraith"
	MonsterClasses(12)="Revenant"
	MonsterClasses(13)="Vulgar"
	MonsterClasses(14)="Commando"
	MonsterClasses(15)="Mancubus"
	MonsterClasses(16)="Archvile"
	MonsterClasses(17)="Bruiser"
	MonsterClasses(18)="Forgotten"
	MonsterClasses(19)="HellKnight"

	PatReplacement(0)="Sabaoth"
	PatReplacement(1)="Maledict"
	PatReplacement(2)="HunterInvul"
	PatReplacement(3)="HunterHellTime"
	LargePatReplacement(0)="Cyberdemon"
	LargePatReplacement(1)="Maledict"
	LargePatReplacement(2)="HunterHellTime"

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
