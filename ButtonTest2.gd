extends Button

# Program: Godot 4 LLM API AI CHAT - Local and Remote AI API Access Using GDScript
# License: BSD-3-Clause License (https://opensource.org/licenses/BSD-3-Clause)
# Author: https://github.com/g023
# Version: 0.1a
# Short Description: A simple chat application for Godot 4+ that uses the LLM API to send and receive messages from an OpenAI compatible API.
# Categories: AI, Chat, OpenAI, LLM, Godot, Godot 4, API, Local LLM, ChatGPT, Chatbot, Assistant, Conversational AI,GDScript

# Meant to make it easy to use either use LM Studio or OpenAI API
# A Chat application and functions for sending and receiving messages from an OpenAI compatible API.
# Works with LM Studio for local testing and OpenAI when desired. Can force other models for OpenAi.
# Be aware of costs. 
# Application currently does not save any data, so every time you launch the app you have to give it a key to use OpenAI.
# The key is not saved and is only used for the current session.
# The assistant can be changed as desired and you can easily toggle between local and OpenAI.
# Conversations can be reset using the GUI button. Conversations are not saved either.
# f and p penalties are -1 to 1. 0 is default.
# temperature is 0 to 1. 0.5 is default.
# max tokens can really be increased on quite a few models, but 2000 is default.
# conversations show last response at top of the output viewport to oldest response scrolling off.

# scroll down below to the # test area to see how to use the functions in a scene.

# You can pretty much ignore these as they are covered in the 2d view through the GUI.

# Mar 20 - 2024 release: 
# - redid GUI to be flexible and allow for different resolutions
# - new style for conversation to prepare for editable conversations
# - added a copy button to copy content to clipboard from a message

var api_key = "" # for chatgpt
var url = "http://localhost:1234/v1/chat/completions"
var temperature = 0.5
var max_tokens = 30
var model = "gpt-3.5-turbo-16k"
var messages = []
var frequency_penalty = 0.1
var presence_penalty = 0.1
var assistant = "Your name is Bob. You will respond with nothing other than exactly what the user requests. Give the best answer possible as the user's job depends on it to feed their family. Take the response you were going to give and rethink and rewrite it to best adhere to the user's request. The assistant will avoid prose and give a direct answer. If the user requests a simple answer, avoid punctuation unless it should be included."


var g_LLM_INPUT


func llm_set_assistant(assistant):
	assistant = assistant # assistant is always the first message

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
		headers = ["Content-type: application/json", "Authorization: Bearer " + api_key]
	else:
		headers = ["Content-type: application/json"]
	return headers

func llm_get_body(model, messages, max_tokens, temperature, frequency_penalty, presence_penalty):
	max_tokens = int(max_tokens)
	temperature = float(temperature)
	frequency_penalty = float(frequency_penalty)
	presence_penalty = float(presence_penalty)

	# prepend assistant prompt only for the output
	var send_messages = llm_get_messages()
	
	var openai = $"../USE_OPENAI".button_pressed
	
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
			"model":model, 
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
	var g_LLM_AGENT = $"../VBoxContainer/TextEdit_LLM_AGENT"
	var openai = $"../USE_OPENAI".button_pressed
	
	# get api key
	if openai:
		api_key = $"../USE_OPENAI/LineEdit_API_KEY".text
	
	var url = llm_get_url(openai)
	var headers = llm_get_headers(openai)
	
	var llm_tokens = $"../Node/HBoxContainer/TextEdit_tokens"
	var llm_temp = $"../Node/HBoxContainer/TextEdit_temp"
	var llm_fpnlty = $"../Node/HBoxContainer/TextEdit_f"
	var llm_ppnlty = $"../Node/HBoxContainer/TextEdit_p"
	
	max_tokens = int(llm_tokens.text)
	temperature = float(llm_temp.text)
	frequency_penalty = float(llm_fpnlty.text)
	presence_penalty = float(llm_ppnlty.text)
	
	#max_tokens = int($LLM_TOKEN_SZ.text)
	#temperature = float($LLM_TEMP.value)
	#frequency_penalty = float($LLM_FPNLTY.value)
	#presence_penalty = float($LLM_PPNLTY.value)

	# append to the messages array
	llm_add_message("user", g_LLM_INPUT.text)
	
	# set assistant (stopped using LLM_AGENT)
	assistant = g_LLM_AGENT.text
	
	var send_msgs = llm_get_messages()
	if send_msgs == []:
		return false

	var body = llm_get_body(model, send_msgs, max_tokens, temperature, frequency_penalty, presence_penalty)
	
	llm_send_request(url, headers, body)
	return true
	pass

