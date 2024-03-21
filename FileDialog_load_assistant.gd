extends FileDialog

@onready var file_dialog_save = $"."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass





func get_save_dict():
	var save_dict = {}
	
	var llm_tokens = $"../Node/HBoxContainer/TextEdit_tokens"
	var llm_temp = $"../Node/HBoxContainer/TextEdit_temp"
	var llm_fpnlty = $"../Node/HBoxContainer/TextEdit_f"
	var llm_ppnlty = $"../Node/HBoxContainer/TextEdit_p"
	
	
	var max_tokens = int(llm_tokens.text)
	var temperature = float(llm_temp.text)
	var frequency_penalty = float(llm_fpnlty.text)
	var presence_penalty = float(llm_ppnlty.text)
	
	save_dict.messages = $"../ButtonTest2".messages
	save_dict.assistant = $"../ButtonTest2".assistant
	
	save_dict.max_tokens = max_tokens
	save_dict.temperature = temperature
	save_dict.frequency_penalty = frequency_penalty
	save_dict.presence_penalty = presence_penalty

	return save_dict
	


func _on_file_selected(path):
	print("loading")
	var load_file = FileAccess.open(path, FileAccess.READ)
	var the_dict = load_file.get_var()
	
	print(JSON.stringify(the_dict))
	
	var llm_assistant = $"../VBoxContainer/TextEdit_LLM_AGENT"
	#var llm_tokens = $"../Node/HBoxContainer/TextEdit_tokens"
	#var llm_temp = $"../Node/HBoxContainer/TextEdit_temp"
	#var llm_fpnlty = $"../Node/HBoxContainer/TextEdit_f"
	#var llm_ppnlty = $"../Node/HBoxContainer/TextEdit_p"
	#
	#$"../ButtonTest2".messages = the_dict.messages
	llm_assistant.text = str(the_dict.assistant)
	#llm_tokens.text = str(the_dict.max_tokens)
	#llm_temp.text = str(the_dict.temperature)
	#llm_fpnlty.text = str(the_dict.frequency_penalty)
	#llm_ppnlty.text = str(the_dict.presence_penalty)
	#var save_dict = {}
	#

	$"../ButtonTest2".update_output()
	
