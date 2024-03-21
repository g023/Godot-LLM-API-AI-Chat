extends Button

var id = ""

func _ready():
	# checkbox.pressed = true # if we want to force
	$".".connect("button_up", _on_button_up)
	id = randi_range(0,99999)

#func _on_button_up(button_pressed):
	#
	#print(id)

func _on_button_up():
	print(id)
	DisplayServer.clipboard_set($"../../TextEdit".text) # godot 4 compatible
	print("copied to clipboard")

