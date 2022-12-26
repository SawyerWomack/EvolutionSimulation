extends Control

var speed
var sight
var dname = "blank"
func _ready():
	$VBoxContainer/MarginContainer/Name.text = "name: " + dname
	$VBoxContainer/MarginContainer2/Sight.text = "speed: " + str(speed)
	$VBoxContainer/MarginContainer3/Speed.text = "sight: " + str(sight)
func kill(var theName : String):
	print(name)
	print(theName)
	if dname == theName:
		print("killed")
		queue_free()


func _on_Button_pressed():
	queue_free()
