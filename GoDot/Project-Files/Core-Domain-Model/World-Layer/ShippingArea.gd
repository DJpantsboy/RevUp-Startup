##
# ShippingArea
#
# ShippingArea is a World Layer object representing the physical
# dispatch location where completed products leave a Facility.
#
# Examples:
# - Residential Mailbox
# - Driveway Pickup Area
# - Shipping Dock
# - Warehouse Loading Bay
#
# ShippingArea serves as the final destination inside the company
# before products enter the logistics network.
#
# Typical Flow:
#
# Production
#     ↓
# Storage
#     ↓
# ShippingArea
#     ↓
# ShippingRequest
#     ↓
# Delivery
#     ↓
# Customer
#
# ShippingArea acts as the physical bridge between completed
# manufacturing work and outbound logistics.
#
# ShippingArea does NOT:
# - Transport products
# - Create Deliveries
# - Schedule Shipments
# - Process Orders
#
# Those responsibilities belong to the Logistics Layer.
#
# ShippingArea exists to answer the question:
#
#     "Where do completed products leave the facility?"
##

class_name ShippingArea
extends Interactable

# ------------------------------------------------------------------
# Identity
# ------------------------------------------------------------------

var shipping_area_id: int = 0

# ------------------------------------------------------------------
# Logistics References
# ------------------------------------------------------------------

# Logical dispatch location.
var location: Location = null

# Inventory containers associated with shipping.
#
# Completed products are typically staged within these containers
# while awaiting shipment.
var inventory_containers: Array[InventoryContainer] = []

# ------------------------------------------------------------------
# Interaction Functions
# ------------------------------------------------------------------

func interact(player: Player) -> void:
        _open_shipping_interface(player)


# Opens the shipping interface.
#
# UI implementation will be added later.
func _open_shipping_interface(player: Player) -> void:
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

# Returns total Assemblies staged for shipment.
func get_total_assemblies() -> int:

        var total: int = 0

        for container in inventory_containers:
                total += container.get_assembly_count()

        return total


# Returns total Parts staged for shipment.
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


func is_valid_shipping_area() -> bool:

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
