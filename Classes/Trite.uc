class Trite extends Tick;

function Landed(vector HitNormal)
{
	if( bLunging )
	{
		PrepareStillAttack(None);
		bLunging = false;
		SetAnimAction(LandAnims[0]);
	}
	Super(Monster).Landed(HitNormal);
}
simulated function Implode()
{
	if(Level.NetMode != NM_DedicatedServer)
	{
		Spawn(class'TriteExplode',,,GetBoneCoords('Head').Origin);
		LifeSpan = 0.25f;
	}
}
simulated function PlayDirectionalDeath(Vector HitLoc)
{
	if( FRand()>0.75f )
	{
		PlayAnim('DeathCurlExplode',1.00);
		LifeSpan = 1.5f;
		SetCollision(false);
	}
	else Super.PlayDirectionalDeath(HitLoc);
}
simulated function FadeSkins()
{
	Skins[0] = FadeFX;
	MakeBurnAway();
}
simulated function BurnAway()
{
	Skins[0] = BurnFX;
	Burning = true;
}
simulated function SpawnSparksFX()
{
	Super(DoomMonster).SpawnSparksFX();
}
simulated function ZombieCrispUp()
{
	Super(DoomMonster).ZombieCrispUp();
}

defaultproperties
{
     LungeAttackDamage=15
     DeathAnims(2)="DeathCurl"
     DeathAnims(3)="DeathF"
     MeleeAttackSounds(0)=Sound'2009DoomMonstersSounds.Trite.Trite_attack18'
     MeleeAttackSounds(1)=Sound'2009DoomMonstersSounds.Trite.Trite_chomp1'
     MeleeAttackSounds(2)=Sound'2009DoomMonstersSounds.Trite.Trite_attack13'
     MeleeAttackSounds(3)=Sound'2009DoomMonstersSounds.Trite.Trite_attack11'
     SightSound=Sound'2009DoomMonstersSounds.Trite.Trite_sight3'
     BurningMaterial=Shader'2009DoomMonstersTex.Trite.TriteShader'
     BurnDust=Class'ScrnDoom3KF.DoomDeResDustSmall'
     MeleeDamage=10
     FootStep(0)=Sound'2009DoomMonstersSounds.Trite.trite_walk1'
     FootStep(1)=Sound'2009DoomMonstersSounds.Trite.trite_walk2'
     HitSound(0)=Sound'2009DoomMonstersSounds.Trite.Trite_pain13'
     HitSound(1)=Sound'2009DoomMonstersSounds.Trite.Trite_pain21'
     HitSound(2)=Sound'2009DoomMonstersSounds.Trite.Trite_pain22'
     HitSound(3)=Sound'2009DoomMonstersSounds.Trite.Trite_pain10'
     DeathSound(0)=Sound'2009DoomMonstersSounds.Trite.Trite_death21'
     DeathSound(1)=Sound'2009DoomMonstersSounds.Trite.Trite_Death22'
     DeathSound(2)=Sound'2009DoomMonstersSounds.Trite.Trite_death23'
     DeathSound(3)=Sound'2009DoomMonstersSounds.Trite.Trite_death21'
     ChallengeSound(0)=Sound'2009DoomMonstersSounds.Trite.Trite_sight3'
     ChallengeSound(1)=Sound'2009DoomMonstersSounds.Trite.Trite_sight11'
     ChallengeSound(2)=Sound'2009DoomMonstersSounds.Trite.Trite_sight13'
     ChallengeSound(3)=Sound'2009DoomMonstersSounds.Trite.Trite_sight5'
     ScoringValue=12
     RagdollOverride="D3Trite"
     MeleeRange=35.000000
     GroundSpeed=115.000000
     HealthMax=120.000000
     Health=120
     MenuName="Trite"
     LandAnims(0)="Jump_End"
     LandAnims(1)="Jump_End"
     LandAnims(2)="Jump_End"
     LandAnims(3)="Jump_End"
     Mesh=SkeletalMesh'2009DoomMonstersAnims.TriteMesh'
     PrePivot=(Z=2.000000)
     Skins(0)=Combiner'2009DoomMonstersTex.Trite.JTrite'
     Skins(1)=Texture'2009DoomMonstersTex.Revenant.InvisMat'
     AmbientGlow=30
     CollisionHeight=22.000000

	FireRootBone="Spine1"
	RootBone="Belly"
}
