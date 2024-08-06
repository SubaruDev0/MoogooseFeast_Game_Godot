extends Area2D

# Variable de velocidad del personaje
@export var speed = 200

# Función para obtener el vector de desplazamiento del personaje
# en función de las teclas de dirección presionadas
func get_input():
	# Crear un vector de desplazamiento para almacenar la dirección
	var desplazamiento = Vector2.ZERO
	
	# Verificar si se presionan las teclas de dirección
	if Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left"):
		desplazamiento.x = 1
	elif Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
		desplazamiento.x = -1
	if Input.is_action_pressed("ui_down") and not Input.is_action_pressed("ui_up"):
		desplazamiento.y = 1
	elif Input.is_action_pressed("ui_up") and not Input.is_action_pressed("ui_down"):
		desplazamiento.y = -1
	
	# Normalizar el vector de desplazamiento para mantener una velocidad constante
	return desplazamiento.normalized()


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
	position.x = clamp(position.x, 90, 540)
	position.y = clamp(position.y, 50, 720)
	
	# Actualizar la animación del personaje
	actualizar_animacion(desplazamiento)
