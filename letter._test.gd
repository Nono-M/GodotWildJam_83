extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	#var font = get_tree().root.get_theme_default_font()
	#var font_rid = font.get_rids()[0]
	#var text_server = TextServerManager.get_primary_interface()
	#var glyph_index = text_server.font_get_glyph_index(font_rid, 80, $Label.text.unicode_at(0), 0)
	#var glyph_offset = text_server.font_get_glyph_offset(font_rid,Vector2i(80,80),glyph_index)
	#var glyph_size = text_server.font_get_glyph_size(font_rid,Vector2i(80,80),glyph_index)
	##var glyph_offset = text_server.font_get_glyph_offset(font_rid,$Label.size,glyph_index)
	#print(glyph_offset)
	#print(glyph_size)
	#print(glyph_size - glyph_offset)
	#print($Label.size)
	#
	
	#$Label/MeshInstance2D.position = Vector2(0,0)
	#$Label/MeshInstance2D.position = $Label.size
	#$Label/MeshInstance2D.mesh.offset = Vector2(glyph_offset.x , glyph_offset.y)
	#$Label/MeshInstance2D.position = $Label.position
	#print("Mesh pos : %s" % $Label/MeshInstance2D.mesh.get_glyph_index_at_line_column(0,0))
	#print("Label pos : %s" % $Label.label_settings.font.get_glyphe_offset())
	
	$Label/MeshInstance2D.mesh.text = "f"
	
	burn_letter_animation()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#$Label/MeshInstance2D.material.set_shader_parameter("burn", delta * 0.2)
	#print($Label/MeshInstance2D.mesh.material.get_shader_parameter("burn"))
	pass


func burn_letter_animation():
	$Label.self_modulate = Color(1,1,1,0)
	var burn_tween = get_tree().create_tween()
	burn_tween.tween_property($Label/MeshInstance2D,"material:shader_parameter/burn",1.0, 1.0)
