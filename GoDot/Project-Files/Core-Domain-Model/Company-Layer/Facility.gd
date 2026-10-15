##
# Facility
#
# Facility is a Company Layer object representing a physical business
# property owned by a Company.
#
# Examples:
# - Home Garage
# - Small Warehouse
# - Manufacturing Plant
# - Corporate Office
#
# A Facility serves as the container for business operations and may
# contain production areas, storage areas, shipping areas, equipment,
# employees, and inventory.
#
# Facility does NOT:
# - Perform manufacturing
# - Execute logistics
# - Manage employees
# - Process finances
#
# Those responsibilities belong to other systems.
#
# Facility exists to answer the question:
#
#     "Where does the company operate?"
##

class_name Facility
extends RefCounted

# ------------------------------------------------------------------
# Identity
# ------------------------------------------------------------------

var facility_id: int = 0

var facility_name: String = ""

var description: String = ""

# ------------------------------------------------------------------
# Classification
# ------------------------------------------------------------------

# Examples:
# "Garage"
# "Warehouse"
# "Factory"
# "Office"
var facility_type: String = ""

# ------------------------------------------------------------------
# Locations
# ------------------------------------------------------------------

# Logical locations owned by this facility.
#
# Examples:
# - Material Storage
# - Shipping Area
# - Arrival Area
# - Machine Queues
var locations: Array[Location] = []

# ------------------------------------------------------------------
# Assets
# ------------------------------------------------------------------

var equipment: Array[Equipment] = []

var inventory_containers: Array[InventoryContainer] = []

# ------------------------------------------------------------------
# Timing
# ------------------------------------------------------------------

# MasterClock time when this facility was acquired.
var acquisition_time: float = 0.0

# ------------------------------------------------------------------
# Location Functions
# ------------------------------------------------------------------

func add_location(location: Location) -> bool:

        if location == null:
                return false

        if locations.has(location):
                return false

        locations.append(location)

        return true


func remove_location(location: Location) -> bool:

        if location == null:
                return false

        return locations.erase(location)


func get_location_count() -> int:
        return locations.size()

# ------------------------------------------------------------------
# Equipment Functions
# ------------------------------------------------------------------

func add_equipment(machine: Equipment) -> bool:

        if machine == null:
                return false

        if equipment.has(machine):
                return false

        equipment.append(machine)

        return true


func remove_equipment(machine: Equipment) -> bool:

        if machine == null:
                return false

        return equipment.erase(machine)


func get_equipment_count() -> int:
        return equipment.size()

# ------------------------------------------------------------------
# Inventory Functions
# ------------------------------------------------------------------

func add_inventory_container(
        container: InventoryContainer
) -> bool:

        if container == null:
                return false

        if inventory_containers.has(container):
                return false

        inventory_containers.append(container)

        return true


func remove_inventory_container(
        container: InventoryContainer
) -> bool:

        if container == null:
                return false

        return inventory_containers.erase(container)


func get_inventory_container_count() -> int:
        return inventory_containers.size()

# ------------------------------------------------------------------
# Query Functions
# ------------------------------------------------------------------

func is_empty() -> bool:

        return (
                equipment.is_empty()
                and inventory_containers.is_empty()
        )


# Returns total stored assemblies within all containers.
func get_total_stored_assemblies() -> int:

        var total: int = 0

        for container in inventory_containers:
                total += container.get_assembly_count()

        return total

# ------------------------------------------------------------------
# Validation Functions
# ------------------------------------------------------------------

func is_valid_facility() -> bool:

        if facility_name.is_empty():
                return false

        return true

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

func get_summary() -> String:

        return "%s | Equipment: %d | Containers: %d" % [
                facility_name,
                get_equipment_count(),
                get_inventory_container_count()
        ]
