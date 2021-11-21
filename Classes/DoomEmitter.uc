class DoomEmitter extends Emitter;

static function PreCacheMaterials(LevelInfo Level)
{
	local int i;

    for ( i = 0; i < default.Emitters.length; ++i ) {
        Level.AddPrecacheMaterial(default.Emitters[i].Texture);
    }
}

defaultproperties
{
     AutoDestroy=True
     bNoDelete=False
     bNotOnDedServer=False
}
