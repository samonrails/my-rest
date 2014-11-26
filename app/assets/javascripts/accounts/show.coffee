Application.AccountDetails = Backbone.View.extend
  events:
    "click #section-tab-navigation a" : "selectTab"

  initialize: ()->
    @setElement $('#account-details')

    _.bindAll @, "selectTab"

    @setupFormBindings()

    @delegateEvents()

  setupFormBindings: ()->
    @$('#billing-section form').ajaxError (e, request, settings)=>
      console.log "Error", arguments

    @$('#billing-section form').on "ajax:success", (e, data, status, xhr)=>
      Application.successMessage @$('#billing-section')


  selectTab: (e)->
    e.preventDefault()

    target = @$(e.target)
    target.tab('show')

    @$('.section-tab').hide()
    @$(".section-tab#{ target.attr('href') }").show()


# This will specifically get called on the accounts show action
Application.accounts.show = ()->
  window.accountDetails = new Application.AccountDetails()

$('#payment_method').on 'change', ->
  payment_method = $('#payment_method :selected').text()
  if payment_method == 'CC'
    $('.js-payment-method-toggle-extra-info').show()
  else
    $('.js-payment-method-toggle-extra-info').hide()

$('#account_preference_preference_type').on 'change', ->
  preference_type = $('#account_preference_preference_type :selected').text()
  $('.js-event-toggle-preference-type').show()
  if preference_type == 'Vendor'
    $('.js-event-toggle-preference-type-cuisine').hide()
    $('.js-event-toggle-preference-type-vendor').show()
  if preference_type == 'Cuisine'
    $('.js-event-toggle-preference-type-vendor').hide()
    $('.js-event-toggle-preference-type-cuisine').show()
