extends Position2D

var Posicion = Vector2()
var PosJugadores = []
var PosJugadoresX = []
var PosJugadoresY = []
var sumaX = 0
var sumaY = 0
var PromedioX = 0
var PromedioY = 0
var maximoX = 0
var minimoX = 0
var maximoY = 0
var minimoY = 0
var diferenciaX = 0
var diferenciaY = 0

func max_arr(arr):
	if arr.size() == 1:
		return arr[0]
	else:
		var max_val = arr[0]
		for i in range(1, arr.size()):
			max_val = max(max_val, arr[i])
			return max_val
func min_arr(arr):
	if arr.size() == 1:
		return arr[0]
	else:
		var min_val = arr[0]
		for i in range(1, arr.size()):
			min_val = min(min_val, arr[i])
			return min_val

func _ready():
	set_process(true)
	AutoLoad.Controles.resize(4)
	PosJugadores.resize(4)
	for i in [0,1,2,3]:
		if AutoLoad.Controles[i] != null:
			AutoLoad.ControlesInicializados = AutoLoad.ControlesInicializados + [i]
	pass 


func _process(delta):
	PosJugadores = []
	PosJugadores.resize(4)
	PosJugadoresX = []
	PosJugadoresX.resize(Input.get_connected_joypads().size())
	PosJugadoresY = []
	PosJugadoresY.resize(Input.get_connected_joypads().size())
	sumaX = 0
	sumaY = 0
	if not AutoLoad.ActualizandoControles:
		for i in AutoLoad.ControlesInicializados:
			PosJugadores[i] = get_parent().get_node("Player" + str(i)).get_position()
			pass 
		for i in Input.get_connected_joypads().size():
			sumaX = sumaX + PosJugadores[i].x
			sumaY = sumaY + PosJugadores[i].y
			PosJugadoresX[i] = PosJugadores[i].x
			PosJugadoresY[i] = PosJugadores[i].y
			#Detecte un bug en esta parte al desconectar el control 1, las coordenadas
			#del 2do control desaparecen y las del 1ro quedan congeladas. A lo mejor podemos hacer
			#que cuando se desconecte un control, aparezca un mensaje de advertencia y se pause el 
			#juego, para que el usuario reconecte el control, o salga de la partida.
		maximoX = max_arr(PosJugadoresX)
		minimoX = min_arr(PosJugadoresX)
		maximoY = max_arr(PosJugadoresY)
		minimoY = min_arr(PosJugadoresY)
		
	PromedioX = sumaX / Input.get_connected_joypads().size()
	PromedioY = sumaY / Input.get_connected_joypads().size()
	
	Posicion.x = PromedioX
	Posicion.y = PromedioY
	
	diferenciaX = maximoX - minimoX
	diferenciaY = maximoY - minimoY
	
	if diferenciaX > 1000:
		AutoLoad.coeficienteZoom.x = (1.15 * diferenciaX)/1000
	if diferenciaY > 500:
		AutoLoad.coeficienteZoom.y = (1.15 * diferenciaY)/500
	set_position(Posicion)
	pass


