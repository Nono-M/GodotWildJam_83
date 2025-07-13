extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	#Global.load_word(Data._key_word)
	#Global.load_flames(Data._red_flames,Data._blue_flames, Data._yellow_flames)
	Global.load_json()
	Global.load_round_data(1)
	#print_tree_pretty()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
