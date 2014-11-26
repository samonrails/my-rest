# ------------------ Select Event Schedule Vendor -----------------------------------

$(document).on 'click', '.open_edit_select_event_schedule_vendor', (event) ->
  select_event_schedule_vendor_id = $(this).data('id')
  account_id = $(this).data('account_id')

  $.ajax
    type: "Get"
    url: "/accounts/" + account_id + "/select_event_schedule_vendors/" + select_event_schedule_vendor_id
    success: (data) ->
      $("#edit_select_event_schedule_vendor_form").html data
    error: (e) ->
      alert "error"
