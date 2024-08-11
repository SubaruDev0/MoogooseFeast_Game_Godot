#ControlAjustesIngles
extends Control

# Ruta del archivo de configuración para guardar y cargar ajustes
const CONFIG_FILE_PATH = "user://settings.cfg"


# Esta función se ejecuta cuando el nodo está listo para la interacción.
func _ready():
	# Verifica si el botón de pantalla completa existe en la escena.
	var full_screen_button = $FullScreenButton
	if full_screen_button:
		# Conecta la señal `toggled` del CheckButton a la función que maneja el cambio de estado.
		full_screen_button.toggled.connect(_on_full_screen_button_toggled)
	else:
		print("Error: FullScreenButton no encontrado")
	
	# Carga la configuración guardada desde el archivo.
	var settings = load_settings_from_file()
	
	# Aplica el volumen guardado a la configuración de AudioServer.
	var saved_volume = settings["volume"]
	var initial_volume_db = linear_to_db(saved_volume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), initial_volume_db)
	
	# Actualiza la barra de volumen y la etiqueta que muestra el porcentaje.
	$VolumenBarra2.value = saved_volume * 100
	$NumVolumenLabel2.text = str(int($VolumenBarra2.value)) + "%"


# Función que se llama cuando se presiona el botón de regreso.
# Guarda el volumen actual y oculta la configuración.
func _on_back_button_2_pressed():
	save_volume_to_file($VolumenBarra2.value / 100.0)
	get_tree().paused = false
	$Despause.play()
	hide_settings()


# Función que se llama cuando se presiona el botón de créditos.
# Guarda el volumen actual y cambia a la escena de créditos en inglés.
func _on_creditos_button_2_pressed():
	save_volume_to_file($VolumenBarra2.value / 100.0)
	get_tree().change_scene_to_file("res://creditosIngles.tscn")


# Mueve el nodo al centro y hace que aparezca con una animación.
# Asegura que el nodo esté oculto antes de hacerlo visible.
func move_to_center():
	if not self.visible:
		self.visible = true



# Oculta la configuración con una animación.
# Crea un Tween para animar la desaparición del nodo.
func hide_settings():

	self.visible = false


# Función que se llama cuando el valor del control deslizante de volumen cambia.
# Convierte el valor del control deslizante (0-100) a un valor lineal (0-1) y ajusta el volumen del bus "Master".
func _on_volumen_barra_2_value_changed(value):
	var linear_value = value / 100.0
	
	# Ajusta el volumen del bus "Master" basado en el valor lineal.
	var volume_db = linear_to_db(linear_value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume_db)
	
	# Actualiza la etiqueta de porcentaje del volumen.
	$NumVolumenLabel2.text = str(int(value)) + "%"


# Guarda el volumen actual en el archivo de configuración.
func save_volume_to_file(volume):
	var config = ConfigFile.new()
	config.set_value("Settings", "volume", volume)
	config.save(CONFIG_FILE_PATH)


# Carga el volumen desde el archivo de configuración.
func load_volume_from_file():
	var config = ConfigFile.new()
	if config.load(CONFIG_FILE_PATH) == OK:
		return config.get_value("Settings", "volume", null)
	return null


# Función que se llama cuando se selecciona un idioma del menú.
# Guarda la configuración y cambia a la escena correspondiente según el idioma seleccionado.
func _on_change_lenguaje_button_item_selected(index):
	var volume = $VolumenBarra2.value / 100.0
	if index == 2:
		save_settings_to_file(volume, "Español")
		get_tree().change_scene_to_file("res://menu/menu.tscn")
	elif index == 1:
		save_settings_to_file(volume, "Inglés")
		get_tree().change_scene_to_file("res://menu/menuIngles.tscn")


# Guarda el idioma seleccionado en el archivo de configuración.
func save_language_to_file(lang):
	var config = ConfigFile.new()
	config.set_value("Settings", "language", lang)
	config.save(CONFIG_FILE_PATH)


# Carga el idioma desde el archivo de configuración.
func load_language_from_file():
	var config = ConfigFile.new()
	if config.load(CONFIG_FILE_PATH) == OK:
		return config.get_value("Settings", "language", "English")
	return "English"


# Guarda tanto el volumen como el idioma en el archivo de configuración.
func save_settings_to_file(volume, lang):
	var config = ConfigFile.new()
	config.set_value("Settings", "volume", volume)
	config.set_value("Settings", "language", lang)
	config.save(CONFIG_FILE_PATH)


# Carga el volumen y el idioma desde el archivo de configuración.
func load_settings_from_file():
	var config = ConfigFile.new()
	if config.load(CONFIG_FILE_PATH) == OK:
		return {
			"volume": config.get_value("Settings", "volume", 1.0),
			"language": config.get_value("Settings", "language", "English")
		}
	return {
		"volume": 1.0,
		"language": "English"
	}


# Función que se llama cuando se cambia el estado del CheckButton de pantalla completa.
# Ajusta el modo de pantalla completa según el estado del CheckButton.
func _on_full_screen_button_toggled(toggled_on):
	if toggled_on:
		# Activar el modo de pantalla completa.
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		# Activar el modo ventana.
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


# Guarda la configuración de pantalla completa en el archivo de configuración.
func save_fullscreen_to_file(fullscreen):
	var config = ConfigFile.new()
	config.set_value("Settings", "fullscreen", fullscreen)
	config.save(CONFIG_FILE_PATH)


# Carga la configuración de pantalla completa desde el archivo de configuración.
func load_fullscreen_from_file():
	var config = ConfigFile.new()
	if config.load(CONFIG_FILE_PATH) == OK:
		return config.get_value("Settings", "fullscreen", false)
	return false
