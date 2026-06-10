extends Node2D
@onready var audio_player = get_node("/root/Gameplay/AudioStreamPlayer")


var distance_from_y = 859

var travel_time: float = 1.5 #number of seconds the note has to travel down the lane into the receptor
#adjusting the time will make the speed faster/slower
var note_speed = distance_from_y/travel_time

#


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var spawn_time: float = audio_player.get_playback_position()
	var hit_time =  spawn_time + travel_time
	print(hit_time)
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.y += note_speed*delta #delta time!
	
	if (global_position.y > 1081):
		queue_free() #deletes it and stuff after it goes out of screen.
		#otherwise there could be hudnreds of notes off-screen which could lag it
	pass
