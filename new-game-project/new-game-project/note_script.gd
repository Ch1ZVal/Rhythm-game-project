extends Node2D

#will be modified in main so they are default to 0.0
var hit_time: float = 0.0
var note_speed: float = 0.0
var receptor_y: float = 0.0


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	if global_position.y > 1081:
		queue_free() #deletes if off-screen
