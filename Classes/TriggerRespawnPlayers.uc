Class TriggerRespawnPlayers extends KeyPoint;

function Trigger( actor Other, pawn EventInstigator )
{
	local Controller C;
	local bool bWaveInProgress;
	local KFGameType KF;

	if( Level.Game.bGameEnded )
		return;
	KF = KFGameType(Level.Game);
	if( KF!=None )
	{
		bWaveInProgress = KF.bWaveInProgress;
		KF.bWaveInProgress = false;
	}
	for ( C = Level.ControllerList; C != none; C = C.NextController )
	{
		if ( C.PlayerReplicationInfo!=none && !C.PlayerReplicationInfo.bOnlySpectator && C.Pawn==None )
		{
			C.PlayerReplicationInfo.bOutOfLives = false;
			C.PlayerReplicationInfo.NumLives = 0;
			if( PlayerController(C) != none )
			{
				PlayerController(C).GotoState('PlayerWaiting');
				PlayerController(C).SetViewTarget(C);
				PlayerController(C).ClientSetBehindView(false);
				PlayerController(C).bBehindView = False;
				PlayerController(C).ClientSetViewTarget(C);
			}
			C.ServerReStartPlayer();
		}
	}
	if( KF!=None )
		KF.bWaveInProgress = bWaveInProgress;
	SetTimer(1,false);
}
function Timer()
{
	local Controller C;

	for ( C = Level.ControllerList; C != none; C = C.NextController )
	{
		if ( C.PlayerReplicationInfo!=none && C.Pawn!=None && PlayerController(C)!=none )
		{
			PlayerController(C).SetViewTarget(C.Pawn);
			PlayerController(C).ClientSetBehindView(false);
			PlayerController(C).bBehindView = False;
			PlayerController(C).ClientSetViewTarget(C.Pawn);
		}
	}
}

defaultproperties
{
     bStatic=False
}
