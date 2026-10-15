##
# ShippingService
#
# ShippingService is a Service Layer object responsible for
# coordinating logistics activities throughout Startup Simulator.
#
# ShippingService acts as the logistics orchestration layer between:
#
# ShippingRequest
#     ↓
# Delivery
#     ↓
# ArrivalArea / ShippingArea
#
# Responsibilities:
# - Create ShippingRequests
# - Create Deliveries
# - Dispatch Deliveries
# - Monitor Delivery progress
# - Complete Deliveries
#
# ShippingService does NOT:
# - Manage inventory ownership
# - Manufacture products
# - Generate market demand
# - Process finances
#
# Those responsibilities belong to other services.
#
# ShippingService exists to answer the question:
#
#     "How do goods move through the logistics network?"
##

class_name ShippingService
extends RefCounted

# ------------------------------------------------------------------
# Active Logistics
# ------------------------------------------------------------------

var active_requests: Array[ShippingRequest] = []

var active_deliveries: Array[Delivery] = []

# ------------------------------------------------------------------
# Shipping Request Functions
# ------------------------------------------------------------------

func create_shipping_request(
	request_name: String,
	request_type: ShippingRequest.RequestType,
	origin_location: Location,
	destination_location: Location,
	scheduled_ship_time: float,
	expected_arrival_time: float
) -> ShippingRequest:

	var request := ShippingRequest.new()

	request.shipping_request_name = request_name
	request.request_type = request_type
	request.origin_location = origin_location
	request.destination_location = destination_location
	request.scheduled_ship_time = scheduled_ship_time
	request.expected_arrival_time = expected_arrival_time

	active_requests.append(request)

	return request


func add_request(
	request: ShippingRequest
) -> bool:

	if request == null:
		return false

	if active_requests.has(request):
		return false

	active_requests.append(request)

	return true


func remove_request(
	request: ShippingRequest
) -> bool:

	if request == null:
		return false

	return active_requests.erase(request)

# ------------------------------------------------------------------
# Delivery Functions
# ------------------------------------------------------------------

func create_delivery(
	request: ShippingRequest
) -> Delivery:

	if request == null:
		return null

	var delivery := Delivery.new()

	delivery.delivery_name = request.shipping_request_name
	delivery.origin_location = request.origin_location
	delivery.destination_location = request.destination_location
	delivery.arrival_time = request.expected_arrival_time

	for assembly in request.assemblies:
		delivery.add_assembly(assembly)

	request.assign_delivery(delivery)

	active_deliveries.append(delivery)

	return delivery


func dispatch_delivery(
	request: ShippingRequest,
	current_time: float
) -> Delivery:

	if request == null:
		return null

	if not request.is_ready_to_ship(current_time):
		return null

	var delivery := create_delivery(request)

	if delivery == null:
		return null

	delivery.depart(current_time)

	return delivery

# ------------------------------------------------------------------
# Delivery Monitoring
# ------------------------------------------------------------------

func update_deliveries(
	current_time: float
) -> void:

	var completed_deliveries: Array[Delivery] = []

	for delivery in active_deliveries:

		if delivery.is_ready_for_delivery(current_time):

			delivery.deliver(current_time)

			completed_deliveries.append(delivery)

	for delivery in completed_deliveries:
		active_deliveries.erase(delivery)

# ------------------------------------------------------------------
# Request Completion
# ------------------------------------------------------------------

func mark_request_fulfilled(
	request: ShippingRequest
) -> void:

	if request == null:
		return

	request.mark_fulfilled()

# ------------------------------------------------------------------
# Query Functions
# ------------------------------------------------------------------

func get_active_request_count() -> int:
	return active_requests.size()


func get_active_delivery_count() -> int:
	return active_deliveries.size()


func has_active_requests() -> bool:
	return not active_requests.is_empty()


func has_active_deliveries() -> bool:
	return not active_deliveries.is_empty()

# ------------------------------------------------------------------
# Validation Functions
# ------------------------------------------------------------------

func is_valid_service() -> bool:
	return true

# ------------------------------------------------------------------
# Debug Functions
# ------------------------------------------------------------------

func get_summary() -> String:

	return "Requests: %d | Deliveries: %d" % [
		get_active_request_count(),
		get_active_delivery_count()
	]
