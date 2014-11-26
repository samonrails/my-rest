modalWrapper      = $('.new-vendor-form')
tableBody         = $('.vendors.results table tbody')
vendorForm        = $('.new-vendor-form form')

try
  <% if(@vendor.valid?) %>

  modalWrapper.modal('hide')
  Application.successMessage tableBody.parents('.results')

  done = false

  tableBody.children('tr').each ->
    if !done
      if $(this).attr("data-name") > "<%= @vendor.name %>"
        $(this).before("<%= j render(:partial=>'vendors/partials/table_row',locals:{:vendor=>@vendor}) %>")
        done = true

  if !done
    tableBody.append("<%= j render(:partial=>'vendors/partials/table_row',locals:{:vendor=>@vendor}) %>")

  # clear the form so it can be used again
  Application.forms.clear(vendorForm)

  <% else %>
  Application.displayModelErrors("<%= @vendor.errors.to_json %>", model:"vendor").onForm(vendorForm)
  <% end %>

catch e
  console.log "Error parsing response in vendors/create.js.coffee", e.message, _.unescape("<%= @vendor.errors.to_json %>")