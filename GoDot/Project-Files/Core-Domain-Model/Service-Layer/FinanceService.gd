##
# FinanceService
#
# FinanceService is a Service Layer object responsible for
# coordinating financial activity throughout Startup Simulator.
#
# FinanceService acts as the financial orchestration layer between:
#
# Orders
#     ↓
# Revenue
#     ↓
# Account
#
# Purchases
#     ↓
# Expenses
#     ↓
# Account
#
# Responsibilities:
# - Record Revenue
# - Record Expenses
# - Process Order Payments
# - Process Purchases
# - Monitor Profitability
#
# FinanceService does NOT:
# - Generate Orders
# - Manufacture Products
# - Execute Shipments
# - Manage Employees
#
# Those responsibilities belong to other services.
#
# FinanceService exists to answer the question:
#
#     "How does money move through the business?"
##

class_name FinanceService
extends RefCounted

# ------------------------------------------------------------------
# Revenue Functions
# ------------------------------------------------------------------

# Records revenue earned by a Company.
func record_revenue(
	account: Account,
	amount: float
) -> bool:

	if account == null:
		return false

	if amount <= 0.0:
		return false

	account.record_revenue(amount)

	return true


# Processes payment for a completed Order.
func process_order_payment(
	account: Account,
	order: Order
) -> bool:

	if account == null:
		return false

	if order == null:
		return false

	if order.is_paid:
		return false

	record_revenue(
		account,
		order.payment_amount
	)

	order.mark_paid()

	return true

# ------------------------------------------------------------------
# Expense Functions
# ------------------------------------------------------------------

# Records an expense against a Company Account.
func record_expense(
	account: Account,
	amount: float
) -> bool:

	if account == null:
		return false

	if amount <= 0.0:
		return false

	account.record_expense(amount)

	return true


# Processes a purchase transaction.
func process_purchase(
	account: Account,
	cost: float
) -> bool:

	if account == null:
		return false

	if cost <= 0.0:
		return false

	if not account.can_afford(cost):
		return false

	account.record_expense(cost)

	return true

# ------------------------------------------------------------------
# Financial Metrics
# ------------------------------------------------------------------

func get_cash_balance(
	account: Account
) -> float:

	if account == null:
		return 0.0

	return account.cash_balance


func get_total_revenue(
	account: Account
) -> float:

	if account == null:
		return 0.0

	return account.total_revenue


func get_total_expenses(
	account: Account
) -> float:

	if account == null:
		return 0.0

	return account.total_expenses


func get_total_profit(
	account: Account
) -> float:

	if account == null:
		return 0.0

	return account.total_profit

# ------------------------------------------------------------------
# Business Health Functions
# ------------------------------------------------------------------

func is_profitable(
	account: Account
) -> bool:

	if account == null:
		return false

	return account.is_profitable()


func can_afford_purchase(
	account: Account,
	cost: float
) -> bool:

	if account == null:
		return false

	return account.can_afford(cost)

# ------------------------------------------------------------------
# Win Condition Functions
# ------------------------------------------------------------------

# Returns true if the player has achieved the primary win condition.
func has_reached_victory(
	account: Account
) -> bool:

	if account == null:
		return false

	return account.total_profit >= 1000000.0

# ------------------------------------------------------------------
# Validation Functions
# ------------------------------------------------------------------

func is_valid_service() -> bool:
	return true

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

func get_summary(
	account: Account
) -> String:

	if account == null:
		return "Invalid Account"

	return "Cash: $%.2f | Profit: $%.2f" % [
		account.cash_balance,
		account.total_profit
	]
