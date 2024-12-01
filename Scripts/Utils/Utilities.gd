class_name Utilities

extends Node

#optimized lerp by Freya Holmer
static func exp_decay(a, b, decay, delta):
	return b + (a - b) * exp(-decay * delta)
	
	
static func ease_out(t: float) -> float:
	t = clamp(t, 0.0, 1.0)
	return 1 - pow(1 - t, 3)


static func ease_in_back(t: float) -> float:
	var c1 = 1.70158 
	var c3 = c1 + 1
	t = clamp(t, 0.0, 1.0)
	return c3 * t * t * t - c1 * t * t


static func ease_in(t: float) -> float:
	t = clamp(t, 0.0, 1.0)
	return pow(t, 3)
