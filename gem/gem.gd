#gem
extends Area2D

# Señal que se emite cuando el objeto es recogido
signal picked(type)

# Tipo de gema: puede ser "gem" o "firefly"
var gem_type = "gem"

func _ready():
	# Configurar el color de gema y tipo aleatorio
	set_gem_color_and_type()
	
	# Conectar la señal 'body_entered' para detectar cuando un cuerpo entra en el área de detección
	connect("body_entered", Callable(self, "_on_body_entered"))

func set_gem_color_and_type():
	# Decidir aleatoriamente el color de la gema
	var color_choice = randi() % 3  # Genera un número entre 0 y 2
	match color_choice:
		0:
			gem_type = "gem"
			$AnimatedSprite2D
		1:
			gem_type = "gem"
			$AnimatedSprite2D.modulate = Color(4, 0, 0.5)  # Rojo claro
		2:
			gem_type = "gem"
			$AnimatedSprite2D.modulate = Color(0, 1, 0)  # Verde

func _on_body_entered(body):
	# Verificar si el cuerpo que entró es "Froggy"
	if body.name == "Froggy":
		pickup()  # Llamar a la función pickup cuando Froggy recoge el objeto
		emit_signal("picked", gem_type)  # Emitir señal con el tipo de gema

func pickup():
	# Crear un Tween para animar la desaparición del objeto
	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	# Animar la reducción de escala
	tween.tween_property($AnimatedSprite2D, "scale", $AnimatedSprite2D.scale / 3, 0.2)
	
	# Animar la reducción de la opacidad
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 1, 1, 0), 0.2)
	
	# Esperar a que termine la animación
	await tween.finished
	
	# Eliminar el nodo del árbol de escena
	queue_free()
