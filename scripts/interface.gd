extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_reset_round_button_pressed():
	Global.reset_round()


func _on_next_round_button_pressed():
	$NextRoundButton.disabled = true
	Global.display_message(" ")
	Global.clear_word()
	Global.load_round_data(Global.current_round)


func _on_quit_button_pressed():
	get_tree().quit()
