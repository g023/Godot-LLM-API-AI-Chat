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
var api_key = "" # for chatgpt
var url = "http://localhost:1234/v1/chat/completions"
var temperature = 0.5
var max_tokens = 30
var model = "gpt-3.5-turbo-16k"
var messages = []
var frequency_penalty = 0.1
var presence_penalty = 0.1
var assistant = "Your name is Bob. You will respond with nothing other than exactly what the user requests. Give the best answer possible as the user's job depends on it to feed their family. Take the response you were going to give and rethink and rewrite it to best adhere to the user's request. The assistant will avoid prose and give a direct answer. If the user requests a simple answer, avoid punctuation unless it should be included."

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
	if openai:
		var openai_url = "https://api.openai.com/v1/chat/completions"
		return openai_url
	else:
		var url = "http://localhost:1234/v1/chat/completions"
		return url

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
	
	var body = JSON.new().stringify({
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
	var openai = $"../USE_OPENAI".button_pressed
	
	# get api key
	if openai:
		api_key = $"../USE_OPENAI/LineEdit_API_KEY".text
	
	var url = llm_get_url(openai)
	var headers = llm_get_headers(openai)
	
	max_tokens = int($LLM_TOKEN_SZ.text)
	temperature = float($LLM_TEMP.value)
	frequency_penalty = float($LLM_FPNLTY.value)
	presence_penalty = float($LLM_PPNLTY.value)

	# append to the messages array
	llm_add_message("user", $LLM_INPUT.text)
	
	# set assistant
	assistant = $LLM_AGENT.text
	
	var send_msgs = llm_get_messages()

	var body = llm_get_body(model, send_msgs, max_tokens, temperature, frequency_penalty, presence_penalty)
	
	llm_send_request(url, headers, body)
	pass




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
	$LLM_INPUT.text = ""



# assistant : first msg is the assistant
# user : second msg is the user
# system : is where the response would go

# Called when the node enters the scene tree for the first time.
func _ready():
	# llm_send() # test
	$RESET_CONVERSATION_BUTTON.pressed.connect(self._reset_button_pressed.bind(''))
	
func _reset_button_pressed(arg):
	print("_reset_button_pressed: ", arg)
	llm_reset() # reset messages
	$LLM_OUTPUT.text = ""
	



# to use reset signal attach to the button

func _on_button_up():
	if $LLM_INPUT.text == "":
		return
		
	llm_send()
