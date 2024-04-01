extends TextEdit

# to add to other textareas:
# add a HTTPRequest to the textedit node and attach this script to the textedit node
# fix a few associations

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
	
	# --- 
	
	menu.add_item("Ai Assist: Simple Clean", MENU_MAX + 2)
	# Connect callback.
	menu.id_pressed.connect(_on_mnu_ai_assist_pressed)	
	
	menu.add_item("Ai Assist: Simple Translate to English", MENU_MAX + 53)
	# Connect callback.
	menu.id_pressed.connect(_on_mnu_ai_assist_pressed)	
	
	menu.add_item("Ai Assist: Simple Translate to Chinese", MENU_MAX + 54)
	# Connect callback.
	menu.id_pressed.connect(_on_mnu_ai_assist_pressed)	

	menu.add_item("Ai Assist: Simple Translate to Spanish", MENU_MAX + 55)
	# Connect callback.
	menu.id_pressed.connect(_on_mnu_ai_assist_pressed)	

	menu.add_item("Ai Assist: Simple Translate to Hindi", MENU_MAX + 56)
	# Connect callback.
	menu.id_pressed.connect(_on_mnu_ai_assist_pressed)	
	
	menu.add_item("Ai Assist: Simple Translate to Canadian French", MENU_MAX + 57)
	# Connect callback.
	menu.id_pressed.connect(_on_mnu_ai_assist_pressed)	
	
	menu.add_item("Ai Assist: Simple Translate to German", MENU_MAX + 58)
	# Connect callback.
	menu.id_pressed.connect(_on_mnu_ai_assist_pressed)	

	menu.add_item("Ai Assist: Simple Simplify (Compress)", MENU_MAX + 5)
	# Connect callback.
	menu.id_pressed.connect(_on_mnu_ai_assist_pressed)	
		
	menu.add_item("Ai Assist: Simple Expand (Decompress)", MENU_MAX + 6)
	# Connect callback.
	menu.id_pressed.connect(_on_mnu_ai_assist_pressed)	
		
	menu.add_item("Ai Assist: Simple Code Improver", MENU_MAX + 7)
	# Connect callback.
	menu.id_pressed.connect(_on_mnu_ai_assist_pressed)	

	menu.add_item("Ai Assist: Simple Code Commenter", MENU_MAX + 8)
	# Connect callback.
	menu.id_pressed.connect(_on_mnu_ai_assist_pressed)	

	menu.add_item("Ai Assist: Intelligent Code Optimizer", MENU_MAX + 9)
	# Connect callback.
	menu.id_pressed.connect(_on_mnu_ai_assist_pressed)

	menu.add_item("Ai Assist: Intelligent Code Completer", MENU_MAX + 10)
	# Connect callback.
	menu.id_pressed.connect(_on_mnu_ai_assist_pressed)

	menu.add_item("Ai Assist: Intelligent Code Repair", MENU_MAX + 11)
	# Connect callback.
	menu.id_pressed.connect(_on_mnu_ai_assist_pressed)# menu_item
	

func _on_mnu_insert_date_pressed(id):
	if id == MENU_MAX + 1:
		insert_text_at_caret(Time.get_date_string_from_system())




### begin -- ai assistant -- selected text cleanup
### begin -- ai assistant -- selected text cleanup
### begin -- ai assistant -- selected text cleanup
var g_ai_assist_busy = false
func _on_mnu_ai_assist_pressed(id):

	if id == MENU_MAX + 2:
		return do_context('assistant-s-text-clean')

	if id == MENU_MAX + 53:
		return do_context('assistant-s-text-translate-english')

	if id == MENU_MAX + 54:
		return do_context('assistant-s-text-translate-chinese')
		
	if id == MENU_MAX + 55:
		return do_context('assistant-s-text-translate-spanish')
		
	if id == MENU_MAX + 56:
		return do_context('assistant-s-text-translate-hindi')
		
	if id == MENU_MAX + 57:
		return do_context('assistant-s-text-translate-canadian-french')
		
	if id == MENU_MAX + 58:
		return do_context('assistant-s-text-translate-german')

	if id == MENU_MAX + 5:
		return do_context('assistant-s-text-simplify')

	if id == MENU_MAX + 6:
		return do_context('assistant-s-text-expander')

	if id == MENU_MAX + 7:
		return do_context('assistant-s-code-improver')

	if id == MENU_MAX + 8:
		return do_context('assistant-s-code-commenter')

	if id == MENU_MAX + 9:
		return do_context('assistant-i-code-optimize')

	if id == MENU_MAX + 10:
		return do_context('assistant-i-code-complete')

	if id == MENU_MAX + 11:
		return do_context('assistant-i-code-repair') # skip ole clickity clackity




