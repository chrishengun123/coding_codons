extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	%time.visible = %timed.button_pressed
	$tutorial.visible = Global.in_dialogue
	if %insulin.button_pressed:
		%tasks.value = 1
		%tasks.visible = true
		%task_label.text = "Tasks:"
		%timed.button_pressed = true
		%endless.button_pressed = false


func _on_start_pressed() -> void:
	GlobalNode.submit()
	Global.playername = %name.text
	Global.tasks = %tasks.value
	Global.modes.timed = %timed.button_pressed
	Global.time = %time.value
	Global.modes.endless = %endless.button_pressed
	Global.modes.blind = %blind.button_pressed
	Global.modes.insulin = %insulin.button_pressed
	GlobalNode.change_scene("res://level.tscn")


func _on_tips_pressed() -> void:
	GlobalNode.click()
	Global.dialogue("tutorial")


func _on_endless_pressed() -> void:
	GlobalNode.tick()
	if %endless.button_pressed and !%insulin.button_pressed:
		%tasks.visible = false
		%task_label.text = "Tasks: infinite"
	else:
		%tasks.visible = true
		%task_label.text = "Tasks:"


func _on_timed_pressed() -> void:
	GlobalNode.tick()


func _on_blind_pressed() -> void:
	GlobalNode.tick()


func _on_insulin_pressed() -> void:
	GlobalNode.tick()
	if %insulin.button_pressed: %time.value = 600
