#HUD
extends Control

# Función para actualizar el temporizador en la interfaz
func update_timer(new_val):
	# Actualiza el texto del LabelTimer dentro del MarginContainer
	$MarginContainer/LabelTimer.text = str(new_val)

# Función para actualizar la puntuación en la interfaz
func update_score(new_val):
	# Actualiza el texto del LabelScore dentro del MarginContainer
	$MarginContainer/LabelScore.text = str(new_val)
