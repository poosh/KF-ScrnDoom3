class DemonSpawnBase extends DoomEmitter;

var Sound SpawnSound;
var float TeleportInTime;

var class<DoomSymbolProjector> SpawnProj;

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
	Spawn(SpawnProj,,,Location + vect(0,0,10));
}

static function PreCacheMaterials(LevelInfo Level)
{
	local int i;

	for ( i = 0; i < default.Emitters.Length; ++i ) {
		Level.AddPrecacheMaterial(default.Emitters[i].default.Texture);
	}

	if ( default.SpawnProj != none ) {
		Level.AddPrecacheMaterial(default.SpawnProj.default.ProjTexture);
	}
}

defaultproperties
{
	SpawnProj=class'ScrnDoom3KF.DoomSymbolProjector'
	SpawnSound=Sound'2009DoomMonstersSounds.Misc.Misc_tele2_full3_1s'
	TeleportInTime=1.500000
	bNetTemporary=True
	RemoteRole=ROLE_SimulatedProxy
	LifeSpan=8.000000
	AmbientGlow=150
}
