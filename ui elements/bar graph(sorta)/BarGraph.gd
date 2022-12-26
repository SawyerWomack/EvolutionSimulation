extends Control


var data = [0,0,0,0,0,0,0,0,0,0]
export var title = "enter text"
export var xMaxLength = 40
export var species = "predator or prey"
export var trait = "speed"

onready var graphPanel = $graphPanel
onready var line = $graphPanel/Control/Line2D
func _ready():
	graphData()
	$TextContainer/y.text = title
func _process(_delta):
	graphData()
func updateData(type,t):
	$TextContainer/y2.text = str(data.find(data.max()) + 1)
	if(species == type && t == trait):
	
		data = Grid.data[species][t]
		
		graphData()
	
func graphData():
	var dimensions = graphPanel.rect_size - graphPanel.rect_position
	var gap = Vector2(dimensions.x / (len(data)-1),dimensions.y / (data.max() + 1))
	line.clear_points()
	for i in range(0,len(data)):
		line.add_point(Vector2((i * gap.x),(data[i] * gap.y)*-1),i)
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
