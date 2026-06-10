extends Node2D

@export var note_scene: PackedScene
@onready var audio_stream = $AudioStreamPlayer
@onready var playfield = $Playfield 

const NOTE_TEMPLATE = preload("res://Note.tscn")
const RECEPTOR_Y = 859.0 #where the Y recetor is. Basically feeds on the notes at that Y.
const SPAWN_Y = 0.0 #the y in which notes spawn

var current_time: float = 0.0
var travel_time: float = 1.5 #1.5 seconds to travel down
var note_speed: float = 572.6

var selected_song = ""

var test_chart: Array[Dictionary] = [  #gemini made this test song chart
	#which is also why it has comments ;-;
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
	{"spawn_time": 9.5, "lane": 2}, #oh yeah make to add commas if we're gonna be doing it like this
	
	{"spawn_time": 15, "lane": 2},
	{"spawn_time": 15, "lane": 1}
]

#these arrays track all notes spawned within their respective lanes.
var lane_1_notes: Array[Node2D] = []
var lane_2_notes: Array[Node2D] = []
var lane_3_notes: Array[Node2D] = []
var lane_4_notes: Array[Node2D] = []


func _ready() -> void:
	selected_song = GlobalTrackManager.selected_song
	if selected_song != null:
		audio_stream.stream = selected_song
		audio_stream.play() 


func _process(_delta: float) -> void:
	if audio_stream.is_playing():
		current_time = audio_stream.get_playback_position()
		
		for i in range(test_chart.size() - 1, -1, -1):
			var note_data = test_chart[i]
			
			if current_time >= note_data["spawn_time"]:
				_spawn_note_in_lane(note_data["lane"], note_data["spawn_time"])
				test_chart.remove_at(i)
		_move_active_notes()


func _spawn_note_in_lane(lane_num: int, spawn_time: float):
	var new_note = NOTE_TEMPLATE.instantiate()
	var color_rect = new_note.get_node("ColorRect")
	
	#color notes
	if lane_num == 1:
		color_rect.color = Color.from_string("#ff9ee8", Color.HOT_PINK) #2nd param is backup if  color loading fails
	elif lane_num == 2:
		color_rect.color = Color.from_string("#fff700", Color.YELLOW)
	elif lane_num == 3:
		color_rect.color = Color.from_string("#00318c", Color.NAVY_BLUE)
	elif lane_num == 4:
		color_rect.color = Color.from_string("#ff6159", Color.LIGHT_CORAL)
		
	var receiver = playfield.get_node("HitZone/Lane" + str(lane_num) + "_Receiver")
	new_note.global_position.x = receiver.global_position.x
	
	
	var time_passed_since_spawn = current_time - spawn_time
	var extra_distance = time_passed_since_spawn * note_speed
	
	new_note.global_position.y = SPAWN_Y + extra_distance
	
	new_note.hit_time = spawn_time + travel_time #When it's due at RECEPTOR_Y
	new_note.note_speed = note_speed
	new_note.receptor_y = RECEPTOR_Y 
	
	playfield.add_child(new_note)
	
	if lane_num == 1: lane_1_notes.append(new_note)
	elif lane_num == 2: lane_2_notes.append(new_note)
	elif lane_num == 3: lane_3_notes.append(new_note)
	elif lane_num == 4: lane_4_notes.append(new_note)


func _move_active_notes() -> void: #moves the notes... pretty explainitory.
	var all_live_notes = lane_1_notes + lane_2_notes + lane_3_notes + lane_4_notes
	
	for note in all_live_notes:
		if is_instance_valid(note):
			#NOTE so uh what this does is finds the time remaining and distance, then it just updates pos
			var time_remaining = note.hit_time - current_time
			var distance_from_receptor = time_remaining * note.note_speed
			note.global_position.y = note.receptor_y - distance_from_receptor
		else:
			lane_1_notes.erase(note)
			lane_2_notes.erase(note)
			lane_3_notes.erase(note)
			lane_4_notes.erase(note)


func _input(event: InputEvent) -> void: #timing
	if audio_stream.is_playing() and event is InputEventKey and event.pressed and not event.echo:
			var user_hit_time = audio_stream.get_playback_position()
			var spawn_time = user_hit_time + travel_time
			var lane = 0
			#:var = x is a neat way to edit stuff :)
			if event.physical_keycode == KEY_D: lane = 1 
			elif event.physical_keycode == KEY_F: lane = 2
			elif event.physical_keycode == KEY_J: lane = 3
			elif event.physical_keycode == KEY_K: lane = 4
			
			
			
			
			
	
	pass
	