func do_context(str_id):
	var do_it = false

	var tokens_max 		= int($"../../../../Node/HBoxContainer/TextEdit_tokens".text)
	var ai_memory_pre 	= int($"../HBoxContainer/TextEdit_ai_memory_pre".text)
	var ai_memory_post 	= int($"../HBoxContainer/TextEdit_ai_memory_post".text)
	var txt_assistant 	= ""
	var txt_prompt 		= ""
			
	if g_ai_assist_busy:
		print("Busy doing last request. Plz try again. *")
		return 0 # busy on another operation
		
	match(str_id):
		# add more ai agents here...


# 0-S-0
		'assistant-s-text-simple-clean': # s = simple (no mem) , i = intelligent (pre/post mem)
			print("function:do_context:assistant:s:text clean")
			do_it = true
			##
			var sel 		= get_selected() # pre, post, selected
			var txt_sel 	= sel.selected

			if txt_sel.strip_edges() == "":
				print("empty input. ignoring.")
				return 0 # fail and bail

			txt_assistant 	+= "You are a text rewriting and cleaning agent. User will give you a portion of selected text, and you are to optimize and rework it to fix any inconsistencies, improve its clarity, and flesh out any details that might benefit from elaboration. You will just return the fixed and improved selected text and nothing else. Do not respond with double quotes. If there is no changes required, just return the original text."
			txt_prompt 		+= "\n```selected text\n" + txt_sel + "\n```\n"
			
			pass # assistant-s-text-translate-chinese (simple = does not use pre/post memory)


# 0-S-0
		'assistant-s-text-translate-english': # s = simple (no mem) , i = intelligent (pre/post mem)
			print("function:do_context:assistant:s:text translate english")
			do_it = true
			##
			var sel 		= get_selected() # pre, post, selected
			var txt_sel 	= sel.selected

			if txt_sel.strip_edges() == "":
				print("empty input. ignoring.")
				return 0 # fail and bail

			txt_assistant += "You are a master translater that can translate from many languages to the best translation of the North American English language as possible. "
			txt_assistant += "You will return the text translated to English. Do not respond with double quotes. If there is no changes required, just return the original selected text."
			txt_prompt 		+= "\n```selected text\n" + txt_sel + "\n```\n"
			
			pass # assistant-s-text-translate-chinese (simple = does not use pre/post memory)


# 0-S-0
		'assistant-s-text-translate-chinese': # s = simple (no mem) , i = intelligent (pre/post mem)
			print("function:do_context:assistant:s:text translate chinese")
			do_it = true
			##
			var sel 		= get_selected() # pre, post, selected
			var txt_sel 	= sel.selected

			if txt_sel.strip_edges() == "":
				print("empty input. ignoring.")
				return 0 # fail and bail

			txt_assistant += "You are a master translater that can translate from many languages to the best translation of the Chinese Mandarin language as possible. "
			txt_assistant += "You will return the text translated to Chinese Mandarin. Do not respond with double quotes. If there is no changes required, just return the original selected text."
			txt_prompt 		+= "\n```selected text\n" + txt_sel + "\n```\n"
			
			pass # assistant-s-text-translate-chinese (simple = does not use pre/post memory)

