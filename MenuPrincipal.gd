extends Control

var escena = "res://World.tscn"

func _ready():
	pass 

func _on_Inicio_pressed():
	get_tree().change_scene(escena)
	pass 


func _on_Salir_pressed():
	get_tree().quit()
	pass 
