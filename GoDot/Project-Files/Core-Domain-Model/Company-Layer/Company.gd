##
# Company
#
# Company is a Company Layer object representing the player's business.
#
# Company serves as the top-level business entity within Startup
# Simulator and acts as the owner of assets, employees, facilities,
# equipment, contracts, and financial accounts.
#
# Company is responsible for tracking:
# - Business identity
# - Owned facilities
# - Employees
# - Asset ownership
# - Financial accounts
#
# Company does NOT:
# - Perform manufacturing
# - Execute logistics
# - Generate market opportunities
# - Calculate accounting transactions
#
# Those responsibilities belong to Production, Logistics,
# Market, and Finance systems respectively.
#
# Company exists to answer a simple question:
#
#     "Who owns this business?"
##

class_name Company
extends RefCounted

# ------------------------------------------------------------------
# Identity
# ------------------------------------------------------------------

var company_id: int = 0

var company_name: String = ""

# ------------------------------------------------------------------
# Business Structure
# ------------------------------------------------------------------

# Primary financial account.
var account: Account = null

# Registry of all owned assets.
var asset_register: AssetRegister = null

# ------------------------------------------------------------------
# Ownership
# ------------------------------------------------------------------

var facilities: Array[Facility] = []

var employees: Array[Employee] = []

# ------------------------------------------------------------------
# Timing
# ------------------------------------------------------------------

# MasterClock time when the company was founded.
var creation_time: float = 0.0

# ------------------------------------------------------------------
# Facility Functions
# ------------------------------------------------------------------

func add_facility(facility: Facility) -> bool:

        if facility == null:
                return false

        if facilities.has(facility):
                return false

        facilities.append(facility)

        return true


func remove_facility(facility: Facility) -> bool:

        if facility == null:
                return false

        return facilities.erase(facility)


func get_facility_count() -> int:
        return facilities.size()

# ------------------------------------------------------------------
# Employee Functions
# ------------------------------------------------------------------

func add_employee(employee: Employee) -> bool:

        if employee == null:
                return false

        if employees.has(employee):
                return false

        employees.append(employee)

        return true


func remove_employee(employee: Employee) -> bool:

        if employee == null:
                return false

        return employees.erase(employee)


func get_employee_count() -> int:
        return employees.size()

# ------------------------------------------------------------------
# Account Functions
# ------------------------------------------------------------------

func has_account() -> bool:
        return account != null


func get_cash_balance() -> float:

        if account == null:
                return 0.0

        return account.cash_balance

# ------------------------------------------------------------------
# Asset Functions
# ------------------------------------------------------------------

func has_asset_register() -> bool:
        return asset_register != null

# ------------------------------------------------------------------
# Validation Functions
# ------------------------------------------------------------------

func is_valid_company() -> bool:

        if company_name.is_empty():
                return false

        return true

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

func get_summary() -> String:

        return "%s | Facilities
