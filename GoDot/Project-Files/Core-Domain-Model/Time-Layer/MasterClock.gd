##
# MasterClock
#
# MasterClock is a Time Layer object that serves as the single
# authoritative source of time for the entire simulation.
#
# Every time-dependent system in Startup Simulator references
# the MasterClock.
#
# Examples:
# - Equipment cycle times
# - Employee schedules
# - Shipping arrivals
# - Shipping departures
# - Need generation
# - Order deadlines
# - Contract creation
# - Payroll events
#
# MasterClock does NOT:
# - Perform scheduling
# - Trigger business logic
# - Manage events
# - Control production
#
# Those responsibilities belong to other systems.
#
# MasterClock exists to answer the question:
#
#     "What time is it?"
#
# Sacred Framework Rule:
#
#     No system should maintain its own timeline.
#
#     All time originates from MasterClock.
##

class_name MasterClock
extends RefCounted

# ------------------------------------------------------------------
# Time State
# ------------------------------------------------------------------

# Current simulation time in game seconds.
var current_time: float = 0.0

# ------------------------------------------------------------------
# Time Scale
# ------------------------------------------------------------------

# Simulation speed multiplier.
#
# Examples:
# 1.0 = Normal Speed
# 2.0 = Double Speed
# 4.0 = Quadruple Speed
# 0.0 = Paused
var time_scale: float = 1.0

# ------------------------------------------------------------------
# State
# ------------------------------------------------------------------

var is_paused: bool = false

# ------------------------------------------------------------------
# Time Functions
# ------------------------------------------------------------------

# Advances time using real-world elapsed time.
func tick(delta: float) -> void:

	if is_paused:
		return

	current_time += delta * time_scale


# Sets the current simulation time.
#
# Primarily useful for loading save files and debugging.
func set_time(new_time: float) -> void:
	current_time = max(new_time, 0.0)


# Returns the current simulation time.
func get_time() -> float:
	return current_time

# ------------------------------------------------------------------
# Pause Functions
# ------------------------------------------------------------------

func pause() -> void:
	is_paused = true


func resume() -> void:
	is_paused = false


func toggle_pause() -> void:
	is_paused = not is_paused

# ------------------------------------------------------------------
# Time Scale Functions
# ------------------------------------------------------------------

func set_time_scale(new_scale: float) -> void:
	time_scale = max(new_scale, 0.0)


func get_time_scale() -> float:
	return time_scale

# ------------------------------------------------------------------
# Time Comparison Functions
# ------------------------------------------------------------------

# Returns true if the supplied time has passed.
func has_reached(target_time: float) -> bool:
	return current_time >= target_time


# Returns remaining time until a target time is reached.
func get_remaining_time(
	target_time: float
) -> float:

	return max(target_time - current_time, 0.0)

# ------------------------------------------------------------------
# Validation Functions
# ------------------------------------------------------------------

func is_running() -> bool:
	return not is_paused

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

func get_summary() -> String:

	return (
		"Time: %.2f | Scale: %.2f | Paused: %s"
		% [
			current_time,
			time_scale,
			str(is_paused)
		]
	)
