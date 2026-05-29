extends Node2D

var note_speed = 500


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.y += note_speed*delta #delta time!
	
	if (global_position.y > 1081):
		queue_free() #deletes it and stuff after it goes out of screen.
		#otherwise there could be hudnreds of notes off-screen which could lag it
	pass
