#menuIngles
extends Control

const CONFIG_FILE_PATH = "user://settings.cfg"  # Ruta del archivo de configuración


func _ready():
	# Cargar la configuración del archivo
	var settings = load_settings_from_file()
	var language = settings["language"]
	
	if language == "Español":
		# Si el idioma es español, cambiar a la escena del menú en español
		get_tree().change_scene_to_file("res://menu/menu.tscn")
		return  # Si cambiamos de escena, no necesitamos continuar con el resto del código
	
	# Código existente para inglés
	$MenuPrueba.play()
	$MenuPrueba.seek(1.3)
	
	# Cargar los datos del juego al iniciar
	GameData.load_game()

	# Mostrar el puntaje final y el puntaje máximo en el menú
	$LabelLastScore.visible = true
	$LabelLastScore.text = "Last Score\n" + (str(GameData.last_score) if GameData.last_score > 0 else "-")
	
	$LabelLastLevel.visible = true
	$LabelLastLevel.text = "Last Level\n" + (str(GameData.last_level) if GameData.last_level > 0 else "-")

	$LabelMaxScore.visible = true
	$LabelMaxScore.text = "Max Score\n" + (str(GameData.max_score) if GameData.max_score > 0 else "-")

	$LabelMaxLevel.visible = true
	$LabelMaxLevel.text = "Max Level\n" + (str(GameData.max_level) if GameData.max_level > 0 else "-")


func _on_start_button_pressed():
	# Cambia a la escena principal del juego en inglés cuando se presiona el botón de inicio
	get_tree().change_scene_to_file("res://main/mainIngles.tscn")


func _on_menu_prueba_finished():
	# Reproduce el menú de prueba en bucle
	$MenuPrueba.play()
	$MenuPrueba.seek(1.3)


func _on_quit_button_pressed():
	# Sale del juego cuando se presiona el botón de salir
	get_tree().quit()


func _on_config_button_pressed():
	# Muestra el menú de configuración en inglés cuando se presiona el botón de configuración
	$ControlAjustesIngles.move_to_center()
	$ControlAjustesIngles.show()
	$ControlAjustesIngles.grab_focus()


func load_settings_from_file():
	# Carga la configuración desde el archivo
	var config = ConfigFile.new()
	if config.load(CONFIG_FILE_PATH) == OK:
		return {
			"volume": config.get_value("Settings", "volume", 1.0),
			"language": config.get_value("Settings", "language", "Inglés")
		}
	return {
		"volume": 1.0,
		"language": "Inglés"
	}


func _on_level_selector_button_pressed():
	get_tree().change_scene_to_file("res://main/level_selector_ingles.tscn")
