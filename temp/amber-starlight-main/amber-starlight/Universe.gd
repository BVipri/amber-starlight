extends Object
class_name Universe

var id
var size
var stars
var universe = []

func _init(id, size, stars):
	self.id = id
	self.size = size
	self.stars = stars
	
	var count = 0
	for i in range(stars):
		for j in range(stars):
			for k in range(stars):
				var star = Star.new(count,self)
				count += 1
				universe.append(star)

func getStar(index):
	return universe[index]

func getSize():
	return size
	
func _to_string() -> String:
	var ret = "Universe: Size " + str(size) + " #Stars " + str(stars) + "\n"
	for i in range(stars):
		ret += universe[i]._to_string()
	return ret
	
class Star:
	extends Object

	var id
	var position
	var size
	var hue
	var planets = []
	var universe
	var numPlanets
	var random = RandomNumberGenerator.new()

	func _init(id, universe):
		self.id = id
		self.universe = universe
		
		random.seed = id
		self.position = Vector3(randf_range(0,universe.getSize()),randf_range(0,universe.getSize()),randf_range(0,universe.getSize()))
		self.size = randf_range(50,200)
		self.hue = randf_range(0,1)
		self.numPlanets = random.rand_weighted([4,8,16,32,64,128,64,32,16,8,4,2,1,0.5,0.25,0.125])
		for i in range(numPlanets):
			var planet = Planet.new(1,self)
			planets.append(planet)
			
	func _to_string() -> String:
		var ret = "Star: ID " + str(id) + " Pos " + str(position) + " Size " + str(size) + " Hue " + str(hue) + "\n"
		for i in range(numPlanets):
			ret += planets.get(i)._to_string()
		return ret

class Planet:
	extends Object
	
	static var numPlanets: = 0
	var id
	var dist
	var atmosphere
	var size
	var scale
	var seed
	var colorType
	var color
	var star
	var random = RandomNumberGenerator.new()
	var colors
	
	func _init(dist, star):
		self.id = numPlanets
		numPlanets += 1
		self.star = star
		self.dist = dist
		random.seed = id
		self.atmosphere = random.randf()
		self.size = random.randf()*500
		self.scale = random.randf()*200
		self.colorType = randi_range(0,2)
		var color1
		var color2
		var color3
		match self.colorType:
			0: # colorshift
				var rand = randi_range(0,3)
				match rand:
					0: # full shift
						color1 = Color(random.randf(),random.randf(),random.randf())
						color3 = Color(random.randf(),random.randf(),random.randf())
						color2 = color1.lerp(color3,0.5)
					1: # hue shift
						var h1 = random.randf()
						var h2 = random.randf()
						var s = random.randf()
						var v = random.randf()
						color1 = Color.from_hsv(h1,s,v)
						color3 = Color.from_hsv(h2,s,v)
						color2 = color1.lerp(color3,0.5)
					2: # saturation shift
						var h = random.randf()
						var s1 = random.randf()
						var s2 = random.randf()
						var v = random.randf()
						color1 = Color.from_hsv(h,s1,v)
						color3 = Color.from_hsv(h,s2,v)
						color2 = color1.lerp(color3,0.5)
					3: # value shift
						var h = random.randf()
						var s = random.randf()
						var v1 = random.randf()
						var v2 = random.randf()
						color1 = Color.from_hsv(h,s,v1)
						color3 = Color.from_hsv(h,s,v1)
						color2 = color1.lerp(color3,0.5)
			1: # complimentary colors
				var rand = randi_range(0,1)
				match rand:
					0: # colorshift
						var h1 = random.randf()
						var h2 = h1 + 0.5
						var s = random.randf()
						var v = random.randf()
						color1 = Color.from_hsv(h1,s,v)
						color3 = Color.from_hsv(h2,s,v)
						color2 = color1.lerp(color3,0.5)
					1: # triadic color scheme
						var h1 = random.randf()
						var h2 = h1 + 0.3333
						var h3 = h2 + 0.3333
						var s = random.randf()
						var v = random.randf()
						color1 = Color.from_hsv(h1,s,v)
						color3 = Color.from_hsv(h3,s,v)
						color2 = Color.from_hsv(h2,s,v)
			2: # random colors
				color1 = Color(random.randf(),random.randf(),random.randf())
				color2 = Color(random.randf(),random.randf(),random.randf())
				color3 = Color(random.randf(),random.randf(),random.randf())
		self.colors = [color1,color2,color3]
	
	func _to_string() -> String:
		return "Planet: ID " + str(id) + " Dist " + str(dist) + " Size " + str(size) + " Atmo " + str(atmosphere) + " Size " + str(size) + " Scale " + str(scale) + "\n"

class WarmPlanet:
	extends Planet
	
	func _init(dist, star):
		super(dist, star)
