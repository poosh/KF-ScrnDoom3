// Boss - PAT Replacement extension, providing boss wave with additional features
// (c) PooSH
class BossExt extends Actor;

var DoomMonster Boss;

var byte MaxMonsters; // max monsters boss can spawn in solo mode
var byte MaxMonstersPerPlayerInc; // max monsters increase per-player

var transient float LastSpawnTime; //time when last boss aids were spawned
var transient int FiveSecondDamageTotal;
var transient float FiveSecondStart;
var transient int HealthFactor; // damage received - health of monster spawned
var transient float DifficultyHealthModifer;

var transient float TeleportFXEndTime; // time, when teleportation effect ends - to spawn zeds


var array<localized string> strHelp, strRest;

var array<float> TeleportHealthPct; // when boss's health drops below a given %, he will teleport to take a cool down
var int TeleportHealthIndex; // current index in TeleportHealthPct


// Monsters that will spawn in boss wave
struct BossAid {
	var class<DoomMonster> MonsterClass;
	var byte Count;
	var float NextSpawnCooldown; //time to next spawn
};
var array<BossAid> BossAidArray;

struct SummonQueueRec {
	var class<DoomMonster> MonsterClass;
	var Vector SummonPos;
};
var array<SummonQueueRec> SummonQueue;

var transient bool bBigSquadSpawned;
var transient NavigationPoint LastUsedSpawnPoint;


function BossAid GetBossAid()
{
	local float HealthPct, MinIdx, MaxIdx;
	local BossAid result;

	//the less health boss has, the higher indexes will be used (stronger monsters will spawn)
	HealthPct = float(Boss.Health) / Boss.HealthMax;

	//if boss is weak, spawn the stongest squad
	if ( Boss.Health < 3000 && !bBigSquadSpawned) {
		result = BossAidArray[BossAidArray.length - 1];
		bBigSquadSpawned = true;
	}
	else {
		if ( HealthPct > 0.75 ) {
			MinIdx = 0;
			MaxIdx = 3; //up to imps
		}
		else if ( HealthPct > 0.50 ) {
			MinIdx = 2; // From Maggot
			MaxIdx = 5; // up to Sawyer
		}
		else if ( HealthPct > 0.25 ) {
			MinIdx = 3; // From Imp
			MaxIdx = 7; // up to Cacodemon
		}
		else {
			MinIdx = 3; // From Imps and above
			MaxIdx = BossAidArray.length-1;
		}
		result = BossAidArray[clamp(Round(RandRange(MinIdx, MaxIdx)), 0, BossAidArray.length - 1)];
	}
	/*
	//make spawns quicker, if there are more players
	result.NextSpawnCooldown *= (1.0 + frand()*0.5) / (1.0 + 0.2 * fmax(Level.Game.NumPlayers-1,0));
	if ( Boss.Health < 3000 )
		result.NextSpawnCooldown *= 0.3; //spawn 3x faster because each next shot to the Boss can be lethal
	else if ( HealthPct < 0.25)
		result.NextSpawnCooldown *= 0.5; //spawn twice faster when health is low
	*/

	return result;
}

function PostBeginPlay()
{
	super.PostBeginPlay();

	MaxMonsters = clamp(default.MaxMonsters + MaxMonstersPerPlayerInc*(Level.Game.NumPlayers-1), 6, KFGameType(Level.Game).MaxZombiesOnce - 1);

	LastSpawnTime = Level.TimeSeconds;
	SetTimer(5, true); //check every 5 seconds, if need to spawn extra monsters
}

