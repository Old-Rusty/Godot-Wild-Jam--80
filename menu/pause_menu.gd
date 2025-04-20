extends Control

var is_paused: bool = false #setget set_is_paused
#var _is_paused: bool : 
#	set(value):
		#is_paused = value
		#print(value)
	#get:
		#return is_paused
		#set_is_paused(_is_paused)



func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		#self.is_paused = !is_paused
		set_is_paused(!is_paused)

func set_is_paused(value: bool):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused


func _on_resume_pressed():
	#self.is_paused = false
	set_is_paused(!is_paused)

func _on_return_pressed():
	set_is_paused(!is_paused)
	get_tree().change_scene_to_file("res://menu/menu.tscn")
	


func _on_quit_pressed():
	get_tree().quit()
