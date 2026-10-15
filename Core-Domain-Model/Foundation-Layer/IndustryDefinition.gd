##
# IndustryDefinition
#
# IndustryDefinition is a Foundation Layer data object that defines
# an industry used throughout Startup Simulator.
#
# Industries provide market context for need generation and help
# determine which types of products, attributes, and opportunities
# appear within the market.
#
# Examples:
# - Construction
# - Agriculture
# - Automotive
# - Aerospace
# - Consumer Goods
#
# IndustryDefinitions serve as a master catalog of industries used
# by the Market system.
#
# This class contains no market logic, need generation logic,
# economic simulation, or gameplay behavior. It simply defines
# an industry and its identifying information.
##

class_name IndustryDefinition
extends Resource

# ------------------------------------------------------------------
# Basic Industry Information
# ------------------------------------------------------------------

@export var industry_id: int = 0

@export var industry_name: String = ""

@export_multiline var description: String = ""

# ------------------------------------------------------------------
# Public Functions
# ------------------------------------------------------------------

# Returns true if the industry has a valid identifier.
func has_valid_id() -> bool:
        return industry_id > 0


# Returns true if the industry contains a name.
func has_name() -> bool:
        return not industry_name.is_empty()


# Returns basic validation status.
#
# Useful for editor tools and future data validation.
func is_valid_definition() -> bool:
        return has_valid_id() and has_name()
