class_name Utilities

extends Node

#optimized lerp by Freya Holmer
static func exp_decay(a, b, decay, delta):
	return b + (a - b) * exp(-decay * delta)
