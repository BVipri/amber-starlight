extends Node

func _ready():
	var mainObjectLayerC1 = self
	var mainObjectLayerC2 = self.get_parent().get_node("C2")
	for i in range(6):
		var object = Objects._generatePlant(0)
		Objects.resizeObject(object[0],Vector2i(i,i),0)
		Objects.resizeObject(object[1],Vector2i(i,i),1)
		mainObjectLayerC1.set_pattern(Vector2i(i*100-1000,-1000),object[0])
		mainObjectLayerC2.set_pattern(Vector2i(i*100-1000,-1000),object[1])
