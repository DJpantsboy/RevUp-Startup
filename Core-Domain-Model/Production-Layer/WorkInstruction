##
# WorkInstruction
#
# WorkInstruction is a Production Layer object that defines a
# manufacturing process for a specific PartDefinition.
#
# A WorkInstruction does not represent a single production run.
# Instead, it defines the set of operations that should be performed
# when manufacturing a particular type of part.
#
# Examples:
#
# Work Instruction 1:
# - Retrieve Material
# - Perform Bend
#
# Work Instruction 2:
# - Perform Drill Hole #1
# - Perform Drill Hole #2
#
# Work Instruction 3:
# - Perform Powder Coat
#
# Work Instruction 4:
# - Ship Product
#
# Employees use WorkInstructions as templates for generating and
# executing Tasks.
#
# WorkInstructions do not:
# - Move parts
# - Assign employees
# - Operate equipment
# - Schedule work
#
# Those responsibilities belong to Tasks, Employees,
# ProductionJobs, and Services.
##

class_name WorkInstruction
extends RefCounted

# ------------------------------------------------------------------
# Identity
# ------------------------------------------------------------------

var work_instruction_id: int = 0

var work_instruction_name: String = ""

var description: String = ""

# ------------------------------------------------------------------
# Product Definition
# ------------------------------------------------------------------

# The PartDefinition this instruction applies to.
var part_definition: PartDefinition = null

# ------------------------------------------------------------------
# Manufacturing Scope
# ------------------------------------------------------------------

# Operations this WorkInstruction is responsible for completing.
#
# Example:
# [
#     BendOperation
# ]
#
# Or:
#
# [
#     DrillHole1,
#     DrillHole2
# ]
var required_operations: Array[OperationDefinition] = []

# ------------------------------------------------------------------
# Material Handling
# ------------------------------------------------------------------

# Optional source location.
#
# Example:
# Material Rack
# Machine Queue
# Storage Area
var source_location: Location = null

# Optional destination location.
#
# Example:
# Drill Press Queue
# Paint Booth Queue
# Shipping Area
var destination_location: Location = null

# ------------------------------------------------------------------
# Validation Functions
# ------------------------------------------------------------------

# Returns true if the instruction has a valid PartDefinition.
func has_valid_part_definition() -> bool:
        return part_definition != null


# Returns true if the instruction contains work.
func has_operations() -> bool:
        return required_operations.size() > 0


# Returns true if the instruction is usable.
func is_valid_instruction() -> bool:

        if not has_valid_part_definition():
                return false

        if not has_operations():
                return false

        return true

# ------------------------------------------------------------------
# Operation Functions
# ------------------------------------------------------------------

# Returns the number of operations contained in the instruction.
func get_operation_count() -> int:
        return required_operations.size()


# Returns true if the instruction contains the operation.
func contains_operation(
        operation: OperationDefinition
) -> bool:

        return required_operations.has(operation)


# Returns operation names for UI and debugging.
func get_operation_names() -> Array[String]:

        var operation_names: Array[String] = []

        for operation in required_operations:
                operation_names.append(
                        operation.operation_name
                )

        return operation_names

# ------------------------------------------------------------------
# Runtime Evaluation
# ------------------------------------------------------------------

# Determines whether a Part still requires any of the
# operations managed by this WorkInstruction.
#
# This allows partially completed Parts to resume production
# without requiring special-case logic.
func part_requires_work(part: Part) -> bool:

        if part == null:
                return false

        for operation in required_operations:

                if not part.has_completed_operation(operation):
                        return true

        return false


# Returns operations from this instruction that
# are still incomplete on the provided Part.
func get_remaining_operations(
        part: Part
) -> Array[OperationDefinition]:

        var remaining_operations: Array[
                OperationDefinition
        ] = []

        if part == null:
                return remaining_operations

        for operation in required_operations:

                if not part.has_completed_operation(operation):
                        remaining_operations.append(operation)

        return remaining_operations

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

func get_summary() -> String:

        return "%s | Operations: %d" % [
                work_instruction_name,
                required_operations.size()
        ]