# 0-S-0
		'assistant-s-text-translate-spanish': # s = simple (no mem) , i = intelligent (pre/post mem)
			print("function:do_context:assistant:s:text translate spanish")
			do_it = true
			##
			var sel 		= get_selected() # pre, post, selected
			var txt_sel 	= sel.selected

			if txt_sel.strip_edges() == "":
				print("empty input. ignoring.")
				return 0 # fail and bail

			txt_assistant += "You are a master translater that can translate from many languages to the best translation of the Spanish language as possible. "
			txt_assistant += "You will return the text translated to Spanish. Do not respond with double quotes. If there is no changes required, just return the original selected text."
			txt_prompt 	  	+= "\n```selected text\n" + txt_sel + "\n```\n"
			
			pass # assistant-s-text-translate-spanish (simple = does not use pre/post memory)

# 0-S-0
		'assistant-s-text-translate-hindi': # s = simple (no mem) , i = intelligent (pre/post mem)
			print("function:do_context:assistant:s:text translate hindi")
			do_it = true
			##
			var sel 		= get_selected() # pre, post, selected
			var txt_sel 	= sel.selected

			if txt_sel.strip_edges() == "":
				print("empty input. ignoring.")
				return 0 # fail and bail

			txt_assistant += "You are a master translater that can translate from many languages to the best translation of the Hindi in Devanagari script language as possible. "
			txt_assistant += "You will return the text translated to  Hindi in Devanagari script. Do not respond with double quotes. If there is no changes required, just return the original selected text."
			txt_prompt 	  	+= "\n```selected text\n" + txt_sel + "\n```\n"
			
			pass # assistant-s-text-translate-hindi (simple = does not use pre/post memory)


# 0-S-0
		'assistant-s-text-translate-canadian-french': # s = simple (no mem) , i = intelligent (pre/post mem)
			print("function:do_context:assistant:s:text translate canadian french")
			do_it = true
			##
			var sel 		= get_selected() # pre, post, selected
			var txt_sel 	= sel.selected

			if txt_sel.strip_edges() == "":
				print("empty input. ignoring.")
				return 0 # fail and bail

			txt_assistant += "You are a master translater that can translate from many languages to the best translation of the Canadian dialect of Quebec French language as possible. "
			txt_assistant += "You will return the text translated to the Canadian dialect of Quebec French language. Do not respond with double quotes. If there is no changes required, just return the original selected text."
			txt_prompt 	  	+= "\n```selected text\n" + txt_sel + "\n```\n"
			
			pass # assistant-s-text-translate-canadian-french (simple = does not use pre/post memory)

# 0-S-0
		'assistant-s-text-translate-german': # s = simple (no mem) , i = intelligent (pre/post mem)
			print("function:do_context:assistant:s:text translate german")
			do_it = true
			##
			var sel 		= get_selected() # pre, post, selected
			var txt_sel 	= sel.selected

			if txt_sel.strip_edges() == "":
				print("empty input. ignoring.")
				return 0 # fail and bail

			txt_assistant += "You are a master translater that can translate from many languages to the best translation of the German language as possible. "
			txt_assistant += "You will return the text translated to the German language. Do not respond with double quotes. If there is no changes required, just return the original selected text."
			txt_prompt 	  	+= "\n```selected text\n" + txt_sel + "\n```\n"
			
			pass # assistant-s-text-translate-german (simple = does not use pre/post memory)


# 0-S-0
		'assistant-s-text-simplify': # s = simple (no mem) , i = intelligent (pre/post mem)
			print("function:do_context:assistant:s:text simplify")
			do_it = true
			##
			var sel 		= get_selected() # pre, post, selected
			var txt_sel 	= sel.selected

			if txt_sel.strip_edges() == "":
				print("empty input. ignoring.")
				return 0 # fail and bail

			txt_assistant 	+= "You will at most return 3 sentences. You are a master simplification agent that understands how to rewrite a given selected text string into a minimalist, optimized, enhanced and simplified version of itself. You use as few sentences as possible to convey the original string's idea. You will respond at a grade 7 level of vocabulary with a goal of returning at most a few sentences. You will just return the fixed string of text and nothing else. Do not respond with double quotes. If there is no changes required, just return the original text."
			txt_prompt 		+= "\n```selected text\n" + txt_sel + "\n```\n"
			
			pass # text-simplify (simple = does not use pre/post memory)


