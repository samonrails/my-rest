# ------------------ Select Event Vendor -----------------------------------

$(document).on 'click', '#add_event_vendor_select_event_add_event_vendor', (event) ->
	select_event_id = $(this).data('select_event_id')

	$.ajax
    type: "Get"
    url: "/select_events/" + select_event_id + "/select_event_vendors/new"
    success: (data) ->
      $("#new_select_event_vendor_form").html data
    error: (e) ->
      alert "error"


$(document).on 'change', '.select_event_vendor_cuisine', (event) ->
    event.preventDefault()
    cuisine = $(this).val()
    edit_row_id = $(this).attr('data-edit_row_id')
   
    callback = (response) ->
      $el = $("#event_vendor_vendor_" + edit_row_id)
      $el.empty()
      for k,v of response
        $newelement = $("<optgroup>");
        $el.append $newelement.attr("label", k)
        $.each v, (index, vendor) ->
          $optionElement = $("<option></option>")
          $optionElement.attr("value", vendor.id).text(vendor.name)
          $optionElement.appendTo $newelement
      $el.trigger("change")

    event_vendor_type_arg = ''
    if ( $('#event_vendor_type').val() != undefined )
      event_vendor_type_arg = '&event_vendor_type='+$('#event_vendor_type').val()
    
    $.get '/vendors/get_vendors_by_cuisine_and_product_and_market_and_account?cuisine='+cuisine+'&product='+$('#event_vendor_product').val()+'&market='+$('#event_vendor_market').val()+'&account_id='+$('#event_vendor_account_id').val()+ event_vendor_type_arg, {}, callback, "json"



$(document).on 'click', '.open_edit_select_event_vendor', (event) ->
  select_event_vendor_id = $(this).data('id')
  select_event_id = $(this).data('select_event_id')
  
  $.ajax
    type: "Get"
    url: "/select_events/" + select_event_id + "/select_event_vendors/" + select_event_vendor_id
    success: (data) ->
      $("#edit_select_event_vendor_form").html data
    error: (e) ->
      alert "error"

$(document).on 'change', '.select_event_vendor_vendor', (event) ->
    event.preventDefault()
    vendor_id = $(this).val()
    edit_row_id = $(this).attr('data-edit_row_id')

    unless vendor_id?
      $el = $("#select_event_vendor_menu_template_" + edit_row_id)
      $el.empty()
    else
      callback = (response) ->
        $el = $("#select_event_vendor_menu_template_" + edit_row_id)
        $el.empty()
        $.each response, (index, menu_template) ->
          $el.append $("<option></option>").attr("value", menu_template.id).text(menu_template.name)
      $.get '/vendors/'+vendor_id+'/get_vendor_menu_templates_by_product?product=select', {}, callback, "json"
        
