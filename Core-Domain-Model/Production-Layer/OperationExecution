##
# OperationExecution
#
# OperationExecution is a Production Layer object representing a single
# manufacturing operation currently being performed on a Part by a
# specific piece of Equipment.
#
# This object is created when production begins and exists until the
# operation completes or is cancelled.
#
# Responsibilities:
# - Track the Equipment performing the work
# - Track the Part being modified
# - Track the Operation being executed
# - Track start and completion times
# - Determine completion status
# - Apply the Operation to the Part when completed
#
# OperationExecution does NOT:
# - Schedule work
# - Assign employees
# - Create jobs
# - Generate tasks
# - Manage orders
#
# Those concerns belong to higher-level Production Layer and Service
# Layer objects.
#
# In Startup Simulator, OperationExecution is the atomic unit of
# manufacturing work.
##

class_name OperationExecution
extends RefCounted

# ------------------------------------------------------------------
# Identity
# ------------------------------------------------------------------

var execution_id: int = 0

# ------------------------------------------------------------------
# References
# ------------------------------------------------------------------

# Machine performing the operation.
var equipment: Equipment = null

# Part being modified.
var part: Part = null

# Operation currently being performed.
var operation: OperationDefinition = null

# ------------------------------------------------------------------
# Timing
# ------------------------------------------------------------------

# MasterClock time when execution started.
var start_time: float = 0.0

# MasterClock time when execution should complete.
var completion_time: float = 0.0

# ------------------------------------------------------------------
# State
# ------------------------------------------------------------------

var is_complete: bool = false

var is_cancelled: bool = false

# Prevents duplicate application of the operation.
var operation_applied: bool = false

# ------------------------------------------------------------------
# Initialization
# ------------------------------------------------------------------

func _init(
        new_equipment: Equipment,
        new_part: Part,
        new_operation: OperationDefinition,
        current_time: float
) -> void:

        equipment = new_equipment
        part = new_part
        operation = new_operation

        start_time = current_time

        if operation != null:
                completion_time = (
                        current_time +
                        operation.cycle_time_seconds
                )

# ------------------------------------------------------------------
# Status Functions
# ------------------------------------------------------------------

# Returns true when enough MasterClock time has elapsed
# for the operation to complete.
func is_ready_to_complete(current_time: float) -> bool:

        if is_cancelled:
                return false

        if is_complete:
                return false

        return current_time >= completion_time


# Returns remaining execution time.
func get_remaining_time(current_time: float) -> float:

        if is_complete:
                return 0.0

        return max(completion_time - current_time, 0.0)


# Returns operation progress from 0.0 to 1.0.
func get_progress(current_time: float) -> float:

        var total_duration: float = (
                completion_time -
                start_time
        )

        if total_duration <= 0.0:
                return 1.0

        var elapsed_time: float = (
                current_time -
                start_time
        )

        return clamp(
                elapsed_time / total_duration,
                0.0,
                1.0
        )

# ------------------------------------------------------------------
# Completion Functions
# ------------------------------------------------------------------

# Completes the execution and applies the operation
# to the Part.
#
# Returns true if completion succeeded.
func complete(current_time: float) -> bool:

        if not is_ready_to_complete(current_time):
                return false

        if operation_applied:
                return false

        if part == null:
                return false

        if operation == null:
                return false

        part.apply_operation(operation)

        operation_applied = true
        is_complete = true

        return true


# Cancels execution before completion.
func cancel() -> void:

        if is_complete:
                return

        is_cancelled = true

# ------------------------------------------------------------------
# Validation Functions
# ------------------------------------------------------------------

func is_valid_execution() -> bool:

        if equipment == null:
                return false

        if part == null:
                return false

        if operation == null:
                return false

        return true

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

# Returns a human-readable status summary.
func get_summary() -> String:

        var operation_name: String = "Unknown"

        if operation != null:
                operation_name = operation.operation_name

        return "%s | Complete: %s | Cancelled: %s" % [
                operation_name,
                str(is_complete),
                str(is_cancelled)
        ]
