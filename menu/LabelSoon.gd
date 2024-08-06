extends Label

# Llamado cuando el nodo entra en el árbol de la escena por primera vez.
func _ready():
	# Aquí no necesitas hacer nada si la animación se controlará desde otro nodo
	pass

func start_animation():
	animate_label()

func animate_label():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "rect_scale", Vector2(1.5, 1.5), 1.0)
	tween.tween_property(self, "rect_scale", Vector2(1, 1), 1.0)
	tween.set_loops()  # Hace que la animación se repita indefinidamente
