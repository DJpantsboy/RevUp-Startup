##
# Market
#
# Market is a Market Layer object representing the active business
# opportunities available to the player.
#
# Market is responsible for:
# - Managing active Needs
# - Managing IndustryProfiles
# - Adding and removing opportunities
# - Tracking market state
#
# Market does NOT:
# - Evaluate Samples
# - Create Contracts
# - Generate Orders
# - Calculate product scores
#
# Those responsibilities belong to MarketService.
#
# Market serves as the runtime container for available demand
# within Startup Simulator.
#
# Market answers the question:
#
#     "What opportunities currently exist?"
##

class_name Market
extends RefCounted

# ------------------------------------------------------------------
# Industry Profiles
# ------------------------------------------------------------------

# Industry profiles available to the market.
var industry_profiles: Array[IndustryProfile] = []

# ------------------------------------------------------------------
# Active Needs
# ------------------------------------------------------------------

# Currently available opportunities.
var active_needs: Array[Need] = []

# ------------------------------------------------------------------
# Market Timing
# ------------------------------------------------------------------

# Last time the market was refreshed.
var last_refresh_time: float = 0.0

# ------------------------------------------------------------------
# Industry Profile Functions
# ------------------------------------------------------------------

func add_industry_profile(
        profile: IndustryProfile
) -> bool:

        if profile == null:
                return false

        if industry_profiles.has(profile):
                return false

        industry_profiles.append(profile)

        return true


func remove_industry_profile(
        profile: IndustryProfile
) -> bool:

        if profile == null:
                return false

        return industry_profiles.erase(profile)


func get_industry_profile_count() -> int:
        return industry_profiles.size()

# ------------------------------------------------------------------
# Need Functions
# ------------------------------------------------------------------

func add_need(need: Need) -> bool:

        if need == null:
                return false

        if active_needs.has(need):
                return false

        active_needs.append(need)

        return true


func remove_need(need: Need) -> bool:

        if need == null:
                return false

        return active_needs.erase(need)


func get_active_need_count() -> int:
        return active_needs.size()


func get_active_needs() -> Array[Need]:
        return active_needs


# Returns all active opportunities for a specific industry.
func get_needs_by_industry(
        industry: IndustryDefinition
) -> Array[Need]:

        var matching_needs: Array[Need] = []

        if industry == null:
                return matching_needs

        for need in active_needs:

                if need.industry_definition == industry:
                        matching_needs.append(need)

        return matching_needs

# ------------------------------------------------------------------
# Market Maintenance
# ------------------------------------------------------------------

# Removes expired Needs.
func remove_expired_needs(
        current_time: float
) -> void:

        var needs_to_remove: Array[Need] = []

        for need in active_needs:

                need.update_status(current_time)

                if not need.is_active:
                        needs_to_remove.append(need)

        for need in needs_to_remove:
                active_needs.erase(need)


# Records market refresh activity.
#
# Actual Need generation belongs to MarketService.
func refresh_market(
        current_time: float
) -> void:

        last_refresh_time = current_time

# ------------------------------------------------------------------
# Validation Functions
# ------------------------------------------------------------------

func has_industry_profiles() -> bool:
        return not industry_profiles.is_empty()


func has_active_needs() -> bool:
        return not active_needs.is_empty()


func is_valid_market() -> bool:
        return has_industry_profiles()

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

func get_summary() -> String:

        return "Profiles: %d | Active Needs: %d" % [
                get_industry_profile_count(),
                get_active_need_count()
        ]
