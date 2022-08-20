extends Node

var player1 = "Moulue"
var player2 = "Couillu"

func reset():
	player1 = "Moulue"
	player2 = "Couillu"

func swap():
	var tmp = player1
	player1 = player2
	player2 = tmp
