extends Button

# Program: Godot 4 LLM API AI CHAT - Local and Remote AI API Access Using GDScript
# License: BSD-3-Clause License (https://opensource.org/licenses/BSD-3-Clause)
# Author: https://github.com/g023
# Version: 0.2a
# This is an example Ai Assistant that rewrites the prompt for the user to attempt to make a better prompt.

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
	
	var openai = $"../../../USE_OPENAI".button_pressed
	
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
	
	var openai = $"../../../USE_OPENAI".button_pressed
	
	# get api key
	if openai:
		api_key = $"../../../USE_OPENAI/LineEdit_API_KEY".text
	
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
	var prompt_text = str($"../../TextEdit_LLM_INPUT".text)
	var sys_message = "You are a master prompt crafter that crafts prompts for asking an LLM (large language model) properly formatted questions. You will analyze whether the user is asking you to make a prompt, or whether the user is supplying a prompt and you will respond with the best prompt possible based on the given information. Really try to apply ChatGPT prompt optimizations to your response to come up with the best possible prompt. You will just return the prompt ready to be sumbitted to the LLM. You will craft a prompt that can get a better response from a language model. Show that prompt. Do not attempt to answer the user's prompt, but rather expand on it. Make the prompt better. You will not return code. You will return with a refactored prompt ready to be submitted for an assistant's response to give the ultimate answer. You will not ask for links, but will rather ask for source code when it comes to programming related prompts. Limit your response to 3-5 sentences max."	
	
	llm_add_message("assistant",sys_message)
	llm_add_message("user","```Please rewrite the following prompt to be a better prompt in the format of an ai prompt for LLM:\nprompt\n" + prompt_text + "\n```\n")
	print("assistant:\n", sys_message)
	
	# will respect local max tokens
	max_tokens = int($"../../../Node/HBoxContainer/TextEdit_tokens".text)
	
	var send_msgs = llm_get_messages()
	if send_msgs == []:
		return false

	var body = llm_get_body(model, send_msgs, max_tokens, temperature, frequency_penalty, presence_penalty)
	
	llm_send_request(url, headers, body)
	return true
	pass




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

# ```

	return message.substr(start_index, end_index - start_index)


func llm_response_return(result, response_code, headers, body):
	print("---- received response.")
	print("---- body:",body.get_string_from_utf8())
	
	var response = JSON.parse_string(body.get_string_from_utf8())
	var message = response["choices"][0]["message"]["content"]

	# remove dub quotes
	if message.begins_with("\"") and message.ends_with("\""):
		message = message.substr(1, message.length()-2)
	# only want backticked data
	message = get_content_inside_backticks(message)
	print('---- response:', response)
	print(message)
	
	$"../../TextEdit_LLM_INPUT".text = message
	$".".disabled = false




# assistant : first msg is the assistant
# user : second msg is the user
# system : is where the response would go

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	



# to use reset signal attach to the button
func _on_button_up():
	$".".disabled = true
	llm_send()
