extends KinematicBody2D

var organism
var eyes
onready var organismScene = preload("res://organism/organism.tscn")
var destination = Vector2.ZERO

var traits = {"sight" : 5, "speed" : 1, "control" : 1}
var isAlive = true


var rng = RandomNumberGenerator.new()
func _ready():
	randomize()
	
	organism = organismScene.instance().duplicate()
	
	
	organism.setMouthLayer(11,true)
	organism.setMouthMask(2,true)
	#to observe prey
	organism.setEyeMask(9,true)
	
	organism.setType("predator")
	organism.setChild("res://Predator/Predator.tscn")
	
	call_deferred("add_child",organism)
	
	
	
func _process(delta):
	organism = $Organism
	eyes = $Organism/eyes
	
	organism.checkHealth()
	
	if(organism.moving):
			var test = organism.move(delta)
			position += test
	elif organism.movementTimer.time_left == 0.0:
		organism.findNextMove()
	
func scatterTraits():
	for key in traits.keys():
		var num = randi() % 10 + 1
		print(num)
		traits[key] = num
func emit():
	pass

func die():
	organism.removeData()
	queue_free()
