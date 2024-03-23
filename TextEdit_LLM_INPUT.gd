extends TextEdit

var last_key_down = -1 # used for autocomplete

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
	
	
	menu.add_item("Ai Assist: Translate to English", MENU_MAX + 3)
	# Connect callback.
	menu.id_pressed.connect(_on_mnu_ai_assist_pressed)	
	
	menu.add_item("Ai Assist: Translate to Chinese", MENU_MAX + 4)
	# Connect callback.
	menu.id_pressed.connect(_on_mnu_ai_assist_pressed)	
		
# menu_item
func _on_mnu_insert_date_pressed(id):
	if id == MENU_MAX + 1:
		insert_text_at_caret(Time.get_date_string_from_system())




### begin -- ai assistant -- selected text cleanup
### begin -- ai assistant -- selected text cleanup
### begin -- ai assistant -- selected text cleanup
var g_ai_assist_busy = false
func _on_mnu_ai_assist_pressed(id):
	
	
	
	
	if id == MENU_MAX + 2:
		print("ai assist context menu")
		
		if not g_ai_assist_busy:
			var selected_text = $".".get_selected_text()
			print("selected text:", selected_text)

			if selected_text.strip_edges() == "":
				print("empty input. ignoring.")
			else:			
				g_ai_assist_busy = true
				# llm_send() # old
				var the_selected_text = $".".get_selected_text()
				var the_assistant = "You are a text insertion agent. User will give you a string of text and you are to optimize and rework it to fix any inconsistencies. You will just return the fixed string of text and nothing else. Do not respond with double quotes. If there is no changes required, just return the original text."
				var the_prompt = "the string: \"" + the_selected_text + "\""
				# llm_send_short
				llm_send_short(the_assistant, the_prompt, 4000, 0.0, 0.0, 0.0, rr)
				
		else:
			print("assistant busy")
			
			
	if id == MENU_MAX + 3:
		print("ai assist context menu - translate to english")
		
		if not g_ai_assist_busy:
			var selected_text = $".".get_selected_text()
			print("selected text:", selected_text)

			if selected_text.strip_edges() == "":
				print("empty input. ignoring.")
			else:			
				g_ai_assist_busy = true
				var the_selected_text = $".".get_selected_text()
				var the_assistant = "You are a master translater that can translate from many languages to english. You will just return the fixed string of text and nothing else. Do not respond with double quotes. If there is no changes required, just return the original text."
				var the_prompt = "the string: \"" + the_selected_text + "\""
				llm_send_short(the_assistant, the_prompt, 4000, 0.0, 0.0, 0.0, rr)
				
		else:
			print("assistant busy")
			
			
			
	if id == MENU_MAX + 4:
		print("ai assist context menu - translate to chinese")
		
		if not g_ai_assist_busy:
			var selected_text = $".".get_selected_text()
			print("selected text:", selected_text)

			if selected_text.strip_edges() == "":
				print("empty input. ignoring.")
			else:			
				g_ai_assist_busy = true
				var the_selected_text = $".".get_selected_text()
				var the_assistant = "You are a master translater that can translate from many languages to chinese. You will just return the fixed string of text and nothing else. Do not respond with double quotes. If there is no changes required, just return the original text."
				var the_prompt = "the string: \"" + the_selected_text + "\""
				llm_send_short(the_assistant, the_prompt, 4000, 0.0, 0.0, 0.0, rr)
				
		else:
			print("assistant busy")
			
			


# rr = response return
func rr(result, response_code, headers, body):
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
	g_ai_assist_busy = false
### end -- ai assistant -- selected text cleanup
### end -- ai assistant -- selected text cleanup
### end -- ai assistant -- selected text cleanup
	
	



	
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


func llm_get_headers(openai=false):
	var headers = []
	if openai:
		var api_key = $"../../../USE_OPENAI/LineEdit_API_KEY".text
		headers = ["Content-type: application/json", "Authorization: Bearer " + api_key]
	else:
		headers = ["Content-type: application/json"]
		print(headers)
	return headers



func llm_get_body_short(the_messages, max_tokens, temperature, frequency_penalty, presence_penalty):
	var model = "gpt-3.5-turbo-16k"
	max_tokens 			= int(max_tokens)
	temperature 		= float(temperature)
	frequency_penalty 	= float(frequency_penalty)
	presence_penalty	= float(presence_penalty)

	# prepend assistant prompt only for the output
	var send_messages 	= the_messages
	
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


func llm_send_request_short(url, headers, body, return_func):
	print("sending request")
	#$HTTPRequest.request_completed.connect(llm_response_return)
	$HTTPRequest.request_completed.connect(return_func)
	var send_request = $HTTPRequest.request(url,headers,HTTPClient.METHOD_POST, body) # what do we want to connect to

	if send_request != OK:
		print("ERROR sending request")
	pass



func llm_send_short(assistant, prompt, max_tokens, temperature, frequency_penalty, presence_penalty, return_Func):
	## --- begin local or remote
	var openai = $"../../USE_OPENAI".button_pressed
	
	# get api key
	if openai:
		var api_key = $"../../USE_OPENAI/LineEdit_API_KEY".text
	
	var url 	= llm_get_url(openai)
	var headers = llm_get_headers(openai)
	## --- end local or remote

	var msgs = []
	msgs.append({
		"role":"assistant",
		"content":assistant
	})

	msgs.append({
		"role":"user", # user
		"content":prompt
	})
	
	var the_body = llm_get_body_short(msgs, max_tokens, temperature, frequency_penalty, presence_penalty)
	# send url
	llm_send_request_short(url, headers, the_body, return_Func)

	pass


func llm_get_url(openai=false):
	var the_url = "http://localhost:1234/v1/chat/completions"

	if openai:
		the_url = "https://api.openai.com/v1/chat/completions"
		
	return the_url

#### END CRITICAL FUNCTIONS ####




