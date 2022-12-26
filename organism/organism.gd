extends Node2D

#-------properties of the organism--------
export var type = "predator"

var hunger = 100
var children = 0
var node
var realName

var breedTimer = Timer
var breedCooldown = 5
#------movement behavior------
var start
var mapSize

var elapsed = 0
var tileRes = 64

var migrating = false
var moving = false

var currentDirection = ""

var foodInRange = []

var movementTimer = Timer

var migrationLocation = Vector2.ZERO
var currentDestination = Vector2.ZERO

var spawnMovement = Vector2(64,0)

var mouseIn = false

var displaying = false

var updated = false

onready var particles = $CPUParticles2D
var ate = false
func _ready():
	randomize()
	
	realName = get_parent().name
	mapSize = Grid.size
	
	start = get_parent().position
	
	breedTimer = Timer.new()
	breedTimer.one_shot = true
	add_child(breedTimer)
	
	movementTimer = Timer.new()
	movementTimer.one_shot = true
	add_child(movementTimer)
	
	foodInRange = $eyes.get_overlapping_areas()
	$eyes/CollisionShape2D.shape.radius = get_parent().traits.sight * Grid.SIGHT_SCALE
	#beginMoving(start + spawnMovement)
	
	updateData()
	
	




"""
func _draw():
	var debugColor = Color.yellow
	debugColor.a = .5
	draw_circle(Vector2.ZERO,traits.sight * Grid.SIGHT_SCALE,debugColor)
"""
#---------Movement Functions------------

#called to set the current destionation after finding where the organism should go
func beginMoving(destination):
	currentDestination = destination
	moving = true


#called to see if the organism is done moving and if not its moves the organism
func move(delta):
	if elapsed >= 1:
		elapsed = 0
		moving = false
		movementTimer.start(10 - get_parent().traits.speed)
		start = get_parent().position
		hunger -= get_parent().traits.speed
		return Vector2.ZERO
		
	else:
		delta *= get_parent().traits.speed
		var newPosition = start.linear_interpolate(currentDestination,elapsed) - get_parent().position
		elapsed += delta
		return newPosition

#called to calculate where the organism should move next
func findNextMove():
	foodInRange = sort($eyes.get_overlapping_areas())
	
	if len(foodInRange) == 0:
		migrate()
	else:
		if(type == "predator"):
			beginMoving(pathFind(foodInRange[0].get_parent().get_parent().position))
		else:
			beginMoving(pathFind(foodInRange[0].get_parent().position))

#picks a random location on the map for the organism to travel to and return the coordinates
#of that position. Also checks if the organism has arrived at the picked location
func migrate():
	if(migrating):
		if(get_parent().position.x - migrationLocation.x < Grid.resolution.x && get_parent().position.y - migrationLocation.y < Grid.resolution.y):
			migrating = false
		else:
			beginMoving(pathFind(migrationLocation))
	else:
		var point = Vector2(randi() % int(Grid.size.x), randi() % int(Grid.size.y))
		migrationLocation = Vector2(Grid.resolution.x * point.x, Grid.resolution.y * point.y)
		migrating = true

#a very crude path finding algorithim that just takes the distance on the x and y axis and if one
#is longer it moves up on tile in that direction
func pathFind(destination):
	var currentPosition = get_parent().position
	var difX = abs(destination.x - currentPosition.x)
	var difY = abs(destination.y - currentPosition.y)
	if difX > difY :
		if destination.x > currentPosition.x:
			
			currentPosition.x += Grid.resolution.x
		else:
			currentPosition.x -= Grid.resolution.x
			
	elif difX <= difY:
		if destination.y - currentPosition.y > 0:
			currentPosition.y += Grid.resolution.y
		else:
			currentPosition.y -= Grid.resolution.y
	return currentPosition

#reproduces the organism
func breed():
	if breedTimer.time_left == 0:
		var child = node.instance().duplicate()
		child.position = get_parent().position
		child.name = get_parent().name + str(children)
		children += 1
		child.traits = setTraits()
		breedTimer.start(breedCooldown)
		
		get_parent().get_parent().add_child(child)

