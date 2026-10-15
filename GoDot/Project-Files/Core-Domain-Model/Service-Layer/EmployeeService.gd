##
# EmployeeService
#
# EmployeeService is a Service Layer object responsible for
# coordinating employee work throughout Startup Simulator.
#
# EmployeeService acts as the workforce orchestration layer between:
#
# Employees
#     ↓
# WorkInstructions
#     ↓
# Tasks
#
# Responsibilities:
# - Assign WorkInstructions
# - Assign Tasks
# - Monitor employee availability
# - Monitor employee workload
#
# EmployeeService does NOT:
# - Create production requirements
# - Generate WorkInstructions
# - Create Orders
# - Schedule manufacturing
#
# Those responsibilities belong to ProductionService
# and MarketService.
#
# EmployeeService exists to answer the question:
#
#     "Who should perform this work?"
##

class_name EmployeeService
extends RefCounted

# ------------------------------------------------------------------
# Employee Registry
# ------------------------------------------------------------------

var employees: Array[Employee] = []

# ------------------------------------------------------------------
# Employee Functions
# ------------------------------------------------------------------

func add_employee(
	employee: Employee
) -> bool:

	if employee == null:
		return false

	if employees.has(employee):
		return false

	employees.append(employee)

	return true


func remove_employee(
	employee: Employee
) -> bool:

	if employee == null:
		return false

	return employees.erase(employee)


func get_employee_count() -> int:
	return employees.size()

# ------------------------------------------------------------------
# Work Instruction Assignment
# ------------------------------------------------------------------

func assign_work_instruction(
	employee: Employee,
	work_instruction: WorkInstruction
) -> bool:

	if employee == null:
		return false

	if work_instruction == null:
		return false

	return employee.assign_work_instruction(
		work_instruction
	)

# ------------------------------------------------------------------
# Task Assignment
# ------------------------------------------------------------------

func assign_task(
	employee: Employee,
	task: Task
) -> bool:

	if employee == null:
		return false

	if task == null:
		return false

	if not employee.can_accept_work():
		return false

	return employee.assign_task(task)


# Completes the Employee's current Task.
func complete_task(
	employee: Employee
) -> void:

	if employee == null:
		return

	employee.complete_task()

# ------------------------------------------------------------------
# Query Functions
# ------------------------------------------------------------------

func get_available_employees() -> Array[Employee]:

	var available_employees: Array[Employee] = []

	for employee in employees:

		if employee.can_accept_work():
			available_employees.append(employee)

	return available_employees


func get_busy_employees() -> Array[Employee]:

	var busy_employees: Array[Employee] = []

	for employee in employees:

		if not employee.can_accept_work():
			busy_employees.append(employee)

	return busy_employees


func get_available_employee_count() -> int:
	return get_available_employees().size()


func get_busy_employee_count() -> int:
	return get_busy_employees().size()

# ------------------------------------------------------------------
# Task Queries
# ------------------------------------------------------------------

func has_available_employee() -> bool:

	for employee in employees:

		if employee.can_accept_work():
			return true

	return false


# Returns the first available employee.
#
# Initial implementation uses a simple first-available strategy.
# More advanced assignment systems can be added later.
func get_next_available_employee() -> Employee:

	for employee in employees:

		if employee.can_accept_work():
			return employee

	return null

# ------------------------------------------------------------------
# Status Functions
# ------------------------------------------------------------------

func has_employees() -> bool:
	return not employees.is_empty()

# ------------------------------------------------------------------
# Validation Functions
# ------------------------------------------------------------------

func is_valid_service() -> bool:
	return true

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

func get_summary() -> String:

	return "Employees: %d | Available: %d | Busy: %d" % [
		get_employee_count(),
		get_available_employee_count(),
		get_busy_employee_count()
	]
