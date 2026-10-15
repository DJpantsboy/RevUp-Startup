##
# MaterialDefinition
#
# MaterialDefinition is a Foundation Layer data object that defines a material
# type used throughout Startup Simulator.
#
# This object contains the static properties of a material, including its name,
# value, category, and starting attributes. It does not represent a physical
# piece of material on the shop floor. Instead, it serves as the template from
# which runtime Part objects are created.
#
# Examples:
# - Mild Steel
# - Stainless Steel
# - Aluminum 6061
# - Copper
#
# MaterialDefinitions are intended to be created as Resource assets and loaded
# by other game systems when needed.
##

class_name MaterialDefinition
extends Resource

# ------------------------------------------------------------------
# Basic Material Information
# ------------------------------------------------------------------

@export var material_id: int = 0

@export var material_name: String = ""

@export var material_category: String = ""

# Base economic value of the material before operations are applied.
@export var base_value: float = 0.0

# ------------------------------------------------------------------
# Material Attributes
# ------------------------------------------------------------------

# Dictionary containing all starting material attributes.
#
# Example:
# {
#     "Strength": 80.0,
#     "Weight": 75.0,
#     "CorrosionResistance": 20.0,
#     "Connectability": 90.0
# }
#
# Keys should always match AttributeDefinition names.
@export var attributes: Dictionary = {}

# ------------------------------------------------------------------
# Public Functions
# ------------------------------------------------------------------

# Returns the value of an attribute.
# Returns 0.0 if the attribute does not exist.
func get_attribute(attribute_name: String) -> float:
        return attributes.get(attribute_name, 0.0)


# Returns true if the material contains the requested attribute.
func has_attribute(attribute_name: String) -> bool:
        return attributes.has(attribute_name)


# Sets an attribute value.
#
# This function mainly exists to support editor tools and future import
# utilities. MaterialDefinitions should generally be treated as immutable
# during gameplay.
func set_attribute(attribute_name: String, value: float) -> void:
        attributes[attribute_name] = value
