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
	print(letter.get_node("../Label").text)
	letter.get_parent().queue_free()
	var red_counter:int = red_counter_label.text.to_int() - 1
	red_counter_label.text = "x %d" % red_counter
	total_flames -= 1
	if total_flames <= 0:
		check_word()
	pass


func blue_flame():
	pass


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
	print("word to be checked")
	pass


func game_over():
	pass
