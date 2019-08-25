extends Node

var PosicionPivote = Vector2()
var ControlesInicializados = []
var Controles = Input.get_connected_joypads()
var ActualizandoControles = false
var coeficienteZoom = Vector2(1.25, 1.25)
