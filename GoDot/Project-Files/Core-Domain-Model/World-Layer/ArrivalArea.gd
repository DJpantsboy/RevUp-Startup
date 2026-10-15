##
# ArrivalArea
#
# ArrivalArea is a World Layer object representing the physical
# receiving location where inbound deliveries enter a Facility.
#
# Examples:
# - Residential Driveway
# - Mailbox Delivery Area
# - Receiving Dock
# - Warehouse Receiving Bay
#
# ArrivalArea serves as the initial destination for:
# - Material Deliveries
# - Equipment Deliveries
# - Internal Facility Transfers
#
# ArrivalArea acts as the physical bridge between incoming
# Deliveries and the company's inventory systems.
#
# ArrivalArea does not:
# - Transport goods
# - Create Deliveries
# - Schedule Shipments
# - Manage Inventory
#
# Those responsibilities belong to the Logistics Layer.
#
# ArrivalArea exists to answer the question:
#
#     "Where do incoming deliveries arrive?"
##

class_name ArrivalArea
extends Interactable

# ------------------------------------------------------------------
# Identity
# ------------------------------------------------------------------

var arrival_area_id: int = 0

# ------------------------------------------------------------------
# Logistics References
# ------------------------------------------------------------------

# Logical receiving location.
var location: Location = null

# Inventory containers associated with receiving.
#
# Deliveries may place received Assemblies into these containers.
var inventory_containers: Array[InventoryContainer] = []

# ------------------------------------------------------------------
# Interaction Functions
# ------------------------------------------------------------------

func interact(player: Player) -> void:
        _open_arrival_interface(player)


# Opens the receiving interface.
#
# UI implementation will be added later.
func _open_arrival_interface(player: Player) -> void:
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

# Returns total Assemblies currently stored in receiving.
func get_total_assemblies() -> int:

        var total: int = 0

        for container in inventory_containers:
                total += container.get_assembly_count()

        return total


# Returns total Parts currently stored in receiving.
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


func is_valid_arrival_area() -> bool:

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
