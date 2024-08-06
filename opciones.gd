#opciones
extends Control


# Llamada cuando el nodo entra en el árbol de la escena por primera vez.
func _ready():
	pass # Reemplaza con el cuerpo de la función.


func _on_back_button_pressed():
	# Cambia a la escena del menú cuando se presiona el botón de retroceso.
	get_tree().change_scene_to_file("res://menu/menu.tscn")


func _on_creditos_button_pressed():
	# Cambia a la escena de créditos cuando se presiona el botón de créditos.
	get_tree().change_scene_to_file("res://creditos.tscn")

#ESTO YA NO SIRVE???... NO IMPORTA, SI EL JUEGO CORRE, NO LO TOQUES
