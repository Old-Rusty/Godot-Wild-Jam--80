extends Control
@onready var sfxClick =  $sfxButton
var playSignal: bool
var exitSignal: bool
@onready var aniPlayer = $AnimationPlayer

func _ready():
	$MarginContainer/VBoxContainer/Settings.grab_focus()
	playSignal = false
	exitSignal = false

func _on_play_pressed():
	aniPlayer.play("playTrans")
	sfxClick.play()
	playSignal = true
	

func _on_options_pressed():
	sfxClick.play()


func _on_exit_pressed():
	aniPlayer.play("exitTrans")
	sfxClick.play()
	exitSignal = true


#func _on_sfx_button_finished():
#	if playSignal:
#		get_tree().change_scene_to_file("res://main.tscn")
#	elif exitSignal:
#		get_tree().quit()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "playTrans":
		get_tree().change_scene_to_file("res://main.tscn")
	elif anim_name == "exitTrans":
		get_tree().quit()
	
