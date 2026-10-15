##
# ShopFloor
#
# ShopFloor is a World Layer object representing the physical
# production area within a Facility.
#
# ShopFloor serves as the organizational container for manufacturing
# activities and physically groups together the resources required
# for production.
#
# A ShopFloor may contain:
# - Equipment
# - Employees
# - Storage Areas
# - Arrival Areas
# - Shipping Areas
#
# Examples:
# - Home Garage Shop
# - Small Manufacturing Cell
# - Warehouse Production Area
# - Factory Production Hall
#
# ShopFloor does NOT:
# - Perform manufacturing
# - Schedule jobs
# - Manage inventory
# - Generate market demand
#
# Those responsibilities belong to Production, Logistics,
# and Market systems.
#
# ShopFloor exists to answer the question:
#
#     "Where does production physically occur?"
##

class_name ShopFloor
extends RefCounted

# ------------------------------------------------------------------
# Identity
# ------------------------------------------------------------------

var shop_floor_id: int = 0

var shop_floor_name: String = ""

# ------------------------------------------------------------------
# Facility References
# ------------------------------------------------------------------

var facility: Facility = null

# ------------------------------------------------------------------
# Production Assets
# ------------------------------------------------------------------

var equipment: Array[Equipment] = []

var employees: Array[Employee] = []

# ------------------------------------------------------------------
# World Areas
# ------------------------------------------------------------------

var storage_areas: Array[StorageArea] = []

var arrival_areas: Array[ArrivalArea] = []

var shipping_areas: Array[ShippingArea] = []

# ------------------------------------------------------------------
# Equipment Functions
# ------------------------------------------------------------------

func add_equipment(machine: Equipment) -> bool:

        if machine == null:
                return false

        if equipment.has(machine):
                return false

        equipment.append(machine)

        return true


func remove_equipment(machine: Equipment) -> bool:

        if machine == null:
                return false

        return equipment.erase(machine)


func get_equipment_count() -> int:
        return equipment.size()

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
# Storage Area Functions
# ------------------------------------------------------------------

func add_storage_area(
        storage_area: StorageArea
) -> bool:

        if storage_area == null:
                return false

        if storage_areas.has(storage_area):
                return false

        storage_areas.append(storage_area)

        return true


func get_storage_area_count() -> int:
        return storage_areas.size()

# ------------------------------------------------------------------
# Arrival Area Functions
# ------------------------------------------------------------------

func add_arrival_area(
        arrival_area: ArrivalArea
) -> bool:

        if arrival_area == null:
                return false

        if arrival_areas.has(arrival_area):
                return false

        arrival_areas.append(arrival_area)

        return true


func get_arrival_area_count() -> int:
        return arrival_areas.size()

# ------------------------------------------------------------------
# Shipping Area Functions
# ------------------------------------------------------------------

func add_shipping_area(
        shipping_area: ShippingArea
) -> bool:

        if shipping_area == null:
                return false

        if shipping_areas.has(shipping_area):
                return false

        shipping_areas.append(shipping_area)

        return true


func get_shipping_area_count() -> int:
        return shipping_areas.size()

# ------------------------------------------------------------------
# Query Functions
# ------------------------------------------------------------------

func is_empty() -> bool:

        return (
                equipment.is_empty()
                and employees.is_empty()
        )

# ------------------------------------------------------------------
# Validation Functions
# ------------------------------------------------------------------

func is_valid_shop_floor() -> bool:

        if shop_floor_name.is_empty():
                return false

        return true

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

func get_summary() -> String:

        return "%s | Equipment: %d | Employees: %d" % [
                shop_floor_name,
                get_equipment_count(),
                get_employee_count()
        ]
