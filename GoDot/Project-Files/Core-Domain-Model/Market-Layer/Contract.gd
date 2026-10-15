##
# Contract
#
# Contract is a Market Layer object representing a business agreement
# created from a successful SampleSubmission.
#
# Contract serves as the bridge between market demand and production.
#
# Relationship:
#
# Need
#     ↓
# SampleSubmission
#     ↓
# Contract
#     ↓
# Order
#
# A Contract defines:
# - The customer agreement
# - The accepted product
# - Contract value
# - Associated Orders
#
# Contract does NOT:
# - Manufacture products
# - Generate production plans
# - Execute logistics
# - Process payments
#
# Those responsibilities belong to other layers of the architecture.
#
# Contract exists to answer the question:
#
#     "What business agreement was created from this opportunity?"
##

class_name Contract
extends RefCounted

# ------------------------------------------------------------------
# Identity
# ------------------------------------------------------------------

var contract_id: int = 0

var contract_name: String = ""

# ------------------------------------------------------------------
# Source Information
# ------------------------------------------------------------------

# Need that ultimately created this Contract.
var need: Need = null

# Submission that was accepted.
var sample_submission: SampleSubmission = null

# ------------------------------------------------------------------
# Product Information
# ------------------------------------------------------------------

# Product definition agreed upon by the customer.
var part_definition: PartDefinition = null

# ------------------------------------------------------------------
# Financial Information
# ------------------------------------------------------------------

# Total value of the Contract.
var contract_value: float = 0.0

# ------------------------------------------------------------------
# Orders
# ------------------------------------------------------------------

# Orders created under this Contract.
#
# A Contract may eventually generate multiple Orders over time.
var orders: Array[Order] = []

# ------------------------------------------------------------------
# Timing
# ------------------------------------------------------------------

# MasterClock time when the Contract was accepted.
var creation_time: float = 0.0

# ------------------------------------------------------------------
# State
# ------------------------------------------------------------------

var is_active: bool = true

var is_completed: bool = false

var is_cancelled: bool = false

# ------------------------------------------------------------------
# Order Functions
# ------------------------------------------------------------------

func add_order(order: Order) -> bool:

        if order == null:
                return false

        if orders.has(order):
                return false

        orders.append(order)

        return true


func remove_order(order: Order) -> bool:

        if order == null:
                return false

        return orders.erase(order)


func get_order_count() -> int:
        return orders.size()

# ------------------------------------------------------------------
# Progress Functions
# ------------------------------------------------------------------

# Returns true if all Orders associated with this
# Contract have been completed.
func are_all_orders_complete() -> bool:

        if orders.is_empty():
                return false

        for order in orders:

                if not order.is_complete():
                        return false

        return true


# Marks the Contract as completed.
func mark_completed() -> void:

        is_completed = true
        is_active = false

# ------------------------------------------------------------------
# State Functions
# ------------------------------------------------------------------

func cancel() -> void:

        if is_completed:
                return

        is_cancelled = true
        is_active = false


func is_open() -> bool:

        return (
                is_active
                and not is_completed
                and not is_cancelled
        )

# ------------------------------------------------------------------
# Validation Functions
# ------------------------------------------------------------------

func has_valid_need() -> bool:
        return need != null


func has_valid_submission() -> bool:
        return sample_submission != null


func has_valid_part_definition() -> bool:
        return part_definition != null


func is_valid_contract() -> bool:

        if not has_valid_need():
                return false

        if not has_valid_submission():
                return false

        if not has_valid_part_definition():
                return false

        if contract_value < 0.0:
                return false

        return true

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

func get_summary() -> String:

        return "%s | Orders: %d | Value: $%.2f" % [
                contract_name,
                get_order_count(),
                contract_value
        ]
