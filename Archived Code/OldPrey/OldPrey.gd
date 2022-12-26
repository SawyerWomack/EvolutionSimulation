extends KinematicBody2D
#should sort the array everytime somthing is detected in the area and update the array to 
#but that node at the beginning of the array.

#------organism traits--------
var type = "prey"
var traits = {"vision" : 5, "sight" : 5, "speed" : 1, "sleep" : 5}
var hunger = 100
var prey
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
var children = 0
func _ready():
	randomize()
	start = self.position
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	prey = load("res://Prey/Prey.tscn")
	foodInRange = $eyes.get_overlapping_areas()
	$eyes/CollisionShape2D.shape.radius = traits.sight * Grid.SIGHT_SCALE
"""
func _draw():
	var debugColor = Color.yellow
	debugColor.a = .5
	draw_circle(Vector2.ZERO,traits.sight * Grid.SIGHT_SCALE,debugColor)
"""

func _process(delta):
	foodInRange = sort($eyes.get_overlapping_areas())
	checkHealth()
	if timer.time_left == 0.0:
		movementBehavior(delta)

func movementBehavior(delta):
	if(moving):
		if elapsed < 1:
			move(delta)
		else:
			elapsed = 0
			start = self.position
			moving = false
			timer.start(traits["speed"])
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
				
	


func move(delta):
	delta *= traits.speed
	position += start.linear_interpolate(currentDestination,elapsed) - position
	elapsed += delta
	

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

func breed():
	var child = prey.instance()
	child.traits = setTraits()
	child.position = position
	child.name = name + str(children)
	children += 1
	get_parent().add_child(child)
	Grid.changeLineData("prey", 1)

func checkHealth():
	if hunger <= 0:
		queue_free()
		Grid.changeLineData("prey", -1)

func setTraits():
	var newTraits = traits.duplicate()
	for key in traits.keys():
		var num = randi() % 2
		if num == 0:
			newTraits[key] = clamp(newTraits[key] + 1,1,10)
		elif num == 1:
			newTraits[key] = clamp(newTraits[key] - 1,1,10)
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


func daySwitch(day):
	
	if day:
		$eyes/CollisionShape2D.shape.radius = traits.sight *Grid.SIGHT_SCALE * 20
	else:
		$eyes/CollisionShape2D.shape.radius = 10 - traits.sight * Grid.SIGHT_SCALE * 20

func _on_eyes_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	pass

func _on_mouth_area_entered(area):
	if area.name == "mouth" && area.get_parent().type == "predator":
		area.get_parent().eat()
		Grid.changeLineData("prey", -1)
		queue_free()
