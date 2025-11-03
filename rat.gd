extends Area2D

const GRIDE_SIZE = 32
const RAT_SCENE = preload("res://rat.tscn")

var is_eaten = false
var can_create_new_rat = true

func _ready() -> void:
	add_to_group("rat")
	move_to_random_position()
	area_entered.connect(_on_area_entered)

func _on_area_entered(area):
	if area.is_in_group("head") and not is_eaten:
		is_eaten = true
		on_eaten()

func move_to_random_position():
	var viewport_size = get_viewport_rect().size
	var max_x = int((viewport_size.x - GRIDE_SIZE * 2) / GRIDE_SIZE)
	var max_y = int((viewport_size.y - GRIDE_SIZE * 2) / GRIDE_SIZE)

	var new_x = (randi() % max_x + 1) * GRIDE_SIZE
	var new_y = (randi() % max_y + 1) * GRIDE_SIZE

	global_position = Vector2(new_x, new_y)

	scale = Vector2(0.5, 0.5)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.3)

func  on_eaten():
	if not is_eaten or not can_create_new_rat:
		return

	can_create_new_rat = false
	
	call_deferred("create_new_rat")
	queue_free()

func create_new_rat():
	var new_rat = RAT_SCENE.instantiate()
	if is_instance_valid(get_parent()):
		get_parent().add_child(new_rat)
	else:
		get_tree().current_scene.add_child(new_rat)
	queue_free()
