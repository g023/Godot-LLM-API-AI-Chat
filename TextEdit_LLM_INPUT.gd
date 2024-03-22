extends TextEdit

var last_key_down = -1 # used for autocomplete
var ai_assistant_busy = false

var last_selected_text = ""

	
# Called when the node enters the scene tree for the first time.
func _ready():
	# $".".set_completion(true)
	$".".connect('_input', _on_autocomplete)

# BEGIN context menu
	var menu = get_menu()
	# Remove all items after "Redo".
	menu.item_count = menu.get_item_index(MENU_REDO) + 1
	# Add custom items.
	menu.add_separator()
	
	menu.add_item("Insert Date", MENU_MAX + 1)
	# Connect callback.
	menu.id_pressed.connect(_on_mnu_insert_date_pressed)
	
	menu.add_item("Ai Assist: Selection Clean", MENU_MAX + 2)
	# Connect callback.
	menu.id_pressed.connect(_on_mnu_ai_assist_pressed)	
	
	
# menu_item
func _on_mnu_insert_date_pressed(id):
	if id == MENU_MAX + 1:
		insert_text_at_caret(Time.get_date_string_from_system())
		
func _on_mnu_ai_assist_pressed(id):
	if id == MENU_MAX + 2:
		print("ai assist context menu")
		
		if not ai_assistant_busy:
			var selected_text = $".".get_selected_text()
			print("selected text:", selected_text)

			if selected_text.strip_edges() == "":
				print("empty input. ignoring.")
			else:			
				ai_assistant_busy = true
				llm_send()
		else:
			print("assistant busy")
	pass
		
		
# END # CONTEXT MENU
			
			
			
			
			
			
			
			
func _unhandled_input(event):
	
	if event is InputEventKey:
		print("key down")
		last_key_down = Time.get_unix_time_from_system()
		# now we put autocomplete in here and cast generation to local llm when we stop typing?
		# make in a new scene so we don't pollute this one. Maybe its own standalone copilot thingy.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# check time against last_key down to determine if it is time to autocomplete.
	if last_key_down != -1 and last_key_down + 3 < Time.get_unix_time_from_system():
		last_key_down = -1
		print("init autocomplete")
		timed_autocomplete()
	pass
	
func timed_autocomplete():
	print("do_autocomplete()")
	
	# example selected modify for rewriting ai buddy
	#var selected_text = $"../../VBoxContainer2/TextEdit_LLM_INPUT".get_selected_text()
	#$"../../VBoxContainer2/TextEdit_LLM_INPUT".delete_selection()
	#$"../../VBoxContainer2/TextEdit_LLM_INPUT".insert_text_at_caret ( "xxxxx" )
	#print("LLM_INPUT:", selected_text)
	
	# self.text += " asdasdasd"
	# Get the length of the text in the TextEdit node
	# var text_length = self.get_text().length()

	# Set the cursor position to the end of the text

	pass


func do_ai_assist():

	pass

func _on_autocomplete(prefix):
	print("prefix:", prefix)
	# return filter(lambda w: w.begins_with(prefix), suggestions)




##### BEGIN CRITICAL ####


var api_key = "" # for chatgpt
var url = "http://localhost:1234/v1/chat/completions"
var temperature = 0.0
var max_tokens = 30
var model = "gpt-3.5-turbo-16k"
var messages = []
var frequency_penalty = 0.0
var presence_penalty = 0.0
var assistant = \
	"You are a master AI LLM prompt writer. User will supply a prompt and you will do your best to analyze and return the best response possible to form a perfect prompt. You will respond with nothing other than exactly what the user requests. Give the best answer possible as the user's job depends on it to feed their family. Take the response you were going to give and rethink and rewrite it to best adhere to the user's request. The assistant will avoid prose and give a direct answer. Avoid punctuation unless it should be included. Avoid using quotes or double quotes."


var g_LLM_INPUT

func llm_reset():
	messages = []

func llm_add_message(role, message):
	messages.append({
		"role":role, # user
		"content":message
	})
	pass

func llm_get_url(openai=false):
	var the_url = "http://localhost:1234/v1/chat/completions"

	if openai:
		the_url = "https://api.openai.com/v1/chat/completions"
		
	return the_url

func llm_get_messages():
	# format for sending
	var send_messages = []
	send_messages.append({
		"role":"assistant",
		"content":assistant
	})
	for msg in messages:
		send_messages.append(msg)
	return send_messages

