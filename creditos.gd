#creditos
extends Control


# Esta función se ejecuta cuando el nodo está listo para la interacción.
# Inicializa el volumen de la canción y la reproduce desde la mitad, luego comienza el efecto de fade-in.
func _ready():
	$CreditosSong.volume_db = -30  # Inicia con el volumen bajo para el fade-in
	$CreditosSong.play()
	$CreditosSong.seek(20)  # Inicia desde la mitad
	start_fade_in()


# Inicia el efecto de fade-in de la canción.
# Utiliza un Tween para animar el volumen de -30 dB a -9 dB en 3 segundos.
func start_fade_in():
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($CreditosSong, "volume_db", -9, 3)  # Ajusta el volumen de la canción durante 3 segundos


# Función que se llama cuando se presiona el botón de regreso.
# Cambia la escena a la del menú principal.
func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://menu/menu.tscn")


# Función que se llama cuando se presiona el botón de créditos.
# Cambia la escena a la de créditos.
func _on_creditos_button_pressed():
	get_tree().change_scene_to_file("res://creditos.tscn")


# Función que se llama cuando se presiona el botón de sonidos.
# Cambia la escena a la de ajustes de sonido en español.
func _on_sounds_button_pressed():
	get_tree().change_scene_to_file("res://menu/sounds_español.tscn")


# Función que se llama cuando la canción de créditos termina.
# Reinicia la canción y aplica el efecto de fade-in.
func _on_creditos_song_finished():
	$CreditosSong.play()
	start_fade_in()


func _on_arte_1_pressed():
	OS.shell_open("https://www.twitch.tv/garoudg")
	
	
func _on_arte_2_pressed():
	OS.shell_open("https://www.instagram.com/shad.din/")


func _on_arte_3_pressed():
	OS.shell_open("https://www.instagram.com/jaboo_alo/")


func _on_arte_4_pressed():
	OS.shell_open("https://www.instagram.com/young_zattu/")


func _on_creador_pressed():
	OS.shell_open("https://www.instagram.com/subarudev/")
