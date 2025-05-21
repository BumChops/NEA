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

var handCard = preload("res://resources/hand_card.tscn")

var packets = []
var packetsToSend = []

var cardBackImg = load("res://assets/cards/0.png")
var cardEmptyImg = load("res://assets/images/empty_slot.png")

@onready var meCards = $PlayerCardTiles
@onready var opCards = $OpCardTiles
@onready var meHpNode = $GameUI/PlayerHP
@onready var opHpNode = $GameUI/OpHP

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
	myDeck.shuffle()
	print(username + ": Game in tree")

func updateMapDisplay():
	meHpNode.text = "🟅" + str(map["me"]["hp"]) + "🟅"
	opHpNode.text = "🟅" + str(map["op"]["hp"]) + "🟅"
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
	for i in map["me"]["hand"]:
		#output(i)
		var card = handCard.instantiate()
		card.texture = load("res://assets/cards/"+str(i)+".png")
		$PlayerCardTiles/HandContainer.add_child(card)
	for i in map["op"]["hand"]:
		output("op's hand: "+str(i))
		var card = handCard.instantiate()
		card.texture = cardBackImg
		$OpCardTiles/HandContainer.add_child(card)

func setPlay(_canPlay:bool):
	pass

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
				packetsToSend.append("DONE_PRE_MATCH " + str(map["me"]["reserve"]) + " " + str(map["me"]["c-reserve"]))
				for i in range(5):
					map["me"]["hand"].append(myDeck.pop_front())
				updateMapDisplay()
			"DONE_PRE_MATCH":
				map["op"]["reserve"] = int(packet[1])
				map["op"]["c-reserve"] = int(packet[2])
				for i in range(5):
					map["me"]["hand"].append(myDeck.pop_front())
				var handString = ""
				for i in map["me"]["hand"]:
					handString += str(i) + ","
				if len(handString) > 0:
					handString = handString.substr(0, len(handString)-1)
				packetsToSend.append("OP_HAND " + handString)
				setPlay(myTurn)
				updateMapDisplay()
			"OP_HAND":
				for i in packet[1].split(","):
					map["op"]["hand"].append(int(i))
				output(map["op"]["hand"])
				output(map["me"]["hand"])
				var handString = ""
				for i in map["me"]["hand"]:
					handString += str(i) + ","
				if len(handString) > 0:
					handString = handString.substr(0, len(handString)-1)
				packetsToSend.append("OTHER_OP_HAND " + handString)
				updateMapDisplay()
			"OTHER_OP_HAND":
				for i in packet[1].split(","):
					map["op"]["hand"].append(int(i))
				output(map["op"]["hand"])
				output(map["me"]["hand"])
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
