Application.VendorDetails = Backbone.View.extend
  events:
    "click #section-tab-navigation a" : "selectTab"

  initialize: ()->
    @setElement $('#vendor-details')

    _.bindAll @, "selectTab"

    @setupFormBindings()

    @delegateEvents()

  setupFormBindings: ()->
    @$('#product-config-section form').ajaxError (e, request, settings)=>
      console.log "Error", arguments

    @$('#product-config-section form').on "ajax:success", (e, data, status, xhr)=>
      Application.successMessage @$('#product-config-section')


  selectTab: (e)->
    e.preventDefault()

    target = @$(e.target)
    target.tab('show')

    @$('.section-tab').hide()
    @$(".section-tab#{ target.attr('href') }").show()


# This will specifically get called on the vendors show action
Application.vendors.show = ()->
  console.log "vendors.show"
  window.vendorDetails = new Application.VendorDetails()

$('#inventory_item_add_on').on 'change', -> 
  if $('#inventory_item_add_on').is(":checked")
    $('.primary-inventory-item').hide()
  else
    $('.primary-inventory-item').show()

$('#inventory_item_add_on').trigger 'change'

$('a').tooltip();

# ------------------- Vendor Preferences -------------------

$('#vendor_preference_preference_type').on 'change', ->
  preference_type = $('#vendor_preference_preference_type :selected').text()
  $('.js-event-toggle-preference-type').show()
  if preference_type == 'Account'
    $('.js-event-toggle-preference-type-account').show()
    $('.js-event-toggle-preference-type-location').hide()
  if preference_type == 'Location'
    $('.js-event-toggle-preference-type-account').hide()
    $('.js-event-toggle-preference-type-location').show()

