##
# SampleSubmission
#
# SampleSubmission is a Market Layer object representing a player's
# attempt to satisfy a Need by submitting a manufactured product
# for evaluation.
#
# SampleSubmission serves as the bridge between:
#
# Need
#     ↓
# SampleSubmission
#     ↓
# Contract
#
# A SampleSubmission records:
# - Which Need was targeted
# - Which product was submitted
# - Evaluation results
# - Acceptance status
#
# SampleSubmission does NOT:
# - Evaluate products
# - Generate contracts
# - Generate orders
#
# Those responsibilities belong to MarketService.
#
# SampleSubmission exists to answer the question:
#
#     "What was submitted, and what was the result?"
##

class_name SampleSubmission
extends RefCounted

# ------------------------------------------------------------------
# Identity
# ------------------------------------------------------------------

var submission_id: int = 0

# ------------------------------------------------------------------
# Submission Information
# ------------------------------------------------------------------

# Need being targeted.
var need: Need = null

# Product being submitted.
#
# Initial implementation assumes a single Part.
var part: Part = null

# ------------------------------------------------------------------
# Timing
# ------------------------------------------------------------------

# MasterClock time when submitted.
var submission_time: float = 0.0

# MasterClock time when evaluation completed.
var evaluation_time: float = 0.0

# ------------------------------------------------------------------
# Evaluation Results
# ------------------------------------------------------------------

# Overall evaluation score.
#
# Scoring logic belongs to MarketService.
var score: float = 0.0

# Whether the submission was accepted.
var is_accepted: bool = false

# Whether evaluation has occurred.
var is_evaluated: bool = false

# ------------------------------------------------------------------
# Evaluation Functions
# ------------------------------------------------------------------

# Records evaluation results.
func record_evaluation(
        new_score: float,
        accepted: bool,
        current_time: float
) -> void:

        score = new_score
        is_accepted = accepted
        is_evaluated = true
        evaluation_time = current_time


# Returns true if the submission was successful.
func was_accepted() -> bool:
        return is_accepted


# Returns true if evaluation has occurred.
func has_been_evaluated() -> bool:
        return is_evaluated

# ------------------------------------------------------------------
# Validation Functions
# ------------------------------------------------------------------

func has_valid_need() -> bool:
        return need != null


func has_valid_part() -> bool:
        return part != null


func is_valid_submission() -> bool:

        if not has_valid_need():
                return false

        if not has_valid_part():
                return false

        return true

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

func get_summary() -> String:

        return "Score: %.2f | Accepted: %s | Evaluated: %s" % [
                score,
                str(is_accepted),
                str(is_evaluated)
        ]