# 0-S-0
		'assistant-s-text-expander': # s = simple (no mem) , i = intelligent (pre/post mem)
			print("function:do_context:assistant:s:text expander")
			do_it = true
			##
			var sel 		= get_selected() # pre, post, selected
			var txt_sel 	= sel.selected

			if txt_sel.strip_edges() == "":
				print("empty input. ignoring.")
				return 0 # fail and bail

			txt_assistant 	+= "You are a master copywriter that understands how to communicate effectively and rewrite a given selected text to add more depth about the context, optimize the conveyance of the underlying context, and enhance an expanded version of the original given selected text. You will add a fair bit more content to best communicate the context of the selected text better. You will increase the selected text length by 50% with supporting details. You will respond at a grade 7 level. You will avoid uncommon words and phrases. You will attempt to double the returned data's length. You will just return the fixed string of text and nothing else. Do not respond with double quotes. If there is no changes required, just return the original text."
			txt_prompt 		+= "\n```selected text\n" + txt_sel + "\n```\n"
			
			pass # text-expander (simple = does not use pre/post memory)


# 0-S-0
		'assistant-s-code-improver': # s = simple (no mem) , i = intelligent (pre/post mem)
			print("function:do_context:assistant:s:code improver")
			do_it = true
			##
			var sel 		= get_selected() # pre, post, selected
			var txt_sel 	= sel.selected

			if txt_sel.strip_edges() == "":
				print("empty input. ignoring.")
				return 0 # fail and bail

			txt_assistant 	+= "You will rewrite the code supplied in the string to be more effective, functional, and more detailed. You will attempt to add more code to improve the code in the string. You will just return the updated string of text and nothing else. Do not respond with double quotes. If there is no changes required, just return the original text."
			txt_prompt 		+= "Add improvements to the following selected code:"
			txt_prompt 		+= "\n```selected code\n" + txt_sel + "\n```\n"
			
			pass # simple-improver (simple = does not use pre/post memory)


# 0-S-0
		'assistant-s-code-commenter': # s = simple (no mem) , i = intelligent (pre/post mem)
			print("function:do_context:assistant:s:code commenter")
			do_it = true
			##
			var sel 		= get_selected() # pre, post, selected
			var txt_sel 	= sel.selected

			if txt_sel.strip_edges() == "":
				print("empty input. ignoring.")
				return 0 # fail and bail

			txt_assistant 	+= "You are an advanced code commenter that comments code. You will reply as commented code on each line."
			txt_prompt 		+= "Add detailed comments to the following selected code:"
			txt_prompt 		+= "\n```selected code\n" + txt_sel + "\n```\n"
			
			pass # simple-commenter (simple = does not use pre/post memory)


# 0-0-0
		'assistant-i-code-optimize':
			print("function:do_context:assistant:i:code optimize")
			do_it = true
			##
			var sel 		= get_selected() # pre, post, selected
			var txt_pre 	= keep_end(sel.pre, ai_memory_pre) 
			var txt_post 	= keep_start(sel.post, ai_memory_post)
			var txt_sel 	= sel.selected

			if txt_sel.strip_edges() == "":
				print("empty input. ignoring.")
				return 0 # fail and bail
			
			txt_assistant = "You are a programming source code clarity and code tricks optimization expert. You can detect the provided code selection and improve on it substantially. Your responses are rich with productive code, and well commented steps on optimizations taken. You are very good at writing code comments, and are detailed and verbose on descriptions."

			txt_prompt += "The user is sending the selected code between the pre and post data to be repaired and optimized for robustness of code. "
			txt_prompt += "The code would be something that would be in between the pre and post data. "			
			txt_prompt += "Do not return something that exists in pre or post. Only return the repaired and optimized version of the selected code. "
			txt_prompt += "If there is nothing to change, figure out some other optimizations or improvements to the selected code that would be helpful and return that result. "
			txt_prompt += "The user's job and ability to feed their family depends on the best possible answer that exists. Rethink your response and respond with the best option available. "
			txt_prompt += "Describe step-by-step as code comments."
			txt_prompt += "\n```selected code to be repaired,optimized,improved and returned in your response\n"+txt_sel+"\n```\n"

			txt_prompt 		+= "A portion of the part that came before it was (pre data):\n```pre data\n" + txt_pre + "\n```\n"
			txt_prompt 		+= "A portion of the part that came after it was (post data):\n```post data\n" + txt_post +  "\n```\n"

			pass # assistant-i-code-optimize (selection)
					
