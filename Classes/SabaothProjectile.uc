class SabaothProjectile extends DoomProjectile;

var SabaothProjTrail Trail;
var Sound NewImpactSounds[4];
var class<SabaothProjArc> GreenArcs[2];
var Sound ArcSounds[3];
var vector NormalDir;
var bool bHadDeathFX;
var int Health;
var float ChargeTime;

var transient int PlayerHits; //how many times arcs hit players
var transient bool bDestoyedByHuman;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if ( Level.NetMode != NM_DedicatedServer )
		Trail = Spawn(class'SabaothProjTrail',self);
	Velocity = Vector(Rotation) * Speed;
	ChargeTime = Level.TimeSeconds + default.ChargeTime;
	SetTimer(1.0, false);
}

simulated function Timer()
{
	local Actor A;
	local byte ArcCounter;
	local SabaothProjArc Arc;

	if (bDeleteMe)
		return;

	if( NormalDir==vect(0,0,0) )
		NormalDir = Normal(Velocity);

	foreach VisibleCollidingActors(class'Actor', A, 600)
	{
		if( !A.bStatic && A.Class!=Class && A!=Instigator && (A.bProjTarget || A.bBlockActors) && ((NormalDir Dot Normal(A.Location-Location))>0.45f) )
		{
			if( Level.NetMode!=NM_DedicatedServer )
			{
				Arc = Spawn(GreenArcs[Rand(2)],Self);
				Arc.mSpawnVecA = A.Location;
				Arc.Target = A;
				Arc.AmbientSound = ArcSounds[Rand(3)];
			}
			if( A.Role==ROLE_Authority ) {
				A.TakeDamage(Damage*0.1,Instigator,Location,1000.f * vRand(),MyDamageType);
				if ( KFPawn(A) != none )
					PlayerHits++;
			}
			if( ++ArcCounter>=6 )
				break;
		}
	}
	SetTimer(0.1, false);
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
	local int OriginalDamage;

	if( bHadDeathFX )
		return;
	bHadDeathFX = true;

	OriginalDamage = Damage;
	if ( Level.TimeSeconds < ChargeTime ) {
		Damage *= fmax(0.2, 1.0 - ((ChargeTime - Level.TimeSeconds) / default.ChargeTime));
	}
	Level.GetLocalPlayerController().ClientMessage("BFG exploded with Damage " $ Damage $ " / " $ OriginalDamage);

	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );

	PlaySound(NewImpactSounds[Rand(4)], SLOT_Misc);
	if ( EffectIsRelevant(Location,false) )
		Spawn(class'SabaothProjExplosion',,, Location);
	Destroy();
}

simulated function Destroyed()
{
	if (Trail != None)
		Trail.Kill();
	if( !bHadDeathFX && Level.NetMode==NM_Client )
		Explode(Location,Normal(-Velocity));
	Super.Destroyed();
}

function ProcessTouch(Actor Other, Vector HitLocation)
{
	if ( Other!=Instigator && ExtendedZCollision(Other)==None )
		Explode(HitLocation,Normal(HitLocation-Other.Location));
}
singular function HitWall(vector HitNormal, actor Wall)
{
	if ( !Wall.bStatic && !Wall.bWorldGeometry )
	{
		if ( Instigator == None || Instigator.Controller == None )
			Wall.SetDelayedDamageInstigatorController( InstigatorController );
		Wall.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
		if (DamageRadius > 0 && Vehicle(Wall) != None && Vehicle(Wall).Health > 0)
			Vehicle(Wall).DriverRadiusDamage(Damage, DamageRadius, InstigatorController, MyDamageType, MomentumTransfer, Location);
		HurtWall = Wall;
	}
	MakeNoise(1.0);
	Explode(Location + ExploWallOut * HitNormal, HitNormal);
	HurtWall = None;
}
function TakeDamage(int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
	local class<KFWeaponDamageType> KFDamType;

	KFDamType = class<KFWeaponDamageType>(DamageType);
	if (KFDamType != none && KFDamType.default.bCheckForHeadShots && KFDamType.default.HeadShotDamageMult > 1.0) {
		Damage *= KFDamType.default.HeadShotDamageMult;
	}

	Health -= Damage;
	if( Health <= 0 ) {
		bDestoyedByHuman = KFPawn(InstigatedBy) != none;
		DamageRadius = 100.f;
		Explode(Location,Normal(Location-HitLocation));
		// this added for achievement track - destory BFG cell before it hurts anyone
		if ( PlayerHits == 0 ) {
			Instigator.TakeDamage(666, InstigatedBy, Instigator.Location, vect(0,0,0), class'DamTypeBFG' );
		}
	}
}

