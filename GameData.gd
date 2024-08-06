extends Node

# Variables para almacenar el puntaje y el nivel de la última partida
var last_score: int = 0
var last_level: int = 0

# Variables para almacenar el puntaje máximo y el nivel máximo
var max_score: int = 0
var max_level: int = 0

# Ruta del archivo donde se guardarán los datos del juego
var save_path = "user://save_game.dat"

# Diccionario para almacenar los datos del juego
var game_data: Dictionary = {
	"max_score": max_score,  # Puntaje máximo
	"max_level": max_level   # Nivel máximo
}

# Función para guardar los datos del juego
func save_game():
	# Actualizar el diccionario con los valores actuales
	game_data["max_score"] = max_score
	game_data["max_level"] = max_level
	
	# Abrir el archivo en modo escritura
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	
	# Guardar el diccionario de datos del juego en el archivo
	save_file.store_var(game_data)
	
	# Cerrar el archivo
	save_file.close()
	
	# Liberar el recurso
	save_file = null

# Función para cargar los datos del juego
func load_game():
	# Verificar si el archivo de guardado existe
	if FileAccess.file_exists(save_path):
		# Abrir el archivo en modo lectura
		var save_file = FileAccess.open(save_path, FileAccess.READ)
		
		# Leer el diccionario de datos del juego desde el archivo
		game_data = save_file.get_var()
		
		# Asignar los datos a las variables
		max_score = game_data.get("max_score", 0)
		max_level = game_data.get("max_level", 0)
		
		# Cerrar el archivo
		save_file.close()
		
		# Liberar el recurso
		save_file = null
