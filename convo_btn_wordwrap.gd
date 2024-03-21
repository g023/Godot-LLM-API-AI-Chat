extends CheckButton


var id = ""

func _ready():
	# checkbox.pressed = true # if we want to force
	$".".connect("toggled", _on_checkbox_toggled)
	id = randi_range(0,99999)

func _on_checkbox_toggled(button_pressed):
	print("CheckBox is pressed? ", button_pressed)
	#var text = $"../../TextEdit".text
	if button_pressed:
		$"../../TextEdit".wrap_enabled = true
	#$"../../TextEdit".text = text
	
	print(id)
