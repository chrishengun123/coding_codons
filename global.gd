extends Node

const characters = preload("res://character.tscn")
var playername:String = ""
var level
var balloon
var ids = []
var actors = []
var actor
var in_dialogue = false
var difficulty:String
var modes = {"timed":false,"endless":false,"blind":false,"insulin":false}
var tasks:int = 1
var time = 1
var correct:int = 0
var incorrect:int = 0

func change_scene(filepath:String):
	for i in actors:
		i.queue_free()
	actors.clear()
	ids.clear()
	get_tree().change_scene_to_file(filepath)

func dialogue(title:String):
	DialogueManager.show_dialogue_balloon(load("res://script.dialogue"),title)

func act(id:String, img:String, pos:Vector2, spd:float, delete = false):
	if ids.find(id) < 0:
		var character = characters.instantiate()
		actors.append(character)
		ids.append(id)
		character.texture = load("res://"+img+".png")
		character.position = pos
		character.target_pos = pos
		character.speed = spd
		level.add_child(character)
	else:
		actor = actors[ids.find(id)]
		actor.texture = load("res://"+img+".png")
		actor.target_pos = pos
		actor.speed = spd

func leave(id:String):
	if ids.find(id) != -1:
		actors[ids.find(id)]
		actors.remove_at(ids.find(id))
		ids.remove_at(ids.find(id))

func show_results():
	level.show_results()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
