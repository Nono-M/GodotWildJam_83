extends Node

var total_flames:int
var red_counter_label:Node
var blue_counter_label:Node
var yellow_counter_label:Node

func _ready() -> void:
	red_counter_label = get_tree().root.get_node("Main/Flames/RedFlame/Counter")
	blue_counter_label = get_tree().root.get_node("Main/Flames/BlueFlame/Counter")
	yellow_counter_label = get_tree().root.get_node("Main/Flames/YellowFlame/Counter")

func red_flame(letter):
	#print(letter.get_parent())
	letter.get_parent().queue_free()
	await letter.get_parent().tree_exited
	var red_counter:int = red_counter_label.text.to_int() - 1
	red_counter_label.text = "x %d" % red_counter
	total_flames -= 1
	if total_flames <= 0 :
		check_word()


func blue_flame(letter:Node, letter_flame:bool=false):
	var letter_to_lit:Node = letter.get_parent()
	var blue_flame_instance = load("res://flame.tscn").instantiate()
	blue_flame_instance.flame_color = "blue"
	blue_flame_instance.letter_flame = true
	blue_flame_instance.name = "BlueFlame"
	blue_flame_instance.get_node("Counter").text = "1"
	blue_flame_instance.get_node("Counter").visible = false
	blue_flame_instance.position = Vector2(0, -60)
	letter_to_lit.add_child(blue_flame_instance)
	
	#print("blue flame function : %s" % letter_flame)
	if letter_flame:
		total_flames -= 1
		var blue_counter:int = blue_counter_label.text.to_int() - 1	
		blue_counter_label.text = "x %d" % blue_counter
		var word_displayer = get_tree().root.get_node("Main/WordDisplayer")
		for child in word_displayer.get_children():
			if child.has_node("./BlueFlame"):
				#print(letter_to_lit.get_path())
				var pos_A = letter_to_lit.get_index()
				var pos_B = child.get_index()
				word_displayer.move_child(letter_to_lit, pos_B)
				word_displayer.move_child(child, pos_A)
				letter_to_lit.get_node("BlueFlame").queue_free()
				child.get_node("BlueFlame").queue_free()
				#print("switch letter : %s" % child.get_node("Label").text)
				
	if total_flames <= 0 :
		check_word()


func yellow_flame():
	pass


func load_word(keyword):
	var letter_scene = preload("res://letter.tscn") 
	for character:int in keyword.length():
		var letter = letter_scene.instantiate()
		letter.get_node("Label").text = keyword[character]
		letter.name = "Letter%d" % character
		get_tree().root.get_node("Main/WordDisplayer").add_child(letter)


func load_flames(red, blue, yellow):
	red_counter_label.text = "x %d" % red
	blue_counter_label.text = "x %d" % blue
	yellow_counter_label.text = "x %d" % yellow
	total_flames = red + blue + yellow
	


func reset_puzzle():
	pass


func calculate_score():
	pass


func timer():
	pass


func check_word():
	var word_displayer:Node = get_tree().root.get_node("Main/WordDisplayer")
	var final_word:String = ""
	
	for child in word_displayer.get_children():
		final_word += child.get_node("Label").text
	
	#print(final_word)
	
	var word_index:int = Data._answers.find(final_word)
	if word_index == -1:
		#print("'%s' word not found" % final_word.to_upper())
		display_message("'%s' Word not existant, try again" % final_word.to_upper())
		clear_word()
		Global.load_word(Data._key_word)
		Global.load_flames(Data._red_flames,Data._blue_flames, Data._yellow_flames)
	else:
		var result_displayer = get_tree().root.get_node("Main/ResultDisplayer")
		var new_result = Label.new()
		new_result.text = final_word
		new_result.uppercase = true
		result_displayer.add_child(new_result)
		
		Data._answers.remove_at(word_index)
		
		if Data._answers.size() > 0:
			clear_word()
			Global.load_word(Data._key_word)
			Global.load_flames(Data._red_flames,Data._blue_flames, Data._yellow_flames)
			display_message("You found '%s', %d words to find" % [final_word.to_upper(),Data._answers.size()])
		else:
			display_message("Congratz you WON")


func clear_word() -> bool:
	var word_displayer:Node = get_tree().root.get_node("Main/WordDisplayer")
	for child in word_displayer.get_children():
			word_displayer.remove_child(child)
	if word_displayer.get_children().size() == 0:
		return true
	else:
		return false

func display_message(message:String) -> void:
	var message_box = get_tree().root.get_node("Main/MessageBox")
	message_box.text = message

func game_over():
	pass
