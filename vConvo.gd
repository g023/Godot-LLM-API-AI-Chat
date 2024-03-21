extends VBoxContainer

# Reference to the VBoxContainer node
var vbox_container

# Conversation data structure
var conversation = [
	{"speaker": "Alice", "message": "Hello Bob!"},
	{"speaker": "Bob", "message": "Hi Alice, how are you?"},
	{"speaker": "Alice", "message": "I'm doing well, thanks for asking."},
	{"speaker": "Bob", "message": "That's great to hear!"},
	{"speaker": "Alice", "message": "By the way, did you finish the project?"},
	{"speaker": "Bob", "message": "Not yet, I'm still working on it."},
	{"speaker": "Alice", "message": "No problem, take your time."}
]

func _ready():
	# Get reference to the VBoxContainer
	vbox_container = $"."
	
	var vbox_container = VBoxContainer.new()
	add_child(vbox_container)

	# Populate conversation
	populateConversation()

func populateConversation():
	# Clear existing conversation
	#vbox_container.
#
	## Iterate over the conversation and create message elements
	#for message_data in conversation:
		#var speaker_label = Label.new()
		#speaker_label.text = message_data["speaker"] + ":"
		#vbox_container.add_child(speaker_label)
#
		#var message_label = Label.new()
		#message_label.text = message_data["message"]
		#vbox_container.add_child(message_label)
	pass
