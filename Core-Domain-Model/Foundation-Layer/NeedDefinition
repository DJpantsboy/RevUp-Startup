##
# NeedDefinition
#
# NeedDefinition is a Foundation Layer data object that defines a
# market need template used by Startup Simulator's market system.
#
# A NeedDefinition describes the types of attributes that a market
# opportunity values, along with the relative importance of each
# attribute when evaluating a product.
#
# Examples:
# - Low Cost Structural Component
# - Corrosion Resistant Bracket
# - Lightweight Utility Component
# - High Precision Mounting Plate
#
# NeedDefinitions are used by the Market system to generate runtime
# Need objects that players can pursue.
#
# This object does not represent an active customer request and
# contains no runtime state. It simply defines the characteristics
# that a generated Need should possess.
##

class_name NeedDefinition
extends Resource

# ------------------------------------------------------------------
# Basic Need Information
# ------------------------------------------------------------------

@export var need_definition_id: int = 0

@export var need_name: String = ""

@export_multiline var description: String = ""

# ------------------------------------------------------------------
# Market Classification
# ------------------------------------------------------------------

# Industry associated with this Need template.
#
# Example:
# Construction
# Agriculture
# Automotive
# Consumer Goods
@export var industry_definition: IndustryDefinition

# ------------------------------------------------------------------
# Desired Attributes
# ------------------------------------------------------------------

# Defines which attributes matter for this Need and how
# important they are relative to one another.
#
# Example:
# {
#     "Strength": 0.6,
#     "Cost": 0.4
# }
#
# Total weight does not need to equal 1.0.
# The Market system can normalize weights if needed.
@export var attribute_weights: Dictionary = {}

# ------------------------------------------------------------------
# Acceptance Settings
# ------------------------------------------------------------------

# Used by the Market system when determining whether
# a submitted sample is acceptable.
#
# Exact evaluation logic belongs in MarketService.
@export var acceptance_threshold: float = 0.75

# ------------------------------------------------------------------
# Public Functions
# ------------------------------------------------------------------

# Returns the weighting assigned to an attribute.
#
# Returns 0.0 if the attribute is not part of this Need.
func get_attribute_weight(attribute_name: String) -> float:
        return attribute_weights.get(attribute_name, 0.0)


# Returns true if the Need values the specified attribute.
func requires_attribute(attribute_name: String) -> bool:
        return attribute_weights.has(attribute_name)


# Returns the list of attributes used by this Need.
func get_attribute_names() -> Array[String]:
        var attribute_names: Array[String] = []

        for attribute_name in attribute_weights.keys():
                attribute_names.append(attribute_name)

        return attribute_names


# Returns all weights summed together.
#
# Useful for future weight normalization and debugging.
func get_total_weight() -> float:
        var total_weight: float = 0.0

        for weight in attribute_weights.values():
                total_weight += weight

        return total_weight


# Returns the highest-weighted attribute.
#
# Useful for UI displays and market analysis tools.
func get_primary_attribute() -> String:
        var highest_attribute: String = ""
        var highest_weight: float = -1.0

        for attribute_name in attribute_weights.keys():
                var weight: float = attribute_weights[attribute_name]

                if weight > highest_weight:
                        highest_weight = weight
                        highest_attribute = attribute_name

        return highest_attribute
