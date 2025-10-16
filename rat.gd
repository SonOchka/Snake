extends Area2D

const GRIDE_SIZE = 32
const RAT_SCENE = preload("res://rat.tscn")

var is_eaten = false

func _ready() -> void:
	add_to_group("rat")
	move_to_random_position()
	area_entered.connect(_on_area_entered)

func _on_area_entered(area):
	if area.is_in_group("head"):
		is_eaten = true
		on_eaten()

func move_to_random_position():
	var viewport_size = get_viewport_rect().size
	var max_x = int(viewport_size.x / GRIDE_SIZE) - 1
	var max_y = int(viewport_size.y / GRIDE_SIZE) - 1

	var new_x = randi() % max_x * GRIDE_SIZE
	var new_y = randi() % max_y * GRIDE_SIZE

	global_position = Vector2(new_x, new_y)

	scale = Vector2(0.5, 0.5)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.3)

func  on_eaten():
	if not is_eaten:
		return
	var new_rat = RAT_SCENE.instantiate()
	get_parent().add_child(new_rat)
	queue_free()
