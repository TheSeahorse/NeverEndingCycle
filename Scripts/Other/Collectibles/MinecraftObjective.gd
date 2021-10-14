extends Area2D


func show_texture(texture: int):
	get_node("Textures/" + str(texture)).show()
