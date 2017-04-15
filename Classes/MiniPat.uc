Class MiniPat extends ZombieBoss;

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
    super(ZombieBossBase).Died(Killer,damageType,HitLocation);
}

defaultproperties
{
     HealthMax=2000.000000
     Health=2000
     MenuName="Patriarch Jr."
}
