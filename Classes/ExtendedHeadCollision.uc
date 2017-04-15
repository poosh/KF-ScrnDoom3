// extra collision cylinder for head detection
class ExtendedHeadCollision extends ExtendedZCollision
	NotPlaceable
	Transient;

// Damage the player this is attached to
function TakeDamage( int Damage, Pawn EventInstigator, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
    // 101 - hardcoded HitIndex for headshots
	if( Owner!=None )
		Owner.TakeDamage(Damage,EventInstigator,HitLocation,Momentum,DamageType, 101);
}