# 0-0-0
		'assistant-i-code-complete':
			print("function:do_context:assistant:i:code complete")
			do_it = true
			
			var sel 		= get_caret() # pre, post, line, column
			var txt_pre 	= sel.pre
			var txt_post 	= sel.post

			txt_pre 	= keep_end(txt_pre, ai_memory_pre)
			txt_post	= keep_start(txt_post, ai_memory_post)
			
			txt_assistant = "You are a code completion agent."
			txt_prompt 	+= "Show me the code that would go in between the pre and post data and return the code. The code would be something that would be in between the pre and post code. Do not return something that exists in pre or post, but instead show some complimentary code that would extend the pre code but fit in before the post code.\n\n"
			txt_prompt 	+= "A portion of the part that came before it was (pre data):\n```pre data\n" + txt_pre + "\n```\n"
			txt_prompt 	+= "A portion of the part that came after it was (post data):\n```post data\n" + txt_post +  "\n```\n"

			pass # assistant-i-code-complete (at cursor)
		
# 0-0-0
		'assistant-i-code-repair':
			print("function:do_context:assistant:i:code repair")
			do_it = true
			##
			var sel 		= get_selected() # pre, post, selected
			var txt_pre 	= keep_end(sel.pre, ai_memory_pre) 
			var txt_post 	= keep_start(sel.post, ai_memory_post)
			var txt_sel 	= sel.selected

			if txt_sel.strip_edges() == "":
				print("empty input. ignoring.")
				return 0 # fail and bail
				
			txt_assistant = "You are a programming source code repair expert."

			txt_prompt += "The user is sending the selected code between the pre and post data to be repaired and optimized for robustness of code. "
			txt_prompt += "The code would be something that would be in between the pre and post data. "			
			txt_prompt += "Do not return something that exists in pre or post. Only return the repaired and optimized version of the selected code. "
			txt_prompt += "If there is nothing to change, figure out some other optimizations or improvements to the selected code that would be helpful and return that result. "
			txt_prompt += "The user's job and ability to feed their family depends on the best possible answer that exists. Rethink your response and respond with the best option available. "
			txt_prompt += "Describe step-by-step as code comments."
			txt_prompt += "\n```selected code to be repaired,optimized,improved and returned in your response\n"+txt_sel+"\n```\n"

			txt_prompt 		+= "A portion of the part that came before it was (pre data):\n```pre data\n" + txt_pre + "\n```\n"
			txt_prompt 		+= "A portion of the part that came after it was (post data):\n```post data\n" + txt_post +  "\n```\n"
			
			##
			pass # assistant-i-code-repair (selection)
# 0-0-0

	if do_it:
		g_ai_assist_busy = true
		# send prompt and return to func rr(result, response_code, headers, body)
		print("-=-=-\r\n",txt_assistant,"-=-=-\r\n") # debug
		print("-=-=-\r\n",txt_prompt,"-=-=-\r\n") # debug

		llm_send_short(txt_assistant, txt_prompt, tokens_max, 0.0, 0.0, 0.0, rr)
		pass # done it

	return 1 # good result
	pass # func do_context(str_id)

### ---




