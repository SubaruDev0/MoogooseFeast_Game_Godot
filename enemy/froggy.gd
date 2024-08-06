#froggy
extends CharacterBody2D

@export var gravity_power: int  # Potencia de la gravedad
@export var jump_power: int  # Potencia del salto
@export var speed: int  # Velocidad de movimiento
@export var speed_max: int = 500  # Velocidad máxima de movimiento

enum { IDLE, BREATHE, JUMP_UP, JUMP_DOWN }  # Estados posibles del personaje

var state  # Estado actual del personaje
var current_anim  # Animación actual que se está reproduciendo
var new_anim  # Nueva animación a reproducir


func _ready():
	# Configura los intervalos del temporizador y establece el estado inicial
	set_timer_interval()
	transition_to(IDLE)


func transition_to(new_state):
	# Cambia el estado del personaje y actualiza la animación correspondiente
	state = new_state
	match state:
		IDLE:
			new_anim = "idle"
		BREATHE:
			new_anim = "breathe"
		JUMP_UP:
			new_anim = "jump_up"
		JUMP_DOWN:
			new_anim = "jump_down"


func _process(_delta):
	# Cambia la animación si es necesario
	if new_anim != current_anim:
		current_anim = new_anim
		$AnimationPlayer.play(current_anim)
		print("Animación actual: ", current_anim)

	# Transición a JUMP_DOWN si no estamos en el suelo y la velocidad vertical es mayor que 0
	if not is_on_floor() and velocity.y > 0:
		transition_to(JUMP_DOWN)
		
	# Transición a IDLE si estamos en el suelo y el estado es JUMP_DOWN
	if is_on_floor() and state == JUMP_DOWN:
		transition_to(IDLE)

	# Actualizar la velocidad horizontal
	if not is_on_floor():
		velocity.x = speed
	else:
		velocity.x = 0
	
	$Sprite2D.flip_h = (speed > 0)


func _physics_process(delta):
	# Aplica gravedad a la velocidad vertical
	velocity.y += gravity_power * delta

	var screen_width = 440
	var position = get_position()

	# Lógica de desplazamiento y limitación de posición
	position.x = clamp(position.x, 40, 440)
	set_position(position)

	# Ajustar la dirección del sprite según el movimiento
	if position.x <= 0 and velocity.x < 0:
		$Sprite2D.flip_h = false  # Asegurar que el sprite no esté volteado

	if position.x >= screen_width and velocity.x > 0:
		$Sprite2D.flip_h = true  # Voltear el sprite hacia la izquierda

	move_and_slide()


func set_timer_interval():
	# Configura los temporizadores para "Breathe" y "Jump"
	var intervalo = randi_range(3, 5)
	$FroggyTimer.wait_time = intervalo
	$FroggyTimer.start()

	intervalo = randi_range(3, 5)
	$FroggyJumpTimer.wait_time = intervalo
	$FroggyJumpTimer.start()


func _on_froggy_timer_timeout():
	# Maneja el temporizador de "Breathe" y cambia el estado si es necesario
	$FroggyTimer.stop()
	if state == IDLE:
		transition_to(BREATHE)
		$BreatheSound.play()
	set_timer_interval()


func _on_animation_player_animation_finished(anim_name):
	# Maneja la finalización de la animación "breathe"
	if anim_name == "breathe":
		transition_to(IDLE)


func _on_froggy_jump_timer_timeout():
	# Maneja el temporizador de "Jump" y realiza un salto aleatorio
	$FroggyJumpTimer.stop()
	if state == IDLE:
		# Genera un valor aleatorio para la potencia del salto
		velocity.y = randi_range(jump_power * 2.5, jump_power)
		transition_to(JUMP_UP)
		$FroggySound.play()
		update_speed_direction()
	set_timer_interval()


func update_speed_direction():
	# Cambia la dirección de la velocidad de manera aleatoria
	var pulso = bool(randi() % 2)  # Genera un valor booleano aleatorio
	if pulso:
		speed = abs(speed)  # Asegura que la velocidad sea positiva
	else:
		speed = -abs(speed)  # Asegura que la velocidad sea negativa


func _on_speed_increase_timer_timeout():
	# Aumenta la velocidad y limita su valor máximo
	speed += 100
	if speed > speed_max:
		speed = speed_max
	print("Velocidad Froggy aumentada: ", speed)
	print("Potencia de salto Froggy aumentada: ", jump_power)
