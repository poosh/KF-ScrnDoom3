Class DoomBossAI extends Doom3Controller;

var bool bInitialTeleport;

state ZombieHunt
{
    function BeginState()
    {
        if (bInitialTeleport) {
            bInitialTeleport = false;
            GotoState('Teleport', 'Random');
        }
        else {
            super.BeginState();
        }
    }
}

state ZombieCharge
{
    function BeginState()
    {
        super.BeginState();
        bInitialTeleport = false;
    }
}

defaultproperties
{
    bInitialTeleport=true
}