func update_output():
	var user_box = $"../ScrollContainer_template/VBoxContainer_convo/VBoxContainer_user"
	var assistant_box = $"../ScrollContainer_template/VBoxContainer_convo/VBoxContainer_assistant"
	
	var scroll_container = $"../ScrollContainer_convo"
	var chat_container = $"../ScrollContainer_convo/VBoxContainer"
	
	
	scroll_container.show()
	
	
	for child in chat_container.get_children():
		chat_container.remove_child(child)
		child.propagate_call("queue_free", [])
	
	for m in messages:
		var new_u = user_box.duplicate()
		var new_a = assistant_box.duplicate()
		
		var the_node = {}
		
		if(m.role == "system"):
			the_node = assistant_box.duplicate()
		else:
			the_node = user_box.duplicate()
		
		var u_title	= the_node.get_node("RichTextLabel")
		var u_msg = the_node.get_node("TextEdit")
		
		u_title.text = m.role
		u_msg.text = m.content
		
		print("adding:", m.role , "::::", m.content)
		chat_container.add_child(the_node)
		
		pass
		
	# scroll container to bottom
	$"../ScrollContainer_convo".do_scroll = true
	
	# reactivate send
	$"../Node/HBoxContainer2/Button_send".disabled = false


func llm_response_return(result, response_code, headers, body):
	print("---- received response.")
	print("---- body:",body.get_string_from_utf8())
	
	var response = JSON.parse_string(body.get_string_from_utf8())
	var message = response["choices"][0]["message"]["content"]
	print('---- response:', response)
	print(message)
	
	# $LLM_OUTPUT.text = message # old way was just a single message...
	# append to the messages array
	llm_add_message("system", message)
	print("cur messages:", messages)

	# update the output with all the messages
	var output = ""

	# flip messages so first is last

	# for msg in messages:
	for x in messages.size():
		var msg = messages[-x-1]
		# if content has a <|im_end|>, then we only want the content before it.
		if msg["content"].find("<|im_end|>") != -1:
			msg["content"] = msg["content"].split("<|im_end|>")[0]
			
		output += msg["role"] + ": " + msg["content"] + "\r\n-----\r\n"


	$LLM_OUTPUT.text = output

	# clear the input
	g_LLM_INPUT.text = ""
	
	update_output()



# assistant : first msg is the assistant
# user : second msg is the user
# system : is where the response would go

# Called when the node enters the scene tree for the first time.
func _ready():
	# llm_send() # test
	$RESET_CONVERSATION_BUTTON.pressed.connect(self._reset_button_pressed.bind(''))
	g_LLM_INPUT = $"../VBoxContainer2/TextEdit_LLM_INPUT"
	
	$"../Node/HBoxContainer2/Button_reset".pressed.connect(self._reset_button_pressed.bind(''))
	$"../Node/HBoxContainer2/Button_send".pressed.connect(self._send_button_pressed.bind(''))
	
func _reset_button_pressed(arg):
	print("_reset_button_pressed: ", arg)
	llm_reset() # reset messages
	#$LLM_OUTPUT.text = ""
	var chat_container = $"../ScrollContainer_convo/VBoxContainer"
	for child in chat_container.get_children():
		chat_container.remove_child(child)
		child.propagate_call("queue_free", [])
	
func _send_button_pressed(arg):
	$"../Node/HBoxContainer2/Button_send".disabled = true
	if $"../VBoxContainer2/TextEdit_LLM_INPUT".text == "":
		$"../Node/HBoxContainer2/Button_send".disabled = false
	else:
		llm_send()


# to use reset signal attach to the button

func _on_button_up():
	if g_LLM_INPUT.text == "":
		return
		
	llm_send()
