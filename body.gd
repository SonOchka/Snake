extends Area2D


func _ready():
	add_to_group("body_segments")

func update_position(new_position):
	global_position = new_position


func _on_area_entered(area):
	if area.is_in_group("head"):
		
		pass
