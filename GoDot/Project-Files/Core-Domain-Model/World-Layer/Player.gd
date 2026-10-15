##
# Player
#
# Player is a World Layer object representing the business owner
# controlled by the user.
#
# In Startup Simulator, the Player begins by performing nearly every
# task personally:
#
# - Market Research
# - Material Handling
# - Equipment Operation
# - Product Manufacturing
# - Packaging
# - Shipping
#
# As the company grows, Employees assume many of these duties,
# allowing the Player to focus on management and expansion.
#
# The Player is capable of performing any production activity,
# but does not directly contain manufacturing, logistics, market,
# or financial logic.
#
# Player exists to answer the question:
#
#     "Who is performing this action?"
##

class_name Player
extends RefCounted

# ------------------------------------------------------------------
# Identity
# ------------------------------------------------------------------

var player_name: String = "Player"

# ------------------------------------------------------------------
# Location
# ------------------------------------------------------------------

# Current logical location of the Player.
var current_location: Location = null

# ------------------------------------------------------------------
# Inventory State
# ------------------------------------------------------------------

# The Player may carry one Assembly at a time.
#
# This mirrors the initial Employee implementation and keeps
# logistics behavior consistent.
var carried_assembly: Assembly = null

# ------------------------------------------------------------------
# Interaction Functions
# ------------------------------------------------------------------

# Attempts to interact with a world object.
func interact_with(
        interactable: Interactable
) -> bool:

        if interactable == null:
                return false

        if not interactable.can_interact(self):
                return false

        interactable.interact(self)

        return true

# ------------------------------------------------------------------
# Movement Functions
# ------------------------------------------------------------------

# Updates the Player's logical location.
func move_to(
        location: Location
) -> void:

        if location == null:
                return

        current_location = location


# Returns true if the Player currently has a location.
func has_location() -> bool:
        return current_location != null

# ------------------------------------------------------------------
# Inventory Functions
# ------------------------------------------------------------------

# Returns true if the Player is carrying an Assembly.
func is_carrying_assembly() -> bool:
        return carried_assembly != null


# Attempts to pick up an Assembly.
func pick_up_assembly(
        assembly: Assembly
) -> bool:

        if assembly == null:
                return false

        if carried_assembly != null:
                return false

        carried_assembly = assembly

        return true


# Drops and returns the currently carried Assembly.
func drop_assembly() -> Assembly:

        var dropped_assembly: Assembly = carried_assembly

        carried_assembly = null

        return dropped_assembly

# ------------------------------------------------------------------
# Status Functions
# ------------------------------------------------------------------

func can_carry() -> bool:
        return carried_assembly == null

# ------------------------------------------------------------------
# Validation Functions
# ------------------------------------------------------------------

func is_valid_player() -> bool:
        return not player_name.is_empty()

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

func get_summary() -> String:

        var location_name: String = "Unknown"

        if current_location != null:
                location_name = current_location.location_name

        return "%s | Location: %s | Carrying: %s" % [
                player_name,
                location_name,
                str(is_carrying_assembly())
        ]
