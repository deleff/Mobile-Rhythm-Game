extends Node2D

var leftTouchPositions = [null,null]
var rightTouchPositions = [null,null]
var screenWidthMiddle
var frameTimer = Timer.new()
var leftFingerPosition
var rightFingerPosition
const UP = "up"
const DOWN = "down"
const LEFT = "left"
const RIGHT = "right"
var leftX
var leftY
var rightX
var rightY
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

func _evaluate_move():
	## Evaluate left move
	if leftFingerPosition != leftTouchPositions[1]:
		leftTouchPositions.append(leftFingerPosition)
	while leftTouchPositions.size() > 2:
		leftTouchPositions.remove_at(0)
	if null not in leftTouchPositions:
		if leftTouchPositions[1].x > leftTouchPositions[0].x:
			leftX = RIGHT
		elif leftTouchPositions[1].x < leftTouchPositions[0].x:
			leftX = LEFT
		else:
			leftX = null
		if leftTouchPositions[1].y > leftTouchPositions[0].y:
			leftY = DOWN
		elif leftTouchPositions[1].y < leftTouchPositions[0].y: 
			leftY = UP
		else:
			leftY = null
	## Evaluate right move
	if rightFingerPosition != rightTouchPositions[1]:
		rightTouchPositions.append(rightFingerPosition)
	while rightTouchPositions.size() > 2:
		rightTouchPositions.remove_at(0)
	if null not in rightTouchPositions:
		if rightTouchPositions[1].x > rightTouchPositions[0].x:
			rightX = RIGHT
		elif rightTouchPositions[1].x < rightTouchPositions[0].x: 
			rightX = LEFT
		else:
			rightX = null
		if rightTouchPositions[1].y > rightTouchPositions[0].y:
			rightY = DOWN
		elif rightTouchPositions[1].y < rightTouchPositions[0].y: 
			rightY = UP
		else:
			rightY = null
	print("left side: ", leftX, ", ", leftY)
	print("right side: ", rightX, ", ", rightY)
	$LeftLabel.text = "{x} \n {y}".format({"x":leftX,"y":leftY})
	$RightLabel.text = "{x} \n {y}".format({"x":rightX,"y":rightY})
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
			leftX = null
			leftY = null
		else:
			rightTouchPositions = [null,null]
			rightX = null
			rightY = null


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
