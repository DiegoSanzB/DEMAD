extends KinematicBody2D

#Variables
var motion = Vector2()
var deadZone = 0.2
var dobleSalto = 0
var controlesConectados = Input.get_connected_joypads().size()
export var speedMultiplier = 400

#Constantes
const UP = Vector2(0, -1)
const GRAVITY = 20
const JUMP_HEIGHT = -550

#Check de control
func _ready():
	Input.connect("joy_connection_changed", self,"joy_con_changed")
	add_to_group('players')
	

func joy_con_changed(deviceid, isConnected): #primero: identifica coneccion, segundo: identifica si es conexión o desconexión
	if isConnected:
		print("Joystick " + str(deviceid) + " connected")
		if  Input.is_joy_known(0): #Reconoce algunos tipos de control
			print('Control reconocido')
			print(Input.get_joy_name(0) + ' encontrado')
		else:
			print('Control desconectado')
#		KinematicBody2D.set_name('Player_%' % deviceid)
	
#Fisica
func _physics_process(delta):
	#Gravedad
	if Input.get_connected_joypads().size() > 0:
		var yAxis = Input.get_joy_axis(0,JOY_AXIS_1)
		if yAxis > 0 and abs(yAxis) > deadZone and motion.y > 0:
			motion.y += yAxis * 100
	
	if motion.y > 0:
		motion.y += 2 *  GRAVITY
	else:
		motion.y += GRAVITY
	
	#Salto
	#print(dobleSalto) #Debbug: Estado de dobleSlato. 
	#print(Input.is_joy_button_pressed(0,JOY_BUTTON_0)) #Debbug: estar apretando A
	if is_on_floor():
		dobleSalto = 0
		if Input.is_action_just_pressed("ui_up"):# or (Input.is_joy_button_pressed(0,JOY_BUTTON_0)):
			motion.y = JUMP_HEIGHT
	if not is_on_floor() and dobleSalto == 0:
		if Input.is_action_just_pressed("ui_up"):# or Input.is_joy_button_pressed(0,JOY_BUTTON_0):
			motion.y = JUMP_HEIGHT
			dobleSalto =1
		
			
	#Movimiento gorizonttal con joystick
	if Input.get_connected_joypads().size() > 0:
		var xAxis = Input.get_joy_axis(0,JOY_AXIS_0)
		if abs(xAxis) > deadZone:
			#if  xAxis > 0:
				motion.x = 100 * delta * speedMultiplier * (xAxis)
			#elif  xAxis < 0:
				#motion.x = -100 * delta * speedMultiplier * abs(xAxis)
		else:
			motion.x = 0
			
		#Check de que tecla se esta apretando
		#for i in range(16):
			#if Input.is_joy_button_pressed(0,i):
				#print('Boton ' + str(i) + ' presionado, debiera ser ' + Input.get_joy_button_string(i) )
				
	motion = move_and_slide(motion,UP)

#Crea nuevos player dependiendo de la cantidad de controles
func multiPlayer():
	if get_tree().get_nodes_in_group("players").size() < controlesConectados:
		var player = load("res://KinematicBody2D.gd").new()
		player.set_name("Player_2")
		add_child(player)
	print(has_node("Player_2"))
	print(get_tree().get_nodes_in_group("players"))

#Cada frame
func _process(delta):
	#Quit game
	if Input.is_key_pressed(KEY_Q):
		get_tree().quit()
	multiPlayer()


