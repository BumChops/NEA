extends Node

@onready var hostLobbyUI = $HostLobbyUI
@onready var joinLobbyUI = $JoinLobbyUI
@onready var mainUI = $MainUI

@onready var hostButton = $MainUI/VBoxContainer/HostButton
@onready var joinButton = $MainUI/VBoxContainer/JoinButton
@onready var kickButton = $HostLobbyUI/VBoxContainer/KickButton
@onready var startButton = $HostLobbyUI/VBoxContainer/StartButton

@onready var lobbyCodeDisplay = $HostLobbyUI/VBoxContainer/LobbyCode
@onready var hostNameDisplay = $HostLobbyUI/VBoxContainer/NameDisplay
@onready var joinNameDisplay = $JoinLobbyUI/VBoxContainer/NameDisplay

const PORT = 9080

var socket = WebSocketPeer.new()
var tcpServer = null
var packets = []

var clientUp = false
var serverUp = false
var stage = ""

#const base34Chars = "0123456789ABCDEFGHJKLMNPQRSTUVWXYZ"

var joinCode = ""
# Code is 7-char numbers/letters (excluding I and O) --> IPv4 address
var hostCode = ""
var username = ""
var opName = ""

func _ready():
	var http = HTTPRequest.new()
	add_child(http)
	http.connect("request_completed", getMyCode)
	http.request("https://api.ipify.org")

func getMyCode(_r, _c, _h, body):
	hostCode = body.get_string_from_utf8()
	lobbyCodeDisplay.text = "Lobby code is: " + hostCode
	#var ipArr = body.get_string_from_utf8().split(".")
	#print(ipArr)
	#var ipInt = 0
	#for i in range(len(ipArr)):
	#	ipInt += ipArr[i].to_int() * (256 ** i)
	#lobbyCodeDisplay.text = str(ipInt)

func _process(_d):
	manageServer()

func _exit_tree():
	socket.close()
	if serverUp:
		tcpServer.stop()

func checkInputs():
	if username == "":
		hostButton.disabled = true
	else:
		hostButton.disabled = false
	if username == "" or joinCode == "":
		joinButton.disabled = true
	else:
		joinButton.disabled = false

func manageServer():
	if serverUp:
		while tcpServer.is_connection_available():
			var connection = tcpServer.take_connection()
			assert(connection != null)
			socket.accept_stream(connection)
		
		socket.poll()
		if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
			while socket.get_available_packet_count() != 0:
				packets.append(socket.get_packet().get_string_from_ascii())
				print(username + ": " + packets[-1])
				var packet = packets[-1].split(" ", true, 1)
				match packet[0]:
					"CONNECTED":
						opName = packet[1]
						hostNameDisplay.text = "You are in a lobby with: " + opName
						print(username + ": " + packet[1])
						socket.send_text("CONNECTED " + username)
						stage = "LOBBY WAITING"
			
			match stage:
				"LOBBY WAITING":
					kickButton.disabled = false
					startButton.disabled = false
		
	elif clientUp:
		socket.poll()
		if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
			while socket.get_available_packet_count() != 0:
				packets.append(socket.get_packet().get_string_from_ascii())
				print(username + ": " + packets[-1])
				var packet = packets[-1].split(" ", true, 1)
				match packet[0]:
					"CONNECTED":
						opName = packet[1]
						joinNameDisplay.text = "You are in a lobby with: " + opName
						stage = "LOBBY WAITING"
					"KICKED":
						print("You have been kicked :(")
						joinNameDisplay.text = "You have been kicked 😟"
			match stage:
				"CONFIRM CONNECTION":
					print(username + ": test")
					socket.send_text("CONNECTED " + username)
					stage = "NEED PACKET"



func _on_name_entry_text_changed(newName):
	username = newName
	checkInputs()

func _on_code_entry_text_changed(newCode):
	joinCode = newCode
	checkInputs()

func _on_host_button_pressed():
	tcpServer = TCPServer.new()
	if tcpServer.listen(PORT) != OK:
		print("Cannot start!")
	else:
		mainUI.hide()
		hostLobbyUI.show()
		print("Server started!")
		serverUp = true

func _on_join_button_pressed():
	if socket.connect_to_url("ws://localhost:9080") != OK: #Replace with join code!
		print("Cannot connect!")
	else:
		mainUI.hide()
		joinLobbyUI.show()
		print("Client connected!")
		stage = "CONFIRM CONNECTION"
		clientUp = true

func _on_copy_code_button_pressed():
	DisplayServer.clipboard_set(hostCode)

func _on_kick_button_pressed():
	socket.send_text("KICKED")
	await get_tree().create_timer(0.5).timeout
	socket.close()

func _on_leave_button_pressed():
	socket.close()
