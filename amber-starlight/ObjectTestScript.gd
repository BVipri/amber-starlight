extends Node

func _ready():
	var mainObjectLayerC1 = self
	var mainObjectLayerC2 = self.get_parent().get_node("C2")
	for i in range(6):
		var object = Objects._generatePlant(i)
		for tile in object:
			if tile[1] == 0:
				mainObjectLayerC1.set_cell(Vector2i(i*1000+tile[0].x,0+4+tile[0].y),tile[1],Vector2(0,0),0)
			else:
				mainObjectLayerC2.set_cell(Vector2i(i*1000+tile[0].x,0+4+tile[0].y),tile[1],Vector2(0,0),0)
