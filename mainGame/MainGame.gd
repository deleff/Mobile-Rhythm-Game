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

var arrowLeftXPrevious:  String
var arrowLeftYPrevious:  String
var arrowRightXPrevious: String
var arrowRightYPrevious: String

var beatTimer = Timer.new()
var effectsTimer = Timer.new()
var effectsIterator: int = 0
var randomNumberGenerator = RandomNumberGenerator.new()

var encouragementSoundEffect

var score_file = "user://highscore.save"
var highScore
var playerScore: int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$ArrowSpriteLeft2D.visible = false
	$ArrowSpriteRight2D.visible = false
	add_child(effectsTimer)
	effectsTimer.one_shot = false
	add_child(beatTimer)
	beatTimer.one_shot = false
	$SongsAudioStreamPlayer2D.stream = load("res://music/Heaven.mp3")
	effectsTimer.start(1)
	$SongsAudioStreamPlayer2D.play()
	effectsTimer.timeout.connect(_on_effects_timer_timeout)
	beatTimer.timeout.connect(_on_beat_timer_timeout)
	$ArrowSpriteLeft2D.global_position.x = (get_viewport_rect().size.x / 3)
	$ArrowSpriteLeft2D.global_position.y = (get_viewport_rect().size.y / 2)
	$ArrowSpriteRight2D.global_position.x = 2 * (get_viewport_rect().size.x / 3)
	$ArrowSpriteRight2D.global_position.y = (get_viewport_rect().size.y / 2)
	_load_score()


func _load_score():
	if FileAccess.file_exists(score_file):
		print("Score file exists")
		var file = FileAccess.open(score_file, FileAccess.READ)
		highScore = file.get_var()
	else:
		print("Score file does not exist")
		highScore = 0
	print("High score: ", highScore)

func _save_score(content):
	var file = FileAccess.open(score_file, FileAccess.WRITE)
	#print("Saving new high score: ", highScore)
	file.store_var(content)

func _on_effects_timer_timeout():
	effectsIterator += 1
	if effectsIterator == 14:
		$SfxAudioStreamPlayer2D.stream = load("res://sfx/ready.mp3")
		$SfxAudioStreamPlayer2D.play()
	elif effectsIterator == 16:
		$SfxAudioStreamPlayer2D.stream = load("res://sfx/go.mp3")
		beatTimer.start(0.435)
		$SfxAudioStreamPlayer2D.play()
	elif effectsIterator == 214:
		if playerScore == highScore:
			$SfxAudioStreamPlayer2D.stream = load("res://sfx/new_record.mp3")
		else:
			$SfxAudioStreamPlayer2D.stream = load("res://sfx/complete.mp3")
	elif effectsIterator == 215:
		$SfxAudioStreamPlayer2D.play()
		beatTimer.stop()
		$ArrowSpriteLeft2D.visible = false
		$ArrowSpriteRight2D.visible = false
	#print("effectsIterator: ", effectsIterator)
func _on_beat_timer_timeout():
	## Get player input from last turn
	if arrowLeftX == PersistentData.leftX and arrowLeftY == PersistentData.leftY and arrowRightX == PersistentData.rightX and arrowRightY == PersistentData.rightY or arrowLeftXPrevious == PersistentData.leftX and arrowLeftYPrevious == PersistentData.leftY and arrowRightXPrevious == PersistentData.rightX and arrowRightYPrevious == PersistentData.rightY:
		playerScore += 1
		Input.vibrate_handheld(50)
		if playerScore % 6 == 0:
			randomNumberGenerator.randomize()
			encouragementSoundEffect = randomNumberGenerator.randi_range(0,3)
			match encouragementSoundEffect:
				0:
					$SfxAudioStreamPlayer2D.stream = load("res://sfx/congratulations.mp3")
				1:
					$SfxAudioStreamPlayer2D.stream = load("res://sfx/no_contest.mp3")
				2:
					$SfxAudioStreamPlayer2D.stream = load("res://sfx/success.mp3")
				3:
					$SfxAudioStreamPlayer2D.stream = load("res://sfx/wow.mp3")
			$SfxAudioStreamPlayer2D.play()


	## Debugging
	#print("Left arrow: ", arrowLeftX, ", ", arrowLeftY)
	#print("Right arrow: ", arrowRightX, ", ", arrowRightY)
	#print("Previous left arrow: ", arrowLeftXPrevious, ", ", arrowLeftYPrevious)
	#print("Previous right arrow: ", arrowRightXPrevious, ", ", arrowRightYPrevious)
	#print("Controller left: ", PersistentData.leftX, ", ", PersistentData.leftY)
	#print("Controller right: ", PersistentData.rightX, ", ", PersistentData.rightY)


	## Reset player input
	$Controller.reset_controller_positions()
	
	## Reset arrows
	arrowLeftXPrevious = arrowLeftX
	arrowLeftYPrevious = arrowLeftY
	arrowRightXPrevious = arrowRightX
	arrowRightYPrevious = arrowRightY
	
	arrowLeftX = PersistentData.RIGHT
	#$ArrowSpriteLeft2D.visible = false
	#$ArrowSpriteRight2D.visible = false
	$ArrowSpriteLeft2D.texture = load("res://sprites/arrow.png")
	$ArrowSpriteRight2D.texture = load("res://sprites/arrow.png")

	while arrowChoicePrevious == arrowChoice:
		randomNumberGenerator.randomize()
		arrowChoice = randomNumberGenerator.randi_range(0,8)

	match arrowChoice:
		0:
			arrowDirection = 0
			arrowX = PersistentData.TAP
			arrowY = PersistentData.UP
		1:
			arrowDirection = 45
			arrowX = PersistentData.RIGHT
			arrowY = PersistentData.UP
		2:
			arrowDirection = 90
			arrowX = PersistentData.RIGHT
			arrowY = PersistentData.TAP
		3:
			arrowDirection = 135
			arrowX = PersistentData.RIGHT
			arrowY = PersistentData.DOWN
		4:
			arrowDirection = 180
			arrowX = PersistentData.TAP
			arrowY = PersistentData.DOWN
		5:
			arrowDirection = 225
			arrowX = PersistentData.LEFT
			arrowY = PersistentData.DOWN
		6:
			arrowDirection = 270
			arrowX = PersistentData.LEFT
			arrowY = PersistentData.TAP
		7:
			arrowDirection = 315
			arrowX = PersistentData.LEFT
			arrowY = PersistentData.UP
		8:
			arrowDirection = 0
			$ArrowSpriteLeft2D.texture = load("res://sprites/tap.png")
			$ArrowSpriteRight2D.texture = load("res://sprites/tap.png")
			arrowX = PersistentData.TAP
			arrowY = PersistentData.TAP
			
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
	## Update and display the score
	if playerScore > highScore:
		highScore = playerScore
		_save_score(highScore)
	$ScoreLabel.text = "Your Score: {playerScore},     High Score: {highScore}".format({"playerScore":playerScore, "highScore": highScore})

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
