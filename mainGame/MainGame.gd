extends Node2D

var arrowChoice
var arrowChoicePrevious
var arrowVisibility
var arrowDirection

var arrowX:  String
var arrowY:  String
var arrowLeftX:  String
var arrowLeftY:  String
var arrowRightX: String
var arrowRightY: String

var beatTimer = Timer.new()
var randomNumberGenerator = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(beatTimer)
	beatTimer.one_shot = false
	beatTimer.start(0.5)
	beatTimer.timeout.connect(_on_beat_timer_timeout)
	$ArrowSpriteLeft2D.global_position.x = (get_viewport_rect().size.x / 3)
	$ArrowSpriteLeft2D.global_position.y = (get_viewport_rect().size.y / 2)
	$ArrowSpriteRight2D.global_position.x = 2 * (get_viewport_rect().size.x / 3)
	$ArrowSpriteRight2D.global_position.y = (get_viewport_rect().size.y / 2)

func _on_beat_timer_timeout():
	## Get player input from last turn
	if arrowLeftX == PersistentData.leftX and arrowLeftY == PersistentData.leftY and arrowRightX == PersistentData.rightX and arrowRightY == PersistentData.rightY:
		PersistentData.playerScore += 1

	## Reset player input
	$Controller.reset_controller_positions()
	
	## Reset arrow direction
	arrowLeftX = PersistentData.RIGHT
	$ArrowSpriteLeft2D.visible = false
	$ArrowSpriteRight2D.visible = false
	while arrowChoicePrevious == arrowChoice:
		randomNumberGenerator.randomize()
		arrowChoice = randomNumberGenerator.randi_range(0,8)
		print("new: ", arrowChoice, ", old: ", arrowChoicePrevious)
	match arrowChoice:
		0:
			arrowDirection = 0
			arrowX = PersistentData.UP
			arrowY = PersistentData.UP
		1:
			arrowDirection = 45
			arrowX = PersistentData.RIGHT
			arrowY = PersistentData.UP
		2:
			arrowDirection = 90
			arrowX = PersistentData.RIGHT
			arrowY = PersistentData.RIGHT
		3:
			arrowDirection = 135
			arrowX = PersistentData.RIGHT
			arrowY = PersistentData.DOWN
		4:
			arrowDirection = 180
			arrowX = PersistentData.DOWN
			arrowY = PersistentData.DOWN
		5:
			arrowDirection = 225
			arrowX = PersistentData.LEFT
			arrowY = PersistentData.DOWN
		6:
			arrowDirection = 270
			arrowX = PersistentData.LEFT
			arrowY = PersistentData.LEFT
		7:
			arrowDirection = 315
			arrowX = PersistentData.LEFT
			arrowY = PersistentData.UP
		8:
			$ArrowSpriteLeft2D.visible = false
			$ArrowSpriteRight2D.visible = false
			arrowLeftX = PersistentData.TAP
			arrowLeftY = PersistentData.TAP
			arrowRightX = PersistentData.TAP
			arrowRightY = PersistentData.TAP
			
	if arrowLeftX != PersistentData.TAP:
		randomNumberGenerator.randomize()
		arrowVisibility = randomNumberGenerator.randi_range(0,2)
		match arrowVisibility:
			0:
				$ArrowSpriteLeft2D.visible = true
				arrowLeftX = arrowX
				arrowLeftY = arrowY
				$ArrowSpriteRight2D.visible = false
				arrowRightX = ""
				arrowRightY = ""
			1:
				$ArrowSpriteLeft2D.visible = false
				arrowLeftX = ""
				arrowLeftY = ""
				$ArrowSpriteRight2D.visible = true
				arrowRightX = arrowX
				arrowRightY = arrowY
			2:
				$ArrowSpriteLeft2D.visible = true
				arrowLeftX = arrowX
				arrowLeftY = arrowY
				$ArrowSpriteRight2D.visible = true
				arrowRightX = arrowX
				arrowRightY = arrowY
	#if $ArrowSpriteLeft2D.		
	$ArrowSpriteLeft2D.rotation_degrees = arrowDirection
	$ArrowSpriteRight2D.rotation_degrees = arrowDirection
	
	arrowChoicePrevious = arrowChoice

	print("Left arrow: ", arrowLeftX, ", ", arrowLeftY)
	print("Right arrow: ", arrowRightX, ", ", arrowRightY)
	print("Controller left: ", PersistentData.leftX, ", ", PersistentData.leftY)
	print("Controller right: ", PersistentData.rightX, ", ", PersistentData.rightY)
	
	## Display the score
	$ScoreLabel.text = "Score: {playerScore}".format({"playerScore":PersistentData.playerScore})

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
