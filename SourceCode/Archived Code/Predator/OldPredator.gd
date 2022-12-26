extends KinematicBody2D
#should sort the array everytime somthing is detected in the area and update the array to 
#but that node at the beginning of the array.

#------organism traits--------
var type = "predator"
var traits = {"sight" : 5, "speed" : 5}
var hunger = 100
var predator
var children = 0


#------movement behavior------
var directionArr = ["left","right","up","down"]
var elapsed = 0
var moving = false
var movingToFood = false
var start
var tileRes = 64
var currentDestination = Vector2.ZERO
var currentDirection = ""
var timer = Timer
var foodInRange = []


func _init():
	randomize()

func _ready():
	randomize()
	start = self.position
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	predator = load("res://Predator/Predator.tscn")
	foodInRange = $eyes.get_overlapping_areas()
	$eyes/CollisionShape2D.shape.radius = traits.sight * Grid.SIGHT_SCALE
	

"""
func _draw():
	var debugColor = Color.orange
	debugColor.a = .5
	draw_circle(Vector2.ZERO,traits.sight * Grid.SIGHT_SCALE,debugColor)
"""

func _process(delta):
	#sorts the list of overlapping areas by distance to the organism
	foodInRange = sort($eyes.get_overlapping_areas())
	#makes sure that hunger is above zero if not it kills it
	checkHealth()
	
	#check if the movement timer is over if so it decides where to go and moves there
	#once it arrives the timer is reset
	if timer.time_left == 0.0:
		movementBehavior(delta)

#checks if the organism is moving or not. 
#if it is moving then it checks if it has arrived at the destination if so it resets the timer
#if not it just moves
#if the organism is not moving then it checks if there is prey in sight
#if there is it moves torwards the prey
#if not it moves randomly in a direction
func movementBehavior(delta):
	if(moving):
		if elapsed < 1:
			move(delta)
		else:
			elapsed = 0
			start = self.position
			moving = false
			timer.start(10 - traits["speed"])
			hunger -= 10 - traits["speed"]
	else:
		#if foodIsInRange find path to food
		if len(foodInRange) == 0:
			currentDirection = directionArr[randi() % 4]
			currentDestination = findDestination(currentDirection)
			moving = true
		else:
			currentDestination = findDestination(findDirection(foodInRange))
			moving = true

#a basic path finding algorithim to move torwards the nearest prey
#works by checking if the x distance is larger than the y distance
func findDirection(foodInRange):
	var destination = Grid.convertToGrid(foodInRange[0].get_parent().position.x,foodInRange[0].get_parent().position.y)
	var currentPosition = Grid.convertToGrid(position.x,position.y)
	var difX = abs(destination.x - currentPosition.x)
	var difY = abs(destination.y - currentPosition.y)
	if difX > difY :
		if destination.x > currentPosition.x:
			return "right"
		else:
			return "left"
			
	elif difX <= difY:
		if destination.y - currentPosition.y > 0:
			return "down"
		else:
			return "up"
				
	

#lerps the position of the organism to smoothly move it to a specific point
func move(delta):
	delta *= traits.speed
	position += start.linear_interpolate(currentDestination,elapsed) - position
	elapsed += delta

#find a random direction that is within the game world
func findDestination(direction):
	var destination = position
	if direction == "left":
		destination.x -= 64
	elif direction == "right":
		destination.x += 64
	elif direction == "up":
		destination.y -= 64
	elif direction == "down":
		destination.y += 64
		
	return Vector2(clamp(destination.x,0, Grid.size.x * Grid.resolution.x),clamp(destination.y,0,Grid.size.y * Grid.resolution.y))

#reproduces the organism
func breed():
	#creates a instance of the predator class
	var child = predator.instance()
	#sets the positon to its own position
	child.position = position
	#sets the name to its name plus a id number so its able to see how many generation a predator has existed
	child.name = name + str(children)
	#adds 1 to the amount of children so it can continue creating uniqge names
	children += 1
	#assigns the childs traits to its parrents tratis
	#child.traits = setTraits()
	#adds 1 or -1 to each trait
	var test = setTraits()
	child.traits = test
	
	get_parent().add_child(child)
	Grid.changeLineData("predator", 1)

func checkHealth():
	if hunger <= 0:
		queue_free()
		Grid.changeLineData("predator", -1)

func setTraits():
	var newTraits = traits.duplicate()
	for key in traits.keys():
		var num = randi() % 2
		if num == 0:
			newTraits[key] = clamp(newTraits[key] + 1,1,10)
			if key == "sight" && newTraits[key] != 10:
				Grid.changeBarData("preySight",newTraits.sight,true)
		elif num == 1:
			
			newTraits[key] = clamp(newTraits[key] - 1,1,10)
			if key == "sight" && newTraits[key] != 1:
				Grid.changeBarData("preySight",newTraits.sight,false)
	return newTraits


func sort(notes):
	for i in range(notes.size()-1, -1, -1):
		for j in range(1,i+1,1):
			if getDistance(notes[j-1]) > getDistance(notes[j]):
				var temp = notes[j-1]
				notes[j-1] = notes[j]
				notes[j] = temp
	return notes

func getDistance(body):
	return body.get_parent().position.distance_to(position)
#this is the function that is called when the prey collides with a food node

func eat():
	hunger = 100
	foodInRange.remove(0)
	breed()

func scatterTraits():
	for key in traits.keys():
		traits[key] = randi() % 10 + 1
	Grid.changeBarData("preySight",traits.sight,true)

func daySwitch(day):
	
	if day:
		$eyes/CollisionShape2D.shape.radius = traits.sight *Grid.SIGHT_SCALE
	else:
		$eyes/CollisionShape2D.shape.radius = 10 - traits.sight * Grid.SIGHT_SCALE




func _on_mouth_mouse_entered():
	get_parent().addDisplay(name,traits.sight,traits.speed)
	


func _on_mouth_mouse_exited():
	get_tree().call_group("Display", "kill", str(name))
