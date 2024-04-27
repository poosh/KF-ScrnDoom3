class ChaserAI extends DoomBossAI;

state ZombieHunt
{
	function BeginState()
	{
		// teleport more often than usual
		if (NextTeleTimeOnHunt == 0) {
			TeleDelayCount = 0;
			NextTeleTimeOnHunt = Level.TimeSeconds + 30.0 + 30.0 * frand();
		}
		else if (NextTeleTimeOnHunt - Level.TimeSeconds < 2.0) {
			// prevent teleporting immediately after going into ZombieHunt state.
			++TeleDelayCount;
			NextTeleTimeOnHunt = Level.TimeSeconds + 10.0 + 5.0*frand() - TeleDelayCount;
		}
	}
}

defaultproperties
{
	bInitialTeleport=false
}