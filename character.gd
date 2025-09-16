extends Sprite2D

var id:String
var target_pos = Vector2(0,0)
var speed = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = lerp(position,target_pos,speed)
