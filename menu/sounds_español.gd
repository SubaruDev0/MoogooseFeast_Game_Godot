#Sounds_Español
extends Control


# Función llamada cuando el nodo entra en el árbol de escenas por primera vez
func _ready():
	# Configura el volumen de la canción de créditos para iniciar con un nivel bajo
	$CreditosSong.volume_db = -30  
	# Reproduce la canción de créditos
	$CreditosSong.play()
	# Comienza la reproducción de la canción desde el minuto 1:01
	$CreditosSong.seek(61)  
	# Inicia el efecto de fade-in en el volumen de la canción
	start_fade_in()


# Función para aplicar un efecto de fade-in al volumen de la canción
func start_fade_in():
	# Crea un nuevo tween para animar propiedades
	var tween = get_tree().create_tween()
	# Establece la transición del tween como un efecto seno
	tween.set_trans(Tween.TRANS_SINE)
	# Establece el easing del tween como suave (in-out)
	tween.set_ease(Tween.EASE_IN_OUT)
	# Anima la propiedad de volumen de la canción de créditos
	tween.tween_property($CreditosSong, "volume_db", -9, 3)  # Aumenta el volumen de -30 a -9 en 3 segundos


# Función llamada cuando se presiona el primer enlace de sonido
func _on_link_sound_1_pressed():
	# Abre el enlace del sonido en el navegador web
	OS.shell_open("https://freesound.org/people/JoelAudio/sounds/135456/")


# Función llamada cuando se presiona el segundo enlace de sonido
func _on_link_sound_2_pressed():
	# Abre el enlace del sonido en el navegador web
	OS.shell_open("https://freesound.org/people/NoahBangs/sounds/715704/")


# Función llamada cuando se presiona el tercer enlace de sonido
func _on_link_sound_3_pressed():
	# Abre el enlace del video en YouTube en el navegador web
	OS.shell_open("https://www.youtube.com/watch?v=mRN_T6JkH-c")


# Función llamada cuando se presiona el cuarto enlace de sonido
func _on_link_sound_4_pressed():
	# Abre el enlace del video en YouTube en el navegador web
	OS.shell_open("https://www.youtube.com/watch?v=G-FGiICah8Q")


# Función llamada cuando se presiona el botón de retroceso
func _on_back_button_pressed():
	# Cambia a la escena del menú principal
	get_tree().change_scene_to_file("res://menu/menu.tscn")


# Función llamada cuando la canción de créditos termina
func _on_creditos_song_finished():
	# Reproduce nuevamente la canción de créditos
	$CreditosSong.play()
