extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var node
var board
var cursor_position
var color
var stateGame

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	set_process_input(true)
	cursor_position = 0
	color = "red"
	stateGame = ""
	board = []
	for i in range(6):
		board.append(["","","","","","",""])
	
	createToken(color)
	
func createToken(color):
	var token = load("res://Token.tscn")
	node = token.instance()
	node.setupToken(board,color)
	
	cursor_position = 0
	var start_position = get_node("start_pos")
	node.position.x = start_position.position.x
	node.position.y = start_position.position.y
	add_child(node)
	return node

func checkDiagonal(colo):
	
	var c2
	var count = 0
	var lines = range(6)
	var columns = range(7)
	columns.invert()
	lines.invert()
	
	for c in range(7):
		c2 = 0
		for l in lines:
			
			if (c+c2) > 6:
				continue
			
			if board[l][c+c2] == colo:
				count += 1
			else:
				count = 0
				
			if count == 4:
				return true
			c2 += 1
	
	count = 0
	for c in columns:
		c2 = 0
		for l in lines:
			
			if (c+c2) < 0:
				continue
			
			if board[l][c-c2] == colo:
				count += 1
			else:
				count = 0
				
			if count == 4:
				return true
			c2 += 1
	
				
				
	return false
	
func displayWinBox(winner):
	stateGame = "finished"
	var dialog = get_node("gui/WinBox")
	dialog.dialog_text = "Le joueur "+winner+" a gagné"
	dialog.popup()

func checkForWinner():
	#verification des lignes horizontales
	var count = 0
	
	for col in ["yellow","red"]:
		
		#Verification des lignes horizontales
		for l in range(board.size()):
			for c in range(board[l].size()):
				if col == board[l][c]:
					count += 1
				else:
					count = 0
				
				if count == 4:
					displayWinBox(col)
					
		count = 0
		
		#Verification des lignes verticales
		for c in range(7):
			for l in range(6):
				if col == board[l][c]:
					count += 1
				else:
					count = 0
				
				if count == 4:
					displayWinBox(col)
					
		
		#Verification des diagonales
		for l in range(board.size()):
			for c in range(board[l].size()):
				if checkDiagonal(col): 
					displayWinBox(col)

func move(n,vector):
	var i = 0
	
	while i < 10:
		yield()
		n.translate(vector)
		i+=1

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if Input.is_action_just_pressed("ui_right") and cursor_position < 6:
		node.translate(Vector2(135.0,0.0))
		cursor_position +=1
	elif Input.is_action_just_pressed("ui_left") and cursor_position > 0:
		node.translate(Vector2(-135.0,0.0))
		cursor_position -= 1
	elif Input.is_action_just_pressed("ui_accept") and stateGame == "":
		var insetionIsValid = true
		for i in range(6):
			
			if board[0][cursor_position] != "":
				insetionIsValid = false
				break
			
			if board[5-i][cursor_position] == "":
				board[5-i][cursor_position] = color
				node.moveDown(6-i)
				break
			

		if insetionIsValid:
			if color == "red":
				color = "yellow"
			elif color == "yellow":
				color = "red"
			node = createToken(color)
			checkForWinner()
				
		print(board)
		
		
	
func _on_WinBox_confirmed():
	get_tree().change_scene("res://menu.tscn")
