class DoomSymbolProjector extends Projector;

function PostBeginPlay()
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
     FrameBufferBlendingOp=PB_Add
     ProjTexture=Texture'2009DoomMonstersTex.Symbols.SpawnDecal'
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
     DrawScale=0.480000
     bGameRelevant=True
}
