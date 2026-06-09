extends Node2D

@export var note_scene: PackedScene
@onready var audio_stream = $AudioStreamPlayer
@onready var playfield = $Playfield #this is prob gonna be used for some other thing if i want to change the scene template
const NOTE_TEMPLATE = preload("res://Note.tscn")
const RECEPTOR_Y = 859
const SPAWN_Y = 0
var current_time: float = 0.0
var move_down_time: float = 1500.0

var selected_song = ""
#songs lets gooo

var test_chart: Array[Dictionary] = [ #test song chart ai made for me
	# 1. Linear Introduction (Teaches player the layout)
	{"spawn_time": 0.5, "lane": 1},
	{"spawn_time": 1.5, "lane": 2},
	{"spawn_time": 2.5, "lane": 3},
	{"spawn_time": 3.5, "lane": 4},
	
	# 2. The Double-Note (Tests simultaneous rendering)
	{"spawn_time": 5.0, "lane": 1},
	{"spawn_time": 5.0, "lane": 4},
	
	# 3. The Stream (Tests uniform, rhythmic spacing)
	{"spawn_time": 6.0, "lane": 2},
	{"spawn_time": 6.5, "lane": 3},
	{"spawn_time": 7.0, "lane": 4},
	
	# 4. The Double-Tap / Minijack (Tests rapid sequential notes in 1 lane)
	{"spawn_time": 8.0, "lane": 1},
	{"spawn_time": 8.3, "lane": 1},
	
	# 5. Ending Note
	{"spawn_time": 9.5, "lane": 2}
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	selected_song = GlobalTrackManager.selected_song
	
	if selected_song != null:
		audio_stream.stream = selected_song
		audio_stream.play() #no longer has delay when loading song.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.


#Code gameplay for the notes falling, alligning with x position of lane receptor
#allign Y with the "Hitzone" because otherwise the recievers return LOCAL positon in respect to hitzone which is bad...
#use hitzone for distance calculation, reciever for allignment and VFX


#TODO: Clock, math, score calculation, managing songs, etc
#NOTE THIS SCRIPT CONTROLS THE HUD TOO DO NOT MAKE A SEPERATE SCRIPT FOR HUD

func _spawn_note_in_lane(lane_num: int, spawn_time: float):
	var new_note = NOTE_TEMPLATE.instantiate()
	var color_rect = new_note.get_node("ColorRect")
	var hit_time = new_note.hit_time
	
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
	
	#new_note.target_time = calculated_time
	#new_note.travel_time = move_down_time
	
	
	playfield.add_child(new_note)

func _input(event): #event parameter is just whatever keys the user pressed.
	if event is InputEventKey and event.pressed and not event.echo:
		#if event.physical_keycode in [KEY_D, KEY_F, KEY_J, KEY_K]: #checks if lane key pressed
			#print(event.as_text_keycode() + "was pressed")
		if event.physical_keycode in [KEY_D]: #input for testing if spawning the notes work for each lane
			_spawn_note_in_lane(1)
		if event.physical_keycode in [KEY_F]: #input for testing if spawning the notes work for each lane
			_spawn_note_in_lane(2)
		if event.physical_keycode in [KEY_J]: #input for testing if spawning the notes work for each lane
			_spawn_note_in_lane(3)
		if event.physical_keycode in [KEY_K]: #input for testing if spawning the notes work for each lane
			_spawn_note_in_lane(4)


func _process(_delta: float) -> void:
	#if audio_stream.is_playing():
		#print("Is PLAYING THE SONG")
	pass
