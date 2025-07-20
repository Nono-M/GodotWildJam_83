extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	#Global.load_word(Data._key_word)
	#Global.load_flames(Data._red_flames,Data._blue_flames, Data._yellow_flames)
	Global.red_counter_label = get_tree().root.get_node("Main/FlamesBox/RedFlame/Counter")
	Global.blue_counter_label = get_tree().root.get_node("Main/FlamesBox/BlueFlame/Counter")
	Global.yellow_counter_label = get_tree().root.get_node("Main/FlamesBox/YellowFlame/Counter")
	
	Global.load_json()
	Global.load_round_data(1)
	
	Audio.get_node("Music").play()
	
	
	#print_tree_pretty()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
