##
# PartDefinition
#
# PartDefinition is a Foundation Layer data object that defines a
# reusable manufacturing blueprint used throughout Startup Simulator.
#
# A PartDefinition describes the intended design of a part, including
# its starting material and the ordered sequence of operations required
# to manufacture it.
#
# Examples:
# - Mounting Plate
# - Support Bracket
# - Motor Base
# - Sheet Metal Cover
#
# PartDefinitions are used for production planning, work instructions,
# market samples, contracts, and order generation.
#
# A PartDefinition is NOT a manufactured part. It contains no runtime
# state, no inventory information, and no production progress.
# Runtime Part objects represent physical products that exist in the
# game world.
#
# This class serves as the "recipe" that manufacturing attempts to
# produce.
##

class_name PartDefinition
extends Resource

# ------------------------------------------------------------------
# Basic Part Information
# ------------------------------------------------------------------

@export var part_definition_id: int = 0

@export var part_name: String = ""

@export_multiline var description: String = ""

# ------------------------------------------------------------------
# Material Requirements
# ------------------------------------------------------------------

# The starting material required to manufacture this part.
@export var material_definition: MaterialDefinition

# ------------------------------------------------------------------
# Manufacturing Requirements
# ------------------------------------------------------------------

# Ordered list of operations required to create this part.
#
# Operation order matters.
#
# Example:
# 1. Cut
# 2. Drill Hole
# 3. Powder Coat
#
# The resulting runtime Part should contain an operation history that
# matches this sequence.
@export var required_operations: Array[OperationDefinition] = []

# ------------------------------------------------------------------
# Target Attributes
# ------------------------------------------------------------------

# Intended product outcome.
#
# These values are not enforced directly by this class but can be used
# later for validation, quality checks, market evaluation, and sample
# submission scoring.
#
# Example:
# {
#     "Strength": 90.0,
#     "CorrosionResistance": 60.0
# }
@export var target_attributes: Dictionary = {}

# ------------------------------------------------------------------
# Public Functions
# ------------------------------------------------------------------

# Returns the number of operations required to manufacture this part.
func get_operation_count() -> int:
        return required_operations.size()


# Returns a required operation by index.
#
# Returns null if the index is invalid.
func get_operation(index: int) -> OperationDefinition:
        if index < 0 or index >= required_operations.size():
                return null

        return required_operations[index]


# Returns true if the specified operation exists within this recipe.
func requires_operation(operation: OperationDefinition) -> bool:
        return required_operations.has(operation)


# Returns a list of operation names in manufacturing order.
#
# Useful for UI displays, debugging, and production planning.
func get_operation_names() -> Array[String]:
        var operation_names: Array[String] = []

        for operation in required_operations:
                operation_names.append(operation.operation_name)

        return operation_names


# Returns a target attribute value.
#
# Returns 0.0 if the attribute has not been defined.
func get_target_attribute(attribute_name: String) -> float:
        return target_attributes.get(attribute_name, 0.0)


# Returns true if a target attribute exists.
func has_target_attribute(attribute_name: String) -> bool:
        return target_attributes.has(attribute_name)
