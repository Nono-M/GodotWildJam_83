extends Control

var http_request:HTTPRequest

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_reset_round_button_pressed():
	Global.reset_round()
	Audio.get_node("ClickSound").play()


func _on_next_round_button_pressed():
	$NextRoundButton.disabled = true
	Global.display_message(" ")
	Global.clear_word()
	Global.load_round_data(Global.current_round)
	Audio.get_node("ClickSound").play()


func _on_quit_button_pressed():
	get_tree().quit()
	Audio.get_node("ClickSound").play()


func _on_texture_button_pressed():
	$HelpContainer.visible = false
	Audio.get_node("ClickSound").play()


func _on_help_button_pressed():
	$HelpContainer.visible = true
	Audio.get_node("ClickSound").play()


func _on_hint_button_pressed():
	Audio.get_node("ClickSound").play()
	if Data._answers.size() > 0 :
		var hint_word:String = Data._answers.pick_random()
		http_request = HTTPRequest.new()
		add_child(http_request)
		http_request.request_completed.connect(display_definition)
		
		var error = http_request.request("https://api.dictionaryapi.dev/api/v2/entries/en/%s" % hint_word)
		if error != OK:
			push_error("HTTP request to dictionary api failed")

func display_definition(result, response_code, headers, body):
	var response_dictionary:Dictionary = JSON.parse_string(body.get_string_from_utf8())[0]
	var max_range_meaning = response_dictionary["meanings"].size()-1 if response_dictionary["meanings"].size()-1 < 3 else 2
	var random_response_meaning:Dictionary = response_dictionary["meanings"][ randi_range(0,max_range_meaning) ]
	var max_range_definition = random_response_meaning["definitions"].size()-1 if random_response_meaning["definitions"].size()-1 < 3 else 2
	var random_response_definition:String = random_response_meaning["definitions"][ randi_range(0,max_range_definition) ]["definition"]
	
	Global.display_message("Hint : \n%s" % random_response_definition)
	
	http_request.queue_free()