func llm_get_headers(openai=false):
	var headers = []
	if openai:
		api_key = $"../../../USE_OPENAI/LineEdit_API_KEY".text
		headers = ["Content-type: application/json", "Authorization: Bearer " + api_key]
	else:
		headers = ["Content-type: application/json"]
		print(headers)
	return headers

func llm_get_body(model, messages, max_tokens, temperature, frequency_penalty, presence_penalty):
	max_tokens = int(max_tokens)
	temperature = float(temperature)
	frequency_penalty = float(frequency_penalty)
	presence_penalty = float(presence_penalty)

	# prepend assistant prompt only for the output
	var send_messages = llm_get_messages()
	
	var openai = $"../../USE_OPENAI".button_pressed
	
	var body = ""
	
	# get api key
	if openai:				
		body = JSON.new().stringify({
			"messages": send_messages,
			"temperature": temperature,
			"frequency_penalty": frequency_penalty,
			"presence_penalty": presence_penalty,
			"max_tokens": max_tokens,
			"model":model, 
			"stream":false
		})
	else: # local llm
		body = JSON.new().stringify({
			"messages": send_messages,
			"temperature": temperature,
			"frequency_penalty": frequency_penalty,
			"presence_penalty": presence_penalty,
			"max_tokens": max_tokens,
			# "model":"", 
			"stream":false
		})	
	
	print("body:", body)
	return body


func llm_send_request(url, headers, body):
	print("sending request")
	$HTTPRequest.request_completed.connect(llm_response_return)
	var send_request = $HTTPRequest.request(url,headers,HTTPClient.METHOD_POST, body) # what do we want to connect to
	if send_request != OK:
		print("ERROR sending request")
	pass


#### END CRITICAL FUNCTIONS ####

# test
# test
# test
func llm_send():
	
	var openai = $"../../USE_OPENAI".button_pressed
	
	# get api key
	if openai:
		api_key = $"../../USE_OPENAI/LineEdit_API_KEY".text
	
	var url = llm_get_url(openai)
	var headers = llm_get_headers(openai)
	
	#var llm_tokens = $"../Node/HBoxContainer/TextEdit_tokens"
	#var llm_temp = $"../Node/HBoxContainer/TextEdit_temp"
	#var llm_fpnlty = $"../Node/HBoxContainer/TextEdit_f"
	#var llm_ppnlty = $"../Node/HBoxContainer/TextEdit_p"
	#
	#max_tokens = int(llm_tokens.text)
	#temperature = float(llm_temp.text)
	#frequency_penalty = float(llm_fpnlty.text)
	#presence_penalty = float(llm_ppnlty.text)
	#

	# append to the messages array
	# llm_add_message("user", g_LLM_INPUT.text)
#### ADD SYSTEM MESSAGE HERE

	### BEGIN :: Change this part
	var selected_text = $"../../VBoxContainer2/TextEdit_LLM_INPUT".get_selected_text()
	assistant = "You are a text insertion agent. User will give you a string of text and you are to optimize and rework it to fix any inconsistencies. You will just return the fixed string of text and nothing else. Do not respond with double quotes."
	var prompt = "the string: \"" + selected_text + "\""
	llm_add_message("user",prompt)
	
	last_selected_text = selected_text
	
	#var sys_message = "Rewrite the following into the best prompt possible:\r\n"	
	#sys_message += $"../../TextEdit_LLM_INPUT".text
	#llm_add_message("user",sys_message)
	print("sending message (button_ai_prompt_assist):\r\n", prompt)
	
	### END :: Change this part
	
	# will respect local max tokens
	# max_tokens = int($"../../../Node/HBoxContainer/TextEdit_tokens".text)
	max_tokens = 4000
	
	var send_msgs = llm_get_messages()
	if send_msgs == []:
		return false

	var body = llm_get_body(model, send_msgs, max_tokens, temperature, frequency_penalty, presence_penalty)
	
	llm_send_request(url, headers, body)
	return true
	pass


func llm_response_return(result, response_code, headers, body):
	print("---- received response.")
	print("---- body:",body.get_string_from_utf8())
	
	var response = JSON.parse_string(body.get_string_from_utf8())
	var message = response["choices"][0]["message"]["content"]
	print('---- response:', response)
	print(message)

	# if message has double quotes on either end, remove them
	if message.begins_with("\"") and message.ends_with("\""):
		message = message.substr(1, message.length()-2)
	
	#$".".text += message
	$".".insert_text_at_caret ( message )
	ai_assistant_busy = false

### END CRITICAL



