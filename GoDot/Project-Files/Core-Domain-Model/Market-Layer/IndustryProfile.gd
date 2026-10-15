##
# IndustryProfile
#
# IndustryProfile is a Market Layer object that defines how a
# particular industry behaves during market generation.
#
# IndustryProfile serves as the bridge between IndustryDefinitions
# and the Market system.
#
# Responsibilities:
# - Define attribute weighting preferences
# - Define market demand tendencies
# - Influence Need generation
# - Provide industry-specific market behavior
#
# Examples:
#
# Construction:
# - High Strength
# - Moderate Cost Sensitivity
# - Moderate Connectability
#
# Aerospace:
# - High Precision
# - Low Weight
# - High Cost Tolerance
#
# Agriculture:
# - High Durability
# - High Repairability
# - Low Precision Requirements
#
# IndustryProfile does NOT:
# - Generate Needs
# - Manage Market state
# - Evaluate Samples
# - Create Contracts
#
# Those responsibilities belong to Market and MarketService.
#
# IndustryProfile answers the question:
#
#     "What does this industry tend to value?"
##

class_name IndustryProfile
extends RefCounted

# ------------------------------------------------------------------
# Identity
# ------------------------------------------------------------------

var profile_id: int = 0

# Industry associated with this profile.
var industry_definition: IndustryDefinition = null

# ------------------------------------------------------------------
# Market Attribute Preferences
# ------------------------------------------------------------------

# Relative importance of attributes when generating Needs.
#
# Example:
#
# {
#     "Strength": 0.8,
#     "Cost": 0.5,
#     "Precision": 0.2
# }
#
# Higher values indicate stronger market preference.
var attribute_weights: Dictionary = {}

# ------------------------------------------------------------------
# Need Generation Controls
# ------------------------------------------------------------------

# Relative frequency of opportunities generated from this industry.
#
# Example:
# 1.0 = Normal
# 2.0 = Twice as Common
# 0.5 = Half as Common
var demand_frequency: float = 1.0

# General profitability modifier.
#
# Higher values tend to generate more valuable opportunities.
var market_value_modifier: float = 1.0

# ------------------------------------------------------------------
# Attribute Functions
# ------------------------------------------------------------------

# Returns the weighting assigned to an attribute.
func get_attribute_weight(
        attribute_name: String
) -> float:

        return attribute_weights.get(attribute_name, 0.0)


# Returns true if the profile values the attribute.
func uses_attribute(
        attribute_name: String
) -> bool:

        return attribute_weights.has(attribute_name)


# Returns all configured attribute names.
func get_attribute_names() -> Array[String]:

        var attribute_names: Array[String] = []

        for attribute_name in attribute_weights.keys():
                attribute_names.append(attribute_name)

        return attribute_names


# Returns total weighting across all attributes.
#
# Useful for weight normalization during
# market generation.
func get_total_weight() -> float:

        var total_weight: float = 0.0

        for weight in attribute_weights.values():
                total_weight += weight

        return total_weight

# ------------------------------------------------------------------
# Validation Functions
# ------------------------------------------------------------------

func has_valid_industry() -> bool:
        return industry_definition != null


func has_attributes() -> bool:
        return not attribute_weights.is_empty()


func is_valid_profile() -> bool:

        if not has_valid_industry():
                return false

        if not has_attributes():
                return false

        return true

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

func get_summary() -> String:

        var industry_name := "Unknown"

        if industry_definition != null:
                industry_name = industry_definition.industry_name

        return "%s | Attributes: %d | Frequency: %.2f" % [
                industry_name,
                attribute_weights.size(),
                demand_frequency
        ]
