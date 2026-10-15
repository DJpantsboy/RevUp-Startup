##
# ScheduledEvent
#
# ScheduledEvent is a Time Layer object representing an event
# that should occur at a specific MasterClock time.
#
# ScheduledEvents are used to schedule future actions throughout
# Startup Simulator.
#
# Examples:
# - Delivery Arrival
# - Delivery Departure
# - Market Refresh
# - Contract Expiration
# - Payroll Processing
# - Equipment Delivery
#
# ScheduledEvent does NOT:
# - Execute business logic
# - Manage production
# - Manage logistics
# - Manage market systems
#
# Those responsibilities belong to the systems that create and
# consume ScheduledEvents.
#
# ScheduledEvent exists to answer the question:
#
#     "When should this happen?"
##

class_name ScheduledEvent
extends RefCounted

# ------------------------------------------------------------------
# Identity
# ------------------------------------------------------------------

var event_id: int = 0

var event_name: String = ""

var description: String = ""

# ------------------------------------------------------------------
# Timing
# ------------------------------------------------------------------

# MasterClock time when this event should occur.
var scheduled_time: float = 0.0

# ------------------------------------------------------------------
# State
# ------------------------------------------------------------------

var is_triggered: bool = false

var is_cancelled: bool = false

# ------------------------------------------------------------------
# Event Functions
# ------------------------------------------------------------------

# Returns true if the event should occur.
func is_ready(
	current_time: float
) -> bool:

	if is_triggered:
		return false

	if is_cancelled:
		return false

	return current_time >= scheduled_time


# Marks the event as having occurred.
func trigger() -> void:

	if is_cancelled:
		return

	is_triggered = true


# Cancels the event.
func cancel() -> void:

	if is_triggered:
		return

	is_cancelled = true

# ------------------------------------------------------------------
# Status Functions
# ------------------------------------------------------------------

# Returns the remaining time until the event occurs.
func get_remaining_time(
	current_time: float
) -> float:

	if is_triggered:
		return 0.0

	return max(
		scheduled_time - current_time,
		0.0
	)


# Returns true if the event is still active.
func is_active() -> bool:

	return (
		not is_triggered
		and not is_cancelled
	)

# ------------------------------------------------------------------
# Validation Functions
# ------------------------------------------------------------------

func is_valid_event() -> bool:

	if event_name.is_empty():
		return false

	return true

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

func get_summary() -> String:

	return "%s | Triggered: %s | Cancelled: %s" % [
		event_name,
		str(is_triggered),
		str(is_cancelled)
	]
