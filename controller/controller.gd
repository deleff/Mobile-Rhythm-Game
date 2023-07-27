extends Node2D

var leftTouchPositions = [null,null]
var rightTouchPositions = [null,null]
var screenWidthMiddle
var frameTimer = Timer.new()
var leftFingerPosition
var rightFingerPosition
var straightLineInPixels = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Screen width: ", get_viewport_rect().size.x)
	screenWidthMiddle = (get_viewport_rect().size.x / 2)
	$LeftLabel.global_position.x = 0
	$RightLabel.global_position.x = screenWidthMiddle
	add_child(frameTimer)
	frameTimer.one_shot = false
	frameTimer.start(0.016666)
	frameTimer.timeout.connect(_evaluate_move)

func reset_controller_positions():
	leftTouchPositions = [null,null]
	rightTouchPositions = [null,null]
	PersistentData.leftX = ""
	PersistentData.leftY = ""
	PersistentData.rightX = ""
	PersistentData.rightY = ""

func _evaluate_move():
	## Print current values:
	$LeftLabel.text = "{x} \n {y}".format({"x":PersistentData.leftX,"y":PersistentData.leftY})
	$RightLabel.text = "{x} \n {y}".format({"x":PersistentData.rightX,"y":PersistentData.rightY})
	
	## Evaluate left move
	if leftFingerPosition != leftTouchPositions[1]:
		leftTouchPositions.append(leftFingerPosition)
	while leftTouchPositions.size() > 2:
		leftTouchPositions.remove_at(0)
	if null not in leftTouchPositions:
		if leftTouchPositions[1].x - leftTouchPositions[0].x > straightLineInPixels:
			PersistentData.leftX = PersistentData.RIGHT
		elif leftTouchPositions[0].x - leftTouchPositions[1].x > straightLineInPixels:
			PersistentData.leftX = PersistentData.LEFT
		else:
			PersistentData.leftX = PersistentData.TAP
		if leftTouchPositions[1].y - leftTouchPositions[0].y > straightLineInPixels:
			PersistentData.leftY = PersistentData.DOWN
		elif leftTouchPositions[0].y - leftTouchPositions[1].y > straightLineInPixels: 
			PersistentData.leftY = PersistentData.UP
		else:
			PersistentData.leftY = PersistentData.TAP
	## Evaluate right move
	if rightFingerPosition != rightTouchPositions[1]:
		rightTouchPositions.append(rightFingerPosition)
	while rightTouchPositions.size() > 2:
		rightTouchPositions.remove_at(0)
	if null not in rightTouchPositions:
		if rightTouchPositions[1].x - rightTouchPositions[0].x > straightLineInPixels:
			PersistentData.rightX = PersistentData.RIGHT
		elif rightTouchPositions[0].x - rightTouchPositions[1].x > straightLineInPixels: 
			PersistentData.rightX = PersistentData.LEFT
		else:
			PersistentData.rightX = PersistentData.TAP
		if rightTouchPositions[1].y - rightTouchPositions[0].y > straightLineInPixels:
			PersistentData.rightY = PersistentData.DOWN
		elif rightTouchPositions[0].y - rightTouchPositions[1].y > straightLineInPixels: 
			PersistentData.rightY = PersistentData.UP
		else:
			PersistentData.rightY = PersistentData.TAP
	#print("left side: ", PersistentData.leftX, ", ", PersistentData.leftY)
	#print("right side: ", PersistentData.rightX, ", ", PersistentData.rightY)
	$LeftLabel.text = "{x} \n {y}".format({"x":PersistentData.leftX,"y":PersistentData.leftY})
	$RightLabel.text = "{x} \n {y}".format({"x":PersistentData.rightX,"y":PersistentData.rightY})
	#if leftTouchPositions[1].x > leftTouchPositions[0].x:
	#	$LeftLabel.text = "Left screen: swipe left"
func _unhandled_input(event):
	if event is InputEventScreenDrag:
		## Left control
		if event.position.x < screenWidthMiddle:
			leftFingerPosition = event.position
		## Right control
		else:
			rightFingerPosition = event.position
	elif event is InputEventScreenTouch and event.is_pressed():
		if event.position.x < screenWidthMiddle:
			leftTouchPositions = [null,null]
			PersistentData.leftX = PersistentData.TAP
			PersistentData.leftY = PersistentData.TAP
		else:
			rightTouchPositions = [null,null]
			PersistentData.rightX = PersistentData.TAP
			PersistentData.rightY = PersistentData.TAP


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