function Timer()
{
	local float SpawnCoolDown;
	local float HealthPct;

	//show boss HP after the wipe
	if ( Level.Game.IsInState('MatchOver') && Boss != none && Boss.Health > 0 ) {
		Boss.SayToPlayers("%n's HP = "$Boss.Health$"/"$int(Boss.HealthMax)$" ("$(Boss.Health/Boss.HealthMax*100)$"%)", true);
		SetTimer(0, false);
	}

	if ( Boss.ChildMonsterCounter >= MaxMonsters )
		return;

	// spawn boss aids at least once per 45 seconds
	SpawnCoolDown = 45;

	HealthPct = float(Boss.Health) / Boss.HealthMax;
	if ( Boss.Health < 2000 * DifficultyHealthModifer )
		SpawnCoolDown = 5; //spawn often because each next shot to the Boss can be lethal
	else if ( HealthPct < 0.25 )
		SpawnCoolDown = 15;  //spawn 3x faster when health is low
	else if ( HealthPct < 0.5 )
		SpawnCoolDown = 30;  //spawn twice faster when less than 50% hp remaining

	if ( HealthFactor < 5000 * DifficultyHealthModifer )
		SpawnCoolDown *= 2; //a lot of monsters are spawned, so lower the spawn rate
	else if ( HealthFactor < 0 )
		SpawnCoolDown *= 1.5;
	else if ( HealthFactor > 2500 )
		SpawnCoolDown *= 0.5;
	else if ( HealthFactor > 5000 )
		SpawnCoolDown *= 0.25;

	if ( Level.TimeSeconds > LastSpawnTime + SpawnCoolDown )
		AddMonsters(GetBossAid());
	// if HealthFactor is too big even after the aid spawn - spawn 2 squads in a row
	if ( HealthFactor > 5000 )
		AddMonsters(GetBossAid());
}

function Tick(float DeltaTime)
{
	if ( SummonQueue.length > 0 && TeleportFXEndTime < Level.TimeSeconds
			&& Boss.ChildMonsterCounter < MaxMonsters) {
		SpawnMonstersInQueue();
	}
	else if ( Boss.bCanAttackPipebombs && Level.TimeSeconds > Boss.NextPipeAttackTime ) {
			Boss.AttackPipebombs();
	}
}

function SpawnMonstersInQueue()
{
	local int i;

	for (i = 0; i < SummonQueue.length && Boss.ChildMonsterCounter < MaxMonsters; ++i) {
		Boss.SpawnChild(SummonQueue[i].MonsterClass,SummonQueue[i].SummonPos);
	}
	SummonQueue.length = 0; // clear queue no matter all monsters were spawned or not
}

function AddMonsters(BossAid A)
{
	local NavigationPoint N;
	local Vector SummonPos;
	local float Dist;
	local int SummonedCount;
	local SummonQueueRec NewSummon;

	// each time try to sujest next points to avoid situations of monsters spawning in the same
	// place again and again
	if ( LastUsedSpawnPoint == none )
		LastUsedSpawnPoint = Level.NavigationPointList;
	N = LastUsedSpawnPoint.nextNavigationPoint;
	do {
		Dist = VSizeSquared(N.Location-Boss.Location);
		if( PathNode(N)!=None && Dist<1562500 && Dist>22500 ) { // don't spawn closer than 3m and further than 25m
			SummonPos = N.Location;
			// add to summon queue
			NewSummon.MonsterClass = A.MonsterClass;
			NewSummon.SummonPos = SummonPos;
			SummonQueue[SummonQueue.length] = NewSummon;
			SummonedCount++;
			HealthFactor -= A.MonsterClass.Default.Health * DifficultyHealthModifer;
			// spawn teleportation effect
			Spawn(A.MonsterClass.Default.DoomTeleportFXClass,,,SummonPos);
		}
		N = N.nextNavigationPoint;
		if ( N == none )
			N = Level.NavigationPointList; //begin from the start
	} until ( N == LastUsedSpawnPoint || SummonedCount == A.Count );
	LastUsedSpawnPoint = N; //save last point we used for next time

	if (SummonedCount > 0) {
		Boss.SayToPlayers(strHelp[rand(strHelp.length)] @ "("$HealthFactor$")", true); //post a message to players, so they'll know that new monsters are spawning
		LastSpawnTime = Level.TimeSeconds;
	}
	TeleportFXEndTime = fmax(A.MonsterClass.Default.DoomTeleportFXClass.Default.TeleportInTime, 0.5);
}

