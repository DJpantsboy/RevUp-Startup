##
# Employee
#
# Employee is a Runtime Domain Layer object representing a worker
# employed by the player's company.
#
# In the initial implementation, Employees are responsible for:
# - Following WorkInstructions
# - Executing Tasks
# - Moving Parts and Assemblies
# - Operating Equipment
#
# Employees are intentionally simple during early development.
# Systems such as skills, certifications, wages, morale, leadership,
# attendance, and productivity modifiers are reserved for future
# expansion.
#
# Employees do not generate work, schedules, or production plans.
# These responsibilities belong to the appropriate Service Layer
# systems.
#
# Employee serves as the runtime representation of a worker currently
# participating in production activities.
##

class_name Employee
extends RefCounted

# ------------------------------------------------------------------
# Identity
# ------------------------------------------------------------------

var employee_id: int = 0

var employee_name: String = ""

# ------------------------------------------------------------------
# Assignment State
# ------------------------------------------------------------------

# Current WorkInstruction assigned to this employee.
var active_work_instruction: WorkInstruction = null

# Current Task being executed.
var active_task: Task = null

# ------------------------------------------------------------------
# Inventory State
# ------------------------------------------------------------------

# Employees may only carry one Assembly at a time.
#
# Since every Part is treated as an Assembly of one, this allows
# a single handling system for all products.
var carried_assembly: Assembly = null

# ------------------------------------------------------------------
# Availability State
# ------------------------------------------------------------------

var is_available: bool = true

# ------------------------------------------------------------------
# Work Instruction Functions
# ------------------------------------------------------------------

# Assigns a WorkInstruction to this employee.
func assign_work_instruction(
        work_instruction: WorkInstruction
) -> bool:

        if work_instruction == null:
                return false

        active_work_instruction = work_instruction

        return true


# Clears the current WorkInstruction.
func clear_work_instruction() -> void:
        active_work_instruction = null

# ------------------------------------------------------------------
# Task Functions
# ------------------------------------------------------------------

# Assigns a Task to this employee.
func assign_task(task: Task) -> bool:

        if task == null:
                return false

        active_task = task
        is_available = false

        return true


# Completes the current Task.
func complete_task() -> void:

        active_task = null
        is_available = true

# ------------------------------------------------------------------
# Inventory Functions
# ------------------------------------------------------------------

# Returns true if the employee is carrying something.
func is_carrying_assembly() -> bool:
        return carried_assembly != null


# Attempts to pick up an Assembly.
func pick_up_assembly(
        assembly: Assembly
) -> bool:

        if assembly == null:
                return false

        if carried_assembly != null:
                return false

        carried_assembly = assembly

        return true


# Drops and returns the currently carried Assembly.
func drop_assembly() -> Assembly:

        var dropped_assembly: Assembly = carried_assembly

        carried_assembly = null

        return dropped_assembly

# ------------------------------------------------------------------
# Status Functions
# ------------------------------------------------------------------

# Returns true if the employee is available for work.
func can_accept_work() -> bool:

        if not is_available:
                return false

        if active_task != null:
                return false

        return true


# Returns true if the employee currently has an assigned
# WorkInstruction.
func has_work_instruction() -> bool:
        return active_work_instruction != null


# Returns true if the employee currently has an active Task.
func has_task() -> bool:
        return active_task != null

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

# Returns a human-readable summary useful for debugging and UI.
func get_summary() -> String:

        return "%s | Available: %s | Carrying: %s" % [
                employee_name,
                str(is_available),
                str(is_carrying_assembly())
        ]
