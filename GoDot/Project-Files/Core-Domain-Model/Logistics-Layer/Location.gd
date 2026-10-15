##
# Location
#
# Location is a Logistics Layer object representing a logical
# destination within the Startup Simulator world.
#
# Locations are used by logistics, storage, production, shipping,
# and employee systems to identify where objects should be moved,
# stored, delivered, or retrieved.
#
# Examples:
# - Material Storage
# - Drill Press Queue
# - Powder Coat Queue
# - Arrival Area
# - Shipping Area
# - Finished Goods Storage
#
# Location is intentionally lightweight and contains no pathfinding,
# movement, inventory, or world-space logic.
#
# Physical world objects such as StorageAreas, ShippingAreas,
# ArrivalAreas, and Equipment may reference Locations to integrate
# with logistics systems.
#
# A Location answers one question:
#
#     "Where is this supposed to go?"
##

class_name Location
extends RefCounted

# ------------------------------------------------------------------
# Identity
# ------------------------------------------------------------------

var location_id: int = 0

var location_name: String = ""

var description: String = ""

# ------------------------------------------------------------------
# Classification
# ------------------------------------------------------------------

# Examples:
# "Storage"
# "Production"
# "Shipping"
# "Receiving"
# "Queue"
var location_type: String = ""

# ------------------------------------------------------------------
# State
# ------------------------------------------------------------------

var is_active: bool = true

# ------------------------------------------------------------------
# Validation Functions
# ------------------------------------------------------------------

# Returns true if the Location contains a valid identifier.
func has_valid_id() -> bool:
        return location_id > 0


# Returns true if the Location contains a valid name.
func has_name() -> bool:
        return not location_name.is_empty()


# Returns true if the Location can currently be used.
func is_available() -> bool:
        return is_active


# Returns true if the Location is properly configured.
func is_valid_location() -> bool:
        return has_valid_id() and has_name()

# ------------------------------------------------------------------
# State Functions
# ------------------------------------------------------------------

func activate() -> void:
        is_active = true


func deactivate() -> void:
        is_active = false

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

func get_summary() -> String:

        return "%s | Type: %s | Active: %s" % [
                location_name,
                location_type,
                str(is_active)
        ]
