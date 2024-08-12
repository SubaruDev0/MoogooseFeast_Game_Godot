#player
extends Area2D

# Señales emitidas cuando el jugador recoge una gema o se lastima
signal picked
signal hurt

# Variable de velocidad del personaje
@export var speed = 200

# Variables de movimiento táctil
var Tocar_Izquierda = false
var Tocar_Derecha = false
var Tocar_Arriba = false
var Tocar_Abajo = false

# Variable para almacenar la posición del clic
var click_position = null

# Variables para manejar la prioridad de los toques
var last_touch_direction = Vector2.ZERO

# Función para obtener el vector de desplazamiento del personaje
# en función de las teclas de dirección presionadas o clic del ratón
func get_input():
	var desplazamiento = Vector2.ZERO

	# Movimiento por teclas
	var horizontal_input = 0
	var vertical_input = 0

	# Movimiento táctil con prioridad en el último toque
	if Tocar_Derecha:
		horizontal_input = 1
		last_touch_direction = Vector2.RIGHT
	elif Tocar_Izquierda:
		horizontal_input = -1
		last_touch_direction = Vector2.LEFT

	if Tocar_Abajo:
		vertical_input = 1
		last_touch_direction = Vector2.DOWN
	elif Tocar_Arriba:
		vertical_input = -1
		last_touch_direction = Vector2.UP

	# Si no hay toque en la pantalla, permitimos movimiento por teclado
	if horizontal_input == 0 and vertical_input == 0:
		horizontal_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		vertical_input = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	# Movimiento por clic
	if click_position:
		desplazamiento = (click_position - position).normalized()
	else:
		desplazamiento = Vector2(horizontal_input, vertical_input)

	return desplazamiento.normalized()

# Función para actualizar la animación del jugador
func actualizar_animacion(desplazamiento):
	if desplazamiento.x != 0:
		$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = desplazamiento.x < 0
	elif desplazamiento.y != 0:
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")

# Función principal de proceso que se llama en cada frame
func _process(delta):
	var desplazamiento = get_input()

	# Mover al personaje en función del vector de desplazamiento
	position += desplazamiento * speed * delta

	# Limitar la posición del personaje dentro de los límites del mapa
	position.x = clamp(position.x, 20, 460)
	position.y = clamp(position.y, 20, 680)

	# Actualizar la animación del personaje
	actualizar_animacion(desplazamiento)

# Función para manejar el clic del ratón o toque en pantalla táctil
func _input(event):
	if event is InputEventMouseMotion and click_position:
		click_position = event.position
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			click_position = event.position
		else:
			click_position = null

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
	set_process(false)
	$DeathAudio.play()
	$AnimatedSprite2D.animation = "hurt"

# Función que se llama cuando el jugador entra en contacto con otro cuerpo
func _on_body_entered(body):
	if body.is_in_group("enemy"):
		print("Froggy encontrado!")
		emit_signal("hurt")

# Funciones para los botones TOUCH
func _on_left_button_pressed():
	Tocar_Izquierda = true
	Tocar_Derecha = false

func _on_left_button_released():
	Tocar_Izquierda = false

func _on_right_button_pressed():
	Tocar_Derecha = true
	Tocar_Izquierda = false

func _on_right_button_released():
	Tocar_Derecha = false

func _on_up_button_pressed():
	Tocar_Arriba = true
	Tocar_Abajo = false

func _on_up_button_released():
	Tocar_Arriba = false

func _on_down_button_pressed():
	Tocar_Abajo = true
	Tocar_Arriba = false

func _on_down_button_released():
	Tocar_Abajo = false
