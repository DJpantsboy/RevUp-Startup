##
# AssemblyService
#
# AssemblyService is a Service Layer object responsible for managing
# Assembly-related business logic throughout Startup Simulator.
#
# AssemblyService acts as the authoritative service for:
# - Assembly creation
# - Assembly validation
# - Assembly merging
# - Assembly composition evaluation
# - Assembly attribute analysis
#
# Assembly objects store structure and state.
# AssemblyService performs decisions and actions.
#
# AssemblyService does NOT:
# - Manage inventory
# - Perform logistics
# - Schedule production
# - Assign employees
#
# Those responsibilities belong to other services.
#
# AssemblyService exists to answer the question:
#
#     "How should Assemblies be created and managed?"
##

class_name AssemblyService
extends RefCounted

# ------------------------------------------------------------------
# Assembly Creation
# ------------------------------------------------------------------

# Creates an empty Assembly.
func create_assembly(
	assembly_name: String = ""
) -> Assembly:

	var assembly := Assembly.new()
	assembly.assembly_name = assembly_name

	return assembly


# Creates an Assembly containing a single Part.
#
# Supports the Sacred Framework rule that every Part may be
# treated as an Assembly of one.
func create_assembly_from_part(
	part: Part,
	assembly_name: String = ""
) -> Assembly:

	if part == null:
		return null

	var assembly := create_assembly(assembly_name)

	assembly.add_part(part)

	return assembly

# ------------------------------------------------------------------
# Assembly Modification
# ------------------------------------------------------------------

# Adds a Part to an Assembly.
func add_part(
	assembly: Assembly,
	part: Part
) -> bool:

	if assembly == null:
		return false

	if part == null:
		return false

	assembly.add_part(part)

	return true


# Adds a child Assembly.
func add_subassembly(
	parent_assembly: Assembly,
	child_assembly: Assembly
) -> bool:

	if parent_assembly == null:
		return false

	if child_assembly == null:
		return false

	parent_assembly.add_subassembly(
		child_assembly
	)

	return true


# Merges one Assembly into another.
func merge_assemblies(
	target_assembly: Assembly,
	source_assembly: Assembly
) -> bool:

	if target_assembly == null:
		return false

	if source_assembly == null:
		return false

	if target_assembly == source_assembly:
		return false

	target_assembly.merge_assembly(
		source_assembly
	)

	return true

# ------------------------------------------------------------------
# Assembly Evaluation
# ------------------------------------------------------------------

# Returns total Parts contained within an Assembly.
func get_total_part_count(
	assembly: Assembly
) -> int:

	if assembly == null:
		return 0

	return assembly.get_total_part_count()


# Returns combined Assembly attributes.
func get_combined_attributes(
	assembly: Assembly
) -> Dictionary:

	if assembly == null:
		return {}

	return assembly.get_combined_attributes()


# Returns a specific Assembly attribute.
func get_attribute(
	assembly: Assembly,
	attribute_name: String
) -> float:

	if assembly == null:
		return 0.0

	return assembly.get_attribute(
		attribute_name
	)

# ------------------------------------------------------------------
# Validation Functions
# ------------------------------------------------------------------

func is_valid_assembly(
	assembly: Assembly
) -> bool:

	if assembly == null:
		return false

	return (
		assembly.get_total_part_count() > 0
	)


# Returns true if the Assembly contains any Parts.
func has_parts(
	assembly: Assembly
) -> bool:

	if assembly == null:
		return false

	return (
		assembly.get_total_part_count() > 0
	)

# ------------------------------------------------------------------
# Analysis Functions
# ------------------------------------------------------------------

# Returns the total number of direct Parts.
func get_direct_part_count(
	assembly: Assembly
) -> int:

	if assembly == null:
		return 0

	return assembly.get_part_count()


# Returns the total number of direct Subassemblies.
func get_subassembly_count(
	assembly: Assembly
) -> int:

	if assembly == null:
		return 0

	return assembly.get_subassembly_count()

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

func get_summary(
	assembly: Assembly
) -> String:

	if assembly == null:
		return "Invalid Assembly"

	return (
		"Parts: %d | Total Parts: %d"
		% [
			assembly.get_part_count(),
			assembly.get_total_part_count()
		]
	)
