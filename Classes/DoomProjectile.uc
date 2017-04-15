class DoomProjectile extends Projectile;

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	if ( (Other != instigator) && (!Other.IsA('Projectile') || Other.bProjTarget) && ExtendedZCollision(Other)==None )
		Explode(HitLocation, vect(0,0,1));
}
simulated function Landed( vector HitNormal )
{
	HitWall(HitNormal,Level);
}
simulated final function ShakeView( float Radius, float ShakeScale )
{
	local PlayerController PC;
	local float D;

	PC = Level.GetLocalPlayerController();
	if( PC!=None && PC.Pawn!=None )
	{
		D = VSize(PC.Pawn.Location-Location);
		if( D<Radius )
		{
			D = 1.f-(D/Radius);
			PC.ShakeView(vect(300,300,300)*ShakeScale*D, vect(12500,12500,12500), 4.f, vect(4,3,3)*ShakeScale*D, vect(300,300,300), 6.f);
		}
	}
}

defaultproperties
{
     TransientSoundVolume=1.000000
}
