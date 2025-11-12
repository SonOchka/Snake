extends Node2D

var GRID_SIZE = 48
var GRID = [20, 50]

# встроенный метод рисования
func _draw():
	# перебираем по x
	for x in range(self.GRID[0]):
		# перебераем по y
		for y in range(self.GRID[1]):
			# рисуем квадрат в нужной клетке например первый будет 0,0 
			showSquareByCell(x,y)

# рисует квадрат на сетке где x это очередность по x, а y очередность по y 
func showSquareByCell(x, y):
	# позиции точек для линий что бы нарисовать квадрат
	var points = [
		Vector2(x * self.GRID_SIZE, y * self.GRID_SIZE), 
		Vector2((x * self.GRID_SIZE) + self.GRID_SIZE, y * self.GRID_SIZE),
		Vector2((x * self.GRID_SIZE) + self.GRID_SIZE, (y * self.GRID_SIZE) + self.GRID_SIZE), 
		Vector2(x * self.GRID_SIZE, (y * self.GRID_SIZE) + self.GRID_SIZE),
		Vector2(x * self.GRID_SIZE, y * self.GRID_SIZE),
	]
	var color = Color(1, 0, 0, 1) # красный цвет
	var width = 1 # ширина линии
	draw_polyline(points, color, width)
