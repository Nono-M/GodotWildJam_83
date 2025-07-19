extends Node

var total_flames:int
var red_counter_label:Node
var blue_counter_label:Node
var yellow_counter_label:Node
var current_round:int = 1
var rounds_dict:Dictionary
var letter_lit:bool = false

func red_flame(letter):
	#print(letter.get_parent())
	await burn_letter_animation(letter.get_parent())
	letter.get_parent().queue_free()
	await letter.get_parent().tree_exited
	var red_counter:int = red_counter_label.text.to_int() - 1
	red_counter_label.text = "x %d" % red_counter
	total_flames -= 1
	if total_flames <= 0 :
		check_word()


func blue_flame(letter:Node, letter_flame:bool=false):
	var letter_to_lit:Node = letter.get_parent()
	#print("blue flame function : %s" % letter_flame)
	if letter_flame:
		var word_displayer = get_tree().root.get_node("Main/WordDisplayer")
		for child in word_displayer.get_children():
			if child.has_node("./BlueFlame") and child != letter_to_lit:
				var pos_A = letter_to_lit.get_index()
				var pos_B = child.get_index()
				burn_letter_animation(letter_to_lit)
				await burn_letter_animation(child)
				word_displayer.move_child(letter_to_lit, pos_B)
				word_displayer.move_child(child, pos_A)
				burn_letter_animation_inverted(letter_to_lit)
				await burn_letter_animation_inverted(child)
				#letter_to_lit.get_node("BlueFlame").queue_free()
				child.get_node("BlueFlame").queue_free()
				letter_lit = false
				get_tree().root.get_node("Main/FlamesBox").modulate = Color(1.0, 1.0, 1.0, 1.0)
				total_flames -= 1
				var blue_counter:int = blue_counter_label.text.to_int() - 1	
				blue_counter_label.text = "x %d" % blue_counter
	else :
		var blue_flame_instance = load("res://flame.tscn").instantiate()
		blue_flame_instance.flame_color = "blue"
		blue_flame_instance.letter_flame = true
		blue_flame_instance.name = "BlueFlame"
		blue_flame_instance.get_node("Counter").text = "1"
		blue_flame_instance.get_node("Counter").visible = false
		blue_flame_instance.position = Vector2(35, -20)
		letter_to_lit.add_child(blue_flame_instance)
		letter_lit = true
				
	if total_flames <= 0 :
		check_word()



func burn_letter_animation(letter:Node):
	var letter_mesh = letter.get_node("Label/MeshInstance2D")
	var letter_label = letter.get_node("Label")
	var mesh_template = load("res://assets/letter_mesh.tres")
	var burn_material = load("res://styles/burning_letter_material.tres")
	letter_mesh.mesh = mesh_template.duplicate()
	letter_mesh.mesh.text = letter_label.text
	letter_mesh.material = burn_material
	letter_label.self_modulate = Color(1,1,1,0)
	var burn_tween = get_tree().create_tween().bind_node(letter)
	await burn_tween.tween_property(letter_mesh,"material:shader_parameter/burn",1.0, 1.0).finished


func burn_letter_animation_inverted(letter:Node):
	var letter_mesh:MeshInstance2D = letter.get_node("Label/MeshInstance2D")
	var letter_label:Label = letter.get_node("Label")
	var mesh_template:TextMesh = load("res://assets/letter_mesh.tres")
	var burn_material:Material = load("res://styles/burning_letter_material.tres")
	letter_mesh.mesh = mesh_template.duplicate()
	letter_mesh.mesh.text = letter_label.text
	letter_mesh.material = burn_material.duplicate()
	letter_label.self_modulate = Color(1,1,1,0)
	letter_mesh.material.set_shader_parameter("burn", 1.0)
	var burn_tween = get_tree().create_tween().bind_node(letter)
	await burn_tween.tween_property(letter_mesh,"material:shader_parameter/burn",0.0, 1.0).finished
	burn_tween.kill()
	letter_label.self_modulate = Color(1,1,1,1)


func yellow_flame():
	pass


func load_json():
	var name_string = FileAccess.get_file_as_string("res://rounds.json")
	rounds_dict = JSON.parse_string(name_string)


func load_round_data(round_number:int):
	if round_number <= rounds_dict.size():
		var round_data:Dictionary =  rounds_dict["round%d" % round_number]
		Data._key_word = round_data["key_word"]
		Data._blue_flames = round_data["blue_flame"]
		Data._red_flames = round_data["red_flame"]
		Data._yellow_flames = round_data["yellow_flame"]
		Data._answers = round_data["answers"]
		clear_result_displayer()
		load_word(Data._key_word)
		load_flames(Data._red_flames,Data._blue_flames, Data._yellow_flames)
	else:
		display_message("You've finished the game\n You're AMAZING")


func load_word(keyword):
	var letter_scene = preload("res://letter.tscn") 
	for character:int in keyword.length():
		var letter = letter_scene.instantiate()
		letter.get_node("Label").text = keyword[character]
		#letter.get_node("Label/MeshInstance2D").mesh.text = letter.get_node("Label").text
		#print(letter.get_node("Label/MeshInstance2D").mesh.text)
		letter.name = "Letter%d" % character
		get_tree().root.get_node("Main/WordDisplayer").add_child(letter)


func load_flames(red, blue, yellow):
	red_counter_label.text = "x %d" % red
	blue_counter_label.text = "x %d" % blue
	yellow_counter_label.text = "x %d" % yellow
	total_flames = red + blue + yellow


func reset_round():
	clear_word()
	load_word(Data._key_word)
	load_flames(Data._red_flames,Data._blue_flames, Data._yellow_flames)
	get_tree().root.get_node("Main/FlamesBox").modulate = Color(1.0, 1.0, 1.0, 1.0)
	letter_lit = false


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
		display_message("'%s' Word not existant\n try again" % final_word.to_upper())
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
			display_message("You found '%s'\n %d words to find" % [final_word.to_upper(),Data._answers.size()])
		else:
			display_message("Round is over, congratz ! \nClick on the button to go to next round")
			current_round += 1
			get_tree().root.get_node("Main/Interface/NextRoundButton").disabled = false


func clear_word() -> bool:
	var word_displayer:Node = get_tree().root.get_node("Main/WordDisplayer")
	for child in word_displayer.get_children():
			word_displayer.remove_child(child)
	if word_displayer.get_children().size() == 0:
		return true
	else:
		return false


func clear_result_displayer():
	var result_displayer = get_tree().root.get_node("Main/ResultDisplayer")
	for child in result_displayer.get_children():
		child.queue_free()


func display_message(message:String) -> void:
	var message_box = get_tree().root.get_node("Main/MessageBox")
	message_box.text = message

func game_over():
	pass
