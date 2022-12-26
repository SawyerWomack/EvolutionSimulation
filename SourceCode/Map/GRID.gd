extends Node


var map = []

var size = Vector2()

var foodAmount
var preyAmount
var predatorAmount
var dayCycle

var resolution = Vector2(64,64)
var SIGHT_SCALE = 100
#trait array [0,0,0,0,0,0,0,0,0,0]
var data = {
	"prey" : {
	"population" : 0,
	"speed" : [0,0,0,0,0,0,0,0,0,0],
	"sight" : [0,0,0,0,0,0,0,0,0,0],
	"control" : [0,0,0,0,0,0,0,0,0,0]

}, "predator" : {
	"population" : 0,
	"speed" : [0,0,0,0,0,0,0,0,0,0],
	"sight" : [0,0,0,0,0,0,0,0,0,0],
	"control" : [0,0,0,0,0,0,0,0,0,0]
}}
func _ready():
	printGrid()


#no longer neccesarry due to using area 2ds
"""
func scan(orgin : Vector2, radius):
	if radius % 2 != 0:
		radius += 1
	var diameter = radius * 2 + 1
	var topLimit = orgin.y - radius -1
	var lenX = 1
	orgin -= Vector2(1,1)
	var top = false
	for i in diameter:
		
		for x in lenX:
			if x == 0:
				tileDict[topLimit + i][orgin.x] = 1
			elif x % 2 == 0:
				tileDict[topLimit + i][orgin.x + (x/2) ] = 1
			elif x % 2 != 0:
				tileDict[topLimit + i][orgin.x - ((x+1)/2)] = 1
		if lenX + 2 <= diameter && !top:
			lenX+=2
		elif lenX + 2 > diameter && !top:
			top = true
			lenX-=2
		elif lenX <= diameter && top:
			lenX-=2
"""
#returns the grid array in a pretty format
func printGrid():
	for i in len(map):
		print(map)

#func changeLineData(key, input):
#	data[key] += input
#	get_tree().call_group("graphs", "addToData", key,data[key])

func changeBarData(key, input, adding):
	input -= 1
	if adding:
		data[key][input - 1] += 1
	else:
		data[key][input-1] -= 1
	get_tree().call_group("graphs", "addToBarData", key,data[key])
	print(data)
#take a vector2 and changes it to the relative grid size of the map
func convertToGrid(x,y):
	return Vector2(int(x / resolution.x), int(y/ resolution.y))

