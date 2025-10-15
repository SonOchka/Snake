extends Area2D


const GRID_SIZE = 32  # Размер сетки
const MOVE_SPEED = 0.2  # Время между движениями (в секундах)

enum Direction { UP, DOWN, LEFT, RIGHT }

var current_direction = Direction.RIGHT
var next_direction = Direction.RIGHT

var move_timer = 0.0

var body_segments = []

signal moved(new_position)

func _ready():
	call_deferred("initialize_snake")

func initialize_snake():
	body_segments = get_tree().get_nodes_in_group("body_segments")
	
	body_segments.sort_custom(func(a, b): return a.name < b.name)
	
	for i in range(body_segments.size()):
		var segment = body_segments[i]
		segment.global_position = global_position - Vector2(GRID_SIZE * (i + 1), 0)

func _process(delta):
	handle_input()
	
	move_timer += delta
	if move_timer >= MOVE_SPEED:
		move_timer = 0.0
		move_snake()

func handle_input():
	if Input.is_action_just_pressed("ui_up") and current_direction != Direction.DOWN:
		next_direction = Direction.UP
	elif Input.is_action_just_pressed("ui_down") and current_direction != Direction.UP:
		next_direction = Direction.DOWN
	elif Input.is_action_just_pressed("ui_left") and current_direction != Direction.RIGHT:
		next_direction = Direction.LEFT
	elif Input.is_action_just_pressed("ui_right") and current_direction != Direction.LEFT:
		next_direction = Direction.RIGHT

func move_snake():
	current_direction = next_direction
	
	var old_position = global_position
	
	match current_direction:
		Direction.UP:
			global_position.y -= GRID_SIZE
		Direction.DOWN:
			global_position.y += GRID_SIZE
		Direction.LEFT:
			global_position.x -= GRID_SIZE
		Direction.RIGHT:
			global_position.x += GRID_SIZE
	
	move_body_segments(old_position)
	
	emit_signal("moved", global_position)

func move_body_segments(head_old_position):
	if body_segments.size() > 0:
		var previous_position = head_old_position
		
		for segment in body_segments:
			var segment_old_position = segment.global_position
			segment.global_position = previous_position
			previous_position = segment_old_position

func grow():
	pass

func _on_area_entered(area):
	if area.is_in_group("food"):
		grow()
		area.queue_free()  
	elif area.is_in_group("body_segments") or area.is_in_group("wall"):
		game_over()

func game_over():
	print("Game Over!")
	get_tree().paused = true
