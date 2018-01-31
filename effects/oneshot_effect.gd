extends Spatial

export(float) var duration = 1

func _ready():
	yield(get_tree().create_timer(duration), "timeout")
	queue_free()
