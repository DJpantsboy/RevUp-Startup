##
# MarketService
#
# MarketService is a Service Layer object responsible for
# coordinating market activity throughout Startup Simulator.
#
# MarketService acts as the business logic layer between:
#
# IndustryProfile
#     ↓
# Market
#     ↓
# Need
#     ↓
# SampleSubmission
#     ↓
# Contract
#     ↓
# Order
#
# Responsibilities:
# - Generate Needs
# - Evaluate Sample Submissions
# - Create Contracts
# - Create Orders
# - Maintain Market opportunities
#
# MarketService does NOT:
# - Perform manufacturing
# - Execute shipping
# - Manage employees
# - Process finances
#
# Those responsibilities belong to their respective services.
#
# MarketService exists to answer the question:
#
#     "How does market demand become production demand?"
##

class_name MarketService
extends RefCounted

# ------------------------------------------------------------------
# Need Generation
# ------------------------------------------------------------------

# Creates a Need from a NeedDefinition.
func create_need(
	need_definition: NeedDefinition,
	creation_time: float,
	expiration_time: float
) -> Need:

	if need_definition == null:
		return null

	var need := Need.new()

	need.need_definition = need_definition
	need.need_name = need_definition.need_name
	need.industry_definition = (
		need_definition.industry_definition
	)

	need.creation_time = creation_time
	need.expiration_time = expiration_time

	# Copy generated targets from template.
	# Random generation can be expanded later.
	need.target_attributes = (
		need_definition.attribute_weights.duplicate(true)
	)

	return need

# ------------------------------------------------------------------
# Market Functions
# ------------------------------------------------------------------

func add_need_to_market(
	market: Market,
	need: Need
) -> bool:

	if market == null:
		return false

	if need == null:
		return false

	return market.add_need(need)

# ------------------------------------------------------------------
# Sample Submission Functions
# ------------------------------------------------------------------

func submit_sample(
	need: Need,
	part: Part,
	submission_time: float
) -> SampleSubmission:

	if need == null:
		return null

	if part == null:
		return null

	var submission := SampleSubmission.new()

	submission.need = need
	submission.part = part
	submission.submission_time = submission_time

	return submission


# Evaluates a submitted sample.
#
# Initial implementation uses a simple attribute comparison.
func evaluate_submission(
	submission: SampleSubmission
) -> void:

	if submission == null:
		return

	if submission.need == null:
		return

	if submission.part == null:
		return

	var total_score: float = 0.0
	var attribute_count: int = 0

	for attribute_name in (
		submission.need.target_attributes.keys()
	):

		var target_value: float = (
			submission.need.target_attributes[
				attribute_name
			]
		)

		if target_value <= 0.0:
			continue

		var actual_value: float = (
			submission.part.get_attribute(
				attribute_name
			)
		)

		var attribute_score := min(
			actual_value / target_value,
			1.0
		)

		total_score += attribute_score
		attribute_count += 1

	var final_score: float = 0.0

	if attribute_count > 0:
		final_score = (
			total_score / attribute_count
		)

	var accepted := (
		final_score
		>= submission.need.need_definition.acceptance_threshold
	)

	submission.record_evaluation(
		final_score,
		accepted,
		submission.submission_time
	)

# ------------------------------------------------------------------
# Contract Functions
# ------------------------------------------------------------------

func create_contract(
	submission: SampleSubmission,
	contract_value: float,
	creation_time: float
) -> Contract:

	if submission == null:
		return null

	if not submission.is_accepted:
		return null

	var contract := Contract.new()

	contract.need = submission.need
	contract.sample_submission = submission

	if submission.part.part_definition != null:
		contract.part_definition = (
			submission.part.part_definition
		)

	contract.contract_value = contract_value
	contract.creation_time = creation_time

	return contract

# ------------------------------------------------------------------
# Order Functions
# ------------------------------------------------------------------

func create_order(
	contract: Contract,
	order_name: String,
	quantity: int,
	payment_amount: float,
	due_time: float
) -> Order:

	if contract == null:
		return null

	var order := Order.new()

	order.order_name = order_name
	order.part_definition = (
		contract.part_definition
	)
	order.required_quantity = quantity
	order.payment_amount = payment_amount
	order.due_time = due_time

	contract.add_order(order)

	return order

# ------------------------------------------------------------------
# Health Checks
# ------------------------------------------------------------------

func refresh_market(
	market: Market,
	current_time: float
) -> void:

	if market == null:
		return

	market.remove_expired_needs(
		current_time
	)

	market.refresh_market(
		current_time
	)

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

func get_summary() -> String:

	return (
		
