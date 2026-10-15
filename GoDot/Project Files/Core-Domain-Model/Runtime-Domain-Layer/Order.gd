##
# Order
#
# Order is a Runtime Domain Layer object representing a production
# request that must be fulfilled by the company.
#
# Orders are generated from accepted Contracts and define the
# manufacturing work required to satisfy a customer.
#
# An Order specifies:
# - The product required
# - The quantity required
# - The due date
# - The payment amount
#
# Orders do not manage production directly.
# Orders do not schedule employees.
# Orders do not create manufacturing plans.
#
# Instead, Orders serve as the business requirement that drives
# ProductionJobs, material purchases, and shipping activities.
#
# Orders are one of the primary mechanisms through which the Market
# system creates demand for manufacturing.
##

class_name Order
extends RefCounted

# ------------------------------------------------------------------
# Identity
# ------------------------------------------------------------------

var order_id: int = 0

var order_name: String = ""

# ------------------------------------------------------------------
# Product Requirements
# ------------------------------------------------------------------

# Product definition required by the customer.
var part_definition: PartDefinition = null

# Number of units required.
var required_quantity: int = 1

# ------------------------------------------------------------------
# Financial Information
# ------------------------------------------------------------------

# Total payment received upon successful completion.
var payment_amount: float = 0.0

# ------------------------------------------------------------------
# Scheduling
# ------------------------------------------------------------------

# Due date represented in MasterClock time.
#
# Exact format will depend on the MasterClock implementation.
var due_time: float = 0.0

# ------------------------------------------------------------------
# Progress Tracking
# ------------------------------------------------------------------

# Number of units completed toward this Order.
var completed_quantity: int = 0

# Whether the Order has been shipped.
var is_shipped: bool = false

# Whether payment has been received.
var is_paid: bool = false

# ------------------------------------------------------------------
# Progress Functions
# ------------------------------------------------------------------

# Adds completed production toward the Order.
func add_completed_quantity(quantity: int) -> void:

        if quantity <= 0:
                return

        completed_quantity += quantity

        # Prevent overproduction from inflating progress.
        completed_quantity = min(
                completed_quantity,
                required_quantity
        )


# Returns remaining quantity required.
func get_remaining_quantity() -> int:
        return required_quantity - completed_quantity


# Returns completion percentage.
func get_completion_percent() -> float:

        if required_quantity <= 0:
                return 0.0

        return float(completed_quantity) / float(required_quantity)

# ------------------------------------------------------------------
# Status Functions
# ------------------------------------------------------------------

# Returns true if all required units have been completed.
func is_complete() -> bool:
        return completed_quantity >= required_quantity


# Returns true if the Order can be shipped.
func can_ship() -> bool:
        return is_complete() and not is_shipped


# Marks the Order as shipped.
func mark_shipped() -> void:
        is_shipped = true


# Marks the Order as paid.
func mark_paid() -> void:
        is_paid = true

# ------------------------------------------------------------------
# Validation Functions
# ------------------------------------------------------------------

# Returns true if the Order references a valid product.
func has_valid_part_definition() -> bool:
        return part_definition != null


# Returns true if the Order is properly configured.
func is_valid_order() -> bool:

        if not has_valid_part_definition():
                return false

        if required_quantity <= 0:
                return false

        if payment_amount < 0:
                return false

        return true

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

# Returns a human-readable summary.
func get_summary() -> String:

        return "%s | %d/%d Complete | $%.2f" % [
                order_name,
                completed_quantity,
                required_quantity,
                payment_amount
        ]
