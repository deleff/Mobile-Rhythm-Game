extends Node2D

var leftTouchPositions = [0,0]
var rightTouchPositions = [0,0]
var screenWidthMiddle
# Called when the node enters the scene tree for the first time.
func _ready():
	print("Screen width: ", get_viewport_rect().size.x)
	screenWidthMiddle = (get_viewport_rect().size.x / 2)
	$LeftLabel.global_position.x = 0
	$RightLabel.global_position.x = screenWidthMiddle
func _unhandled_input(event):
	if event is InputEventScreenTouch:
		## Left control
		if event.position.x < screenWidthMiddle:
			leftTouchPositions.append(event.position)
			## Should only have 2 values
			#print(leftTouchPositions.size())
			while leftTouchPositions.size() > 2:
				leftTouchPositions.remove_at(0)				
			print("Left taps: ", leftTouchPositions)
			$LeftLabel.text = "Left taps: \n{first} \n{last}".format({"first":leftTouchPositions[0],"last":leftTouchPositions[1]})
		## Right control
		else:
			rightTouchPositions.append(event.position)
			## Should only have 2 values
			#print(rightTouchPositions.size())
			while rightTouchPositions.size() > 2:
				rightTouchPositions.remove_at(0)	
			print("Right taps: ", rightTouchPositions)
			$RightLabel.text = "Left taps: \n{first} \n{last}".format({"first":rightTouchPositions[0],"last":rightTouchPositions[1]})

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
