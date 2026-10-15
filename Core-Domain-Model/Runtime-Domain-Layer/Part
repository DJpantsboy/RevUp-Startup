##
# Part
#
# Part is a Runtime Domain Layer object representing a physical product
# that exists within the Startup Simulator world.
#
# A Part is defined by:
# - A starting MaterialDefinition
# - A quantity
# - An ordered history of completed operations
#
# The Part's attributes are calculated from its material and operation
# history. Attributes are never manually assigned except during
# initialization from the material.
#
# Parts are the fundamental products of manufacturing and may be sold
# directly or grouped into Assemblies.
#
# This class contains no knowledge of markets, orders, employees,
# companies, contracts, or production scheduling.
##

class_name Part
extends RefCounted

# ------------------------------------------------------------------
# Identity
# ------------------------------------------------------------------

var part_id: int = 0

# Optional reference to the blueprint this Part was intended to follow.
var part_definition: PartDefinition = null

# ------------------------------------------------------------------
# Material Information
# ------------------------------------------------------------------

var material_definition: MaterialDefinition = null
# ------------------------------------------------------------------
# Lifecycle Information
# ------------------------------------------------------------------

# MasterClock time when this Part was created.
#
# Useful for reporting, inventory aging, lead time calculations,
# order analysis, and future business metrics.
var creation_time: float = 0.0
# ------------------------------------------------------------------
# Manufacturing History
# ------------------------------------------------------------------

# Ordered list of operations that have been completed.
var operation_history: Array[OperationDefinition] = []

# ------------------------------------------------------------------
# Physical Information
# ------------------------------------------------------------------

var quantity: int = 1

# ------------------------------------------------------------------
# Calculated Attributes
# ------------------------------------------------------------------

# Runtime attribute values.
#
# Initialized from the material and modified as operations are applied.
var attributes: Dictionary = {}

# ------------------------------------------------------------------
# Initialization
# ------------------------------------------------------------------

func _init(
        new_material_definition: MaterialDefinition,
        new_quantity: int = 1,
        new_part_definition: PartDefinition = null,
        new_creation_time: float = 0.0
) -> void:

        material_definition = new_material_definition
        quantity = max(new_quantity, 1)
        part_definition = new_part_definition
        creation_time = new_creation_time

        _initialize_attributes()


# Copies the material's starting attributes into this part.
func _initialize_attributes() -> void:
        if material_definition == null:
                return

        attributes = material_definition.attributes.duplicate(true)

# ------------------------------------------------------------------
# Operations
# ------------------------------------------------------------------

# Applies a completed operation to the Part.
#
# This should only be called after an OperationExecution has
# successfully completed.
func apply_operation(operation: OperationDefinition) -> void:

        if operation == null:
                return

        operation_history.append(operation)

        for attribute_name in operation.attribute_modifiers.keys():

                var modifier: float = operation.attribute_modifiers[attribute_name]

                if not attributes.has(attribute_name):
                        attributes[attribute_name] = 0.0

                attributes[attribute_name] += modifier

# ------------------------------------------------------------------
# Attribute Functions
# ------------------------------------------------------------------

# Returns an attribute value.
#
# Returns 0.0 if the attribute does not exist.
func get_attribute(attribute_name: String) -> float:
        return attributes.get(attribute_name, 0.0)


# Returns true if the Part contains an attribute.
func has_attribute(attribute_name: String) -> bool:
        return attributes.has(attribute_name)
# ------------------------------------------------------------------
# Lifecycle Functions
# Returns the age of the Part relative to current MasterClock time.
func get_age(current_time: float) -> float:
    return max(current_time - creation_time, 0.0)
# ------------------------------------------------------------------
# Operation History Functions
# ------------------------------------------------------------------

# Returns the number of completed operations.
func get_operation_count() -> int:
        return operation_history.size()


# Returns true if the Part has completed the specified operation.
func has_completed_operation(operation: OperationDefinition) -> bool:
        return operation_history.has(operation)


# Returns a list of operation names for debugging and UI display.
func get_operation_names() -> Array[String]:

        var operation_names: Array[String] = []

        for operation in operation_history:
                operation_names.append(operation.operation_name)

        return operation_names

# ------------------------------------------------------------------
# Validation Functions
# ------------------------------------------------------------------

# Returns true if this Part matches its assigned PartDefinition.
#
# Useful for order fulfillment, work instructions, and quality checks.
func matches_definition() -> bool:

        if part_definition == null:
                return false

        if material_definition != part_definition.material_definition:
                return false

        if operation_history.size() != part_definition.required_operations.size():
                return false

        for i in range(operation_history.size()):

                if operation_history[i] != part_definition.required_operations[i]:
                        return false

        return true
