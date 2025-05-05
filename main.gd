extends Node

@onready var hostButton = $MainUI/VBoxContainer/HostButton
@onready var joinButton = $MainUI/VBoxContainer/JoinButton

var codeToJoin = ""
var username = ""

func _on_name_entry_text_changed(newName) -> void:
	if newName == "":
		hostButton.disabled = true
		joinButton.disabled = true
	else:
		username = newName
		hostButton.disabled = false
		if codeToJoin != "":
			joinButton.disabled = false

func _on_code_entry_text_changed(newCode) -> void:
	if newCode == "":
		joinButton.disabled = true
	elif username != "":
			joinButton.disabled = false

func _on_host_button_pressed() -> void:
	pass # Replace with function body.

func _on_join_button_pressed() -> void:
	pass # Replace with function body.
