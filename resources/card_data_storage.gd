extends Node

class_name CardStorage

#Key is their id
static var cards := {
	0: {
		"name": "Face-down card",
		"type": null
	},
	1: {
		"name": "X400 Patrol Ship",
		"type": "ship", "tags": [], "rate": 8, "ATK": 10, "DEF": 10,
		"description": "For when you want to protect your territory whilst also protecting your defence budget.",
		"effect_txt": ""
	},
	2: {
		"name": "Light Escort",
		"type": "ship", "tags": [], "rate": 8, "ATK": 12, "DEF": 12,
		"description": "For when you want to look like you care about that convoy.",
		"effect_txt": ""
	},
	3: {
		"name": "Medium Escort",
		"type": "ship", "tags": [], "rate": 7, "ATK": 18, "DEF": 18,
		"description": "For when you’d rather not have someone ambush that convoy.",
		"effect_txt": ""
	},
	4: {
		"name": "Heavy Escort",
		"type": "ship", "tags": [], "rate": 6, "ATK": 24, "DEF": 24,
		"description": "For when you cannot afford to have anyone ambush that convoy.",
		"effect_txt": ""
	},
}

#Methods
static func get_card(id:int) -> Dictionary:
	return cards[id]
