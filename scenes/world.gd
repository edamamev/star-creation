extends Node3D

## https://www.reddit.com/r/godot/comments/11lollw/how_to_change_an_objects_material_color_in_godot_4/


var material = StandardMaterial3D.new()

func _ready():
	$World/CSGSphere3D.material = material
	material.emission_enabled = true
	material.emission = Color(1,1,1)
	#var a_line := await line(Vector3(0,0,0), Vector3(0,10,0), Color.RED)
	pass


func _on_ui_colour_calculated(colour):
	#colour = round(colour)
	#material.emission = Color(colour.x / 255, colour.y / 255, colour.z / 255)
	#material.emission = Color.from_rgba8(round(colour.x), round(colour.y), roun2.54d(colour.z))
	material.emission = colour


func _on_ui_radius_calculated(radius):
	$World/CSGSphere3D.radius = 10 * radius


func _on_ui_luminosity_calculated(luminosity):
	material.emission_intensity = 5 * luminosity


### Drawing

func line(pos1: Vector3, pos2: Vector3, colour = Color.WHITE_SMOKE, persist_ms = 0):
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(pos1)
	immediate_mesh.surface_add_vertex(pos2)
	immediate_mesh.surface_end()
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = colour
	
	return await final_cleanup(mesh_instance, persist_ms)


func point(pos: Vector3, radius = 0.05, colour = Color.WHITE_SMOKE, persist_ms = 0):
	var mesh_instance := MeshInstance3D.new()
	var sphere_mesh := SphereMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = sphere_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	mesh_instance.position = pos
	
	sphere_mesh.radius = radius
	sphere_mesh.height = radius*2
	sphere_mesh.material = material
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = colour
	return await  final_cleanup(mesh_instance, persist_ms)


func square(pos: Vector3, size: Vector2, color = Color.WHITE_SMOKE, persist_ms = 0):
	var mesh_instance := MeshInstance3D.new()
	var box_mesh := BoxMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = box_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	mesh_instance.position = pos

	box_mesh.size = Vector3(size.x, size.y, 1)
	box_mesh.material = material

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color

	return await final_cleanup(mesh_instance, persist_ms)

## 1 -> Lasts ONLY for current physics frame
## >1 -> Lasts X time duration.
## <1 -> Stays indefinitely
func final_cleanup(mesh_instance: MeshInstance3D, persist_ms: float):
	get_tree().get_root().add_child(mesh_instance)
	if persist_ms == 1:
		await get_tree().physics_frame
		mesh_instance.queue_free()
	elif persist_ms > 0:
		await get_tree().create_timer(persist_ms).timeout
		mesh_instance.queue_free()
	else:
		return mesh_instance