func get_content_inside_backticks(message: String) -> String:
	var start_index = message.find("```")
	if start_index == -1:
		return message
	start_index += 3
	# move to the first \n after the start index
	start_index = message.find("\n", start_index)


	var end_index = message.find("```", start_index)
	if end_index == -1:
		return message

	return message.substr(start_index, end_index - start_index)


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

	# # if message begins and ends with triple backticks, remove the first and last lines of the response
	# if message.begins_with("```") and message.ends_with("```"):
	# 	var lines = message.split("\n")
	# 	message = ""
	# 	for i in range(1, lines.size()-1):
	# 		message += lines[i] + "\n"

	message = get_content_inside_backticks(message)


	# if message has ``` triple backticks, only return content inside them
	

	
	#$".".text += message
	$".".insert_text_at_caret ( message )
	g_ai_assist_busy = false
	
	# END - replace selected text
	
	
	
	
	
### end -- ai assistant -- selected text cleanup
### end -- ai assistant -- selected text cleanup
### end -- ai assistant -- selected text cleanup


# END # CONTEXT MENU


func _unhandled_input(event):
	if event is InputEventKey:
		# print("key down")
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
		var api_key = $"../../../../USE_OPENAI/LineEdit_API_KEY".text
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
	
	var openai = $"../../../../USE_OPENAI".button_pressed
	
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
	var openai = $"../../../../USE_OPENAI".button_pressed
	
	# get api key
	if openai:
		var api_key = $"../../../../USE_OPENAI/LineEdit_API_KEY".text
	
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














#### BEGIN NEW :::

var g_last_selected_text = "" # = $".".get_selected_text()
var g_last_selected_pre = ""
var g_last_selected_post = ""
var g_last_caret_line = -1 # 
var g_last_caret_column = -1 # 
var g_last_caret_pre = ""
var g_last_caret_post = ""

func get_pre_text(end_line, end_column):
	# need to remove dependence on globals
	var ret_pre = ""
	## BEGIN :: find PRE TEXT
	var pre_rows = []
	# get pre text
	for l in range(0, end_line + 1):
		var line = get_line(l)
		#print("{",line,"}")
		# throw away to the right of last line where user has selected to (from_col)
		pre_rows.append(line)
		# if this is last line, cut off at from_col
		if l == end_line:
			pre_rows[l] = pre_rows[l].substr(0, end_column)

	# now recombine.. 
	ret_pre = ""
		# if this is endline don't add the line break
	var arr_count = 0
	for l in pre_rows:
		if arr_count == end_line:
			ret_pre += l
		else:
			ret_pre += l + "\n"
		arr_count += 1

	#print("pre_rows:", ret_pre,"---")
	## -- END :: find PRE TEXT
	return ret_pre


func get_post_text(start_line,start_col):
	var ret_post = ""
	## BEGIN :: find POST TEXT
	var post_rows = []
	# get post text
	for l in range(start_line, get_line_count()):
		var line = get_line(l)
		
		if l == start_line:
			if line.length() == start_col: # is our selection at end?
				line = ""
			
			# now substr line if we have our selection in the middle
			line = line.substr(start_col, line.length() - start_col)
			
		
		#print("~",line,'~')
		post_rows.append(line)


	# now recombine..
	ret_post = ""
	# for l in post_rows:
	# 	ret_post += l + "\n"

	var arr_count = 0
	for l in post_rows:
		if arr_count == post_rows.size() - 1:
			ret_post += l
		else:
			ret_post += l + "\n"
		arr_count += 1


	#print("post_rows:", ret_post,"---")
	## -- END :: find POST TEXT
	return ret_post



func set_last_caret():
	# for prompts that dont care about selected text, just the caret position
	print("updating caret")
	g_last_caret_line = get_caret_line()
	g_last_caret_column = get_caret_column()

	var text_pre = get_pre_text(g_last_caret_line, g_last_caret_column)
	var text_post = get_post_text(g_last_caret_line, g_last_caret_column)
	
	print("------")
	print("the pre:\n","~~"+text_pre+"~~")
	print("the post:\n","~~"+text_post+"~~")
	print("------")

	# end set_last_caret()

