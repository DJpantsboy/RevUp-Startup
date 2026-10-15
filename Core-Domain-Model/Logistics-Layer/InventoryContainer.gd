##
# InventoryContainer
#
# InventoryContainer is a Logistics Layer object representing a
# generic storage location capable of holding Assemblies.
#
# InventoryContainer serves as the common storage abstraction used
# throughout Startup Simulator.
#
# Examples:
# - Material Rack
# - Finished Goods Shelf
# - Shipping Staging Area
# - Arrival Area Inventory
# - Machine Input Queue
# - Warehouse Storage Bin
#
# InventoryContainer does not represent a physical world object.
# Instead, it represents the inventory space associated with a
# Location or gameplay object.
#
# To simplify logistics, InventoryContainers store Assemblies.
# Since every Part is treated as an Assembly of one, all storage,
# movement, and shipping systems can operate using a single object type.
#
# InventoryContainer is responsible only for storage.
# It does not handle pathfinding, employee behavior, shipping,
# production scheduling, or manufacturing operations.
##

class_name InventoryContainer
extends RefCounted

# ------------------------------------------------------------------
# Identity
# ------------------------------------------------------------------

var container_id: int = 0

var container_name: String = ""

# ------------------------------------------------------------------
# Location
# ------------------------------------------------------------------

# Logical destination associated with this container.
var location: Location = null

# ------------------------------------------------------------------
# Storage Capacity
# ------------------------------------------------------------------

# Maximum number of Assemblies that may be stored.
#
# A value of -1 indicates unlimited capacity.
var max_capacity: int = -1

# ------------------------------------------------------------------
# Contents
# ------------------------------------------------------------------

var assemblies: Array[Assembly] = []

# ------------------------------------------------------------------
# Capacity Functions
# ------------------------------------------------------------------

# Returns the current number of stored Assemblies.
func get_assembly_count() -> int:
        return assemblies.size()


# Returns true if another Assembly can be added.
func has_capacity() -> bool:

        if max_capacity < 0:
                return true

        return assemblies.size() < max_capacity


# Returns available storage space.
#
# Returns -1 when capacity is unlimited.
func get_available_capacity() -> int:

        if max_capacity < 0:
                return -1

        return max_capacity - assemblies.size()

# ------------------------------------------------------------------
# Inventory Functions
# ------------------------------------------------------------------

# Adds an Assembly to storage.
func add_assembly(assembly: Assembly) -> bool:

        if assembly == null:
                return false

        if not has_capacity():
                return false

        if assemblies.has(assembly):
                return false

        assemblies.append(assembly)

        return true


# Removes an Assembly from storage.
func remove_assembly(assembly: Assembly) -> bool:

        if assembly == null:
                return false

        return assemblies.erase(assembly)


# Returns true if the Assembly exists in storage.
func contains_assembly(
        assembly: Assembly
) -> bool:

        return assemblies.has(assembly)


# Removes and returns an Assembly.
func retrieve_assembly(
        assembly: Assembly
) -> Assembly:

        if not contains_assembly(assembly):
                return null

        assemblies.erase(assembly)

        return assembly

# ------------------------------------------------------------------
# Query Functions
# ------------------------------------------------------------------

# Returns true if the container is empty.
func is_empty() -> bool:
        return assemblies.is_empty()


# Returns the total number of Parts stored within all Assemblies.
func get_total_part_count() -> int:

        var total_parts: int = 0

        for assembly in assemblies:
                total_parts += assembly.get_total_part_count()

        return total_parts

# ------------------------------------------------------------------
# Validation Functions
# ------------------------------------------------------------------

func has_valid_location() -> bool:
        return location != null


func is_valid_container() -> bool:

        if container_name.is_empty():
                return false

        return true

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

func get_summary() -> String:

        return "%s | Assemblies: %d | Parts: %d" % [
                container_name,
                get_assembly_count(),
                get_total_part_count()
        ]
