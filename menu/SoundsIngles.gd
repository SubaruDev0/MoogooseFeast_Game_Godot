#SoundsIngles
extends Control


# Función llamada cuando el nodo entra en el árbol de escenas por primera vez
func _ready():
	# Inicia la canción de créditos con el volumen bajo para el fade-in
	$CreditosSong.volume_db = -30  
	$CreditosSong.play()  # Reproduce la canción de créditos
	$CreditosSong.seek(61)  # Comienza desde la mitad de la canción
	start_fade_in()  # Comienza el efecto de fade-in para el volumen


# Función para iniciar el efecto de fade-in
func start_fade_in():
	# Crear un nuevo tween para animar propiedades
	var tween = get_tree().create_tween()
	# Establecer el tipo de transición para el tween
	tween.set_trans(Tween.TRANS_SINE)
	# Establecer el tipo de suavizado para el tween
	tween.set_ease(Tween.EASE_IN_OUT)
	# Animar la propiedad de volumen para hacer un fade-in
	tween.tween_property($CreditosSong, "volume_db", -9, 3)  # Ajusta el volumen de -30 a -9 en 3 segundos


# Función llamada cuando se presiona el primer enlace de sonido
func _on_link_sound_1_pressed():
	# Abrir el enlace en el navegador predeterminado
	OS.shell_open("https://freesound.org/people/JoelAudio/sounds/135456/")


# Función llamada cuando se presiona el segundo enlace de sonido
func _on_link_sound_2_pressed():
	# Abrir el enlace en el navegador predeterminado
	OS.shell_open("https://freesound.org/people/NoahBangs/sounds/715704/")


# Función llamada cuando se presiona el tercer enlace de sonido
func _on_link_sound_3_pressed():
	# Abrir el enlace en el navegador predeterminado
	OS.shell_open("https://www.youtube.com/watch?v=mRN_T6JkH-c")


# Función llamada cuando se presiona el cuarto enlace de sonido
func _on_link_sound_4_pressed():
	# Abrir el enlace en el navegador predeterminado
	OS.shell_open("https://www.youtube.com/watch?v=G-FGiICah8Q")


# Función llamada cuando se presiona el botón de retroceso
func _on_back_button_pressed():
	# Cambiar a la escena del menú en inglés
	get_tree().change_scene_to_file("res://menu/menuIngles.tscn")


# Función llamada cuando la canción de créditos termina
func _on_creditos_song_finished():
	# Repetir la canción de créditos
	$CreditosSong.play()
