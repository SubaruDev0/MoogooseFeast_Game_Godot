#mainIngles
extends Node2D

const GEMS_BASE = 5
const MAX_SPEED = 500

# Preload de gemas y luciérnagas
var Gem = preload("res://gem/gem.tscn")
var Firefly = preload("res://gem/firefly.tscn")

# Variables del juego
var score = 0
var level = 1
var tiempo_atras = 30
var incremento_speed = 20
var game_over_timer = Timer.new()
var gold_color = Color("#F5C842")
var froggy_original_scale = Vector2.ONE
var froggy_giant_scale = Vector2(2, 2)
var froggy_giant_duration = 5
var froggy_giant_platform_offset = Vector2(0, 20)
var platform_y_position = 700


func _ready():
	# Inicializa el juego y la interfaz de usuario
	$NivelAlto.play()
	GameData.load_game()
	add_child(game_over_timer)
	timer_settings()
	randomize()
	$HUD.update_timer(tiempo_atras)
	spawn_gems()
	set_firefly_timer()
	$Froggy.visible = true
	froggy_original_scale = $Froggy.scale
	update_max_labels_color()


func timer_settings():
	# Configura el temporizador para el final del juego
	game_over_timer.wait_time = 2
	game_over_timer.one_shot = true
	game_over_timer.connect("timeout", Callable(self, "_on_game_over_timer_timeout"))


func connect_gem_signals():
	# Conecta las señales de recogida de gemas
	for gem in $GemContainer.get_children():
		gem.connect("picked", Callable(self, "_on_gem_picked"))


func _on_game_over_timer_timeout():
	# Maneja el evento de tiempo de espera después del juego
	GameData.last_score = score
	GameData.last_level = level

	if GameData.last_score > GameData.max_score:
		GameData.max_score = GameData.last_score
		GameData.max_level = GameData.last_level

	GameData.save_game()
	get_tree().change_scene_to_file("res://menu/menuIngles.tscn")


func update_max_labels_color():
	# Actualiza el color de las etiquetas si se alcanza un nuevo récord
	if score > GameData.max_score:
		$HUD/MarginContainer/LabelScore.add_theme_color_override("font_color", gold_color)
	
	if level > GameData.max_level and level > 1:
		$HUD/LabelLevelNumber.add_theme_color_override("font_color", gold_color)
		$HUD/MarginContainer/LabelLevel.add_theme_color_override("font_color", gold_color)


func _process(_delta):
	# Actualiza la posición de la plataforma y maneja el progreso del nivel
	update_platform_position()
	if $GemContainer.get_child_count() == 0:
		level += 1
		$LevelAudio.play()
		$HUD/LabelLevelNumber.text = str(level)
		tiempo_atras += 5
		$HUD.update_timer(tiempo_atras)
		show_and_hide_label_tiempo()
		spawn_gems()
		player_speed()
		update_max_labels_color()
		check_froggy_growth()


func update_platform_position():
	# Actualiza la posición de la plataforma para que siga a Froggy
	$Platform.position.x = $Froggy.position.x
	$Platform.position.y = platform_y_position


func show_and_hide_label_tiempo():
	# Muestra y oculta la etiqueta de tiempo restante
	$HUD/LabelTiempo.visible = true
	var tween_show : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween_show.tween_property($HUD/LabelTiempo, "scale", Vector2.ONE, 0.5)
	tween_show.tween_property($HUD/LabelTiempo, "modulate", Color(1, 1, 1, 1), 0.5)
	await tween_show.finished
	
	var tween_hide : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween_hide.tween_property($HUD/LabelTiempo, "scale", Vector2(2,1), 0.5)
	await tween_hide.finished
	$HUD/LabelTiempo.visible = false


func show_and_hide_label_Mas_5_Score():
	# Muestra y oculta la etiqueta de puntuación adicional
	$HUD/LabelMas5Score.visible = true
	var tween_show : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween_show.tween_property($HUD/LabelMas5Score, "scale", Vector2.ONE, 0.5)
	tween_show.tween_property($HUD/LabelMas5Score, "modulate", Color(1, 1, 1, 1), 0.5)
	await tween_show.finished

	var tween_hide : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween_hide.tween_property($HUD/LabelMas5Score, "scale", Vector2(-2,-1), 0.5)
	await tween_hide.finished
	$HUD/LabelMas5Score.visible = false


func show_and_hide_label_deprisa():
	# Muestra y oculta la etiqueta de "deprisa"
	$HUD/LabelDeprisa.visible = true
	var tween_show : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween_show.tween_property($HUD/LabelDeprisa, "modulate", Color(1, 1, 1, 1), 1)
	await tween_show.finished
	
	var tween_hide : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween_hide.tween_property($HUD/LabelDeprisa, "modulate", Color(1, 1, 1, 0), 2)
	await tween_hide.finished
	
	$HUD/LabelDeprisa.visible = false
	
	
