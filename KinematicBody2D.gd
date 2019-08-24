extends KinematicBody2D

#Variables
var motion = Vector2()
var deadZone = 0.2
var speedMultiplier = 60

#Constantes
const UP = Vector2(0, -1)
const GRAVITY = 20
const JUMP_HEIGHT = -550

#Check de control
func _ready():
# warning-ignore:return_value_discarded
	Input.connect("joy_connection_changed", self,"joy_con_changed")

func joy_con_changed(deviceid, isConnected): #primero: identifica coneccion, segundo: identifica si es conexión o desconexión
	if isConnected:
		print("Joystick" + str(deviceid) + "connected")
		if  Input.is_joy_known(0): #Reconoce algunos tipos de control
			print('Control reconocido')
			print(Input.get_joy_name(0) + ' encontrado')
		else:
			print('Control desconectado')

#Fisica
func _physics_process(delta):
	#Gravedad
	motion.y += GRAVITY
	
	#Salto
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up") or Input.is_joy_button_pressed(0,JOY_BUTTON_0):
			motion.y = JUMP_HEIGHT
			
	#Movimiento gorizonttal con joystick
	if Input.get_connected_joypads().size() > 0:
		var xAxis = Input.get_joy_axis(0,JOY_AXIS_0)
		if abs(xAxis) > deadZone:
			if  xAxis > 0:
				motion.x = 100 * delta * speedMultiplier * abs(xAxis)
			elif  xAxis < 0:
				motion.x = -100 * delta * speedMultiplier * abs(xAxis)
		else:
			motion.x = 0
			
		#Check de que tecla se esta apretando
		for i in range(16):
			if Input.is_joy_button_pressed(0,i):
				print('Boton ' + str(i) + ' presionado, debiera ser ' + Input.get_joy_button_string(i) )
				
		
		
	motion = move_and_slide(motion,UP)

	#Quit game
	if Input.is_key_pressed(KEY_Q):
		get_tree().quit()


