try
  <% if(@event.valid? && !@party.nil? && !@event_transaction_method.nil?) %>

  modalWrapper      = $('.update_transaction_method_form')
  modalWrapper.modal('hide')

  party_type = "<%= @party.class.name %>"
  party_id = "<%= @party.id %>"

  transaction_method = "<%= @event_transaction_method.transaction_method %>"

  $('#transaction_method_' + party_type + '_' + party_id).html(transaction_method)

  if transaction_method == "CC"
    $('#transaction_info1_' + party_type + '_' + party_id).html("<%= @event_transaction_method.info1 %>")
    $('#transaction_info2_' + party_type + '_' + party_id).html("<%= @event_transaction_method.info2 %>")
    $('.transaction_info_' + party_type + '_' + party_id).show()
  else
    $('.transaction_info_' + party_type + '_' + party_id).hide()

  <% end %>

catch e
  console.log "Error parsing response in events/update_transaction_method.js.coffee", e.message, _.unescape("<%= @event.errors.to_json %>")