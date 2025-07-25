extends Node

func _ready():
	var mainObjectLayerC1 = self
	var mainObjectLayerC2 = self.get_parent().get_node("C2")
	var mainObjectLayerC3 = self.get_parent().get_node("C3")
	for i in range(30):
		var object = Objects._generatePlant(i,1,0)
		mainObjectLayerC1.set_pattern(Vector2i(i*100-1000,-1000),object[0])
		mainObjectLayerC2.set_pattern(Vector2i(i*100-1000,-1000),object[1])
		mainObjectLayerC3.set_pattern(Vector2i(i*100-1000,-1000),object[2])
