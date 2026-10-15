##
# ProductionService
#
# ProductionService is a Service Layer object responsible for
# coordinating manufacturing activities throughout Startup Simulator.
#
# ProductionService acts as the orchestration layer between:
#
# Orders
#     ↓
# ProductionJobs
#     ↓
# WorkInstructions
#     ↓
# Tasks
#     ↓
# OperationExecutions
#     ↓
# Parts
#
# Responsibilities:
# - Create ProductionJobs
# - Manage active ProductionJobs
# - Create OperationExecutions
# - Complete OperationExecutions
# - Monitor production progress
#
# ProductionService does NOT:
# - Operate Equipment
# - Execute Employee Tasks
# - Generate Orders
# - Generate Market Demand
#
# Those responsibilities belong to other layers.
#
# ProductionService exists to answer the question:
#
#     "How does production move forward?"
##

class_name ProductionService
extends RefCounted

# ------------------------------------------------------------------
# Active Production
# ------------------------------------------------------------------

var active_jobs: Array[ProductionJob] = []

var active_executions: Array[OperationExecution] = []

# ------------------------------------------------------------------
# Production Job Functions
# ------------------------------------------------------------------

# Creates a ProductionJob from an Order.
func create_production_job(
	order: Order,
	current_time: float
) -> ProductionJob:

	if order == null:
		return null

	var job := ProductionJob.new()

	job.production_job_name = order.order_name
	job.order = order
	job.part_definition = order.part_definition
	job.required_quantity = order.required_quantity
	job.creation_time = current_time

	active_jobs.append(job)

	return job


# Registers an existing ProductionJob.
func add_job(
	job: ProductionJob
) -> bool:

	if job == null:
		return false

	if active_jobs.has(job):
		return false

	active_jobs.append(job)

	return true


# Removes a completed or cancelled job.
func remove_job(
	job: ProductionJob
) -> bool:

	if job == null:
		return false

	return active_jobs.erase(job)

# ------------------------------------------------------------------
# Operation Execution Functions
# ------------------------------------------------------------------

# Creates a new operation execution.
func create_operation_execution(
	equipment: Equipment,
	part: Part,
	operation: OperationDefinition,
	current_time: float
) -> OperationExecution:

	if equipment == null:
		return null

	if part == null:
		return null

	if operation == null:
		return null

	var execution := OperationExecution.new(
		equipment,
		part,
		operation,
		current_time
	)

	active_executions.append(execution)

	return execution


# Starts an operation on Equipment.
func start_operation(
	equipment: Equipment,
	part: Part,
	operation: OperationDefinition,
	current_time: float
) -> OperationExecution:

	if not equipment.can_start_operation(operation):
		return null

	var execution := create_operation_execution(
		equipment,
		part,
		operation,
		current_time
	)

	if execution == null:
		return null

	var started := equipment.start_operation(
		operation,
		execution
	)

	if not started:
		active_executions.erase(execution)
		return null

	return execution


# Updates all active executions.
#
# Intended to be called periodically by the game loop.
func update_executions(
	current_time: float
) -> void:

	var completed_executions: Array[
		OperationExecution
	] = []

	for execution in active_executions:

		if execution.is_ready_to_complete(current_time):

			execution.complete(current_time)

			if execution.equipment != null:
				execution.equipment.complete_operation()

			completed_executions.append(execution)

	for execution in completed_executions:
		active_executions.erase(execution)

# ------------------------------------------------------------------
# Production Progress Functions
# ------------------------------------------------------------------

# Records completed quantity for a job.
func record_completed_quantity(
	job: ProductionJob,
	quantity: int,
	current_time: float
) -> void:

	if job == null:
		return

	job.add_completed_quantity(quantity)

	if job.is_complete and job.completion_time <= 0.0:
		job.mark_complete(current_time)


# Returns completion percentage for a job.
func get_job_progress(
	job: ProductionJob
) -> float:

	if job == null:
		return 0.0

	return job.get_completion_percent()

# ------------------------------------------------------------------
# Query Functions
# ------------------------------------------------------------------

func get_active_job_count() -> int:
	return active_jobs.size()


func get_active_execution_count() -> int:
	return active_executions.size()


func has_active_jobs() -> bool:
	return not active_jobs.is_empty()


func has_active_executions() -> bool:
	return not active_executions.is_empty()

# ------------------------------------------------------------------
# Validation Functions
# ------------------------------------------------------------------

func is_valid_service() -> bool:
	return true

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

func get_summary() -> String:

	return "Jobs: %d | Executions: %d" % [
		get_active_job_count(),
		get_active_execution_count()
	]
