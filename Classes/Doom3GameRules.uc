class Doom3GameRules extends GameRules;

var Doom3Mutator Mut;

function AddGameRules(GameRules GR)
{
    if ( GR!=Self ) //prevent adding same rules more than once
        Super.AddGameRules(GR);
}

function int NetDamage( int OriginalDamage, int Damage, pawn injured, pawn instigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType )
{
    // forward call to next rules
    if ( NextGameRules != None )
        Damage = NextGameRules.NetDamage( OriginalDamage,Damage,injured,instigatedBy,HitLocation,Momentum,DamageType );

	if ( OriginalDamage > 0 && DoomMonster(instigatedBy) != none && KFPawn(injured) != none )
            HumanDamage(Damage, KFPawn(injured), DoomMonster(instigatedBy), DamageType);
            
    return Damage;
}

function HumanDamage(int Damage, KFPawn Victim, DoomMonster InstigatedBy, class<DamageType> DamageType)
{
	local Doom3Controller D3C;
	
	D3C = Doom3Controller(InstigatedBy.Controller);
	if ( D3C != none ) {
		// monster delivered damage soon after teleportation - good spot
		if ( D3C.bRateTeleportDest && Level.TimeSeconds < D3C.LastTeleportTime + 30 ) {
			// IncLastTeleportDestRaiting is raising raiting only once per teleportation
			D3C.IncLastTeleportDestRaiting(0.1);
		}
	}
}
