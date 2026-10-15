##
# Calendar
#
# Calendar is a Time Layer object responsible for converting raw
# MasterClock time into player-facing calendar information.
#
# Calendar provides human-readable representations of time such as:
# - Hours
# - Days
# - Weeks
# - Months
# - Years
#
# Calendar does NOT:
# - Advance time
# - Schedule events
# - Trigger gameplay logic
# - Manage timers
#
# Those responsibilities belong to MasterClock,
# ScheduledEvent, and TimerTask.
#
# Calendar exists to answer the question:
#
#     "What date and time is it?"
#
# All calculations are derived from MasterClock time.
##

class_name Calendar
extends RefCounted

# ------------------------------------------------------------------
# Time Constants
# ------------------------------------------------------------------

const SECONDS_PER_MINUTE: int = 60
const MINUTES_PER_HOUR: int = 60
const HOURS_PER_DAY: int = 24

const SECONDS_PER_HOUR: int = (
	SECONDS_PER_MINUTE * MINUTES_PER_HOUR
)

const SECONDS_PER_DAY: int = (
	SECONDS_PER_HOUR * HOURS_PER_DAY
)

const DAYS_PER_WEEK: int = 7
const DAYS_PER_MONTH: int = 30
const MONTHS_PER_YEAR: int = 12

# ------------------------------------------------------------------
# Time Extraction Functions
# ------------------------------------------------------------------

func get_hour(current_time: float) -> int:

	return int(
		current_time / SECONDS_PER_HOUR
	) % HOURS_PER_DAY


func get_minute(current_time: float) -> int:

	return int(
		current_time / SECONDS_PER_MINUTE
	) % MINUTES_PER_HOUR


func get_day(current_time: float) -> int:

	return int(
		current_time / SECONDS_PER_DAY
	) + 1


func get_week(current_time: float) -> int:

	return (
		(get_day(current_time) - 1)
		/ DAYS_PER_WEEK
	) + 1


func get_month(current_time: float) -> int:

	return (
		(get_day(current_time) - 1)
		/ DAYS_PER_MONTH
	) % MONTHS_PER_YEAR + 1


func get_year(current_time: float) -> int:

	return (
		(get_day(current_time) - 1)
		/ (DAYS_PER_MONTH * MONTHS_PER_YEAR)
	) + 1

# ------------------------------------------------------------------
# Time Formatting Functions
# ------------------------------------------------------------------

# Returns a formatted time string.
#
# Example:
# 08:30
func get_time_string(
	current_time: float
) -> String:

	var hour := get_hour(current_time)
	var minute := get_minute(current_time)

	return "%02d:%02d" % [
		hour,
		minute
	]


# Returns a formatted date string.
#
# Example:
# Year 1, Month 2, Day 14
func get_date_string(
	current_time: float
) -> String:

	return "Year %d, Month %d, Day %d" % [
		get_year(current_time),
		get_month(current_time),
		get_day_in_month(current_time)
	]


# Returns a complete formatted date-time string.
func get_datetime_string(
	current_time: float
) -> String:

	return "%s | %s" % [
		get_date_string(current_time),
		get_time_string(current_time)
	]

# ------------------------------------------------------------------
# Calendar Functions
# ------------------------------------------------------------------

func get_day_in_week(
	current_time: float
) -> int:

	return (
		(get_day(current_time) - 1)
		% DAYS_PER_WEEK
	) + 1


func get_day_in_month(
	current_time: float
) -> int:

	return (
		(get_day(current_time) - 1)
		% DAYS_PER_MONTH
	) + 1

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

func get_summary(
	current_time: float
) -> String:

	return get_datetime_string(current_time)
