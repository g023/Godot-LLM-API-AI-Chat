extends Button



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	

	pass
	
func get_idx():
	return int($"../../arr_id".text)
	
func del_idx(int_idx):
	$"../../../../../ButtonTest2".messages.remove_at(int_idx) # remove ButtonTest2 messages[the_id]
	$"../../../../../ButtonTest2".update_output() # refresh content


func _on_button_up():
	# del_idx(get_idx())
	var confirm_dlg = $"../../../../../Node2D_confirmations/ConfirmationDialog_delete_message"
	confirm_dlg.msg_id = get_idx()
	confirm_dlg.show()
	# update system arr and then redisable this button
	#var the_idx = int($"../../arr_id".text)
	#print(the_idx)
	##$"../../../../../ButtonTest2".messages[the_idx].content = $"../../TextEdit".text	
	## remove ButtonTest2 messages[the_id]
	#$"../../../../../ButtonTest2".messages.remove_at(the_idx)
	## refresh content
	#$"../../../../../ButtonTest2".update_output()
	
	pass # Replace with function body.

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_confirmation_dialog_delete_message_confirmed():
	var confirm_dlg = $"../../../../../Node2D_confirmations/ConfirmationDialog_delete_message"
	var msg_id = int(confirm_dlg.msg_id)
	if msg_id != -1:
		del_idx(msg_id)
		pass
	pass # Replace with function body.
