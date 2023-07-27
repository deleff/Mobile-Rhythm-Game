extends Node2D

var arrowChoice
var arrowVisibility
var arrowDirection
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
	randomNumberGenerator.randomize()
	arrowChoice = randomNumberGenerator.randi_range(0,9)
	match arrowChoice:
		0:
			arrowDirection = 0
		1:
			arrowDirection = 45
		2:
			arrowDirection = 90
		3:
			arrowDirection = 135
		4:
			arrowDirection = 180
		5:
			arrowDirection = 225
		6:
			arrowDirection = 270
		7:
			arrowDirection = 315
		8:
			arrowDirection = 360
		9:
			print("TAP")

	randomNumberGenerator.randomize()
	arrowVisibility = randomNumberGenerator.randi_range(0,2)
	match arrowVisibility:
		0:
			$ArrowSpriteLeft2D.visible = true
			$ArrowSpriteRight2D.visible = false
		1:
			$ArrowSpriteLeft2D.visible = false
			$ArrowSpriteRight2D.visible = true
		2:
			$ArrowSpriteLeft2D.visible = true
			$ArrowSpriteRight2D.visible = true
	print(arrowVisibility, ", ", arrowDirection)
	
	$ArrowSpriteLeft2D.rotation_degrees = arrowDirection
	$ArrowSpriteRight2D.rotation_degrees = arrowDirection


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
