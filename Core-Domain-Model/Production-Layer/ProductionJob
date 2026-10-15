##
# ProductionJob
#
# ProductionJob is a Production Layer object representing a
# manufacturing effort created to satisfy an Order.
#
# A ProductionJob tracks the progress of producing a specific
# quantity of a product and serves as the production-side
# representation of customer demand.
#
# ProductionJob sits above:
# - WorkInstructions
# - Tasks
# - OperationExecutions
#
# ProductionJob does not perform manufacturing work directly.
# It does not operate machines, move parts, or assign employees.
#
# Instead, ProductionJob exists to:
# - Define what must be produced
# - Track progress toward completion
# - Connect production activity to an Order
# - Provide visibility into manufacturing status
#
# In Startup Simulator, ProductionJob is the primary object used
# to monitor production progress from start to completion.
##

class_name ProductionJob
extends RefCounted

# ------------------------------------------------------------------
# Identity
# ------------------------------------------------------------------

var production_job_id: int = 0

var production_job_name: String = ""

# ------------------------------------------------------------------
# Order Information
# ------------------------------------------------------------------

# Order being fulfilled by this ProductionJob.
var order: Order = null

# Product to manufacture.
var part_definition: PartDefinition = null

# ------------------------------------------------------------------
# Quantity Tracking
# ------------------------------------------------------------------

# Quantity requested by the Order.
var required_quantity: int = 0

# Quantity successfully completed.
var completed_quantity: int = 0

# ------------------------------------------------------------------
# Production Planning
# ------------------------------------------------------------------

# WorkInstructions used to manufacture this product.
var work_instructions: Array[WorkInstruction] = []

# ------------------------------------------------------------------
# Timing
# ------------------------------------------------------------------

var creation_time: float = 0.0

var completion_time: float = 0.0

# ------------------------------------------------------------------
# State
# ------------------------------------------------------------------

var is_complete: bool = false

var is_cancelled: bool = false

# ------------------------------------------------------------------
# Progress Functions
# ------------------------------------------------------------------

# Adds completed quantity to this job.
func add_completed_quantity(quantity: int) -> void:

        if quantity <= 0:
                return

        completed_quantity += quantity

        if completed_quantity >= required_quantity:
                completed_quantity = required_quantity
                is_complete = true


# Returns quantity remaining to be produced.
func get_remaining_quantity() -> int:
        return max(required_quantity - completed_quantity, 0)


# Returns completion percentage from 0.0 to 1.0.
func get_completion_percent() -> float:

        if required_quantity <= 0:
                return 0.0

        return float(completed_quantity) / float(required_quantity)

# ------------------------------------------------------------------
# Work Instruction Functions
# ------------------------------------------------------------------

# Adds a WorkInstruction to this ProductionJob.
func add_work_instruction(
        work_instruction: WorkInstruction
) -> void:

        if work_instruction == null:
                return

        if work_instructions.has(work_instruction):
                return

        work_instructions.append(work_instruction)


# Returns the number of WorkInstructions assigned.
func get_work_instruction_count() -> int:
        return work_instructions.size()

# ------------------------------------------------------------------
# State Functions
# ------------------------------------------------------------------

# Marks the ProductionJob as complete.
func mark_complete(current_time: float) -> void:

        is_complete = true
        completion_time = current_time


# Cancels the ProductionJob.
func cancel() -> void:

        if is_complete:
                return

        is_cancelled = true


# Returns true if the job can continue production.
func is_active() -> bool:

        return (
                not is_complete
                and not is_cancelled
        )

# ------------------------------------------------------------------
# Validation Functions
# ------------------------------------------------------------------

func has_valid_order() -> bool:
        return order != null


func has_valid_part_definition() -> bool:
        return part_definition != null


func is_valid_job() -> bool:

        if not has_valid_order():
                return false

        if not has_valid_part_definition():
                return false

        if required_quantity <= 0:
                return false

        return true

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

func get_summary() -> String:

        return "%s | %d/%d Complete | %.0f%%" % [
                production_job_name,
                completed_quantity,
                required_quantity,
                get_completion_percent() * 100.0
        ]
