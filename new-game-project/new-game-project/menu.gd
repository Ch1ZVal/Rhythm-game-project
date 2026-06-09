extends Control

@onready var sau_play = $ShineasusualPlaybutton
@onready var shiawase_play = $ShiawasePlaybutton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if sau_play.is_pressed():
		GlobalTrackManager.selected_song = load("res://songs_mp3/Shine as usual.mp3")
		get_tree().change_scene_to_file("res://Stage.tscn")
	elif shiawase_play.is_pressed():
		GlobalTrackManager.selected_song = load("res://songs_mp3/Shiawase.mp3")
		get_tree().change_scene_to_file("res://Stage.tscn")
	#and then add more elifs as we add more songs
	pass
