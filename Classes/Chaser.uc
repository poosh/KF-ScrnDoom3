class Chaser extends HunterInvul;

simulated function Charge()
{
	super.Charge();
	// longer invulnerability phases
	NextShockwaveTime += 15.0;
}

defaultproperties
{
	ControllerClass=Class'ChaserAI'
	MenuName="Hunter"
	HealthMax=4000
	Health=4000
	PlayerCountHealthScale=1.0
}