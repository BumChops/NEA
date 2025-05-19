extends Node

var packets = []

@onready var opName = get_parent().opName
@onready var username = get_parent().username

var myTurn = false

func output(data) -> void:
	print(username + ": " + str(data))

func _ready():
	print(username + ": Game in tree")

func _process(_d):
	if len(packets) > 0:
		var packet = packets.pop_back().split(" ")
		match packet[0]:
			"TURN":
				if packet[1] == "M":
					myTurn = true
				else:
					myTurn = false
			"MOVE":
				pass
				#move card x from location y to location z
			"ATTACK":
				pass
				# identify target + stats --> resolution/damage
			"DEFEATED":
				pass
				# identify victory cause etc.
