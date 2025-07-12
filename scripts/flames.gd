extends Sprite2D

@export var flame_color: String

var is_dragging:bool = false
var _duplicated_flame : Sprite2D
var mouse_offset:Vector2
var delay:int = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_dragging == true:
		var tween = get_tree().create_tween().bind_node(_duplicated_flame)
		tween.tween_property(_duplicated_flame, "global_position", get_global_mouse_position() - mouse_offset, delay * delta)
	

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if get_rect().has_point(to_local(event.position)):
				_duplicated_flame = duplicate_flame(self)
				is_dragging = true
				mouse_offset = get_global_mouse_position() - global_position
		else:
			if _duplicated_flame != null :
				var collided_letter = _duplicated_flame.get_node("CollisionDetector").get_overlapping_areas()
				match _duplicated_flame.flame_color:
					"red":
						if _duplicated_flame.get_node("CollisionDetector").has_overlapping_areas():
							Global.red_flame(collided_letter[0])
					"blue":
						Global.blue_flame()
				_duplicated_flame.queue_free()
			is_dragging = false


func duplicate_flame(node:Node) -> Node:
	var duplicated_flame = node.duplicate()
	for child in duplicated_flame.get_children():
		child.queue_free()
	var area2d = Area2D.new()
	var collisionshape2D = CollisionShape2D.new()
	var rectangleshape2D = RectangleShape2D.new()
	rectangleshape2D.size = Vector2(60,60)
	collisionshape2D.shape = rectangleshape2D
	area2d.add_child(collisionshape2D)
	area2d.name = "CollisionDetector"
	duplicated_flame.add_child(area2d)
	duplicated_flame.position -= node.position
	add_child(duplicated_flame)
	return duplicated_flame
