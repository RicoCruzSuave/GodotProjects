// AssetPlacerButton.cs
// Copyright (c) 2023 CookieBadger. All Rights Reserved.

#if TOOLS
#nullable disable
using Godot;

namespace AssetPlacer;

/**
 * Class for the asset buttons. Purely for event/signal handling.
 * On rebuilding, any custom C# event Actions get disconnected.
 * Built-in event actions that are connected to an anonymous lambda with captured variables
 * are then null, which is bad. Very bad.
 */
[Tool]
public partial class AssetPlacerButton : Button
{
	public string assetPath;
	public string assetName;
	
	[Signal]
	public delegate void RightClickedEventHandler(string assetPath, Vector2 clickPosition);
	
	[Signal]
	public delegate void ButtonWasPressedEventHandler(AssetPlacerButton button, string assetPath, string assetName);

	public override void _Ready()
	{
		Pressed += OnPressed;
		GuiInput += OnGuiInput;
	}

	public void SetData(string assetPath, string assetName)
	{
		this.assetPath = assetPath;
		this.assetName = assetName;
	}

	public void OnGuiInput(InputEvent @event)
	{
		if (@event is InputEventMouseButton mouseButton && mouseButton.ButtonMask == MouseButtonMask.Right)
			EmitSignal(SignalName.RightClicked, assetPath, GetScreenPosition() + mouseButton.Position);
	}

	public void OnPressed()
	{
		EmitSignal(SignalName.ButtonWasPressed, this, assetPath, assetName);
	}
}
#endif
