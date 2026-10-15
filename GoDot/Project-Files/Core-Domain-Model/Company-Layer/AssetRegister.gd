##
# AssetRegister
#
# AssetRegister is a Company Layer object responsible for tracking
# company-owned assets.
#
# AssetRegister serves as the authoritative ownership registry for
# all assets owned by a Company.
#
# Assets may include:
# - Facilities
# - Equipment
# - InventoryContainers
# - Assemblies
# - Parts
#
# AssetRegister does NOT:
# - Operate equipment
# - Manage inventory
# - Schedule production
# - Track finances
#
# Those responsibilities belong to their respective systems.
#
# AssetRegister exists to answer the question:
#
#     "What does this company own?"
##

class_name AssetRegister
extends RefCounted

# ------------------------------------------------------------------
# Asset Collections
# ------------------------------------------------------------------

var facilities: Array[Facility] = []

var equipment: Array[Equipment] = []

var inventory_containers: Array[InventoryContainer] = []

var assemblies: Array[Assembly] = []

# ------------------------------------------------------------------
# Facility Functions
# ------------------------------------------------------------------

func add_facility(facility: Facility) -> bool:

        if facility == null:
                return false

        if facilities.has(facility):
                return false

        facilities.append(facility)

        return true


func remove_facility(facility: Facility) -> bool:

        if facility == null:
                return false

        return facilities.erase(facility)


func get_facility_count() -> int:
        return facilities.size()

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
# Inventory Container Functions
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
# Assembly Functions
# ------------------------------------------------------------------

func add_assembly(assembly: Assembly) -> bool:

        if assembly == null:
                return false

        if assemblies.has(assembly):
                return false

        assemblies.append(assembly)

        return true


func remove_assembly(assembly: Assembly) -> bool:

        if assembly == null:
                return false

        return assemblies.erase(assembly)


func get_assembly_count() -> int:
        return assemblies.size()

# ------------------------------------------------------------------
# Query Functions
# ------------------------------------------------------------------

func get_total_asset_count() -> int:

        return (
                get_facility_count()
                + get_equipment_count()
                + get_inventory_container_count()
                + get_assembly_count()
        )

# ------------------------------------------------------------------
# Validation Functions
# ------------------------------------------------------------------

func is_empty() -> bool:
        return get_total_asset_count() == 0

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

func get_summary() -> String:

        return (
                "Facilities: %d | Equipment: %d | Containers: %d | Assemblies: %d"
                % [
                        get_facility_count(),
                        get_equipment_count(),
                        get_inventory_container_count(),
                        get_assembly_count()
                ]
        )
