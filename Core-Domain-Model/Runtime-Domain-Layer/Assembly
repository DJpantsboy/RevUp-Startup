##
# Assembly
#
# Assembly is a Runtime Domain Layer object representing a collection
# of Parts and/or other Assemblies.
#
# Assemblies allow complex products to be built from multiple
# individual components while maintaining a consistent logistics model.
#
# A key design rule of Startup Simulator is that every Part is treated
# as an Assembly containing one Part. This allows storage, shipping,
# employee handling, and inventory systems to interact with a single
# object type.
#
# Assemblies contain no manufacturing logic and do not perform
# operations. They merely organize Parts into larger structures.
#
# Examples:
# - Single steel bracket
# - Welded frame assembly
# - Multi-component machine subassembly
# - Finished customer product
##

class_name Assembly
extends RefCounted

# ------------------------------------------------------------------
# Identity
# ------------------------------------------------------------------

var assembly_id: int = 0

var assembly_name: String = ""

# ------------------------------------------------------------------
# Contents
# ------------------------------------------------------------------

# Direct Parts contained within this Assembly.
var parts: Array[Part] = []

# Child Assemblies contained within this Assembly.
var subassemblies: Array[Assembly] = []

# ------------------------------------------------------------------
# Part Management
# ------------------------------------------------------------------

# Adds a Part to the Assembly.
func add_part(part: Part) -> void:

        if part == null:
                return

        parts.append(part)


# Removes a Part from the Assembly.
func remove_part(part: Part) -> void:
        parts.erase(part)


# Returns true if the Assembly contains the specified Part.
func contains_part(part: Part) -> bool:
        return parts.has(part)

# ------------------------------------------------------------------
# Subassembly Management
# ------------------------------------------------------------------

# Adds a child Assembly.
func add_subassembly(assembly: Assembly) -> void:

        if assembly == null:
                return

        if assembly == self:
                return

        subassemblies.append(assembly)


# Removes a child Assembly.
func remove_subassembly(assembly: Assembly) -> void:
        subassemblies.erase(assembly)

# ------------------------------------------------------------------
# Counting Functions
# ------------------------------------------------------------------

# Returns the number of Parts directly contained by this Assembly.
func get_part_count() -> int:
        return parts.size()


# Returns the number of direct child Assemblies.
func get_subassembly_count() -> int:
        return subassemblies.size()


# Returns the total number of Parts contained within this Assembly,
# including all nested subassemblies.
func get_total_part_count() -> int:

        var total: int = parts.size()

        for assembly in subassemblies:
                total += assembly.get_total_part_count()

        return total

# ------------------------------------------------------------------
# Attribute Functions
# ------------------------------------------------------------------

# Calculates combined Assembly attributes.
#
# Part attributes are summed together to create the Assembly's
# aggregate attribute values.
func get_combined_attributes() -> Dictionary:

        var combined_attributes: Dictionary = {}

        # Process direct parts.
        for part in parts:

                for attribute_name in part.attributes.keys():

                        if not combined_attributes.has(attribute_name):
                                combined_attributes[attribute_name] = 0.0

                        combined_attributes[attribute_name] += part.attributes[attribute_name]

        # Process nested assemblies.
        for assembly in subassemblies:

                var child_attributes := assembly.get_combined_attributes()

                for attribute_name in child_attributes.keys():

                        if not combined_attributes.has(attribute_name):
                                combined_attributes[attribute_name] = 0.0

                        combined_attributes[attribute_name] += child_attributes[attribute_name]

        return combined_attributes


# Returns a combined attribute value.
#
# Returns 0.0 if the attribute does not exist.
func get_attribute(attribute_name: String) -> float:

        var combined_attributes := get_combined_attributes()

        return combined_attributes.get(attribute_name, 0.0)

# ------------------------------------------------------------------
# Assembly Operations
# ------------------------------------------------------------------

# Merges another Assembly into this one.
#
# The source Assembly is not destroyed here. That responsibility
# belongs to whichever system performs the merge.
func merge_assembly(source_assembly: Assembly) -> void:

        if source_assembly == null:
                return

        if source_assembly == self:
                return

        for part in source_assembly.parts:
                parts.append(part)

        for child_assembly in source_assembly.subassemblies:
                subassemblies.append(child_assembly)

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

# Returns a human-readable summary.
func get_summary() -> String:

        return "%s | Parts: %d | Total Parts: %d" % [
                assembly_name,
                get_part_count(),
                get_total_part_count()
        ]
