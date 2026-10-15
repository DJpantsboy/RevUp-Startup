##
# StorageArea
#
# StorageArea is a World Layer object representing a physical storage
# location within a Facility.
#
# StorageAreas provide a physical world representation for inventory
# storage and act as the bridge between the World Layer and the
# Logistics Layer.
#
# Examples:
# - Material Rack
# - Finished Goods Shelf
# - Warehouse Storage Area
# - Work In Progress Storage
#
# StorageArea does not directly store Assemblies.
# Storage is handled by one or more InventoryContainers.
#
# StorageArea provides the physical location that Players and
# Employees interact with while InventoryContainers manage the
# underlying inventory records.
#
# StorageArea exists to answer the question:
#
#     "Where are these items physically stored?"
##

class_name StorageArea
extends Interactable

# ------------------------------------------------------------------
# Identity
# ------------------------------------------------------------------

var storage_area_id: int = 0

# ------------------------------------------------------------------
# Logistics References
# ------------------------------------------------------------------

# Logical location associated with this storage area.
var location: Location = null

# Inventory containers physically located here.
var inventory_containers: Array[InventoryContainer] = []

# ------------------------------------------------------------------
# Interaction Functions
# ------------------------------------------------------------------

func interact(player: Player) -> void:
        _open_storage_interface(player)


# Opens storage interaction interface.
#
# Actual UI implementation will be added later.
func _open_storage_interface(player: Player) -> void:
        pass

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
# Inventory Functions
# ------------------------------------------------------------------

# Returns total Assemblies stored within this area.
func get_total_assemblies() -> int:

        var total: int = 0

        for container in inventory_containers:
                total += container.get_assembly_count()

        return total


# Returns total Parts stored within this area.
func get_total_parts() -> int:

        var total: int = 0

        for container in inventory_containers:
                total += container.get_total_part_count()

        return total

# ------------------------------------------------------------------
# Validation Functions
# ------------------------------------------------------------------

func has_valid_location() -> bool:
        return location != null


func is_valid_storage_area() -> bool:

        if not has_valid_location():
                return false

        return not interactable_name.is_empty()

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

func get_summary() -> String:

        return "%s | Containers: %d | Assemblies: %d" % [
                interactable_name,
                get_inventory_container_count(),
                get_total_assemblies()
        ]
