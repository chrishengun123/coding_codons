extends TextureRect

var toggle = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = !Global.modes.blind


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.in_dialogue:
		position.x = lerp(position.x,float(1162),0.25)
	elif toggle:
		position.x = lerp(position.x,float(688),0.25)
	else:
		position.x = lerp(position.x,float(1152-914/8),0.25)

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		toggle = !toggle
