try
  <% if(!@error.nil?) %>
    bootbox.alert "Error creating new Event: <%= @error %>"
  <% else %>
    modalWrapper      = $('.duplicate_event_form')
    modalWrapper.modal('hide')
    bootbox.alert "Event <%= @event.pretty_id %> created"
  <% end %>
catch e
  console.log "Error parsing response in events/duplicate_event.js.coffee", e.message