#checks if the hunger is zero and if so it kills the organism
func checkHealth():
	if hunger <= 0:
		get_parent().die()
		#Grid.changeLineData("predator", -1)

#sorts the array by the distance to the node
func sort(notes):
	for i in range(notes.size()-1, -1, -1):
		for j in range(1,i+1,1):
			if getDistance(notes[j-1]) > getDistance(notes[j]):
				var temp = notes[j-1]
				notes[j-1] = notes[j]
				notes[j] = temp
	return notes

#reuturn the global distance from this node to node "body"
func getDistance(body):
	return body.get_parent().global_position.distance_to(global_position)

func displayInfo():
	get_parent().get_parent().addDisplay(get_parent().name,get_parent().traits.speed,get_parent().traits.sight)




#--------- Setters ----------------------
func setEyeLayer(layer,on):
	$eyes.set_collision_layer_bit(layer,on)

func setEyeMask(mask,on):
	$eyes.set_collision_mask_bit(mask,on)

func setMouthLayer(layer,on):
	$mouth.set_collision_layer_bit(layer,on)

func setMouthMask(mask,on):
	$mouth.set_collision_mask_bit(mask,on)

func setType(x):
	type = x
	

func setChild(x):
	node = load(x)

#completly randomizes the get_parent().traits of an organism
#NOTE: only to be called on intial instance of the simulation



func setTraits():
	var newTraits = get_parent().traits.duplicate()
	
	for key in get_parent().traits.keys():
		var num = randi() % 2
		
		if num == 0:
			newTraits[key] = clamp(newTraits[key] + 1,1,10)
		
		elif num == 1:
			newTraits[key] = clamp(newTraits[key] - 1,1,10)
		
	return newTraits

func updateData():
	if(updated):
		return
	Grid.data[type].population += 1
	Grid.data[type].speed[get_parent().traits.speed - 1] += 1
	Grid.data[type].sight[get_parent().traits.sight - 1] += 1
	Grid.data[type].control[get_parent().traits.control - 1] += 1
	get_tree().call_group("graphs", "updateData", type, "speed")
	get_tree().call_group("graphs", "updateData", type, "population")
	get_tree().call_group("graphs", "updateData", type, "sight")
	get_tree().call_group("graphs", "updateData", type, "control")
	updated = true

func removeData():
	Grid.data[type].population -= 1
	Grid.data[type].speed[get_parent().traits.speed - 1] -= 1
	Grid.data[type].sight[get_parent().traits.sight - 1] -= 1
	Grid.data[type].control[get_parent().traits.control - 1] -= 1
	get_tree().call_group("graphs", "updateData", type, "speed")
	get_tree().call_group("graphs", "updateData", type, "population")
	get_tree().call_group("graphs", "updateData", type, "sight")
	get_tree().call_group("graphs", "updateData", type, "control")
#----------signals---------------
func daySwitch(day):
	
	if day:
		$eyes/CollisionShape2D.shape.radius = get_parent().traits.sight *Grid.SIGHT_SCALE * 20
	else:
		$eyes/CollisionShape2D.shape.radius = 10 - get_parent().traits.sight * Grid.SIGHT_SCALE * 20


func _on_mouth_mouse_entered():
	mouseIn = true
	


func _on_mouth_mouse_exited():
	mouseIn = false

func eat():
	hunger = 100
	
	breed()

func _on_mouth_area_entered(area):
	if(type == "prey" && area.name == "mouth" && area.get_parent().type == "predator"):
		if(!ate):
			area.get_parent().eat()
			get_parent().emit()
			get_parent().get_node("Icon").visible = false
			ate = true
		



func _on_mouth_area_exited(_area):
	pass # Replace with function body.


func _on_mouth_input_event(viewport, event, shape_idx):
	if  event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if displaying:
			get_tree().call_group("Display", "kill", get_parent().name)
			displaying = false
		else:
			displaying = true
			displayInfo()
