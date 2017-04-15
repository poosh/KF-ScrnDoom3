class ArchvileSymbolProjector extends Projector;

function PostBeginPlay()
{
	local Rotator R;

	if ( PhysicsVolume.bNoDecals )
	{
		Destroy();
		return;
	}
	R.Pitch = -16400;
	SetRotation(R);
	Super.PostBeginPlay();
}

defaultproperties
{
     MaterialBlendingOp=PB_AlphaBlend
     FrameBufferBlendingOp=PB_Add
     ProjTexture=Texture'2009DoomMonstersTex.Symbols.SpawnBurn'
     FOV=45
     MaxTraceDistance=256
     bProjectParticles=False
     bProjectActor=False
     bClipBSP=True
     bClipStaticMesh=True
     bProjectOnUnlit=True
     bNoProjectOnOwner=True
     DrawScale=0.300000
}
