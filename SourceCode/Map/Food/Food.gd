extends Node2D

#not totally sure if this is still nececarry
var type = "food"
var isAlive = false

var eaten = false
func _on_Area2D_area_entered(area):
	#calls the eat function when a preys mouth collision box comes into contact with this collison box
	if area.name == "mouth" && area.get_parent().type == "prey" && !eaten:
		eaten = true
		area.get_parent().eat()
		queue_free()
