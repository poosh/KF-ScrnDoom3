Class TriggerSpawnDemon extends KeyPoint;

var() array< class<DoomMonster> > MobClasses;
var() byte MaxInLevel,CoopMaxInLevel;
var() int Capacity,CoopCapacity;
var() float SpawnInterval,InitSpawnDelay,InitSpawnDelayCoop,CoopPerPlayerHPMulti;
var() name SpawnedOneEvent,AllSpawnedEvent,FinishedEvent;

var() bool bShowTeleportEffect,bCovert; // Covert = Only spawn if point is not seen by a player.
var bool bHasUntriggered,bTimingNow;

var() enum ESpawning
{
	SPAWN_Constant,
	SPAWN_UntilUntrigger,
	SPAWN_SingleAtTime
} Spawning;
struct FSpawnPoint
{
	var() edfindable Actor Point;
};
var() array<FSpawnPoint> RandSpawnPoints;

var byte NumMobs;
var int TotalMobs;
var class<DoomMonster> InitClass;
var Actor InitSpawnPoint;

function BeginPlay()
{
	if( Level.NetMode!=NM_StandAlone )
	{
		Capacity = CoopCapacity;
		MaxInLevel = CoopMaxInLevel;
		InitSpawnDelay = InitSpawnDelayCoop;
	}
}
function InitNextSpawn()
{
	InitClass = MobClasses[Rand(MobClasses.Length)];
	if( RandSpawnPoints.Length>0 )
		InitSpawnPoint = RandSpawnPoints[Rand(RandSpawnPoints.Length)].Point;
	if( InitSpawnPoint==None )
		InitSpawnPoint = Self;
}
final function byte CountPlayers()
{
	local Controller C;
	local byte i;

	for( C=Level.ControllerList; C!=None; C=C.nextController )
		if( C.bIsPlayer && C.PlayerReplicationInfo!=None && C.Pawn!=None && C.Pawn.Health>0 && KFPawn(C.Pawn)!=None )
			i++;
	if( i>0 )
		i--;
	return i;
}
function SpawnMob( bool bFinal )
{
	local DoomMonster M;

	if( bShowTeleportEffect && !bFinal )
	{
		Spawn(InitClass.Default.DoomTeleportFXClass,,,InitSpawnPoint.Location);
		return;
	}
	M = Spawn(InitClass,,,InitSpawnPoint.Location,InitSpawnPoint.Rotation);
	if( M==None )
		return;
	M.SpawnFactory = Self;
	NumMobs++;
	TotalMobs++;
	if( bShowTeleportEffect )
		M.NotifyTeleport();
	if( CoopPerPlayerHPMulti>0 && Level.NetMode!=NM_StandAlone )
		M.Health*=(1.f+float(CountPlayers())*CoopPerPlayerHPMulti);
	TriggerEvent(SpawnedOneEvent,Self,M);
}
function NotifyMobDied()
{
	NumMobs--;
}
function EndOfAction()
{
	switch( Spawning )
	{
	case SPAWN_UntilUntrigger:
		if( bHasUntriggered )
			GoToState('Idle');
	case SPAWN_Constant:
		GoToState('SpawnMobs','Begin');
		break;
	case SPAWN_SingleAtTime:
		GoToState('Idle');
		break;
	}
}

Auto state Idle
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		bHasUntriggered = false;
		GoToState('SpawnMobs');
	}
}

State SpawnMobs
{
	function UnTrigger( actor Other, pawn EventInstigator )
	{
		bHasUntriggered = true;
	}
	function Trigger( actor Other, pawn EventInstigator )
	{
		bHasUntriggered = false;
	}
Begin:
	InitNextSpawn();
	if( InitSpawnDelay>0 )
	{
		Sleep(InitSpawnDelay);
		InitSpawnDelay = 0;
	}
	if( bCovert && InitSpawnPoint.PlayerCanSeeMe() )
		GoTo'SkipSpawn';
	SpawnMob(false);
	if( bShowTeleportEffect )
	{
		Sleep(InitClass.Default.DoomTeleportFXClass.Default.TeleportInTime);
		SpawnMob(true);
	}
SkipSpawn:
	if( Capacity>0 && TotalMobs>=Capacity )
		GoToState('Finish');
	if( NumMobs>=MaxInLevel )
		GoToState('Waiting');
	Sleep(SpawnInterval);
	EndOfAction();
}
State Waiting
{
	function UnTrigger( actor Other, pawn EventInstigator )
	{
		bHasUntriggered = true;
	}
	function Trigger( actor Other, pawn EventInstigator )
	{
		bHasUntriggered = false;
	}
	function NotifyMobDied()
	{
		if( --NumMobs<MaxInLevel )
		{
			if( SpawnInterval>0 )
			{
				if( !bTimingNow )
				{
					bTimingNow = true;
					SetTimer(SpawnInterval,false);
				}
			}
			else EndOfAction();
		}
	}
	function Timer()
	{
		bTimingNow = false;
		EndOfAction();
	}
}
State Finish
{
	function NotifyMobDied()
	{
		if( --NumMobs==0 )
			TriggerEvent(FinishedEvent,Self,None);
	}
	function BeginState()
	{
		TriggerEvent(AllSpawnedEvent,Self,None);
	}
}

defaultproperties
{
     MaxInLevel=1
     CoopMaxInLevel=1
     Capacity=1
     CoopCapacity=1
     SpawnInterval=1.000000
     bShowTeleportEffect=True
     bStatic=False
     CollisionHeight=40.000000
     bDirectional=True
}
