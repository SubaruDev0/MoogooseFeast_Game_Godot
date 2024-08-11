extends Control

func _on_pause_button_pressed():
	# Muestra el menú de configuración cuando se presiona el botón de configuración
	$ControlAjustes.move_to_center()
	$ControlAjustes.show()
	$ControlAjustes.grab_focus()
	$Pause.play()
	get_tree().paused = true
	
# Función para manejar entradas del usuario
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if get_tree().paused:
			$Despause.play()
			# Oculta el menú y reanuda el juego cuando el juego está pausado
			$ControlAjustes.visible = false
			get_tree().paused = false
		else:
			# Muestra el menú cuando el juego no está pausado
			$ControlAjustes.move_to_center()
			$ControlAjustes.show()
			$ControlAjustes.grab_focus()
			$Pause.play()
			get_tree().paused = true



func _on_salir_button_pressed():
	$Despause.play()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu/menu.tscn")  # Cambia a la escena del menú principal
