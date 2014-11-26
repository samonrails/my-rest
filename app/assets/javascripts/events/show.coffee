Application.EventDetails = Backbone.View.extend
  events:
    "click #section-tab-navigation a" : "selectTab"

  initialize: ()->
    @setElement $('#event-details')

    _.bindAll @, "selectTab"

    @delegateEvents()

  selectTab: (e)->
    e.preventDefault()

    target = @$(e.target)
    target.tab('show')

    @$('.section-tab').hide()
    @$(".section-tab#{ target.attr('href') }").show()


# This will specifically get called don the events show action
Application.events.show = ()->
  window.eventDetails = new Application.EventDetails()

$("#event-button-invoice").click (event) ->
  if document.getElementById("event-button-invoice").className.indexOf("disabled") != -1
    return false
  else
    return confirm('Are you sure? Invoicing will lock the event.')

$(".event-document-buttons").click (event) ->
  if document.getElementById("event-button-invoice").className.indexOf("disabled") != -1
    return false
  if document.getElementById("event-button-invoice-summary").className.indexOf("disabled") != -1
    return false
  if document.getElementById("event-button-quote").className.indexOf("disabled") != -1
    return false
  if document.getElementById("event-button-packing-slip").className.indexOf("disabled") != -1
    return false
  if document.getElementById("event-button-purchase-order").className.indexOf("disabled") != -1
    return false

  $('.event-document-buttons').find('.btn').addClass("disabled");

$("a").tooltip
  selector: ""
  placement: "right"

# ----------------------------------- Event Payments ------------------------------------------
# ---------------------------------------------------------------------------------------------

payment_method_change_warning = ->
  $('#payment_method_change_warning').show()

disable_new_transaction_button = -> 
  $('#new_transaction_text').show()
  $('.new-transaction').hide()
  payment_method_change_warning()

enable_new_transaction_button = ->  
  $('#new_transaction_text').hide()
  payment_method = $("#event_transaction_method_transaction_method :selected").val()
  if(payment_method == 'on_account')
    $('.new-transaction').hide()
  else if(payment_method == 'credit_card')
    $('.new-transaction').show()
  else
    $('.new-transaction').hide()

$('#event_transaction_method_transaction_method').change ->
  disable_new_transaction_button()
  payment_method = $("#event_transaction_method_transaction_method :selected").val()
  if(payment_method == 'on_account')
    $('#on_account_payment').show()
    $('.credit_card_payment').hide()
    $('#credit_card_box').hide()
    $('#on_account_div').show()
    $('#payment_history_div').hide()
    $('.new-transaction').hide()
  else if(payment_method == 'credit_card')
    $('#on_account_payment').hide()
    $('.credit_card_payment').show()
    $('#on_account_div').hide()
    $('#credit_card_box').show()
    $('#payment_history_div').show()
    $('.new-transaction').show()
  else
    $('#on_account_payment').hide()
    $('.credit_card_payment').hide()
    $('#on_account_div').hide()
    $('#credit_card_box').hide()
    $('#payment_history_div').hide()
    $('.new-transaction').hide()

$(document).on "change", "#event_transaction_method_transaction_method", ->
  disable_new_transaction_button()
  payment_method = $('#event_transaction_method_transaction_method :selected').val()
  if(payment_method == 'on_account')
    $('#payment_method_account').show()
    $('#payment_method_card').hide()
  else if(payment_method == 'credit_card')
    $('#payment_method_account').hide()
    $('#payment_method_card').show()
  else
    $('#payment_method_account').hide()
    $('#payment_method_card').hide()

select_cards = ->
  user_id = $('#event_transaction_method_user_id :selected').val()
  event_id = $('#event_transaction_method_transaction_method').data('event')
  url = "/events/" + event_id + "/cards?user_id=" + user_id
  $.fetch_cards(url)

$(document).on "change", "#event_transaction_method_user_id", ->
  disable_new_transaction_button()
  select_cards()

select_card = ->
  selected_card = $('#select_payment_method_credit_card :selected').val()
  event_id = $('#event_transaction_method_transaction_method').data('event')
  if event_id? and selected_card?
    url = "/events/" + event_id + "/cards/" + selected_card
    $.fetch_card(url)

$(document).on "change", "#select_payment_method_credit_card", ->
  disable_new_transaction_button()
  select_card()

$.update_card = (url) ->
  $.ajax
    type: "PUT"
    url: url
    success: (data) -> 
      $("#credit_card_box_meta").html(data)
      $('#credit-cards-success-message').html('<div class="alert alert-success">This card has successfully been set as the active payment.<button data-dismiss="alert" class="close" type="button">×</button></div>')
    error: (e) ->
      console.log e
    beforeSend: ->
      $("#credit_card_box_meta").html("<div><center><img src='/assets/ajax-loader.gif' style='align:center'/></center></div>")

