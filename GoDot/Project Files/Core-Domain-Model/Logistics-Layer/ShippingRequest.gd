##
# ShippingRequest
#
# ShippingRequest is a Logistics Layer object representing a planned
# inbound or outbound shipment.
#
# ShippingRequests are responsible for defining logistics work that
# needs to occur and serve as the source from which Deliveries are
# created.
#
# Examples:
# - Purchase order for raw material
# - Equipment purchase delivery
# - Customer order shipment
# - Internal facility transfer
#
# ShippingRequest defines:
# - What is being moved
# - Where it originates
# - Where it is going
# - When shipment should occur
#
# ShippingRequest does not perform transportation itself.
# Actual transportation is represented by Delivery objects.
#
# ShippingRequest is the planning object.
# Delivery is the execution object.
##

class_name ShippingRequest
extends RefCounted

# ------------------------------------------------------------------
# Request Types
# ------------------------------------------------------------------

enum RequestType {
        INBOUND,
        OUTBOUND,
        INTERNAL_TRANSFER
}

# ------------------------------------------------------------------
# Identity
# ------------------------------------------------------------------

var shipping_request_id: int = 0

var shipping_request_name: String = ""

# ------------------------------------------------------------------
# Request Details
# ------------------------------------------------------------------

var request_type: RequestType = RequestType.INBOUND

# ------------------------------------------------------------------
# Routing
# ------------------------------------------------------------------

var origin_location: Location = null

var destination_location: Location = null

# ------------------------------------------------------------------
# Cargo
# ------------------------------------------------------------------

# Assemblies associated with this request.
var assemblies: Array[Assembly] = []

# ------------------------------------------------------------------
# Scheduling
# ------------------------------------------------------------------

# Requested shipment time.
var scheduled_ship_time: float = 0.0

# Expected arrival time.
var expected_arrival_time: float = 0.0

# ------------------------------------------------------------------
# Delivery Tracking
# ------------------------------------------------------------------

# Delivery created from this request.
var active_delivery: Delivery = null

# ------------------------------------------------------------------
# State
# ------------------------------------------------------------------

var is_fulfilled: bool = false

var is_cancelled: bool = false

# ------------------------------------------------------------------
# Cargo Functions
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


func get_total_part_count() -> int:

        var total_parts: int = 0

        for assembly in assemblies:
                total_parts += assembly.get_total_part_count()

        return total_parts

# ------------------------------------------------------------------
# Scheduling Functions
# ------------------------------------------------------------------

func is_ready_to_ship(current_time: float) -> bool:

        if is_cancelled:
                return false

        if is_fulfilled:
                return false

        return current_time >= scheduled_ship_time

# ------------------------------------------------------------------
# Delivery Functions
# ------------------------------------------------------------------

# Associates a Delivery with this request.
func assign_delivery(delivery: Delivery) -> void:

        active_delivery = delivery


# Returns true if a Delivery has been assigned.
func has_delivery() -> bool:
        return active_delivery != null


# Marks the request as fulfilled.
func mark_fulfilled() -> void:

        is_fulfilled = true

# ------------------------------------------------------------------
# State Functions
# ------------------------------------------------------------------

func cancel() -> void:

        if is_fulfilled:
                return

        is_cancelled = true


func is_active() -> bool:

        return (
                not is_fulfilled
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


func is_valid_request() -> bool:

        if not has_valid_route():
                return false

        return true

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

func get_summary() -> String:

        return "%s | Assemblies: %d | Fulfilled: %s" % [
                shipping_request_name,
                get_assembly_count(),
                str(is_fulfilled)
        ]
