extends Camera2D

var acercamiento = Vector2(1.5,1.5)
func _ready():
	set_process(true)
	set_zoom(acercamiento)
	pass 

func _process(delta):
	acercamiento.x = 1.5
	acercamiento.y = 1.5
	
	if AutoLoad.coeficienteZoom.x >= AutoLoad.coeficienteZoom.y:
		acercamiento = acercamiento * AutoLoad.coeficienteZoom.x
		set_zoom(acercamiento)
	else:
		acercamiento = acercamiento * AutoLoad.coeficienteZoom.y
		set_zoom(acercamiento)
	
	#if acercamiento.x >= 1.5 and acercamiento.y >= 1.5:
	#	acercamiento.x = acercamiento.x * AutoLoad.coeficienteZoom
	#	acercamiento.y = acercamiento.y * AutoLoad.coeficienteZoom
	#elif acercamiento.x >= 1.5:
	#	acercamiento.x = acercamiento.x * AutoLoad.coeficienteZoomX
	#elif acercamiento.y >= 1.5:
	#	acercamiento.y = acercamiento.y * AutoLoad.coeficienteZoomY
		
	
	pass
