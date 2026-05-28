extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.


#Code gameplay for the notes falling, alligning with x position of lane receptor
#allign Y with the "Hitzone" because otherwise the recievers return LOCAL positon in respect to hitzone which is bad...
#use hitzone for distance calculation, reciever for allignment and VFX


#TODO: Clock, math, score calculation, managing songs, etc
#NOTE THIS SCRIPT CONTROLS THE HUD TOO DO NOT MAKE A SEPERATE SCRIPT FOR HUD

func _process(delta: float) -> void:
	pass
