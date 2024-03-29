﻿// LoadData.cs
// Copyright (c) 2023 CookieBadger. All Rights Reserved.

#if TOOLS
#nullable disable
using Godot;

namespace AssetPlacer;

public partial class LoadData : GodotObject
{
    public PreviewRenderingViewport viewport;
    public Callable action; 
    public int loadsteps;
    public PackedScene sceneResource;
    public bool waiting;
    public Vector2I size;
    public AssetPreviewGenerator.Perspective previewPerspective;

    public LoadData()
    {
    }

    public LoadData(Callable action, PackedScene sceneResource, Vector2I size,
        AssetPreviewGenerator.Perspective previewPerspective)
    {
        this.action = action;
        this.sceneResource = sceneResource;
        this.size = size;
        this.previewPerspective = previewPerspective;
        waiting = true;
    }
}
#endif