##
# Task
#
# Task is a Production Layer object representing a single executable
# action that can be assigned to an Employee.
#
# Tasks are the atomic units of work within Startup Simulator.
#
# Examples:
# - Move Assembly from Storage to Drill Press
# - Load Part into Machine
# - Execute Drill Operation
# - Unload Part from Machine
# - Move Assembly to Shipping Area
#
# Tasks are generated from WorkInstructions and executed by Employees.
#
# Tasks do not create work, schedule work, or assign themselves.
# Those responsibilities belong to higher-level Production and
# Service Layer systems.
#
# A Task should always represent one clear action that can be
# started and completed.
##

class_name Task
extends RefCounted

# ------------------------------------------------------------------
# Task Types
# ------------------------------------------------------------------

enum TaskType {
        MOVE,
        PICKUP,
        DROPOFF,
        OPERATE_EQUIPMENT,
        WAIT,
        SHIP
}

# ------------------------------------------------------------------
# Identity
# ------------------------------------------------------------------

var task_id: int = 0

var task_name: String = ""

# ------------------------------------------------------------------
# Task Definition
# ------------------------------------------------------------------

var task_type: TaskType = TaskType.WAIT

# ------------------------------------------------------------------
# References
# ------------------------------------------------------------------

# Optional Assembly involved in the task.
var assembly: Assembly = null

# Optional Equipment involved in the task.
var equipment: Equipment = null

# Optional Operation involved in the task.
var operation: OperationDefinition = null

# Optional source location.
var source_location: Location = null

# Optional destination location.
var destination_location: Location = null

# ------------------------------------------------------------------
# Timing
# ------------------------------------------------------------------

var creation_time: float = 0.0

var start_time: float = 0.0

var completion_time: float = 0.0

# ------------------------------------------------------------------
# State
# ------------------------------------------------------------------

var is_started: bool = false

var is_complete: bool = false

var is_cancelled: bool = false

# ------------------------------------------------------------------
# Lifecycle Functions
# ------------------------------------------------------------------

# Marks the Task as started.
func start(current_time: float) -> void:

        if is_complete:
                return

        if is_cancelled:
                return

        is_started = true
        start_time = current_time


# Marks the Task as completed.
func complete(current_time: float) -> void:

        if is_cancelled:
                return

        is_complete = true
        completion_time = current_time


# Cancels the Task.
func cancel() -> void:

        if is_complete:
                return

        is_cancelled = true

# ------------------------------------------------------------------
# Status Functions
# ------------------------------------------------------------------

func can_start() -> bool:

        if is_started:
                return false

        if is_complete:
                return false

        if is_cancelled:
                return false

        return true


func is_active() -> bool:

        return (
                is_started
                and not is_complete
                and not is_cancelled
        )


func get_duration() -> float:

        if not is_complete:
                return 0.0

        return completion_time - start_time

# ------------------------------------------------------------------
# Validation Functions
# ------------------------------------------------------------------

func is_valid_task() -> bool:

        if task_name.is_empty():
                return false

        return true

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

func get_summary() -> String:

        return "%s | Started: %s | Complete: %s" % [
                task_name,
                str(is_started),
                str(is_complete)
        ]
