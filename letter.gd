extends MarginContainer

@export var letter = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match letter:
		"G":
			$G.visible = true
		"U":
			$U.visible = true
		"A":
			$A.visible = true
		"C":
			$C.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
