Application.DashboardDetails = Backbone.View.extend
  events:
    "click #section-tab-navigation a" : "selectTab"

  initialize: ()->
    @setElement $('#admin-details')

    _.bindAll @, "selectTab"

    @delegateEvents()

  selectTab: (e)->
    e.preventDefault()

    target = @$(e.target)
    target.tab('show')

    @$('.section-tab').hide()
    @$(".section-tab#{ target.attr('href') }").show()


Application.dashboard = ()->

Application.dashboard.index = ()->
  window.dashboardDetails = new Application.DashboardDetails()


# ------------------- Fetch Vouchers -------------------

$(document).on "click", "#search_vouchers", (event) ->
  event.preventDefault()
  $form = $("#search_vouchers_form form")
  valuesToSubmit = $form.serialize()
  $.ajax
    type: "GET"
    url: $form.attr("action")
    data: valuesToSubmit
    success: (data) ->
      $('#voucher_lists').html(data)
      $('#message_area').html($('.message_area_content').html())
    error: (e) ->
      alert "error occured"
    beforeSend: ->
      $("#voucher_lists").html("<div class='well white'><center><img src='/assets/ajax-loader.gif' style='align:center'/></center></div>")
  false

$(document).on "click", "#redeem_all_vouchers", (event) ->
  event.preventDefault()
  $form = $("#voucher_lists form")
  valuesToSubmit = $form.serialize()
  $.ajax
    type: "PUT"
    url: $form.attr("action")
    data: valuesToSubmit
    success: (data) ->
      $('#voucher_lists').html(data)
      $('#message_area').html($('.message_area_content').html())
    error: (e) ->
      alert "error occured"
  false

$(document).on "click", ".redeem_voucher_btn", (event) ->
  event.preventDefault()
  valuesToSubmit = $("#voucher_lists form").serialize()
  $.ajax
    type: "PUT"
    url: $(this).attr("data-url")
    data: valuesToSubmit
    success: (data) ->
      $('#voucher_lists').html(data)
      $('#message_area').html($('.message_area_content').html())
   error: (e) ->
     alert "error occured"
  false

$(document).on "change", "#voucher_ids", (event) ->
  if $(this).val().length is 0
    $('.search_vouchers').addClass("disabled")
    $('.search_vouchers').attr('id', '')
  else
    $('.search_vouchers').removeClass("disabled")
    $('.search_vouchers').attr('id', 'search_vouchers')
# ------------------------------------------------------
