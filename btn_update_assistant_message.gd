extends Button

var message_arr_index=-1 # message row # set when refreshing


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_up():
	print($"../../arr_id".text)
	# update system arr and then redisable this button
	var the_idx = int($"../../arr_id".text)
	$"../../../../../ButtonTest2".messages[the_idx].content = $"../../TextEdit".text
	self.disabled = true
	pass # Replace with function body.


func _on_text_edit_text_changed():
	print($"../../arr_id".text)
	self.disabled = false
	pass # Replace with function body.
