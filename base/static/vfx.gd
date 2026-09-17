class_name Vfx
extends Node


static func spawn(vfx_name: String, position: Vector2, parent: Node2D):
	var vfx := GlobalResources.vfx_scene.instantiate() as AnimatedSprite2D
	parent.add_child(vfx)
	vfx.global_position = position
	vfx.play(vfx_name)
