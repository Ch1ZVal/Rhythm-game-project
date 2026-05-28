extends Node2D

@export var note_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.


#Code gameplay for the notes falling, alligning with x position of lane receptor
#allign Y with the "Hitzone" because otherwise the recievers return LOCAL positon in respect to hitzone which is bad...
#use hitzone for distance calculation, reciever for allignment and VFX


#TODO: Clock, math, score calculation, managing songs, etc
#NOTE THIS SCRIPT CONTROLS THE HUD TOO DO NOT MAKE A SEPERATE SCRIPT FOR HUD

func _input(event): #event parameter is just whatever keys the user pressed.
	if event is InputEventKey:
		if event.physical_keycode in [KEY_D, KEY_F, KEY_J, KEY_K]:
			print(event.as_text_keycode() + "was pressed")
		elif event.physical_keycode in [KEY_1, KEY_2, KEY_3, KEY_4]: #input for testing if spawning the notes work for each lane
			print("Number " + event.as_text_keycode() + " was pressed")
			
pass


func _process(delta: float) -> void:
	#if (Input.is_key_pressed(KEY_D)):
		#print("D Pressed")
	#if (Input.is_key_pressed(KEY_F)):
		#print("F Pressed")
	#if (Input.is_key_pressed(KEY_J)):
		#print("J Pressed")
	#if (Input.is_key_pressed(KEY_K)):
		#print("K Pressed")
		
	pass
