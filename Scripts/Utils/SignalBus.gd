#class name hides singleton ???
#but it's fine if there are static methods and variables ??
#class_name SignalBus

extends Node

signal gain_xp(amount : int)
signal get_new_weapon(weapon : Weapon)
signal level_up_signal(level : int, next_xp : int, current_xp : int)