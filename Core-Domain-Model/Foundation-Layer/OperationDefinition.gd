##
# OperationDefinition
#
# OperationDefinition is a Foundation Layer data object that defines a
# manufacturing operation used throughout Startup Simulator.
#
# This object describes what an operation is, how long it takes, and what
# attribute modifications it applies to a part when completed.
#
# Examples:
# - Drill Hole
# - Tap Hole
# - Bend
# - Cut
# - Powder Coat
#
# OperationDefinitions are intended to be created as Resource assets and
# referenced by EquipmentDefinitions, PartDefinitions, and runtime production
# systems.
#
# This class contains no execution logic. It does not perform operations,
# track progress, or interact with equipment. It simply defines the operation.
##

class_name OperationDefinition
extends Resource

# ------------------------------------------------------------------
# Basic Operation Information
# ------------------------------------------------------------------

@export var operation_id: int = 0

@export var operation_name: String = ""

@export var operation_category: String = ""

# Time required to perform this operation in game seconds.
# Actual execution is controlled by OperationExecution and MasterClock.
@export var cycle_time_seconds: float = 0.0

# ------------------------------------------------------------------
# Attribute Modifications
# ------------------------------------------------------------------

# Dictionary containing attribute modifications applied when this
# operation completes.
#
# Example:
# {
#     "Precision": 5.0,
#     "Cost": 1.0,
#     "Weight": -0.1
# }
#
# Positive values increase attributes.
# Negative values decrease attributes.
@export var attribute_modifiers: Dictionary = {}

# ------------------------------------------------------------------
# Public Functions
# ------------------------------------------------------------------

# Returns the modifier value for a specific attribute.
# Returns 0.0 if the attribute is not modified by this operation.
func get_modifier(attribute_name: String) -> float:
        return attribute_modifiers.get(attribute_name, 0.0)


# Returns true if this operation affects the specified attribute.
func affects_attribute(attribute_name: String) -> bool:
        return attribute_modifiers.has(attribute_name)


# Sets a modifier value for an attribute.
#
# Primarily intended for editor tooling and future import utilities.
func set_modifier(attribute_name: String, modifier_value: float) -> void:
        attribute_modifiers[attribute_name] = modifier_value


# Returns a list containing all modified attribute names.
#
# Useful for debugging and future validation systems.
func get_modified_attributes() -> Array:
        return attribute_modifiers.keys()
