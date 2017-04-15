class DemonSpawnBase extends DoomEmitter;

var Sound SpawnSound;
var float TeleportInTime;

simulated function PostBeginPlay()
{
	if( Level.NetMode==NM_DedicatedServer )
	{
		LifeSpan = 1.f;
		return;
	}
	if( SpawnSound!=None )
	{
		PlaySound(SpawnSound,SLOT_Interact,1.4f,,500.f);
		PlaySound(SpawnSound,SLOT_Pain,1.4f,,500.f);
	}
	Spawn(class'DoomSymbolProjector',,,Location + vect(0,0,10));
}

defaultproperties
{
     SpawnSound=Sound'2009DoomMonstersSounds.Misc.Misc_tele2_full3_1s'
     TeleportInTime=1.500000
     bNetTemporary=True
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=8.000000
     AmbientGlow=150
}
