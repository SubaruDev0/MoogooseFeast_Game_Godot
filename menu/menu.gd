#menu
extends Control

const CONFIG_FILE_PATH = "user://settings.cfg"  # Ruta del archivo de configuración


func _ready():
	# Cargar la configuración del archivo
	var settings = load_settings_from_file()
	var language = settings["language"]
	
	if language == "Inglés":
		# Si el idioma es inglés, cambiar a la escena del menú en inglés
		get_tree().change_scene_to_file("res://menu/menuIngles.tscn")
		return  # Si cambiamos de escena, no necesitamos continuar con el resto del código
	
	# Código existente para español
	$MenuPrueba.play()
	$MenuPrueba.seek(1.3)
	
	# Cargar los datos del juego al iniciar
	GameData.load_game()

	# Mostrar el puntaje final y el puntaje máximo en el menú
	$LabelLastScore.visible = true
	$LabelLastScore.text = "Ultimo Puntaje\n" + (str(GameData.last_score) if GameData.last_score > 0 else "-")
	
	$LabelLastLevel.visible = true
	$LabelLastLevel.text = "Ultimo Nivel\n" + (str(GameData.last_level) if GameData.last_level > 0 else "-")

	$LabelMaxScore.visible = true
	$LabelMaxScore.text = "Maximo Puntaje\n" + (str(GameData.max_score) if GameData.max_score > 0 else "-")

	$LabelMaxLevel.visible = true
	$LabelMaxLevel.text = "Maximo Nivel\n" + (str(GameData.max_level) if GameData.max_level > 0 else "-")


func _on_start_button_pressed():
	# Cambia a la escena principal del juego cuando se presiona el botón de inicio
	get_tree().change_scene_to_file("res://main/main.tscn")


func _on_menu_prueba_finished():
	# Reproduce el menú de prueba en bucle
	$MenuPrueba.play()
	$MenuPrueba.seek(1.3)


func _on_quit_button_pressed():
	# Sale del juego cuando se presiona el botón de salir
	get_tree().quit()


func _on_config_button_pressed():
	# Muestra el menú de configuración cuando se presiona el botón de configuración
	$CanvasLayer/ControlAjustes.move_to_center()
	$CanvasLayer/ControlAjustes.show()
	$CanvasLayer/ControlAjustes.grab_focus()


func load_settings_from_file():
	# Carga la configuración desde el archivo
	var config = ConfigFile.new()
	if config.load(CONFIG_FILE_PATH) == OK:
		return {
			"volume": config.get_value("Settings", "volume", 1.0),
			"language": config.get_value("Settings", "language", "Español")
		}
	return {
		"volume": 1.0,
		"language": "Español"
	}


func _on_level_selector_button_pressed():
	get_tree().change_scene_to_file("res://level_selector_español.tscn")
