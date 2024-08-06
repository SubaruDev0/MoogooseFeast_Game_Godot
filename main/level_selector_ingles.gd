extends Control

# Esta función se ejecuta cuando el nodo está listo para la interacción.
# Inicializa el volumen de la canción y la reproduce desde la mitad, luego comienza el efecto de fade-in.
func _ready():
	# Configura el volumen inicial bajo para el fade-in y reproduce la canción desde la mitad
	$CreditosSong.volume_db = -30  # Establece el volumen inicial bajo
	$CreditosSong.play()  # Inicia la reproducción de la canción
	$CreditosSong.seek(20)  # Comienza la canción desde el minuto 20
	start_fade_in()  # Aplica el efecto de fade-in al volumen

	# Cargar los datos del juego para obtener el puntaje máximo
	GameData.load_game()

	# Activar o desactivar los botones de nivel en función del puntaje máximo alcanzado
	if GameData.max_level >= 20:
		$LabelLevel20.disabled = false  # Habilita el botón de nivel 20 si se ha alcanzado o superado
	else:
		$LabelLevel20.disabled = true  # Desactiva el botón de nivel 20 si no se ha alcanzado

	if GameData.max_level >= 40:
		$LabelLevel40.disabled = false  # Habilita el botón de nivel 40 si se ha alcanzado o superado
	else:
		$LabelLevel40.disabled = true  # Desactiva el botón de nivel 40 si no se ha alcanzado

	if GameData.max_level >= 60:
		$LabelLevel60.disabled = false  # Habilita el botón de nivel 60 si se ha alcanzado o superado
	else:
		$LabelLevel60.disabled = true  # Desactiva el botón de nivel 60 si no se ha alcanzado

	if GameData.max_level >= 80:
		$LabelLevel80.disabled = false  # Habilita el botón de nivel 80 si se ha alcanzado o superado
	else:
		$LabelLevel80.disabled = true  # Desactiva el botón de nivel 80 si no se ha alcanzado

	if GameData.max_level >= 100:
		$LabelLevel100.disabled = false  # Habilita el botón de nivel 100 si se ha alcanzado o superado
	else:
		$LabelLevel100.disabled = true  # Desactiva el botón de nivel 100 si no se ha alcanzado

# Inicia el efecto de fade-in de la canción.
# Utiliza un Tween para animar el volumen de -30 dB a -9 dB en 3 segundos.
func start_fade_in():
	var tween = get_tree().create_tween()  # Crea un nuevo Tween
	tween.set_trans(Tween.TRANS_SINE)  # Establece la transición como Sine
	tween.set_ease(Tween.EASE_IN_OUT)  # Establece el easing como InOut
	tween.tween_property($CreditosSong, "volume_db", -9, 3)  # Animar el volumen de -30 dB a -9 dB en 3 segundos

# Función que se llama cuando se presiona el botón de regreso.
# Cambia la escena a la del menú principal.
func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://menu/menuIngles.tscn")  # Cambia a la escena del menú principal

# Función que se llama cuando se presiona el botón de créditos.
# Cambia la escena a la de créditos.
func _on_creditos_button_pressed():
	get_tree().change_scene_to_file("res://creditosIngles.tscn")  # Cambia a la escena de créditos

# Función que se llama cuando se presiona el botón de sonidos.
# Cambia la escena a la de ajustes de sonido en español.
func _on_sounds_button_pressed():
	get_tree().change_scene_to_file("res://menu/sounds_ingles.tscn")  # Cambia a la escena de ajustes de sonido en español

# Función que se llama cuando la canción de créditos termina.
# Reinicia la canción y aplica el efecto de fade-in.
func _on_creditos_song_finished():
	$CreditosSong.play()  # Reinicia la canción de créditos
	start_fade_in()  # Reaplica el efecto de fade-in

# Función que se llama cuando se presiona el botón del nivel 20.
# Cambia a la escena del nivel 20 si no está bloqueado.
func _on_label_level_20_pressed():
	if not $LabelLevel20.disabled:  # Verifica si el botón de nivel 20 está habilitado
		get_tree().change_scene_to_file("res://main/main20ingles.tscn")  # Cambia a la escena del nivel 20


func _on_label_level_40_pressed():
	if not $LabelLevel40.disabled:  # Verifica si el botón de nivel 20 está habilitado
		get_tree().change_scene_to_file("res://main/main40ingles.tscn")  # Cambia a la escena del nivel 20

func _on_label_level_60_pressed():
	if not $LabelLevel60.disabled:  # Verifica si el botón de nivel 20 está habilitado
		get_tree().change_scene_to_file("res://main/main60ingles.tscn")  # Cambia a la escena del nivel 20

func _on_label_level_80_pressed():
	if not $LabelLevel80.disabled:  # Verifica si el botón de nivel 80 está habilitado
		get_tree().change_scene_to_file("res://main/main80ingles.tscn")  # Cambia a la escena del nivel 80

func _on_label_level_100_pressed():
	if not $LabelLevel100.disabled:  # Verifica si el botón de nivel 100 está habilitado
		get_tree().change_scene_to_file("res://main/main100ingles.tscn")  # Cambia a la escena del nivel 100

