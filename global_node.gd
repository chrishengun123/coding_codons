extends CanvasLayer

var new_scene:String

func tick():
	$tick.play()

func click():
	$click.play()

func submit():
	$submit.play()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$animation.play("RESET")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_scene(filepath:String):
	new_scene = filepath
	$curtain_sfx.play()
	$animation.play("close_curtain")

func _on_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "close_curtain":
		Global.change_scene(new_scene)
		$curtain_sfx.play()
		$animation.play("open_curtain")
