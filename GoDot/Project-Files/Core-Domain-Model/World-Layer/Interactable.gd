##
# Interactable
#
# Interactable is the base World Layer object for anything that can
# be physically interacted with by the Player.
#
# Interactable establishes a common interface for world objects that
# support interaction.
#
# Examples:
# - Computer
# - Equipment
# - Storage Area
# - Shipping Area
# - Arrival Area
#
# Interactable does not define specific interaction behavior.
# Child classes are expected to override the interaction methods
# provided here.
#
# Interactable exists to answer the question:
#
#     "Can the player use this object?"
##

class_name Interactable
extends RefCounted

# ------------------------------------------------------------------
# Identity
# ------------------------------------------------------------------

var interactable_name: String = ""

# ------------------------------------------------------------------
# Interaction State
# ------------------------------------------------------------------

var is_enabled: bool = true

# ------------------------------------------------------------------
# Interaction Functions
# ------------------------------------------------------------------

# Called when the Player interacts with this object.
#
# Child classes should override this function.
func interact(player: Player) -> void:
        pass


# Returns whether interaction is currently possible.
func can_interact(player: Player) -> bool:

        if not is_enabled:
                return false

        return true

# ------------------------------------------------------------------
# State Functions
# ------------------------------------------------------------------

func enable() -> void:
        is_enabled = true


func disable() -> void:
        is_enabled = false

# ------------------------------------------------------------------
# Validation Functions
# ------------------------------------------------------------------

func is_valid_interactable() -> bool:
        return not interactable_name.is_empty()

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

func get_summary() -> String:

        return "%s | Enabled: %s" % [
                interactable_name,
                str
