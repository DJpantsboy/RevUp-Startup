##
# TimerTask
#
# TimerTask is a Time Layer object representing an active countdown
# tied to MasterClock time.
#
# TimerTasks are used to track activities that require a duration
# to complete.
#
# Examples:
# - Equipment Operation Duration
# - Employee Waiting Period
# - Delivery Transit Time
# - Contract Evaluation Delay
# - Equipment Installation Time
#
# TimerTask does NOT:
# - Advance time
# - Schedule events
# - Perform business logic
# - Manage production
#
# Those responsibilities belong to MasterClock and the systems
# utilizing the TimerTask.
#
# TimerTask exists to answer the question:
#
#     "How much time remains until this activity completes?"
##

class_name TimerTask
extends RefCounted

# ------------------------------------------------------------------
# Identity
# ------------------------------------------------------------------

var task_id: int = 0

var task_name: String = ""

# ------------------------------------------------------------------
# Timing
# ------------------------------------------------------------------

# MasterClock time when the task started.
var start_time: float = 0.0

# Duration of the task in game seconds.
var duration: float = 0.0

# Calculated completion time.
var completion_time: float = 0.0

# ------------------------------------------------------------------
# State
# ------------------------------------------------------------------

var is_complete: bool = false

var is_cancelled: bool = false

# ------------------------------------------------------------------
# Initialization
# ------------------------------------------------------------------

func _init(
	new_task_name: String = "",
	new_start_time: float = 0.0,
	new_duration: float = 0.0
) -> void:

	task_name = new_task_name
	start_time = new_start_time
	duration = max(new_duration, 0.0)

	completion_time = start_time + duration

# ------------------------------------------------------------------
# Status Functions
# ------------------------------------------------------------------

# Returns true if enough time has passed
# for the task to complete.
func is_ready_to_complete(
	current_time: float
) -> bool:

	if is_complete:
		return false

	if is_cancelled:
		return false

	return current_time >= completion_time


# Returns progress from 0.0 to 1.0.
func get_progress(
	current_time: float
) -> float:

	if duration <= 0.0:
		return 1.0

	var elapsed_time: float = (
		current_time - start_time
	)

	return clamp(
		elapsed_time / duration,
		0.0,
		1.0
	)


# Returns remaining time.
func get_remaining_time(
	current_time: float
) -> float:

	if is_complete:
		return 0.0

	return max(
		completion_time - current_time,
		0.0
	)

# ------------------------------------------------------------------
# Lifecycle Functions
# ------------------------------------------------------------------

# Marks the task as complete.
func complete() -> void:

	if is_cancelled:
		return

	is_complete = true


# Cancels the task.
func cancel() -> void:

	if is_complete:
		return

	is_cancelled = true


# Returns true if the task is currently active.
func is_active() -> bool:

	return (
		not is_complete
		and not is_cancelled
	)

# ------------------------------------------------------------------
# Validation Functions
# ------------------------------------------------------------------

func is_valid_task() -> bool:

	if task_name.is_empty():
		return false

	if duration < 0.0:
		return false

	return true

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

func get_summary() -> String:

	return "%s | Duration: %.2f | Complete: %s" % [
		task_name,
		duration,
		str(is_complete)
	]
