extends Control
@onready var bocchi: TextureRect = $Bocchi
@onready var nijika: TextureRect = $Ijichi
@onready var ryo: TextureRect = $Ryo
@onready var kita: TextureRect = $Kita
@onready var exit_button = $Exit_Button

#bnri
var imageB2 = preload("res://bocchiNodeimages/bochiNodeB2.png")
var imageB = preload("res://bocchiNodeimages/bochiNodeB.png")
var imageN2 = preload("res://bocchiNodeimages/bochiNodeN2.png")
var imageN = preload("res://bocchiNodeimages/bochiNodeN.png")
var imageR2 = preload("res://bocchiNodeimages/bochiNodeR2.png")
var imageR = preload("res://bocchiNodeimages/bochiNodeR.png")
var imageI2 = preload("res://bocchiNodeimages/bochiNodeI2.png")
var imageI = preload("res://bocchiNodeimages/bochiNodeI.png")
var timeI = 0;
var timeB = 0;
var timeR = 0;
var timeN = 0;
var pressedB = false;
var pressedI = false;
var pressedR = false;
var pressedN = false;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if exit_button.is_pressed():
		get_tree().change_scene_to_file("res://menu.tscn")
	
	
	if(pressedB):
		timeB+=delta;
	if(timeB-0.5>0):
		bocchi.texture = imageB;
		timeB=0;
		pressedB = false;
	if(pressedN):
		timeN+=delta;
	if(timeN-0.5>0):
		nijika.texture = imageN;
		timeN=0;
		pressedN = false;
	if(pressedR):
		timeR+=delta;
	if(timeR-0.5>0):
		ryo.texture = imageR;
		timeR=0;
		pressedR = false;
	if(pressedI):
		timeI+=delta;
	if(timeI-0.5>0):
		kita.texture = imageI;
		timeI=0;
		pressedI = false;
	#TODO
	#Check if timing is correct. If correct make it the happy image
	#else make the sad image
	#check the ms timing as well and award points approiate to the timing.
	#Maybe add text popups saying "Bad" "miss" "Good" "Awesome", etc
	#maybe add a combo counter too at the end
	pass

func _input(event):
	if(event is InputEventKey and event.pressed):
		if(event.keycode == KEY_D):
			bocchi.texture = imageB2
			pressedB = true;
		if(event.keycode == KEY_F):
			nijika.texture = imageN2
			pressedN = true;
		if(event.keycode == KEY_J):
			ryo.texture = imageR2
			pressedR = true;
		if(event.keycode == KEY_K):
			kita.texture = imageI2
			pressedI = true;
	
