extends Node


func _on_Quitter_pressed():
	get_tree().quit()
	
func _on_Jouer_pressed():
	get_tree().change_scene("res://Game.tscn")
	