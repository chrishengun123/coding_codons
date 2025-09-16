extends Node2D

const letters = preload("res://letter.tscn")
var amino_acid_list = ["Phe","Leu","Ser","Tyr","Cys","Trp","Pro","His","Gln","Arg","Ile","Thr","Asn","Lys","Val","Ala","Asp","Glu","Gly"]
var codon = []
var amino_acids = []
var goal = []
var tasks_left:int
var proteins = {"insulin": ["Gly", "Ile", "Val", "Glu", "Gln", "Cys", "Cys", "Thr", "Ser", "Ile", "Cys", "Ser", "Leu", "Tyr", "Gln", "Leu", "Glu", "Asn", "Tyr", "Cys", "Asn", "Phe", "Val", "Asn", "Gln", "His", "Leu", "Cys", "Gly", "Asp", "His", "Leu", "Val", "Glu", "Ala", "Leu", "Tyr", "Leu", "Val", "Cys", "Gly", "Glu", "Arg", "Gly", "Phe", "Tyr", "Thr", "Pro", "Lys", "Thr"]}

func type(x):
	var letter = letters.instantiate()
	letter.letter = x
	$codon.add_child(letter)

func new_task():
	codon.clear()
	for i in $codon.get_children():
		i.queue_free()
	if Global.modes.endless:
		$tasks_left.text = "endless mode"
	else:
		tasks_left -= 1
		$tasks_left.text = "Tasks left: "+str(tasks_left)
	$task.text = "Required: "
	goal = ["start"]
	if Global.modes.insulin:
		$codon.scale /= 2
		$codon.size *= 2
		$task.label_settings.font_size /= 2
		goal.append(proteins.insulin)
		goal.append("end")
		$task.text = str(proteins.insulin).replace("[","").replace("]","").replace("\"","")
		return
	goal.resize(1+randi_range(1,5))
	for i in range(goal.size()-1):
		amino_acid_list.shuffle()
		goal[i+1] = amino_acid_list[0]
		$task.text += goal[i+1]
		if i < goal.size()-2:
			$task.text += ", "
	goal.append("end")

func run_codon():
	amino_acids.clear()
	for i in range(floor(codon.size()/3)):
		match codon[3*i]+codon[3*i+1]+codon[3*i+2]:
			"UUU","UUC":
				amino_acids.append("Phe")
			"UUA","UUG","CUU","CUC","CUA","CUG":
				amino_acids.append("Leu")
			"UCU","UCC","UCA","UCG","AGU","AGC":
				amino_acids.append("Ser")
			"UAU","UAC":
				amino_acids.append("Tyr")
			"UAA","UAG","UGA":
				amino_acids.append("end")
				break
			"UGU","UGC":
				amino_acids.append("Cys")
			"UGG":
				amino_acids.append("Trp")
			"CCU","CCC","CCA","CCG":
				amino_acids.append("Pro")
			"CAU","CAC":
				amino_acids.append("His")
			"CAA","CAG":
				amino_acids.append("Gln")
			"CGU","CGC","CGA","CGG","AGA","AGG":
				amino_acids.append("Arg")
			"AUU","AUC","AUA":
				amino_acids.append("Ile")
			"AUG":
				amino_acids.append("start")
			"ACU","ACC","ACA","ACG":
				amino_acids.append("Thr")
			"AAU","AAC":
				amino_acids.append("Asn")
			"AAA","AAG":
				amino_acids.append("Lys")
			"GUU","GUC","GUA","GUG":
				amino_acids.append("Val")
			"GCU","GCC","GCA","GCG":
				amino_acids.append("Ala")
			"GAU","GAC":
				amino_acids.append("Asp")
			"GAA","GAG":
				amino_acids.append("Glu")
			"GGU","GGC","GGA","GGG":
				amino_acids.append("Gly")
	check()

func check():
	if amino_acids == goal:
		Global.correct += 1
		$error.self_modulate = Color.GREEN
		$error.text = "Correct"
	else:
		Global.incorrect += 1
		$error.self_modulate = Color.RED
		if amino_acids:
			if amino_acids[0] != "start":
				$error.text = "Instruction not started"
			elif amino_acids[-1] != "end":
				$error.text = "Instruction not ended"
			else:
				$error.text = "Incorrect result"
		else:
			$error.text = "Instruction not found"
	$show_error.start()
	if tasks_left > 1:
		new_task()
	else:
		tasks_left -= 1
		Global.dialogue("finish")

func show_results():
	%results.text = %results.text.replace("[correct]",str(Global.correct)).replace("[incorrect]",str(Global.incorrect)).replace("[unfinished]",str(Global.tasks-Global.correct-Global.incorrect)).replace("[accuracy]",str(Global.correct*100/(Global.correct+Global.incorrect)))
	$animation.play("results")

func end_game():
	GlobalNode.change_scene("res://main_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%confirmation.visible = false
	Global.level = self
	Global.correct = 0
	Global.incorrect = 0
	Global.dialogue("start")
	tasks_left = Global.tasks+1
	new_task()
	$time_limit.wait_time = Global.time
	if Global.modes.timed:
		$time_limit.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$time_limit.paused = Global.in_dialogue
	$time_left.visible = Global.modes.timed
	$time_left.text = "Time left: "+str(ceil($time_limit.time_left))

func _input(event: InputEvent) -> void:
	if !Global.in_dialogue and tasks_left > 0:
		if Input.is_action_just_pressed("G"):
			GlobalNode.tick()
			codon.append("G")
			type("G")
		if Input.is_action_just_pressed("U"):
			GlobalNode.tick()
			codon.append("U")
			type("U")
		if Input.is_action_just_pressed("A"):
			GlobalNode.tick()
			codon.append("A")
			type("A")
		if Input.is_action_just_pressed("C"):
			GlobalNode.tick()
			codon.append("C")
			type("C")
		if Input.is_action_pressed("ui_text_backspace") and $codon.get_children() and $backspace_cooldown.time_left <= 0:
			GlobalNode.tick()
			$backspace_cooldown.start()
			codon.pop_back()
			$codon.get_children()[-1].queue_free()
		if Input.is_action_just_pressed("ui_text_submit"):
			GlobalNode.submit()
			run_codon()

func _on_g_button_pressed() -> void:
	GlobalNode.tick()
	codon.append("G")
	type("G")


func _on_u_button_pressed() -> void:
	GlobalNode.tick()
	codon.append("U")
	type("U")


func _on_a_button_pressed() -> void:
	GlobalNode.tick()
	codon.append("A")
	type("A")


func _on_c_button_pressed() -> void:
	GlobalNode.tick()
	codon.append("C")
	type("C")


func _on_back_button_pressed() -> void:
	GlobalNode.tick()
	if $codon.get_children():
		$codon.get_children()[-1].queue_free()


func _on_enter_button_pressed() -> void:
	GlobalNode.submit()
	run_codon()


func _on_show_error_timeout() -> void:
	$error.text = ""


func _on_time_limit_timeout() -> void:
	$animation.play("times up")


func _on_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "times up":
		Global.dialogue("times_up")


func _on_end_pressed() -> void:
	GlobalNode.submit()
	end_game()


func _on_quit_button_pressed() -> void:
	if %confirmation.visible:
		GlobalNode.submit()
		end_game()
	else:
		GlobalNode.click()
		%confirmation.visible = true
		$quit_misclick.start()


func _on_quit_misclick_timeout() -> void:
	%confirmation.visible = false
