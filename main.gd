extends Node

@onready var hostButton = $MainUI/VBoxContainer/HostButton
@onready var joinButton = $MainUI/VBoxContainer/JoinButton
@onready var mainUI = $MainUI

var codeToJoin = ""
# Code is 7-char numbers/letters (excluding I and O) --> IPv4 address
var username = ""

func checkInputs():
	if username == "":
		hostButton.disabled = true
	else:
		hostButton.disabled = false
	if username == "" or codeToJoin == "":
		joinButton.disabled = true
	else:
		joinButton.disabled = false

func _on_name_entry_text_changed(newName) -> void:
	username = newName
	checkInputs()

func _on_code_entry_text_changed(newCode) -> void:
	codeToJoin = newCode
	checkInputs()

func _on_host_button_pressed() -> void:
	pass # Replace with function body.
	print("Hosting!")

func _on_join_button_pressed() -> void:
	pass # Replace with function body.
