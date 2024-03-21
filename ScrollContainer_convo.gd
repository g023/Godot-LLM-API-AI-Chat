extends ScrollContainer

var do_scroll = false # set to true when we want to scroll


#begin - autoscroll to bottom
var max_scroll_length = 0 
@onready var scrollbar = get_v_scroll_bar()

func _ready(): 
	scrollbar.changed.connect(handle_scrollbar_changed)
	max_scroll_length = scrollbar.max_value

func handle_scrollbar_changed(): 
	if do_scroll:
		if max_scroll_length != scrollbar.max_value: 
			max_scroll_length = scrollbar.max_value 
			
		self.scroll_vertical = max_scroll_length
		do_scroll = false
#end - autoscroll to bottom
