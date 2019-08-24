extends KinematicBody2D

#Variables
var motion = Vector2()				#Define hacia donde es el movimiento
export var speedMultiplier = 400	#Multiplicador de velocidad
export var acceleration = 0.4		#Aceleracion
export var airAcceleration = 0.1	#Aceleracion en el aire
export var friction = 0.3			#Friccion(frenado en el suelo)
export var frictionModifier = 13	#Modificador de Friccion(divisor de la friccion cuando esta en el aire)
var dobleSalto = 0					#Doble Salto
var controlesConectados = Input.get_connected_joypads().size()	#Cantidad de controles conectados
var deadZone = 0.2					#Zona de no activacion del joystick
export var control = 0				#Identificador del control, equivale al orden de conexion


#Constantes
const UP = Vector2(0, -1)			#Define hacia donde es arriba
const GRAVITY = 20					#Constante de gravedad
const JUMP_HEIGHT = -550			#Salto maximo

#Check de control
func _ready():
	Input.connect("joy_connection_changed", self,"joy_con_changed")
	add_to_group('players')

#Al conectar un control printea su numero
func joy_con_changed(deviceid, isConnected): #primero: identifica coneccion, segundo: identifica si es conexión o desconexión
	if isConnected:
		print("Joystick " + str(deviceid) + " connected")
		if  Input.is_joy_known(0): #Reconoce algunos tipos de control
			print('Control reconocido')
			print(Input.get_joy_name(0) + ' encontrado')
		else:
			print('Control desconectado')
#Cada frame
func _process(delta):
	#Quit game
	if Input.is_key_pressed(KEY_Q):
		get_tree().quit()

#Fisica
func _physics_process(delta):
	#Gravedad
		#Fast Fall. Si el joystick esta hacia abajo aumenta la velocidad de caida
	if Input.get_connected_joypads().size() > 0:
		var yAxis = Input.get_joy_axis(control,JOY_AXIS_1)
		if yAxis > 0 and abs(yAxis) > deadZone and motion.y > 0:
			motion.y += yAxis * 100
	
	if motion.y > 0:			#Gravedad en bajada
		motion.y += 2 *  GRAVITY
	else:						#Gravedad en subida
		motion.y += GRAVITY
	
	#Salto
	#print(dobleSalto) #Debbug: Estado de dobleSlato. 
	#print(Input.is_joy_button_pressed(0,JOY_BUTTON_0)) #Debbug: estar apretando A
	if is_on_floor():
		dobleSalto = 0
		if Input.is_action_just_pressed("ui_jump" + str(control)):#(Input.is_joy_button_pressed(control,JOY_BUTTON_0)):#Input.is_action_just_pressed("ui_up") or 
			motion.y = JUMP_HEIGHT
	if not is_on_floor() and dobleSalto == 0:
		if Input.is_action_just_pressed("ui_jump" + str(control)):#(Input.is_joy_button_pressed(control,JOY_BUTTON_0)):#Input.is_action_just_pressed("ui_up") or Input.is_joy_button_pressed(control,JOY_BUTTON_0):
			motion.y = JUMP_HEIGHT
			dobleSalto =1
		
		
			
	#Movimiento horizonttal con joystick
	if Input.get_connected_joypads().size() > 0:
		var xAxis = Input.get_joy_axis(control,JOY_AXIS_0)
		if abs(xAxis) > deadZone:
			if  is_on_floor():
				motion.x = lerp(motion.x,speedMultiplier*(xAxis),acceleration)
			else:
				motion.x = lerp(motion.x,speedMultiplier*(xAxis),airAcceleration)
		else:
			if is_on_floor():
				motion.x = lerp(motion.x,0,friction)
			else:
				motion.x = lerp(motion.x,0,friction/frictionModifier)
			
		#Check de que tecla se esta apretando
		#for i in range(16):
			#if Input.is_joy_button_pressed(0,i):
				#print('Boton ' + str(i) + ' presionado, debiera ser ' + Input.get_joy_button_string(i) )
				
	motion = move_and_slide(motion,UP)