// called from Monster class, when boss took any damage
function TookDamage(int damage, Pawn instigatedBy, class<DamageType> DamType)
{
	if( Level.TimeSeconds > FiveSecondStart+5 ) {
		FiveSecondDamageTotal = 0;
		FiveSecondStart = Level.TimeSeconds;
	}
	FiveSecondDamageTotal += damage;
	HealthFactor += damage;

	if ( Boss.Health < 3000 && !bBigSquadSpawned ) {
		AddMonsters(GetBossAid()); // summon the strongest squad
	}
	else if ( FiveSecondDamageTotal > Boss.HealthMax * 0.1
			&& Level.TimeSeconds > (LastSpawnTime + 1) ) {
		// if boss looses 10% health during five seconds, spawn squad immediatelly
		AddMonsters(GetBossAid());
		FiveSecondDamageTotal -= Boss.HealthMax * 0.1;
		FiveSecondStart = Level.TimeSeconds;
	}

	if ( TeleportHealthIndex < TeleportHealthPct.length
			&& float(Boss.Health) / Boss.HealthMax < TeleportHealthPct[TeleportHealthIndex] )
	{
		// teleport somewhere and cooldown
		TeleportHealthIndex++;
		Boss.SayToPlayers(strRest[rand(strRest.length)], true); //post a message to players, so they'll know that new monsters are spawning
		Boss.Controller.GotoState('Teleport', 'Away');
	}
}

defaultproperties
{
	 MaxMonsters=6
	 MaxMonstersPerPlayerInc=2
	 TeleportHealthPct(0)=0.70
	 TeleportHealthPct(1)=0.50
	 TeleportHealthPct(2)=0.25
	 strHelp(0)="%n: Creatures of Hell, come and help me to defeat mortals!"
	 strHelp(1)="%n: Say 'Hello!' to my little friends!"
	 strHelp(2)="%n: Help me, my children, to bring Hell on the Earth!"
	 strHelp(3)="%n: This Fight is only just begun!"
	 strHelp(4)="%n: Welcome to your Death, mortals!"
	 strHelp(5)="%n: Worthless humans, your souls will belong to me!"
	 strRest(0)="%n: Time to rest"
	 strRest(1)="%n: I'm out. See you later."
	 BossAidArray(0)=(MonsterClass=Class'ScrnDoom3KF.FatZombie',Count=4,NextSpawnCooldown=15.000000)
	 BossAidArray(1)=(MonsterClass=Class'ScrnDoom3KF.Boney',Count=3,NextSpawnCooldown=15.000000)
	 BossAidArray(2)=(MonsterClass=Class'ScrnDoom3KF.Maggot',Count=1,NextSpawnCooldown=15.000000)
	 BossAidArray(3)=(MonsterClass=Class'ScrnDoom3KF.Imp',Count=2,NextSpawnCooldown=20.000000)
	 BossAidArray(4)=(MonsterClass=Class'ScrnDoom3KF.Pinky',Count=1,NextSpawnCooldown=20.000000)
	 BossAidArray(5)=(MonsterClass=Class'ScrnDoom3KF.Sawyer',Count=2,NextSpawnCooldown=20.000000)
	 BossAidArray(6)=(MonsterClass=Class'ScrnDoom3KF.LostSoul',Count=4,NextSpawnCooldown=20.000000)
	 BossAidArray(7)=(MonsterClass=Class'ScrnDoom3KF.Cacodemon',Count=2,NextSpawnCooldown=15.000000)
	 BossAidArray(8)=(MonsterClass=Class'ScrnDoom3KF.HellKnight',Count=1,NextSpawnCooldown=20.000000)
	 BossAidArray(9)=(MonsterClass=Class'ScrnDoom3KF.HellKnight',Count=2,NextSpawnCooldown=30.000000)
}