# update our globals on a content selection
func set_last_selected(): 
	# to handle caret in diff places, I think i will try and 
	# when setting g_last_caret_line, if
	# incrementing then we are travelling down with selection
	# decrementing then we are travelling up with our selection
		
	print("updating selected text")
	print("carets:", get_caret_count() )
	print("caret line:", get_caret_line() ) # caret can be before the selection
	print("caret column:", get_caret_column() )
	print("selection line:", get_selection_line())
	print("selection column:", get_selection_column())
	
	g_last_selected_text = $".".get_selected_text()
	#
	#var num_selected_lines = g_last_selected_text.split("\n").size()
	#print("num selected lines:", num_selected_lines)
#
	#var lines_arr = $".".text.split("\n")
	#print("num lines total:", lines_arr.size())
	
	#### NEW IDEA: just replace selected text with an identifier?
	var from_row = get_selection_from_line()
	var from_col = get_selection_from_column()
	var to_row = get_selection_to_line()
	var to_col = get_selection_to_column()

	# Print the line and column numbers
	print("Selection Start: Line", from_row, " Column", from_col)
	print("Selection End: Line", to_row, " Column", to_col)

## BEGIN :: find PRE TEXT
	g_last_selected_pre = get_pre_text(from_row, from_col)
	#print("pre_rows:", g_last_selected_pre,"---")
## -- END :: find PRE TEXT

## BEGIN :: find POST TEXT
	g_last_selected_post = get_post_text(to_row, to_col)
	#print("post_rows:", g_last_selected_post,"---")
## -- END :: find POST TEXT
		
		


	# var all_text = get_text()
	
#
	## Print the text before and after the selection
	#print("Text before selection:", text_before)
	#print("Selected text:", selected_text)
	#print("Text after selection:", text_after)

func my_get_selected():
	# return $".".get_selected_text()
	return g_last_selected_text

#### END NEW :::




### BEGIN :: SELECTED ###
# update our globals on a content selection
func get_selected(): 
	print("updating selected text")
	print("carets:", get_caret_count() )
	print("caret line:", get_caret_line() ) # caret can be before the selection
	print("caret column:", get_caret_column() )
	print("selection line:", get_selection_line())
	print("selection column:", get_selection_column())
	
	g_last_selected_text = $".".get_selected_text()

	#### NEW IDEA: just replace selected text with an identifier?
	var from_row = get_selection_from_line()
	var from_col = get_selection_from_column()
	var to_row = get_selection_to_line()
	var to_col = get_selection_to_column()

	# Print the line and column numbers
	print("Selection Start: Line", from_row, " Column", from_col)
	print("Selection End: Line", to_row, " Column", to_col)

	g_last_selected_pre = get_pre_text(from_row, from_col)
	g_last_selected_post = get_post_text(to_row, to_col)
	
	var ret = {}
	ret.pre = g_last_selected_pre
	ret.post = g_last_selected_post
	ret.selected = g_last_selected_text
	
	return ret
	
	
### END :: SELECTED ###

## BEGIN get_caret()
func get_caret():
	g_last_caret_line = get_caret_line()
	g_last_caret_column = get_caret_column()

	var text_pre = get_pre_text(g_last_caret_line, g_last_caret_column)
	var text_post = get_post_text(g_last_caret_line, g_last_caret_column)
	
	var ret 	= {}
	ret.pre 	= text_pre
	ret.post 	= text_post
	ret.line	= get_caret_line()
	ret.column	= get_caret_column()
	
	return ret
## END get_caret()

# handle shrinking the pre and post text
func keep_end(text, max_length):
	max_length = int(max_length)
	if max_length < 0:
		max_length = 0

	if text.length() > max_length:
		text = text.substr(text.length()-max_length, max_length)
	return text

func keep_start(text, max_length):
	max_length = int(max_length)
	if max_length < 0:
		max_length = 0

	if text.length() > max_length:
		text = text.substr(0, max_length)
	return text

