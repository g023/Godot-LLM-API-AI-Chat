extends FileDialog

@onready var file_dialog_save = $"."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_file_dialog_save_file_selected(path):
	print("saving")

	
	pass




func get_save_dict():
	var save_dict = {}
	#
	#var llm_tokens = $"../Node/HBoxContainer/TextEdit_tokens"
	#var llm_temp = $"../Node/HBoxContainer/TextEdit_temp"
	#var llm_fpnlty = $"../Node/HBoxContainer/TextEdit_f"
	#var llm_ppnlty = $"../Node/HBoxContainer/TextEdit_p"
	#
	#
	#var max_tokens = int(llm_tokens.text)
	#var temperature = float(llm_temp.text)
	#var frequency_penalty = float(llm_fpnlty.text)
	#var presence_penalty = float(llm_ppnlty.text)
	#
	#save_dict.messages = $"../ButtonTest2".messages
	#save_dict.assistant = $"../VBoxContainer/TextEdit_LLM_AGENT".text
	#
	#save_dict.max_tokens = max_tokens
	#save_dict.temperature = temperature
	#save_dict.frequency_penalty = frequency_penalty
	#save_dict.presence_penalty = presence_penalty
	var llm_prompt = $"../VBoxContainer2/TextEdit_LLM_INPUT"
	# llm_prompt = the_dict.prompt
	save_dict.prompt = str(llm_prompt.text)

	return save_dict
	


func _on_file_selected(path):
	var save_file = FileAccess.open(path, FileAccess.WRITE)
	var save_dict = {}
	
	save_file.store_var(get_save_dict())

	
