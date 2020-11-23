extends Area2D

signal onEnterBrightLight # (brightLightArea)
signal onLeaveBrightLight # (brightLightArea)

var brightLightsInArea = [] # List of bright lights that might be illuminating me, but need to be raytrace-checked
var detectionPoints = [] # List of Position2D children of this object, used as additional points for raytracing toward center of bright lights
var isIlluminated = false

export(int) var layerForPhysicsObstructions = 1 # Physics layers that will block light

func _ready():
	detectionPoints.append(self)
	for child in get_children():
		var pt = child as Position2D
		if pt != null: detectionPoints.append(pt)

func _on_BrightLightDetector_area_entered(area):
	if $RaytraceTimer.is_stopped(): $RaytraceTimer.start()
	brightLightsInArea.append(area)
	#emit_signal("onEnterBrightLight", area)


func _on_BrightLightDetector_area_exited(area):
	brightLightsInArea.erase(area)
	if brightLightsInArea.size() == 0: 
		$RaytraceTimer.stop()
		if isIlluminated: # was illuminated, but left the last bright light area
			isIlluminated = false
			emit_signal("onLeaveBrightLight")
			#print(self.get_parent().name, ' leaving bright light (no more bright light areas)')


func _on_RaytraceTimer_timeout():
	var noObstruction
	# Cast rays from object center and any other detectionPoints available
	var space_state = get_world_2d().direct_space_state
	for sourcePoint in brightLightsInArea:
		for destPoint in detectionPoints:
			var result = space_state.intersect_ray(sourcePoint.global_position, destPoint.global_position, [], layerForPhysicsObstructions)
			if result.size() == 0: 
				noObstruction = true
				break
		if noObstruction: break
	if noObstruction && !isIlluminated: # we were not illuminated, but there is currently nothing blocking us from at least one bright light
		isIlluminated = true
		emit_signal("onEnterBrightLight")
		#print(self.get_parent().name, ' entered bright light')
	if !noObstruction && isIlluminated: # we were illuminated, but there are currently no unobstructed paths to a bright light
		isIlluminated = false
		emit_signal("onLeaveBrightLight")
		#print(self.get_parent().name, ' leaving bright light (still in area, but blocked)')
		
