extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	

	pass


func _on_button_up():
	# update system arr and then redisable this button
	var the_idx = int($"../../arr_id".text)
	print(the_idx)
	#$"../../../../../ButtonTest2".messages[the_idx].content = $"../../TextEdit".text	
	
	# remove ButtonTest2 messages[the_id]
	$"../../../../../ButtonTest2".messages.remove_at(the_idx)
	
	# refresh content
	$"../../../../../ButtonTest2".update_output()
	
	pass # Replace with function body.
