extends Node

@onready var hostButton = $MainUI/VBoxContainer/HostButton
@onready var joinButton = $MainUI/VBoxContainer/JoinButton
@onready var mainUI = $MainUI

const base34Chars = "0123456789ABCDEFGHJKLMNPQRSTUVWXYZ"

var codeToJoin = ""
# Code is 7-char numbers/letters (excluding I and O) --> IPv4 address
var hostCode = ""
var username = ""

func _ready():
	
	var http = HTTPRequest.new()
	add_child(http)
	http.connect("request_completed", printIP)
	http.request("https://api.ipify.org")

func printIP(result, code, header, body):
	var ipArr = body.get_string_from_utf8().split(".")
	var ipInt = 0
	for i in range(len(ipArr)):
		ipInt += int(ipArr[i]) * (256 ** i)
	
	print("Internet IP is: ", ipInt)
	

func checkInputs():
	if username == "":
		hostButton.disabled = true
	else:
		hostButton.disabled = false
	if username == "" or codeToJoin == "":
		joinButton.disabled = true
	else:
		joinButton.disabled = false

func _on_name_entry_text_changed(newName):
	username = newName
	checkInputs()

func _on_code_entry_text_changed(newCode):
	codeToJoin = newCode
	checkInputs()

func _on_host_button_pressed():
	pass # Replace with function body.
	print("Hosting!")

func _on_join_button_pressed():
	pass # Replace with function body.
