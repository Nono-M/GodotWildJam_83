extends Node

var _key_word:String = "consume"
var _red_flames:int = 3
var _blue_flames:int = 0
var _yellow_flames:int = 0
var _answers:Array = ["come","cone","cons"]



# Called when the node enters the scene tree for the first time.
func _ready():
	Global.load_word(_key_word)
	Global.load_flames(_red_flames, _blue_flames, _yellow_flames)
	#print_tree_pretty()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
