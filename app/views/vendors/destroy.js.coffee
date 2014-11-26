existingVendorRow = $(".vendors.results table tr[data-id='<%= @vendor.id %>']")

existingVendorRow.fadeOut ()->
  existingVendorRow.remove()