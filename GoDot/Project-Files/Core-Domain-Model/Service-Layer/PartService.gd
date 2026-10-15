##
# PartService
#
# PartService is a Service Layer object responsible for managing
# Part-related business logic throughout Startup Simulator.
#
# PartService acts as the authoritative service for:
# - Part creation
# - Part validation
# - Operation application
# - PartDefinition matching
# - Attribute evaluation
#
# PartService exists to prevent business logic from being embedded
# directly within Part objects.
#
# Part objects store state.
# PartService performs decisions and actions.
#
# PartService does NOT:
# - Schedule production
# - Manage employees
# - Manage logistics
# - Generate market demand
#
# Those responsibilities belong to other services.
#
# PartService exists to answer the question:
#
#     "How should Parts be created and evaluated?"
##

class_name PartService
extends RefCounted

# ------------------------------------------------------------------
# Part Creation
# ------------------------------------------------------------------

# Creates a new Part from a MaterialDefinition.
func create_part(
	material_definition: MaterialDefinition,
	quantity: int = 1,
	part_definition: PartDefinition = null,
	creation_time: float = 0.0
) -> Part:

	return Part.new(
		material_definition,
		quantity,
		part_definition,
		creation_time
	)

# ------------------------------------------------------------------
# Operation Functions
# ------------------------------------------------------------------

# Applies an Operation to a Part.
#
# Returns true if successful.
func apply_operation(
	part: Part,
	operation: OperationDefinition
) -> bool:

	if part == null:
		return false

	if operation == null:
		return false

	part.apply_operation(operation)

	return true

# ------------------------------------------------------------------
# Part Validation
# ------------------------------------------------------------------

# Returns true if the Part matches its assigned PartDefinition.
func matches_definition(
	part: Part
) -> bool:

	if part == null:
		return false

	return part.matches_definition()


# Returns true if the Part has completed all operations
# required by a specific PartDefinition.
func matches_part_definition(
	part: Part,
	part_definition: PartDefinition
) -> bool:

	if part == null:
		return false

	if part_definition == null:
		return false

	if part.material_definition != part_definition.material_definition:
		return false

	if (
		part.operation_history.size()
		!= part_definition.required_operations.size()
	):
		return false

	for i in range(
		part_definition.required_operations.size()
	):

		if (
			part.operation_history[i]
			!= part_definition.required_operations[i]
		):
			return false

	return true

# ------------------------------------------------------------------
# Attribute Functions
# ------------------------------------------------------------------

# Returns a Part's attribute value.
func get_attribute(
	part: Part,
	attribute_name: String
) -> float:

	if part == null:
		return 0.0

	return part.get_attribute(attribute_name)


# Calculates the total value of a Part.
#
# Initial implementation:
# Base Material Value + Cost Attribute
#
# Future versions can expand this logic.
func calculate_part_value(
	part: Part
) -> float:

	if part == null:
		return 0.0

	var material_value := (
		part.material_definition.base_value
	)

	var cost_attribute := (
		part.get_attribute("Cost")
	)

	return material_value + cost_attribute

# ------------------------------------------------------------------
# Progress Functions
# ------------------------------------------------------------------

# Returns the number of operations completed.
func get_completed_operation_count(
	part: Part
) -> int:

	if part == null:
		return 0

	return part.get_operation_count()


# Returns the number of operations remaining.
func get_remaining_operation_count(
	part: Part,
	part_definition: PartDefinition
) -> int:

	if part == null:
		return 0

	if part_definition == null:
		return 0

	var remaining_count := 0

	for operation in part_definition.required_operations:

		if not part.has_completed_operation(operation):
			remaining_count += 1

	return remaining_count

# ------------------------------------------------------------------
# Quality Functions
# ------------------------------------------------------------------

# Compares a Part against a PartDefinition's TargetAttributes.
#
# Returns a score from 0.0 to 1.0.
#
# This will eventually be used by MarketService when evaluating
# sample submissions.
func calculate_target_match_score(
	part: Part,
	part_definition: PartDefinition
) -> float:

	if part == null:
		return 0.0

	if part_definition == null:
		return 0.0

	if part_definition.target_attributes.is_empty():
		return 1.0

	var total_score: float = 0.0
	var attribute_count: int = 0

	for attribute_name in part_definition.target_attributes.keys():

		var target_value: float = (
			part_definition.target_attributes[
				attribute_name
			]
		)

		if target_value <= 0.0:
			continue

		var actual_value: float = (
			part.get_attribute(attribute_name)
		)

		var score := min(
			actual_value / target_value,
			1.0
		)

		total_score += score
		attribute_count += 1

	if attribute_count <= 0:
		return 1.0

	return total_score / attribute_count

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

func get_summary(
	part: Part
) -> String:

	if part == null:
		return "Invalid Part"

	return (
		"Operations: %d | Value: %.2f"
		% [
			part.get_operation_count(),
			calculate_part_value(part)
		]
	)
