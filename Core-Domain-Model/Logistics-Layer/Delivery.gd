##
# Delivery
#
# Delivery is a Logistics Layer object representing a physical
# shipment currently moving through the Startup Simulator world.
#
# Deliveries are created from ShippingRequests and are responsible
# for transporting Assemblies, Materials, Equipment, or other assets
# between Locations.
#
# Examples:
# - Steel shipment from supplier to Arrival Area
# - Drill Press shipment from equipment vendor
# - Customer order shipment leaving Shipping Area
#
# Delivery represents transportation that is actively occurring.
#
# Delivery does not:
# - Generate shipments
# - Schedule shipments
# - Evaluate shipping requirements
# - Manage inventory
#
# These responsibilities belong to ShippingRequest and
# ShippingService.
#
# Delivery exists to track what is being moved, where it is going,
# when it will arrive, and whether it has completed transit.
##

class_name Delivery
extends RefCounted

# ------------------------------------------------------------------
# Identity
# ------------------------------------------------------------------

var delivery_id: int = 0

var delivery_name: String = ""

# ------------------------------------------------------------------
# Routing Information
# ------------------------------------------------------------------

# Starting location.
var origin_location: Location = null

# Destination location.
var destination_location: Location = null

# ------------------------------------------------------------------
# Cargo
# ------------------------------------------------------------------

# Assemblies being transported.
var assemblies: Array[Assembly] = []

# ------------------------------------------------------------------
# Timing
# ------------------------------------------------------------------

# MasterClock time when shipment departed.
var departure_time: float = 0.0

# MasterClock time when shipment is expected to arrive.
var arrival_time: float = 0.0

# ------------------------------------------------------------------
# State
# ------------------------------------------------------------------

var is_departed: bool = false

var is_delivered: bool = false

var is_cancelled: bool = false

# ------------------------------------------------------------------
# Cargo Functions
# ------------------------------------------------------------------

# Adds an Assembly to the shipment.
func add_assembly(assembly: Assembly) -> bool:

        if assembly == null:
                return false

        if assemblies.has(assembly):
                return false

        assemblies.append(assembly)

        return true


# Removes an Assembly from the shipment.
func remove_assembly(assembly: Assembly) -> bool:

        if assembly == null:
                return false

        return assemblies.erase(assembly)


# Returns the number of Assemblies being shipped.
func get_assembly_count() -> int:
        return assemblies.size()


# Returns the total number of Parts contained in the shipment.
func get_total_part_count() -> int:

        var total_parts: int = 0

        for assembly in assemblies:
                total_parts += assembly.get_total_part_count()

        return total_parts

# ------------------------------------------------------------------
# Lifecycle Functions
# ------------------------------------------------------------------

# Marks the shipment as having departed.
func depart(current_time: float) -> void:

        if is_cancelled:
                return

        is_departed = true
        departure_time = current_time


# Returns true when the shipment is ready to arrive.
func is_ready_for_delivery(current_time: float) -> bool:

        if is_cancelled:
                return false

        if is_delivered:
                return false

        return current_time >= arrival_time


# Marks the shipment as delivered.
func deliver(current_time: float) -> void:

        if not is_ready_for_delivery(current_time):
                return

        is_delivered = true


# Cancels the shipment.
func cancel() -> void:

        if is_delivered:
                return

        is_cancelled = true

# ------------------------------------------------------------------
# Status Functions
# ------------------------------------------------------------------

# Returns the remaining transit time.
func get_remaining_time(current_time: float) -> float:

        if is_delivered:
                return 0.0

        return max(arrival_time - current_time, 0.0)


# Returns true if the shipment is currently in transit.
func is_in_transit() -> bool:

        return (
                is_departed
                and not is_delivered
                and not is_cancelled
        )

# ------------------------------------------------------------------
# Validation Functions
# ------------------------------------------------------------------

func has_valid_route() -> bool:

        if origin_location == null:
                return false

        if destination_location == null:
                return false

        return true


func is_valid_delivery() -> bool:

        if not has_valid_route():
                return false

        return true

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

func get_summary() -> String:

        return "%s | Assemblies: %d | Delivered: %s" % [
                delivery_name,
                get_assembly_count(),
                str(is_delivered)
        ]
