extends Area2D


const GRID_SIZE = 32  # Размер сетки
const MOVE_SPEED = 0.2  # Время между движениями (в секундах)
const BODY_SCENE = preload("res://body.tscn")

enum Direction { UP, DOWN, LEFT, RIGHT }

var current_direction = Direction.RIGHT
var next_direction = Direction.RIGHT
var move_timer = 0.0
var body_segments = []

signal moved(new_position)

func _ready():
	add_to_group("head")
	call_deferred("initialize_snake")
	area_entered.connect(_on_area_entered)
	

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
	
	rotateHead()

func rotateHead():
	if next_direction == Direction.UP:
		rotation_degrees = 270
	if next_direction == Direction.DOWN:
		rotation_degrees = 90
	if next_direction == Direction.RIGHT:
		rotation_degrees = 0
	if next_direction == Direction.LEFT:
		rotation_degrees = 180


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
	call_deferred("create_body_segment")

func create_body_segment():
	var new_body_segment = BODY_SCENE.instantiate()
	
	if is_instance_valid(get_parent()):
		get_parent().add_child(new_body_segment)
	else:
		get_tree().current_scene.add_child(new_body_segment)
	
	var tail_position
	if body_segments.size() > 0:
		tail_position = body_segments[-1].global_position
	else:
		tail_position = global_position - Vector2(GRID_SIZE, 0)


	new_body_segment.global_position = tail_position
	body_segments.append(new_body_segment)
	print(body_segments.size())

func _on_area_entered(area):
	if area.is_in_group("rat"):
		grow()

	elif area.is_in_group("body_segments") or area.is_in_group("wall"):
		game_over()

func game_over():
	print("Game Over!")
	get_tree().paused = true
