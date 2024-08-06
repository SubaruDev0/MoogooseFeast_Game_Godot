#player
extends Area2D

# Señales emitidas cuando el jugador recoge una gema o se lastima
signal picked
signal hurt

# Variable de velocidad del personaje
@export var speed = 200
var Tocar_Izquierda = false
var Tocar_Derecha = false
var Tocar_Arriba = false
var Tocar_Abajo = false


# Función para obtener el vector de desplazamiento del personaje
# en función de las teclas de dirección presionadas
func get_input():
	# Crear un vector de desplazamiento para almacenar la dirección
	var desplazamiento = Vector2.ZERO
	
	# Verificar si se presionan las teclas de dirección o los botones táctiles
	# Verificar las direcciones horizontales
	var derecha = Input.is_action_pressed("ui_right") or Tocar_Derecha
	var izquierda = Input.is_action_pressed("ui_left") or Tocar_Izquierda
	if derecha and not izquierda:
		desplazamiento.x = 1
	elif izquierda and not derecha:
		desplazamiento.x = -1

	# Verificar las direcciones verticales
	var abajo = Input.is_action_pressed("ui_down") or Tocar_Abajo
	var arriba = Input.is_action_pressed("ui_up") or Tocar_Arriba
	if abajo and not arriba:
		desplazamiento.y = 1
	elif arriba and not abajo:
		desplazamiento.y = -1
	
	# Normalizar el vector de desplazamiento para mantener una velocidad constante
	return desplazamiento.normalized()


# Función para actualizar la animación del jugador
# en función del vector de desplazamiento
func actualizar_animacion(desplazamiento):
	# Actualizar la animación del personaje
	if desplazamiento.x != 0:
		# Si el personaje se mueve horizontalmente
		$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = desplazamiento.x < 0
	elif desplazamiento.y != 0:
		# Si el personaje se mueve verticalmente
		$AnimatedSprite2D.play("run")
	else:
		# Si el personaje no se mueve
		$AnimatedSprite2D.play("idle")


# Función principal de proceso que se llama en cada frame
func _process(delta):
	# Obtener el vector de desplazamiento
	var desplazamiento = get_input()

	# Mover al personaje en función del vector de desplazamiento
	position += desplazamiento * speed * delta
	
	# Limitar la posición del personaje dentro de los límites del mapa
	position.x = clamp(position.x, 20, 460)
	position.y = clamp(position.y, 20, 680)
	
	# Actualizar la animación del personaje
	actualizar_animacion(desplazamiento)


# Función que se llama cuando el jugador entra en contacto con otra área
func _on_area_entered(area):
	if area.is_in_group("gem"):
		print("Escarabajo encontrado!")
		$BeatleAudio.play()
		emit_signal("picked", "gem")
		
	elif area.is_in_group("firefly"):
		print("Luciernaga encontrada!")
		$FireflyAudio.play()
		emit_signal("picked", "firefly")
		
	if area.has_method("pickup"):	
		area.pickup()


# Función para manejar el final del juego
func game_over():
	set_process(false) # Detiene todas las funciones del Player
	$DeathAudio.play()
	$AnimatedSprite2D.animation = "hurt"


# Función que se llama cuando el jugador entra en contacto con otro cuerpo
func _on_body_entered(body):
	if body.is_in_group("enemy"):
		print("Froggy encontrado!")
		emit_signal("hurt")


# Funciones para los botones TOUCH
# Función para el botón de movimiento a la izquierda presionado
func _on_left_button_pressed():
	Tocar_Izquierda = true

# Función para el botón de movimiento a la izquierda liberado
func _on_left_button_released():
	Tocar_Izquierda = false

# Función para el botón de movimiento a la derecha presionado
func _on_right_button_pressed():
	Tocar_Derecha = true

# Función para el botón de movimiento a la derecha liberado
func _on_right_button_released():
	Tocar_Derecha = false

# Función para el botón de movimiento hacia arriba presionado
func _on_up_button_pressed():
	Tocar_Arriba = true

# Función para el botón de movimiento hacia arriba liberado
func _on_up_button_released():
	Tocar_Arriba = false

# Función para el botón de movimiento hacia abajo presionado
func _on_down_button_pressed():
	Tocar_Abajo = true

# Función para el botón de movimiento hacia abajo liberado
func _on_down_button_released():
	Tocar_Abajo = false
