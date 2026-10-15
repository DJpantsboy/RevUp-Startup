##
# AttributeDefinition
#
# AttributeDefinition is a Foundation Layer data object that defines
# a valid attribute used throughout Startup Simulator.
#
# Attributes are the universal language of the simulation.
#
# Materials possess attributes.
# Operations modify attributes.
# Parts inherit attributes.
# Needs evaluate attributes.
# Orders are fulfilled by satisfying attribute requirements.
#
# Examples:
# - Strength
# - Weight
# - Corrosion Resistance
# - Precision
# - Connectability
# - Cost
#
# AttributeDefinitions serve as the master catalog of attributes
# available within the game.
#
# This class contains no gameplay logic, calculations, scoring,
# production functionality, or market functionality.
# It simply defines the attribute itself.
##

class_name AttributeDefinition
extends Resource

# ------------------------------------------------------------------
# Basic Attribute Information
# ------------------------------------------------------------------

@export var attribute_id: int = 0

@export var attribute_name: String = ""

@export_multiline var description: String = ""

# ------------------------------------------------------------------
# Attribute Limits
# ------------------------------------------------------------------

# Minimum valid value for this attribute.
#
# Not all systems are required to enforce these limits, but they
# provide a useful reference for validation and balancing.
@export var minimum_value: float = 0.0

# Maximum valid value for this attribute.
@export var maximum_value: float = 100.0

# ------------------------------------------------------------------
# Display Settings
# ------------------------------------------------------------------

# Units shown to the player.
#
# Examples:
# "%"
# "lbs"
# "kg"
# ""
#
# Most attributes will probably remain unitless for now.
@export var display_unit: String = ""

# ------------------------------------------------------------------
# Public Functions
# ------------------------------------------------------------------

# Returns true if the value falls within the defined range.
func is_valid_value(value: float) -> bool:
        return value >= minimum_value and value <= maximum_value


# Clamps a value into the valid range.
#
# Useful for validation and future balancing tools.
func clamp_value(value: float) -> float:
        return clampf(value, minimum_value, maximum_value)


# Returns the midpoint of the valid range.
#
# Useful for future UI displays, balancing tools,
# and debugging.
func get_midpoint() -> float:
        return (minimum_value + maximum_value) / 2.0
