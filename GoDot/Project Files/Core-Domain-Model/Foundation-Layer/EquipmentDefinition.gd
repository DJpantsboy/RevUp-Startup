##
# EquipmentDefinition
#
# EquipmentDefinition is a Foundation Layer data object that defines a machine
# type used throughout Startup Simulator.
#
# This object describes the static characteristics of a machine, including
# its identity, purchase cost, supported operations, footprint, and utility
# requirements.
#
# Examples:
# - Floor Drill Press
# - CNC Mill
# - Brake Press
# - Bandsaw
# - Powder Coat Booth
#
# EquipmentDefinitions are intended to be created as Resource assets and
# referenced by runtime Equipment objects.
#
# This class contains no execution logic and no world state. It does not
# track position, inventory, operators, jobs, or production progress.
# Its sole purpose is to define what a machine type is capable of doing.
##

class_name EquipmentDefinition
extends Resource

# ------------------------------------------------------------------
# Basic Equipment Information
# ------------------------------------------------------------------

@export var equipment_id: int = 0

@export var equipment_name: String = ""

@export var equipment_category: String = ""

# Purchase price of the equipment.
@export var purchase_cost: float = 0.0

# ------------------------------------------------------------------
# Equipment Capabilities
# ------------------------------------------------------------------

# List of operations this machine can perform.
#
# Example:
# Drill Press
# [
#     DrillHoleOperation,
#     DrillAndTapOperation
# ]
#
# Stored as OperationDefinition resources.
@export var supported_operations: Array[OperationDefinition] = []

# ------------------------------------------------------------------
# Physical Properties
# ------------------------------------------------------------------

# Floor space required by the machine.
#
# Uses tile units rather than world coordinates so the system remains
# independent from specific maps or scenes.
@export var footprint_width: int = 1

@export var footprint_height: int = 1

# ------------------------------------------------------------------
# Utility Requirements
# ------------------------------------------------------------------

# Future-proofing for later facility management systems.
#
# These are intentionally simple for now and may not be used during
# the first vertical slice.
@export var power_usage: float = 0.0

@export var requires_compressed_air: bool = false

@export var requires_water: bool = false

# ------------------------------------------------------------------
# Public Functions
# ------------------------------------------------------------------

# Returns true if this machine supports the specified operation.
func supports_operation(operation: OperationDefinition) -> bool:
        return supported_operations.has(operation)


# Returns true if this machine supports an operation with the
# specified name.
#
# Useful for debugging and editor validation.
func supports_operation_name(operation_name: String) -> bool:
        for operation in supported_operations:
                if operation.operation_name == operation_name:
                        return true

        return false


# Returns a list of operation names supported by this machine.
#
# Primarily useful for UI generation and debugging.
func get_supported_operation_names() -> Array[String]:
        var operation_names: Array[String] = []

        for operation in supported_operations:
                operation_names.append(operation.operation_name)

        return operation_names
