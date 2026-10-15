##
# Computer
#
# Computer is a World Layer object representing a physical workstation
# used by the Player to perform business administration.
#
# The Computer serves as the primary interface between the Player and
# administrative systems.
#
# Examples:
# - Market Research
# - Reviewing Active Needs
# - Purchasing Equipment
# - Purchasing Materials
# - Hiring Employees
# - Viewing Company Financials
#
# Computers require physical interaction.
# The Player must be present and interact with a Computer in order to
# access administrative functions.
#
# Computer does NOT:
# - Generate Needs
# - Evaluate Samples
# - Create Orders
# - Process Payments
#
# Those responsibilities belong to Market, Production, and Finance
# systems.
#
# Computer exists to answer the question:
#
#     "How does the player access business information?"
##

class_name Computer
extends Interactable

# ------------------------------------------------------------------
# Identity
# ------------------------------------------------------------------

var computer_id: int = 0

# ------------------------------------------------------------------
# State
# ------------------------------------------------------------------

var is_in_use: bool = false

# Current player using the computer.
var active_player: Player = null

# ------------------------------------------------------------------
# Interaction Functions
# ------------------------------------------------------------------

# Called when a Player interacts with the Computer.
func interact(player: Player) -> void:

        if not can_interact(player):
                return

        is_in_use = true
        active_player = player

        _open_computer_interface()


# Returns whether the Computer can currently be used.
func can_interact(player: Player) -> bool:

        if not super.can_interact(player):
                return false

        if is_in_use:
                return false

        return true

# ------------------------------------------------------------------
# Computer Functions
# ------------------------------------------------------------------

# Opens the administrative interface.
#
# UI implementation will be added later.
func _open_computer_interface() -> void:
        pass


# Closes the administrative interface.
func close_interface() -> void:

        is_in_use = false
        active_player = null

# ------------------------------------------------------------------
# State Functions
# ------------------------------------------------------------------

func is_available() -> bool:
        return not is_in_use


# Returns true if a Player is currently using the Computer.
func has_active_player() -> bool:
        return active_player != null

# ------------------------------------------------------------------
# Validation Functions
# ------------------------------------------------------------------

func is_valid_computer() -> bool:
        return not interactable_name.is_empty()

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

func get_summary() -> String:

        return "%s | In Use: %s" % [
                interactable_name,
                str(is_in_use)
        ]
