extends KinematicBody2D

#------child accsess varabiles---------
var organism
var eyes
var isAlive = true
var traits = {"sight" : 5, "speed" : 1, "control" : 1}
#organism instance scene
onready var organismScene = preload("res://organism/organism.tscn")
var rng = RandomNumberGenerator.new()

var destination = Vector2.ZERO
var emitting = false
func _ready():
	randomize()
	
	organism = organismScene.instance().duplicate()

	
	
	#to see food
	organism.setEyeMask(0,true)
	#to interact with food
	organism.setMouthLayer(2,true)
	organism.setMouthLayer(9,true)
	#so it can detect when it can eat food
	organism.setMouthMask(0,true)
	#so predators can see it
	organism.setMouthLayer(2,true)
	organism.setType("prey")
	
	call_deferred("add_child",organism)
	
	
	organism.setChild("res://Prey/Prey.tscn")
	
	
	
	
	
func _process(delta):
	organism = $Organism
	eyes = $Organism/eyes
	
	organism.checkHealth()
	
	if(emitting):
		print("emit")
		if(organism.particles.emitting == false):
			
			queue_free()
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
	organism.particles.emitting = true
	emitting = true
func die():
	organism.removeData()
	queue_free()