func spawn_gems():
	# Genera las gemas en la pantalla
	var total_gemas = GEMS_BASE
	
	if level % 20 == 0:
		total_gemas = GEMS_BASE
	else:
		# Determina el umbral del siguiente nivel múltiplo de 20
		var next_level_threshold = (level / 20 + 1) * 20
		# Calcula el número de gemas adicionales que se deben añadir
		total_gemas += min(level - (next_level_threshold - 20), 19)  # Añadir hasta 19 gemas adicionales

	total_gemas = min(total_gemas, 50)
	
	var posiciones = []

	for i in range(total_gemas):
		var posicionamiento = Vector2(randf_range(0, 430), randf_range(100, 660))
		while posiciones.any(func(p): return posicionamiento.distance_to(p) < 50):
			posicionamiento = Vector2(randf_range(0, 430), randf_range(100, 660))
		
		posiciones.append(posicionamiento)
		var gema = Gem.instantiate()
		gema.position = posicionamiento
		$GemContainer.add_child(gema)
	
	$GemContainer.set_meta("posiciones", posiciones)
	connect_gem_signals()


func player_speed():
	# Ajusta la velocidad del jugador en función del nivel
	var nueva_velocidad = 200 + (level * incremento_speed)
	$Player.speed = min(nueva_velocidad, MAX_SPEED)
	print("Velocidad actualizada: ", $Player.speed)


func game_over():
	# Maneja el evento de fin del juego
	$NivelAlto.stop()
	GameData.last_score = score
	$GameTimer.stop()
	print("Game over!")
	$HUD/GameOver.visible = true
	$Player.game_over()
	game_over_timer.start()


func _on_game_timer_timeout():
	# Maneja la actualización del temporizador
	tiempo_atras -= 1
	$HUD.update_timer(tiempo_atras)
	
	if tiempo_atras <= 0:
		game_over()
	else:
		if tiempo_atras == 5:
			$Deprisa.play()
			show_and_hide_label_deprisa()


func _on_player_picked(type):
	# Maneja el evento cuando el jugador recoge un objeto
	match type:
		"gem":
			$Player/BeatleAudio.play()  # Reproduce el sonido cuando Froggy recoge una gema
			score += 1
			$HUD.update_score(score)
		"firefly":
			$Player/BeatleAudio.play()  # Reproduce el sonido cuando Froggy recoge una gema
			score += 5
			$HUD.update_score(score)
			tiempo_atras += 5
			$HUD.update_timer(tiempo_atras)
			show_and_hide_label_tiempo()
			show_and_hide_label_Mas_5_Score()


func set_firefly_timer():
	# Configura el temporizador para generar fireflies
	var intervalo = randi_range(10, 60)
	$FireflyTimer.wait_time = intervalo
	$FireflyTimer.start()


func _on_firefly_timer_timeout():
	# Maneja la generación de un firefly
	$FireflyTimer.stop()
	var firefly = Firefly.instantiate()
	var firefly_posicion = Vector2(randf_range(0, 360), randf_range(100, 660))
	var gem_positions = $GemContainer.get_meta("posiciones", [])
	while gem_positions.any(func(p): return firefly_posicion.distance_to(p) < 50):
		firefly_posicion = Vector2(randf_range(0, 360), randf_range(100, 660))
	firefly.position = firefly_posicion
	$GemContainer.add_child(firefly)
	set_firefly_timer()


func _on_gem_picked(type):
	# Maneja el evento cuando se recoge una gema
	if type == "gem":
		$Player/BeatleAudio.play()  # Reproduce el sonido cuando Froggy recoge una gema


func _on_player_hurt():
	# Maneja el evento cuando el jugador resulta herido
	game_over()


func _on_nivel_alto_finished():
	# Maneja el evento cuando se termina el nivel alto
	$NivelAlto.play()


func check_froggy_growth():
	# Verifica si Froggy debe crecer o restaurarse
	if (level % 20) == 0:
		grow_froggy()
	elif (level % 20) == froggy_giant_duration:
		restore_froggy()


func grow_froggy():
	# Hace que Froggy crezca
	$Froggy.scale = froggy_giant_scale
	$Froggy/CollisionShape2D.scale *= 0.9  # Reducir un poco el tamaño de las colisiones
	$Platform.position.y += froggy_giant_platform_offset.y


func restore_froggy():
	# Restaura el tamaño original de Froggy
	$Froggy.scale = froggy_original_scale
	$Froggy/CollisionShape2D.scale /= 0.9  # Restaurar el tamaño de las colisiones
	$Platform.position.y -= froggy_giant_platform_offset.y
