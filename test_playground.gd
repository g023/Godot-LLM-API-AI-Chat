# recursive division algorithm example with print output for visualization
# language: Godot 4 GDScript

extends Node2D

var map = []
var width = 10
var height = 10

func _ready():
	map = createMap(width, height)
	map = recursiveDivision(map, 0, 0, width - 1, height - 1)
	printMap(map)

func createMap(w, h):
	var newMap = []
	for y in range(h):
		newMap.append([])
		for x in range(w):
			newMap[y].append(1)
	return newMap

func recursiveDivision(map, x1, y1, x2, y2):
	if x2 - x1 < 2 or y2 - y1 < 2:
		return map

	var horizontal = randi() % 2 == 0
	var wallX = x1 + 1 + randi() % (x2 - x1 - 1)
	var wallY = y1 + 1 + randi() % (y2 - y1 - 1)

	if horizontal:
		for x in range(x1, x2 + 1):
			map[wallY][x] = 0
		var gapX = x1 + randi() % (wallX - x1)
		map[wallY][gapX] = 1
		map[wallY][wallX] = 1
		map = recursiveDivision(map, x1, y1, x2, wallY - 1)
		map = recursiveDivision(map, x1, wallY + 1, x2, y2)
	else:
		for y in range(y1, y2 + 1):
			map[y][wallX] = 0
		var gapY = y1 + randi() % (wallY - y1)
		map[gapY][wallX] = 1
		map[wallY][wallX] = 1
		map = recursiveDivision(map, x1, y1, wallX - 1, y2)
		map = recursiveDivision(map, wallX + 1, y1, x2, y2)

	return map

func printMap(map):
	var str = ""
	for y in range(map.size()):
		for x in range(map[y].size()):
			str += str(map[y][x])
		str += "\n"
	print(str)
	
			
			
 

 
