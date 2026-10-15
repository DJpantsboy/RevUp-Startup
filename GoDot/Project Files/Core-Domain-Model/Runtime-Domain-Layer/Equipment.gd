##
# Equipment
#
# Equipment is a Runtime Domain Layer object representing a physical
# machine placed within the Startup Simulator world.
#
# Equipment is the runtime counterpart to EquipmentDefinition.
#
# While EquipmentDefinition describes what a machine type is capable
# of doing, Equipment represents a specific machine owned by the
# company and placed on a ShopFloor.
#
# Equipment is responsible for:
# - Tracking machine state
# - Tracking the current Part being processed
# - Tracking the currently executing operation
# - Tracking machine availability
#
# Equipment does NOT:
# - Perform market functions
# - Manage employees
# - Create production schedules
# - Generate operations
#
# ProductionService and OperationExecution coordinate work while
# Equipment simply represents the machine performing it.
##

class_name Equipment
extends RefCounted

# ------------------------------------------------------------------
# Identity
# ------------------------------------------------------------------

var equipment_id: int = 0

var equipment_definition: EquipmentDefinition = null

# ------------------------------------------------------------------
# Runtime State
# ------------------------------------------------------------------

# Whether the machine is currently available to accept work.
var is_available: bool = true

# Whether the machine is currently powered on.
var is_powered_on: bool = true

# Current Part being worked on.
var active_part: Part = null

# Current operation being performed.
var active_operation: OperationDefinition = null

# Active operation execution.
#
# This will be owned and managed by ProductionService.
var operation_execution: OperationExecution = null

# ------------------------------------------------------------------
# Part Handling
# ------------------------------------------------------------------

# Loads a Part into the machine.
func load_part(part: Part) -> bool:

        if part == null:
                return false

        if active_part != null:
                return false

        active_part = part

        return true


# Removes and returns the currently loaded Part.
func unload_part() -> Part:

        var unloaded_part: Part = active_part

        active_part = null

        return unloaded_part


# Returns true if a Part is currently loaded.
func has_part() -> bool:
        return active_part != null

# ------------------------------------------------------------------
# Operation Support
# ------------------------------------------------------------------

# Returns true if this machine supports the specified operation.
func supports_operation(operation: OperationDefinition) -> bool:

        if equipment_definition == null:
                return false

        return equipment_definition.supports_operation(operation)


# Returns true if the machine is ready to begin work.
func can_start_operation(operation: OperationDefinition) -> bool:

        if not is_available:
                return false

        if not is_powered_on:
                return false

        if active_part == null:
                return false

        if not supports_operation(operation):
                return false

        return true

# ------------------------------------------------------------------
# Operation State
# ------------------------------------------------------------------

# Called when an operation officially begins.
func start_operation(
        operation: OperationDefinition,
        execution: OperationExecution
) -> bool:

        if not can_start_operation(operation):
                return false

        active_operation = operation
        operation_execution = execution

        is_available = false

        return true


# Called when an operation completes.
func complete_operation() -> void:

        active_operation = null
        operation_execution = null

        is_available = true


# Returns true if the machine is currently busy.
func is_busy() -> bool:
        return not is_available

# ------------------------------------------------------------------
# Utility Functions
# ------------------------------------------------------------------

# Returns the machine's display name.
func get_equipment_name() -> String:

        if equipment_definition == null:
                return "Unknown Equipment"

        return equipment_definition.equipment_name


# Returns the list of supported operation names.
func get_supported_operation_names() -> Array[String]:

        if equipment_definition == null:
                return []

        return equipment_definition.get_supported_operation_names()

# ------------------------------------------------------------------
# Validation Functions
# ------------------------------------------------------------------

# Confirms that the Equipment has a valid definition assigned.
func has_valid_definition() -> bool:
        return equipment_definition != null


# Returns a summary string useful for debugging and UI displays.
func get_summary() -> String:

        var operation_name: String = "Idle"

        if active_operation != null:
                operation_name = active_operation.operation_name

        return "%s | Busy: %s | Operation: %s" % [
                get_equipment_name(),
                str(is_busy()),
                operation_name
        ]
