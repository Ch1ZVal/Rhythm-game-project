extends Node2D

@export var note_scene: PackedScene
@onready var playfield = $Playfield #this is prob gonna be used for some other thing if i want to change the scene template
const NOTE_TEMPLATE = preload("res://Note.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.


#Code gameplay for the notes falling, alligning with x position of lane receptor
#allign Y with the "Hitzone" because otherwise the recievers return LOCAL positon in respect to hitzone which is bad...
#use hitzone for distance calculation, reciever for allignment and VFX


#TODO: Clock, math, score calculation, managing songs, etc
#NOTE THIS SCRIPT CONTROLS THE HUD TOO DO NOT MAKE A SEPERATE SCRIPT FOR HUD

func _spawn_note_in_lane(lane_num : int):
	var new_note = NOTE_TEMPLATE.instantiate()
	var color_rect = new_note.get_node("ColorRect")
	
	if lane_num == 1:
		color_rect.color = Color.from_string("#ff9ee8", Color.HOT_PINK)
		#2nd arg is for if the first color doesn't load, its a backup color
	elif lane_num == 2:
		color_rect.color = Color.from_string("#fff700", Color.YELLOW)
	elif lane_num == 3:
		color_rect.color = Color.from_string("#00318c", Color.NAVY_BLUE)
	elif lane_num == 4:
		color_rect.color = Color.from_string("#ff6159", Color.LIGHT_CORAL)
		
	
	var receiver = playfield.get_node("HitZone/Lane" + str(lane_num) + "_Receiver")
	#NOTE may rename the recievers to get cleaner code
	
	#set pos
	new_note.global_position.x = receiver.global_position.x
	new_note.global_position.y = 0
	
	playfield.add_child(new_note)


func _input(event): #event parameter is just whatever keys the user pressed.
	if event is InputEventKey:
		#if event.physical_keycode in [KEY_D, KEY_F, KEY_J, KEY_K]: #checks if lane key pressed
			#print(event.as_text_keycode() + "was pressed")
		if event.physical_keycode in [KEY_1]: #input for testing if spawning the notes work for each lane
			_spawn_note_in_lane(1)
		elif event.physical_keycode in [KEY_2]: #input for testing if spawning the notes work for each lane
			_spawn_note_in_lane(2)
		elif event.physical_keycode in [KEY_3]: #input for testing if spawning the notes work for each lane
			_spawn_note_in_lane(3)
		elif event.physical_keycode in [KEY_4]: #input for testing if spawning the notes work for each lane
			_spawn_note_in_lane(4)
		
		
pass


func _process(delta: float) -> void:
		
	pass
