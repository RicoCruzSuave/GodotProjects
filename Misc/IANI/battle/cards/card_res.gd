extends Resource
class_name Card

@export var effect_magnitude : = 1
#@export var cost_effects : Array[Callable]
@export var play_effects : Array[String] = ["deal_damage"]
#@export var discard_effects : Array[Callable]

#func cost(target):
	#for effect in cost_effects:
		#effect.call(target)

func play(target):
	for effect in play_effects:
		var callable : = Callable.create(self, effect)
		callable.call(target)
	print("{0} played on {1}".format([resource_path.split("/")[-1].split(".")[0], target.name])) ## Hacky way to get resource file name

#func discard(target):
	#for effect in play_effects:
		#effect.call(target)

func deal_damage(other):
	other.hit(effect_magnitude)
