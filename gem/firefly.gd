#firefly
extends Area2D


# Realiza la animación de recogida del objeto.
# Reduce el tamaño del sprite y desvanece su color antes de eliminar el objeto.
func pickup():
	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property($AnimatedSprite2D, "scale", $AnimatedSprite2D.scale / 3, 0.2)  # Reduce el tamaño del sprite
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 1, 1, 0), 0.2)  # Desvanece el color del sprite
	await tween.finished  # Espera a que termine la animación
	queue_free()  # Elimina el objeto del juego


# Función que se llama cuando el temporizador de vida del objeto se agota.
# Realiza la animación de salida, ampliando el tamaño del sprite y desvaneciéndolo antes de eliminar el objeto.
func _on_life_timer_timeout():
	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property($AnimatedSprite2D, "scale", $AnimatedSprite2D.scale * 2, 0.2)  # Aumenta el tamaño del sprite
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 1, 1, 0), 0.2)  # Desvanece el color del sprite
	await tween.finished  # Espera a que termine la animación
	queue_free()  # Elimina el objeto del juego
