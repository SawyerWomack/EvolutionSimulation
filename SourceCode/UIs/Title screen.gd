extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var MapX = $Mapx/TextEdit
onready var MapY = $Mapy/TextEdit
onready var Food = $Food/TextEdit
onready var Predator = $Predator/TextEdit
onready var Prey = $Prey/TextEdit
onready var DayNight = $DayNight/TextEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	Grid.size = Vector2(int(MapX.text),int(MapY.text))
	Grid.foodAmount = int(Food.text)
	Grid.preyAmount = int(Prey.text)
	Grid.predatorAmount = int(Predator.text)
	Grid.dayCycle = int(DayNight.text)
	
	get_tree().change_scene("res://Map/Map.tscn")
