extends Control


var data = [1]
export var title = "enter text"
export var xMaxLength = 40
export var species = "prey or predator"
export var trait = "sight"

onready var graphPanel = $graphPanel
onready var line = $graphPanel/Control/Line2D
func _ready():
	graphData()
	$TextContainer/y.text = title
func updateData(type, t):
	$TextContainer/y2.text = str(data[len(data)-1])
	
	if(species == type && t == trait):
		if(len(data) < xMaxLength):
			data.append(Grid.data[species][trait])
		elif(len(data) == xMaxLength):
			data.remove(0)
			data.append(Grid.data[species][trait])
		graphData()

func graphData():
	var dimensions = graphPanel.rect_size - graphPanel.rect_position
	var gap = Vector2(dimensions.x / len(data),dimensions.y / (data.max()))
	line.clear_points()
	line.add_point(line.to_local($graphPanel/Control.get_global_position()))
	for i in range(1,len(data)):
		line.add_point(Vector2((i * gap.x) + gap.x,gap.y - (data[i] * gap.y)),i)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
