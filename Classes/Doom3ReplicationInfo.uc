class Doom3ReplicationInfo extends ReplicationInfo;

var const class<DoomMonster> PrecacheMonsters[32];
var int PrecacheMonsterMask;

replication {
	reliable if ( bNetInitial && Role == ROLE_Authority )
		PrecacheMonsterMask;
}

simulated function PostNetBeginPlay()
{
	UpdatePrecacheMaterials();
}

simulated function UpdatePrecacheMaterials()
{
	local int i;
	local int mask;

	mask = PrecacheMonsterMask;
	for ( i = 0; i < 32 && mask != 0; ++i ) {
		if ( (mask & 1) == 1 && PrecacheMonsters[i] != none ) {
			PrecacheMonsters[i].static.PreCacheMaterials(Level);
		}
		mask = mask >>> 1;
	}
}

function PrecacheMonster(class<DoomMonster> DM)
{
	local int i;

	if ( DM == none )
		return;

	for ( i = 0; i < 32; ++i ) {
		if ( PrecacheMonsters[i] == DM ) {
			PrecacheMonsterMask = PrecacheMonsterMask | (1 << i);
			return;
		}
	}
}

defaultproperties
{
	PrecacheMonsterMask=0x1FFFFFFF
	PrecacheMonsters(00)=class'ScrnDoom3KF.Archvile'
	PrecacheMonsters(01)=class'ScrnDoom3KF.Boney'
	PrecacheMonsters(02)=class'ScrnDoom3KF.Bruiser'
	PrecacheMonsters(03)=class'ScrnDoom3KF.Cacodemon'
	PrecacheMonsters(04)=class'ScrnDoom3KF.Cherub'
	PrecacheMonsters(05)=class'ScrnDoom3KF.Commando'
	PrecacheMonsters(06)=class'ScrnDoom3KF.FatZombie'
	PrecacheMonsters(07)=class'ScrnDoom3KF.HellKnight'
	PrecacheMonsters(08)=class'ScrnDoom3KF.Imp'
	PrecacheMonsters(09)=class'ScrnDoom3KF.LostSoul'
	PrecacheMonsters(10)=class'ScrnDoom3KF.Forgotten'
	PrecacheMonsters(11)=class'ScrnDoom3KF.Maggot'
	PrecacheMonsters(12)=class'ScrnDoom3KF.Mancubus'
	PrecacheMonsters(13)=class'ScrnDoom3KF.Pinky'
	PrecacheMonsters(14)=class'ScrnDoom3KF.Revenant'
	PrecacheMonsters(15)=class'ScrnDoom3KF.Sawyer'
	PrecacheMonsters(16)=class'ScrnDoom3KF.Seeker'
	PrecacheMonsters(17)=class'ScrnDoom3KF.Tick'
	PrecacheMonsters(18)=class'ScrnDoom3KF.Trite'
	PrecacheMonsters(19)=class'ScrnDoom3KF.Vulgar'
	PrecacheMonsters(20)=class'ScrnDoom3KF.Wraith'
	PrecacheMonsters(21)=class'ScrnDoom3KF.CyberDemon'
	PrecacheMonsters(22)=class'ScrnDoom3KF.Guardian'
	PrecacheMonsters(23)=class'ScrnDoom3KF.HunterBerserk'
	PrecacheMonsters(24)=class'ScrnDoom3KF.HunterHellTime'
	PrecacheMonsters(25)=class'ScrnDoom3KF.HunterInvul'
	PrecacheMonsters(26)=class'ScrnDoom3KF.Maledict'
	PrecacheMonsters(27)=class'ScrnDoom3KF.Sabaoth'
	PrecacheMonsters(28)=class'ScrnDoom3KF.Vagary'
}
