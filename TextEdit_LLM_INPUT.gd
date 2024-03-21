extends TextEdit

var last_key_down = -1 # used for autocomplete

	
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
	
	menu.add_item("Ai Assist", MENU_MAX + 2)
	# Connect callback.
	menu.id_pressed.connect(_on_mnu_ai_assist_pressed)	
	
	
# menu_item
func _on_mnu_insert_date_pressed(id):
	if id == MENU_MAX + 1:
		insert_text_at_caret(Time.get_date_string_from_system())
		
func _on_mnu_ai_assist_pressed():
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

func _on_autocomplete(prefix):
	print("prefix:", prefix)
	# return filter(lambda w: w.begins_with(prefix), suggestions)
