class_name Utilities

extends Node

static func exp_decay(a, b, decay, delta):
	return b + (a - b) * exp(-decay * delta)