$.fetch_card = (url) ->
  $.ajax
    type: "GET"
    url: url
    success: (data) -> 
      $("#credit_card_box_meta").html(data)
    error: (e) ->
      console.log e
    beforeSend: ->
      $("#credit_card_box_meta").html("<div><center><img src='/assets/ajax-loader.gif' style='align:center'/></center></div>")


$.fetch_cards = (url) ->
  $.ajax
    type: "GET"
    url: url
    dataType: "html"
    success: (data) -> 
      $("#credit_card_box").html(data)
      select_card()
      $.validate_form()
    error: (e) ->
      console.log e
    beforeSend: ->
      $("#credit_card_box").html("<div class='well white'><center><img src='/assets/ajax-loader.gif' style='align:center'/></center></div>")

$(document).on 'click', '#save_payment_method', ->
  data = $('#payment_form').serialize()

  transaction_card_token = $('#select_payment_method_credit_card :selected').val()
  if transaction_card_token?
    data += "&event_transaction_method[transaction_card_token]=#{transaction_card_token}"
  
  event_id = $('#event_transaction_method_transaction_method').data('event')
  event_transaction_method_id = $('#event_transaction_method_transaction_method').data('event-transaction-method') 

  $.ajax
    type: "PUT"
    url: "/events/" + event_id + "/event_transaction_method/" + event_transaction_method_id
    data: data
    dataType: "json"
    success: (data) ->
      $('#new_card_user_name').html(data.user_name)
      select_cards()
      enable_new_transaction_button()
      $('#payment_method_change_warning').hide()
      $('.payment-alert-container').html('<div class="alert alert-success">Event payment method updated successfully<button data-dismiss="alert" class="close" type="button">×</button></div>')
    error: (e) ->
      console.log e
      message= '<div class="alert alert-error">Failed to update payment method: ' + e.responseText + ' <button data-dismiss="alert" class="close" type="button">×</button></div>'
      $('.payment-alert-container').html(message)


# --------------------------- Event Payments: Transactions ------------------------------------
# ---------------------------------------------------------------------------------------------



$(document).on "click", ".new-transaction", (event) ->
  $.ajax
    type: "GET"
    url: $(this).attr('data-url')
    success: (data) ->
      $('#new-transaction').html(data)
      $('#new-transaction').modal('show')
    error: (e) ->
      console.log e
      alert("An error occurred. Please notify support.") 

$(document).on "click", "#issue_refund", ->
  $('#take-refund').modal('toggle')

$(document).on "click", "#new_transaction", (event) ->
  event.preventDefault()
  $("#new_transaction_modal").modal('toggle')

$(document).on "click", ".btn-refund", ->
  $('#amount-refund').val $(this).attr('amount')
  $('#trans-id-refund').val $(this).attr('trans_id')
  $("#ph_refund").modal('toggle')

$(document).on "click", ".btn-settle", ->
  $('#amount-settle').val $(this).attr('amount')
  $('#trans-id-settle').val $(this).attr('trans_id')
  $("#ph_settle").modal('toggle')

$(document).on "click", ".btn-void", ->
  $('#trans-id-void').val $(this).attr('trans_id')
  $("#ph_void").modal('toggle')

$(document).on "change", ".radio-fee", ->
  is_fixed = $('input[name="vendor[is_fixed]"]:checked').val()
  if is_fixed == "true"
    $('#fixed-amt input').removeAttr('disabled')
    $('#fixed-amt').show()
    $('#percent-amt input').attr('disabled', 'disabled')
    $('#percent-amt').hide()
  else
    $('#percent-amt input').removeAttr('disabled')
    $('#percent-amt').show()
    $('#vendor_fee_percent').val('10')
    $('#vendor_cap').val('100')
    $('#fixed-amt input').attr('disabled', 'disabled')
    $('#fixed-amt').hide()

$(document).on "click", "#add-payment-card", ->
  $('.new-card-form').modal('show')

$(document).on "click", ".mtg_updated", ->
  $($(this).attr("data-target")).modal('show')

$(document).on "click", ".refresh_documents", ->
  $.ajax
    type: "GET"
    url: $(this).attr('data-url')
    success: (data) ->
      $(".refresh_document").html(data)
    error: (e) ->
      console.log e
      alert("An error occurred. Please notify support.")
    beforeSend: ->
      $(".refresh_document").html("<div class='well white'><center><img src='/assets/ajax-loader.gif' style='align:center'/></center></div>")
