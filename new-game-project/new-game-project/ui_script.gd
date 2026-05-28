extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#TODO
	#Check if timing is correct. If correct make it the happy image
	#else make the sad image
	#check the ms timing as well and award points approiate to the timing.
	#Maybe add text popups saying "Bad" "miss" "Good" "Awesome", etc
	#maybe add a combo counter too at the end
	if (Input.is_key_pressed(KEY_D)):
		print("D Pressed")
	if (Input.is_key_pressed(KEY_F)):
		print("F Pressed")
	if (Input.is_key_pressed(KEY_J)):
		print("J Pressed")
	if (Input.is_key_pressed(KEY_K)):
		print("K Pressed")
