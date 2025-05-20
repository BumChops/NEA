extends Node

var map = {
	"me": {
		"hp": 100,
		"reserve": 0,
		"c-reserve": 0,
		"hand": [],
		"echelons": [null, null, null, null, null, null],
		"rearguard": [null, null, null, null],
		"vanguard": [null, null, null, null],
		"boneyard": []
	},
	"op": {
		"hp": 100,
		"reserve": 0,
		"c-reserve": 0,
		"hand": [],
		"echelons": [null, null, null, null, null, null],
		"rearguard": [null, null, null, null],
		"vanguard": [null, null, null, null],
		"boneyard": []
	}
}



var packets = []
var packetsToSend = []

var cardBackImg = load("res://assets/images/card_back.png")
var cardEmptyImg = load("res://assets/images/empty_slot.png")

@onready var meCards = $PlayerCardTiles
@onready var opCards = $OpCardTiles

@onready var opName = get_parent().opName
@onready var username = get_parent().username

var myTurn = false

"""Turn:
1.	Draw
2.	Free deploy
3.	Effects
4.	Battle
5.	Some more effects
"""

@onready var myDeck = get_parent().myDeck

func output(data) -> void:
	print(username + ": " + str(data))

func _ready():
	map["me"]["reserve"] = len(myDeck)
	print(username + ": Game in tree")

func updateMapDisplay():
	if map["me"]["reserve"] > 0:
		meCards.get_node("Reserve").texture = cardBackImg
	else:
		meCards.get_node("Reserve").texture = cardEmptyImg
	if map["me"]["c-reserve"] > 0:
		meCards.get_node("C-Reserve").texture = cardBackImg
	else:
		meCards.get_node("C-Reserve").texture = cardEmptyImg
	if map["op"]["reserve"] > 0:
		opCards.get_node("Reserve").texture = cardBackImg
	else:
		opCards.get_node("Reserve").texture = cardEmptyImg
	if map["op"]["c-reserve"] > 0:
		opCards.get_node("C-Reserve").texture = cardBackImg
	else:
		opCards.get_node("C-Reserve").texture = cardEmptyImg

func _process(_d):
	if len(packets) > 0:
		var packet = packets.pop_back().split(" ")
		match packet[0]:
			"TEST_PACKET":
				output("Test packet received")
			"PRE_MATCH":
				if packet[1] == "yes":
					myTurn = true
				map["op"]["reserve"] = int(packet[2])
				map["op"]["c-reserve"] = int(packet[3])
				updateMapDisplay()
			"TURN":
				if packet[1] == "YOURS":
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
