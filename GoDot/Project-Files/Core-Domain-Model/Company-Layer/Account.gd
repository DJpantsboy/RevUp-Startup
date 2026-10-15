##
# Account
#
# Account is a Company Layer object representing the financial
# ledger of a Company.
#
# Account is responsible for tracking:
# - Cash balance
# - Revenue
# - Expenses
# - Profit
#
# Account serves as the authoritative storage location for company
# financial information.
#
# Account does NOT:
# - Process payments
# - Calculate taxes
# - Generate invoices
# - Manage payroll
# - Evaluate business performance
#
# Those responsibilities belong to FinanceService and other future
# financial systems.
#
# Account exists to answer the question:
#
#     "What is the financial state of this company?"
##

class_name Account
extends RefCounted

# ------------------------------------------------------------------
# Identity
# ------------------------------------------------------------------

var account_id: int = 0

var account_name: String = ""

# ------------------------------------------------------------------
# Financial Totals
# ------------------------------------------------------------------

# Current company cash available.
var cash_balance: float = 0.0

# Lifetime revenue earned.
var total_revenue: float = 0.0

# Lifetime expenses incurred.
var total_expenses: float = 0.0

# Lifetime profit earned.
#
# Profit = Revenue - Expenses
var total_profit: float = 0.0

# ------------------------------------------------------------------
# Transaction Recording
# ------------------------------------------------------------------

# Records incoming money.
#
# Example:
# Customer payment
# Contract completion
func record_revenue(amount: float) -> void:

        if amount <= 0.0:
                return

        cash_balance += amount
        total_revenue += amount

        _recalculate_profit()


# Records outgoing money.
#
# Example:
# Material purchase
# Equipment purchase
# Rent payment
func record_expense(amount: float) -> void:

        if amount <= 0.0:
                return

        cash_balance -= amount
        total_expenses += amount

        _recalculate_profit()

# ------------------------------------------------------------------
# Profit Functions
# ------------------------------------------------------------------

# Updates profit after financial changes.
func _recalculate_profit() -> void:
        total_profit = total_revenue - total_expenses


# Returns true if the account has enough cash
# for a purchase.
func can_afford(amount: float) -> bool:

        if amount < 0.0:
                return false

        return cash_balance >= amount

# ------------------------------------------------------------------
# Financial Metrics
# ------------------------------------------------------------------

func get_net_worth() -> float:
        return cash_balance


func is_profitable() -> bool:
        return total_profit > 0.0

# ------------------------------------------------------------------
# Validation Functions
# ------------------------------------------------------------------

func is_valid_account() -> bool:
        return not account_name.is_empty()

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

func get_summary() -> String:

        return "%s | Cash: $%.2f | Profit: $%.2f" % [
                account_name,
                cash_balance,
                total_profit
        ]
