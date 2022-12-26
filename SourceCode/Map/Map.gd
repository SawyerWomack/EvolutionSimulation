extends Node2D

#------map dimensions------
var mapWidth = 100
var mapHeight = 100

#------tile resolution------
export var tileWidth = 64
export var tileHeight = 64

#------tile textures-------
onready var sand = preload("res://Map/tile.png")
onready var grass = preload("res://Map/tile.png")

#------random and perlin noise parameters------
var theSeed = randi() % 500
export var octaves = 5
export var period = 20.0
export var persistence = 0.8
export var middle = 0.5

#------Instance Scenes----------
var tile = PackedScene
var food = PackedScene
var prey = PackedScene
var predator = PackedScene

onready var display = load("res://ui elements/OrganismData/Data.tscn")

#------World Behavior---------
var nightModulate = Color("5c5c5c")
var dayModulate = Color("ffffff")

var day = true

export var dayTime = 50
export var nightTime = 25

onready var timer = $Timer

var foodAmount
var preyAmount
var predatorAmount


func _ready():
	updateInformation()
	
	randomize()
	#updating the grid class
	Grid.resolution = Vector2(tileWidth, tileHeight) 
	
	#starting the day night cycle timer
	timer.start(dayTime)
	
	#--------loading all scenes--------
	tile = preload("res://Map/Tile.tscn")
	food = preload("res://Map/Food/Food.tscn")
	prey = preload("res://Prey/Prey.tscn")
	predator = preload("res://Predator/Predator.tscn")
	
	#generating the tiles
	theSeed = randi() % 500
	spawnTiles()
	
	#spawning entities into the map
	spawnItems(food,foodAmount)
	spawnItems(prey,preyAmount)
	spawnItems(predator,predatorAmount)
	
	#--------updating the graph-----------



func _process(_delta):
	#checks if the day night timer is done
	if timer.time_left > 0:
		pass
	else:
		spawnItems(food,30)
		if(day):
			setNight()
		else:
			setDay()
			

#generates the map
func spawnTiles():
	#instances the noise class and sets parameters
	var noise = OpenSimplexNoise.new()
	noise.seed = theSeed
	noise.octaves = octaves
	noise.period = period 
	noise.persistence = persistence
	
	#loops through mapWidth for every value in mapHeight and spawns in a tile changing its color
	#depending on the value of the perlin noise
	#note: this can be optimized and if I really feel like it removed because making a pathfinding algorithim would be
	#a difficult issue and not nessecary for the creation of this project
	for y in mapHeight:
		Grid.map.append([])
		for x in mapWidth:
			var new = tile.instance()
			new.position = Vector2(tileHeight * y + tileHeight/2, tileWidth * x + tileWidth/2)
			
			var val = noise.get_noise_2d(x,y)
			
			if(val > middle):
				new.get_node("Icon").texture = grass
				Grid.map[y].append(1)
			else:
				new.get_node("Icon").texture = sand
				Grid.map[y].append(0)
			get_node("grid").add_child(new)
			



#for amountOfFood times it loops through spawning an instance of the food instance
func spawnItems(node, amount):
	for i in amount:
		var new = node.instance().duplicate()
		var point = Vector2(randi() % int(mapWidth), randi() % int(mapHeight))
		new.position = Vector2((tileWidth * point.x) + (tileWidth/2), (tileHeight * point.y) + (tileHeight/2))
		if new.isAlive:
			new.name = new.name + str(i)
			new.scatterTraits()
		add_child(new)


#sets the map to night time and alerts all entities that its night time as well
func setNight():
	timer.start(nightTime)
	day = false
	modulate = nightModulate
	get_tree().call_group("organisms", "daySwitch", day)

#sets the map to night time and alerts all entities that its night time as well
func setDay():
	timer.start(dayTime)
	day = true
	modulate = dayModulate
	get_tree().call_group("organisms", "daySwitch", day)

#adds a debug display when the mouse hovers over a entity
#NOTE: this feature is currently not working
func addDisplay(var itsName, var itsSpeed, var itsSight):
	var new = display.instance()
	new.dname = itsName
	new.speed = itsSpeed
	new.sight = itsSight
	$CanvasLayer/RightSidePanel/VBoxContainer.add_child(new)

func updateInformation():
	mapWidth = Grid.size.x
	mapHeight = Grid.size.y
	
	foodAmount = Grid.foodAmount
	preyAmount = Grid.preyAmount
	predatorAmount = Grid.predatorAmount
	
	
	dayTime = Grid.dayCycle
	nightTime = Grid.dayCycle
	
	
#debug function to print out the data of the entire map in a somewhat pretty format
func printArray():
	for i in len(Grid.map):
		print(Grid.map[i])


func _on_Button_pressed():
	get_tree().change_scene("res://UIs/Title screen.tscn")
