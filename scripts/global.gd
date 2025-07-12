extends Node

func red_flame():
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



func load_flames():
	pass


func reset_puzzle():
	pass


func calculate_score():
	pass


func timer():
	pass
