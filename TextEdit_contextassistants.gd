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
	
	menu.add_item("Ai Assist: Selection Clean", MENU_MAX + 2)
	# Connect callback.
	menu.id_pressed.connect(_on_mnu_ai_assist_pressed)	
	
	
	menu.add_item("Ai Assist: Translate to English", MENU_MAX + 3)
	# Connect callback.
	menu.id_pressed.connect(_on_mnu_ai_assist_pressed)	
	
	menu.add_item("Ai Assist: Translate to Chinese", MENU_MAX + 4)
	# Connect callback.
	menu.id_pressed.connect(_on_mnu_ai_assist_pressed)	

	menu.add_item("Ai Assist: Simplify (Compress)", MENU_MAX + 5)
	# Connect callback.
	menu.id_pressed.connect(_on_mnu_ai_assist_pressed)	
		
	menu.add_item("Ai Assist: Expand (Decompress)", MENU_MAX + 6)
	# Connect callback.
	menu.id_pressed.connect(_on_mnu_ai_assist_pressed)	
		
	menu.add_item("Ai Assist: Generic Code Improver", MENU_MAX + 7)
	# Connect callback.
	menu.id_pressed.connect(_on_mnu_ai_assist_pressed)	

	menu.add_item("Ai Assist: Generic Code Summarizer", MENU_MAX + 8)
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
				var the_assistant = "You are a master translater that can translate from many languages to the best translation of English to Mandaring possible. You will just return the fixed string of text and nothing else. Do not respond with double quotes. If there is no changes required, just return the original text."
				var the_prompt = "the string: \"" + the_selected_text + "\""
				llm_send_short(the_assistant, the_prompt, 8000, 0.0, 0.0, 0.0, rr)
				
				
		else:
			print("assistant busy")
			
			

	if id == MENU_MAX + 5:
		print("ai assist context menu - simplify")
		if not g_ai_assist_busy:
			var selected_text = $".".get_selected_text()
			print("selected text:", selected_text)
			if selected_text.strip_edges() == "":
				print("empty input. ignoring.")
			else:			
				g_ai_assist_busy = true
				var the_selected_text = $".".get_selected_text()
				var the_assistant = "You will at most return 3 sentences. You are a master simplification agent that understands how to rewrite a given string into a minimalist, optimized, enhanced and simplified version of itself. You use as few sentences as possible to convey the original string's idea. You will respond at a grade 7 level of vocabulary with a goal of returning at most a few sentences. You will just return the fixed string of text and nothing else. Do not respond with double quotes. If there is no changes required, just return the original text."
				var the_prompt = "the string: \"" + the_selected_text + "\""
				llm_send_short(the_assistant, the_prompt, 4000, 0.0, 0.0, 0.0, rr)
		else:
			print("assistant busy")
			


			

	if id == MENU_MAX + 6:
		print("ai assist context menu - expand")
		if not g_ai_assist_busy:
			var selected_text = $".".get_selected_text()
			print("selected text:", selected_text)
			if selected_text.strip_edges() == "":
				print("empty input. ignoring.")
			else:			
				g_ai_assist_busy = true
				var the_selected_text = $".".get_selected_text()
				# first version was extremely nerdy sounding
				#var the_assistant = "You are a master text elaboration agent that understands how to rewrite a given string into a maximalist, optimized, enhanced and expanded version of itself. You will respond at a grade 7 level of vocabulary with a goal of returning at most a few sentences. You will just return the fixed string of text and nothing else. Do not respond with double quotes. If there is no changes required, just return the original text."
				var the_assistant = "You are a master copywriter that understands how to communicate effectively and rewrite a given string to add more depth about the context, optimize the conveyance of the underlying context, and enhance an expanded version of the original given string. You will add a fair bit more content to best communicate the context of the string better. You will increase the string length by 50% with supporting details. You will respond at a grade 7 level. You will avoid uncommon words and phrases. You will attempt to double the returned data's length. You will just return the fixed string of text and nothing else. Do not respond with double quotes. If there is no changes required, just return the original text."
				var the_prompt = "the string: \"" + the_selected_text + "\""
				llm_send_short(the_assistant, the_prompt, 4000, 0.0, 0.0, 0.0, rr)
		else:
			print("assistant busy")
			



	if id == MENU_MAX + 7:
		print("ai assist context menu - generic code improver")
		if not g_ai_assist_busy:
			var selected_text = $".".get_selected_text()
			print("selected text:", selected_text)
			if selected_text.strip_edges() == "":
				print("empty input. ignoring.")
			else:			
				g_ai_assist_busy = true
				var the_selected_text = $".".get_selected_text()
				# first version was extremely nerdy sounding
				#var the_assistant = "You are a master text elaboration agent that understands how to rewrite a given string into a maximalist, optimized, enhanced and expanded version of itself. You will respond at a grade 7 level of vocabulary with a goal of returning at most a few sentences. You will just return the fixed string of text and nothing else. Do not respond with double quotes. If there is no changes required, just return the original text."
				var the_assistant = "You will rewrite the code supplied in the string to be more effective, functional, and more detailed. You will attempt to add more code to improve the code in the string. You will just return the updated string of text and nothing else. Do not respond with double quotes. If there is no changes required, just return the original text."
				var the_prompt = "the code string: \"" + the_selected_text + "\""
				llm_send_short(the_assistant, the_prompt, 4000, 0.0, 0.0, 0.0, rr)
		else:
			print("assistant busy")
			




	if id == MENU_MAX + 8:
		print("ai assist context menu - generic code summarizer")
		if not g_ai_assist_busy:
			var selected_text = $".".get_selected_text()
			print("selected text:", selected_text)
			if selected_text.strip_edges() == "":
				print("empty input. ignoring.")
			else:			
				g_ai_assist_busy = true
				var the_selected_text = $".".get_selected_text()
				# first version was extremely nerdy sounding
				#var the_assistant = "You are a master text elaboration agent that understands how to rewrite a given string into a maximalist, optimized, enhanced and expanded version of itself. You will respond at a grade 7 level of vocabulary with a goal of returning at most a few sentences. You will just return the fixed string of text and nothing else. Do not respond with double quotes. If there is no changes required, just return the original text."
				var the_assistant = "You are a helpful assistant."
				var the_prompt = "I will provide the source code for a snippet of code that does something. I want you to remove the source code and replace it with code comments describing what the code did in the order that it was done. Show you response as comments in the programming language the source code was in. Use multiline code commenting if appropriate for the programming language code is using. The source code snippet: \"" + the_selected_text + "\""
				llm_send_short(the_assistant, the_prompt, 4000, 0.0, 0.0, 0.0, rr)
		else:
			print("assistant busy")
			


	if id == MENU_MAX + 9:
		print("ai assist context menu - intelligent code optimizer")
		# takes previous content and post content and allows use in final prompt and assistant
		if not g_ai_assist_busy:
			var selected_text = $".".get_selected_text()
			print("selected text:", selected_text)
			if selected_text.strip_edges() == "":
				print("empty input. ignoring.")
			else:			
				g_ai_assist_busy = true
				var the_whole_text = $".".text
				var the_selected_text = $".".get_selected_text()
				#var the_pre_text = $".".get_selection_to_line(get_selection_line())
				print("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-")
				print("selected_line:", get_selection_line())
				var lines_arr = the_whole_text.split("\n")
				var the_pre_str = ""
				var the_post_str = ""


				
				print("x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-")
				
				# pre string is the text before the selected text
				# for i in range(0, get_selection_line()): 
				# need to redo for i to exclude the amount of lines in selected_text
				for i in range(0, get_selection_line() - selected_text.split("\n").size()):
					the_pre_str += lines_arr[i] + "\n"
				# the whole text

				print("x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-")


				# post string is the rest of the text after the selected text
				for i in range(get_selection_line(), lines_arr.size()):
					the_post_str += lines_arr[i] + "\n"


				print("x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-")
				var ai_memory_pre = int($"../HBoxContainer/TextEdit_ai_memory_pre".text)
				var ai_memory_post = int($"../HBoxContainer/TextEdit_ai_memory_post".text)

				if ai_memory_pre < 0:
					ai_memory_pre = 0
				if ai_memory_post < 0:
					ai_memory_post = 0

				# only leave the last 500 characters of the pre string
				if the_pre_str.length() > ai_memory_pre:
					the_pre_str = the_pre_str.substr(the_pre_str.length()-ai_memory_pre, ai_memory_pre)
				
				# only leave the first 500 characters of the post string
				if the_post_str.length() > ai_memory_post:
					the_post_str = the_post_str.substr(0, ai_memory_post)


				print("*** *** *** *** *** ")
				print("*** *** *** *** *** ")
				print("*** *** *** *** *** ")
				print("*** *** *** *** *** ")
				print("pre:\r\n\r\n", the_pre_str)
				print("*** *** *** *** *** ")
				print("post:\r\n\r\n", the_post_str)
				print("*** *** *** *** *** ")
				print("*** *** *** *** *** ")
				print("*** *** *** *** *** ")
				print("*** *** *** *** *** ")
				print("*** *** *** *** *** ")



				print("whole:\r\n\r\n", the_whole_text)
				# the selected text
				print("selected:\r\n\r\n", the_selected_text)


				print("pre:\r\n\r\n", lines_arr)
				print("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-")
				# first version was extremely nerdy sounding
				#var the_assistant = "You are a master text elaboration agent that understands how to rewrite a given string into a maximalist, optimized, enhanced and expanded version of itself. You will respond at a grade 7 level of vocabulary with a goal of returning at most a few sentences. You will just return the fixed string of text and nothing else. Do not respond with double quotes. If there is no changes required, just return the original text."
				
				var pre = the_pre_str
				var post = the_post_str
				
				var openai = $"../../../../USE_OPENAI".button_pressed

				#var the_assistant = "IMPORTANT: You will only return the changed or modified code. You will not send back any extra things like describing the new code or its changes. You will not send back the pre or post. You will optimize a given code string. Return just the changed code string optimized and rewritten to be more modular and attempt to include new and fresh ideas. The text before the code string and the text after the code string is as follows:\n\n```pre\n"+pre+"```\n\n```post\n"+post+"\n"
				# var the_assistant = "You are a code changer. User will send you code as 'code string' and you will modify it to be more compact,robust,modular,optimized and efficient. You will ignore anything outside actual code when processing to make a better solution to the 'code string'. Always attempt to deliver an improvement on the 'code string' when generating the response. You will only return the section that applies to what the user sent as the 'code string'. You will leave any descriptions as comments in the code. You will reference pre and post code for inspiration in modifying the 'code string'. Return the most modular code possible."
				# var the_assistant = "You are a code optimizer that tries to make the most different and performant code possible from a given code string, and then just show the newly improved code. Describe the improvements in a comment section inserted into code. Just return the code. Comment above the code in a commented code section details of the changes. Reference the pre and post data for ideas on improving. Put any explanation above the code as commented code blocks. Just return code. \n\n"
				# the_assistant += "User will provide a 'code string' that you will attempt to modify the 'code string' to be as compact, modular, redundant, as possible and you will only send back the code commment section and the extremely optimized code."
				var the_assistant = "You try and create as many functions as possible for the given code string when they make sense. You put any descriptions in a code comments before any of the code as a step-by-step description. Do not have any comments in the functional parts of the code. What you understand to be the text before the 'code string' is as follows (and will not be returned):\n```pre\n"+pre+"```\n```post\n"+post+"\n\n"
				var the_prompt = "Optimize the following code to be as minimal and simplistic as possible. Only return an improved and different optimized version of the following 'code string': \"" + the_selected_text + "\"\n\n"
				# if openai:
				# 	the_assistant = "You will only return the changed code. You will optimize a given code string. Return just the changed code string optimized and rewritten to be more modular and attempt to include new and fresh ideas. The text before the code string and the text after the code string is as follows:\n\n```pre\n"+pre+"```\n\n```post\n"+post+"\n"


				var tokens_max = int($"../../../../Node/HBoxContainer/TextEdit_tokens".text)
				
				#llm_send_short(the_assistant, the_prompt, 4000, 0.0, 0.0, 0.0, rr)
				llm_send_short(the_assistant, the_prompt, tokens_max, 0.0, 0.0, 0.0, rr)
		else:
			print("assistant busy")
		
		# intelligent code optimizer








	if id == MENU_MAX + 10:
		print("ai assist context menu - intelligent code completer")
		# takes previous content and post content and allows use in final prompt and assistant
		if not g_ai_assist_busy:
			var selected_text = $".".get_selected_text()
			print("selected text:", selected_text)
			# if selected_text.strip_edges() == "":
			# 	print("empty input. ignoring.")
			# else:		
			if 1:	
				g_ai_assist_busy = true

				var the_whole_text = $".".text
				var the_selected_text = $".".get_selected_text()
				#var the_pre_text = $".".get_selection_to_line(get_selection_line())
				print("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-")
				print("selected_column:", get_selection_column())
				var lines_arr = the_whole_text.split("\n")
				var the_pre_str = ""
				var the_post_str = ""


				
				print("x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-")
				
				# pre string is the text before current position in TextEdit in godot gdscript
				# for i in range(0, get_selection_line()): 
				# need to redo for i to exclude the amount of lines in selected_text
				var current_line = get_caret_line()
				var current_column = get_caret_column()
				
				print("Current Line:", current_line)
				print("Current Column:", current_column)
				
				print(". . . . . .")

				var the_current_line = ""
				if current_line == 0:
					the_pre_str = ""
				else:
					for i in range(0, current_line):
						the_pre_str += lines_arr[i] + "\n"
						
					the_current_line = lines_arr[current_line - 1]
					the_pre_str += the_current_line.substr(0, current_column)
					the_pre_str += "\n"

				

				print("x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-")


				# post string is the rest of the text after the selected text
				#the_post_str += the_current_line.substr(current_column, 
				# post str is the rest of the whole text that is after the pre string
				the_post_str += the_whole_text.substr(the_pre_str.length(), the_whole_text.length() - the_pre_str.length())


				print("x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-")
				var ai_memory_pre = int($"../HBoxContainer/TextEdit_ai_memory_pre".text)
				var ai_memory_post = int($"../HBoxContainer/TextEdit_ai_memory_post".text)

				if ai_memory_pre < 0:
					ai_memory_pre = 0
				if ai_memory_post < 0:
					ai_memory_post = 0

				# only leave the last 500 characters of the pre string
				if the_pre_str.length() > ai_memory_pre:
					the_pre_str = the_pre_str.substr(the_pre_str.length()-ai_memory_pre, ai_memory_pre)
				
				# only leave the first 500 characters of the post string
				if the_post_str.length() > ai_memory_post:
					the_post_str = the_post_str.substr(0, ai_memory_post)


				print("*** *** *** *** *** ")
				print("*** *** *** *** *** ")
				print("*** *** *** *** *** ")
				print("*** *** *** *** *** ")
				print("pre:\r\n\r\n", the_pre_str)
				print("*** *** *** *** *** ")
				print("post:\r\n\r\n", the_post_str)
				print("*** *** *** *** *** ")
				print("*** *** *** *** *** ")
				print("*** *** *** *** *** ")
				print("*** *** *** *** *** ")
				print("*** *** *** *** *** ")



				print("whole:\r\n\r\n", the_whole_text)
				# the selected text
				print("selected:\r\n\r\n", the_selected_text)


				print("pre:\r\n\r\n", lines_arr)
				print("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-")
				# first version was extremely nerdy sounding
				#var the_assistant = "You are a master text elaboration agent that understands how to rewrite a given string into a maximalist, optimized, enhanced and expanded version of itself. You will respond at a grade 7 level of vocabulary with a goal of returning at most a few sentences. You will just return the fixed string of text and nothing else. Do not respond with double quotes. If there is no changes required, just return the original text."
				
				var pre = the_pre_str
				var post = the_post_str
				
				var openai = $"../../../../USE_OPENAI".button_pressed

				#var the_assistant = "IMPORTANT: You will only return the changed or modified code. You will not send back any extra things like describing the new code or its changes. You will not send back the pre or post. You will optimize a given code string. Return just the changed code string optimized and rewritten to be more modular and attempt to include new and fresh ideas. The text before the code string and the text after the code string is as follows:\n\n```pre\n"+pre+"```\n\n```post\n"+post+"\n"
				# var the_assistant = "You are a code changer. User will send you code as 'code string' and you will modify it to be more compact,robust,modular,optimized and efficient. You will ignore anything outside actual code when processing to make a better solution to the 'code string'. Always attempt to deliver an improvement on the 'code string' when generating the response. You will only return the section that applies to what the user sent as the 'code string'. You will leave any descriptions as comments in the code. You will reference pre and post code for inspiration in modifying the 'code string'. Return the most modular code possible."
				# var the_assistant = "You are a code optimizer that tries to make the most different and performant code possible from a given code string, and then just show the newly improved code. Describe the improvements in a comment section inserted into code. Just return the code. Comment above the code in a commented code section details of the changes. Reference the pre and post data for ideas on improving. Put any explanation above the code as commented code blocks. Just return code. \n\n"
				# the_assistant += "User will provide a 'code string' that you will attempt to modify the 'code string' to be as compact, modular, redundant, as possible and you will only send back the code commment section and the extremely optimized code."

				# var the_assistant = "You try and create as many functions as possible for the given code string when they make sense. You put any descriptions in a code comments before any of the code as a step-by-step description. You are a master of using only the latest versions of whatever technology you need to complete the code. Your code is built to run, and will not miss out on things. After coming up with the reply, revise and rewrite the response so only the source code shows. Do not have any comments in the functional parts of the code. What you understand to be the text before the 'code string' is as follows (and will not be returned):\n```pre\n"+pre+"```\n```post\n"+post+"\n\n"

				var the_assistant = "You are a code completion agent."

				var the_prompt = "Show me the code that would go in between the pre and post data and return the code. The code would be something that would be in between the pre and post code. Do not return something that exists in pre or post, but instead show some complimentary code that would extend the pre code but fit in before the post code.\n\n"
				the_prompt += "pre:\n\n"+pre+"\n\npost:\n\n"+post+"\n\n"
				# if openai:
				# 	the_assistant = "You will only return the changed code. You will optimize a given code string. Return just the changed code string optimized and rewritten to be more modular and attempt to include new and fresh ideas. The text before the code string and the text after the code string is as follows:\n\n```pre\n"+pre+"```\n\n```post\n"+post+"\n"


				var tokens_max = int($"../../../../Node/HBoxContainer/TextEdit_tokens".text)
				
				#llm_send_short(the_assistant, the_prompt, 4000, 0.0, 0.0, 0.0, rr)
				llm_send_short(the_assistant, the_prompt, tokens_max, 0.0, 0.0, 0.0, rr)
		else:
			print("assistant busy")
		
		# intelligent code optimizer










	if id == MENU_MAX + 11:
		print("ai assist context menu - intelligent code repair")
		# takes previous content and post content and allows use in final prompt and assistant
		if not g_ai_assist_busy:
			var selected_text = $".".get_selected_text()
			print("selected text:", selected_text)
			if selected_text.strip_edges() == "":
				print("empty input. ignoring.")
			else:			
				g_ai_assist_busy = true
				var the_whole_text = $".".text
				var the_selected_text = $".".get_selected_text()
				#var the_pre_text = $".".get_selection_to_line(get_selection_line())
				print("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-")
				print("selected_line:", get_selection_line())
				var lines_arr = the_whole_text.split("\n")
				var the_pre_str = ""
				var the_post_str = ""


				
				print("x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-")
				
				# pre string is the text before the selected text
				# for i in range(0, get_selection_line()): 
				# need to redo for i to exclude the amount of lines in selected_text
				for i in range(0, get_selection_line() - selected_text.split("\n").size()):
					the_pre_str += lines_arr[i] + "\n"
				# the whole text

				print("x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-")


				# post string is the rest of the text after the selected text
				for i in range(get_selection_line(), lines_arr.size()):
					the_post_str += lines_arr[i] + "\n"


				print("x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-")
				var ai_memory_pre = int($"../HBoxContainer/TextEdit_ai_memory_pre".text)
				var ai_memory_post = int($"../HBoxContainer/TextEdit_ai_memory_post".text)

				if ai_memory_pre < 0:
					ai_memory_pre = 0
				if ai_memory_post < 0:
					ai_memory_post = 0

				# only leave the last 500 characters of the pre string
				if the_pre_str.length() > ai_memory_pre:
					the_pre_str = the_pre_str.substr(the_pre_str.length()-ai_memory_pre, ai_memory_pre)
				
				# only leave the first 500 characters of the post string
				if the_post_str.length() > ai_memory_post:
					the_post_str = the_post_str.substr(0, ai_memory_post)


				print("*** *** *** *** *** ")
				print("*** *** *** *** *** ")
				print("*** *** *** *** *** ")
				print("*** *** *** *** *** ")
				print("pre:\r\n\r\n", the_pre_str)
				print("*** *** *** *** *** ")
				print("post:\r\n\r\n", the_post_str)
				print("*** *** *** *** *** ")
				print("*** *** *** *** *** ")
				print("*** *** *** *** *** ")
				print("*** *** *** *** *** ")
				print("*** *** *** *** *** ")



				print("whole:\r\n\r\n", the_whole_text)
				# the selected text
				print("selected:\r\n\r\n", the_selected_text)


				print("pre:\r\n\r\n", lines_arr)
				print("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-")
				# first version was extremely nerdy sounding
				#var the_assistant = "You are a master text elaboration agent that understands how to rewrite a given string into a maximalist, optimized, enhanced and expanded version of itself. You will respond at a grade 7 level of vocabulary with a goal of returning at most a few sentences. You will just return the fixed string of text and nothing else. Do not respond with double quotes. If there is no changes required, just return the original text."
				
				var pre = the_pre_str
				var post = the_post_str
				
				var openai = $"../../../../USE_OPENAI".button_pressed

				#var the_assistant = "IMPORTANT: You will only return the changed or modified code. You will not send back any extra things like describing the new code or its changes. You will not send back the pre or post. You will optimize a given code string. Return just the changed code string optimized and rewritten to be more modular and attempt to include new and fresh ideas. The text before the code string and the text after the code string is as follows:\n\n```pre\n"+pre+"```\n\n```post\n"+post+"\n"
				# var the_assistant = "You are a code changer. User will send you code as 'code string' and you will modify it to be more compact,robust,modular,optimized and efficient. You will ignore anything outside actual code when processing to make a better solution to the 'code string'. Always attempt to deliver an improvement on the 'code string' when generating the response. You will only return the section that applies to what the user sent as the 'code string'. You will leave any descriptions as comments in the code. You will reference pre and post code for inspiration in modifying the 'code string'. Return the most modular code possible."
				# var the_assistant = "You are a code optimizer that tries to make the most different and performant code possible from a given code string, and then just show the newly improved code. Describe the improvements in a comment section inserted into code. Just return the code. Comment above the code in a commented code section details of the changes. Reference the pre and post data for ideas on improving. Put any explanation above the code as commented code blocks. Just return code. \n\n"
				# the_assistant += "User will provide a 'code string' that you will attempt to modify the 'code string' to be as compact, modular, redundant, as possible and you will only send back the code commment section and the extremely optimized code."
				#var the_assistant = "You are a code repair assistant. You will attempt to repair a given bit of code in code string. You will add any code needed to make the code functional. You are a master of using only the latest versions of whatever technology you need to complete the code. Your code is built to run, and will not miss out on things. After coming up with the reply, revise and rewrite the response so only the source code shows. Remove any other descriptions. You will understand and apply the best code changes to make the code more robust. You will analyze and apply all repairs as necessary. You put any descriptions in a code comments before any of the code as a step-by-step description. Do not have any comments in the functional parts of the code. What you understand to be the text before the 'code string' is as follows (and will not be returned):\n```pre\n"+pre+"```\n```post\n"+post+"\n\n"
				var the_assistant = "You are a programming source code repair expert."
				var the_prompt = "Find all the issues and repairs, and return the repaired code from the following 'code string': \"" + the_selected_text + "\"\n\n"
				the_prompt += "The part that came before it was:\n" + the_pre_str + "\n\n"
				the_prompt += "The part that came after it was:\n" + the_post_str +  "\n\n"
				# if openai:
				# 	the_assistant = "You will only return the changed code. You will optimize a given code string. Return just the changed code string optimized and rewritten to be more modular and attempt to include new and fresh ideas. The text before the code string and the text after the code string is as follows:\n\n```pre\n"+pre+"```\n\n```post\n"+post+"\n"


				var tokens_max = int($"../../../../Node/HBoxContainer/TextEdit_tokens".text)
				
				#llm_send_short(the_assistant, the_prompt, 4000, 0.0, 0.0, 0.0, rr)
				llm_send_short(the_assistant, the_prompt, tokens_max, 0.0, 0.0, 0.0, rr)
		else:
			print("assistant busy")
		
		# intelligent code optimizer








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