// copy-pasted from Projectile to add bDamagedPlayer
simulated function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
	local actor Victims;
	local float damageScale, dist;
	local vector dir;

	if ( bHurtEntry )
		return;

	bHurtEntry = true;
	foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
	{
		// don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
		if( (bDestoyedByHuman || Victims != self) && (Hurtwall != Victims) && (Victims.Role == ROLE_Authority) && !Victims.IsA('FluidSurfaceInfo') )
		{
			dir = Victims.Location - HitLocation;
			dist = FMax(1,VSize(dir));
			dir = dir/dist;
			damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
			if ( Instigator == None || Instigator.Controller == None )
				Victims.SetDelayedDamageInstigatorController( InstigatorController );
			if ( Victims == LastTouched )
				LastTouched = None;
			if ( bDestoyedByHuman ) {
				if ( Monster(Victims) != none )
					damageScale *= 20; //do huge amount of damage to monsters if BFG cell is destoryed by human
				else if ( KFPawn(Victims) != none && dist > DamageRadius*0.5 )
					continue; // twice smaller damage radius to humans if they destroyed BFG cell in mid-air
			}
			if ( KFPawn(Victims) != none )
				PlayerHits += 10;
			Victims.TakeDamage
			(
				damageScale * DamageAmount,
				Instigator,
				Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
				(damageScale * Momentum * dir),
				DamageType
			);
			if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
				Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);

		}
	}
	if ( (LastTouched != None) && (LastTouched != self) && (LastTouched.Role == ROLE_Authority) && !LastTouched.IsA('FluidSurfaceInfo') )
	{
		Victims = LastTouched;
		LastTouched = None;
		dir = Victims.Location - HitLocation;
		dist = FMax(1,VSize(dir));
		dir = dir/dist;
		damageScale = FMax(Victims.CollisionRadius/(Victims.CollisionRadius + Victims.CollisionHeight),1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius));
		if ( Instigator == None || Instigator.Controller == None )
			Victims.SetDelayedDamageInstigatorController(InstigatorController);
		Victims.TakeDamage
		(
			damageScale * DamageAmount,
			Instigator,
			Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
			(damageScale * Momentum * dir),
			DamageType
		);
		if ( KFPawn(Victims) != none )
				PlayerHits += 10;
		if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
			Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);
	}

	bHurtEntry = false;
}


defaultproperties
{
	 NewImpactSounds(0)=Sound'2009DoomMonstersSounds.BFG.bfg_explode1'
	 NewImpactSounds(1)=Sound'2009DoomMonstersSounds.BFG.bfg_explode2'
	 NewImpactSounds(2)=Sound'2009DoomMonstersSounds.BFG.bfg_explode3'
	 NewImpactSounds(3)=Sound'2009DoomMonstersSounds.BFG.bfg_explode4'
	 GreenArcs(0)=Class'ScrnDoom3KF.SabaothProjArc'
	 GreenArcs(1)=Class'ScrnDoom3KF.SabaothProjArcFat'
	 ArcSounds(0)=Sound'2009DoomMonstersSounds.BFG.arc_1'
	 ArcSounds(1)=Sound'2009DoomMonstersSounds.BFG.arc_3'
	 ArcSounds(2)=Sound'2009DoomMonstersSounds.BFG.arc_4'
	 Speed=1000.000000
	 MaxSpeed=1150.000000
	 Damage=50 // 60
	 DamageRadius=250.000000
	 MomentumTransfer=10000.000000
	 MyDamageType=Class'ScrnDoom3KF.DamTypeSabaothProj'
	 ExplosionDecal=Class'ScrnDoom3KF.SabaothProjDecal'
	 LightType=LT_Steady
	 LightEffect=LE_QuadraticNonIncidence
	 LightHue=106
	 LightSaturation=104
	 LightBrightness=169.000000
	 LightRadius=4.000000
	 DrawType=DT_None
	 bDynamicLight=True
	 bNetTemporary=False
	 AmbientSound=Sound'2009DoomMonstersSounds.BFG.bfg_fly'
	 LifeSpan=10.000000
	 DrawScale=0.200000
	 SoundVolume=255
	 SoundRadius=250.000000
	 TransientSoundVolume=1.500000
	 TransientSoundRadius=450.000000
	 CollisionRadius=16.000000
	 CollisionHeight=16.000000
	 bProjTarget=True
	 Health=100
	 ChargeTime=1.0
}
