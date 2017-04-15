class WraithTeleportScorch extends Projector;

simulated function PostBeginPlay()
{
	local Rotator R;

	if ( PhysicsVolume.bNoDecals )
	{
		Destroy();
		return;
	}
	R.Pitch = -16384;

	SetRotation(R);
	Super.PostBeginPlay();
}

defaultproperties
{
     MaterialBlendingOp=PB_AlphaBlend
     FrameBufferBlendingOp=PB_None
     ProjTexture=Texture'2009DoomMonstersTex.Symbols.SpawnBurnAlphaInvert2'
     FOV=1
     MaxTraceDistance=75
     bProjectTerrain=False
     bProjectParticles=False
     bProjectActor=False
     bClipBSP=True
     bClipStaticMesh=True
     bProjectOnUnlit=True
     FadeInTime=1.000000
     bStatic=False
     LifeSpan=4.000000
     DrawScale=0.350000
     bGameRelevant=True
}
