extends Node



func _process(delta):
	if Input.is_action_pressed("Quit"):
		get_tree().quit()
