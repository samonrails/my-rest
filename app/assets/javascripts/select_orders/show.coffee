Application.SelectOrderDetails = Backbone.View.extend
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


Application.select_orders.show = ()->
  window.selectOrderDetails = new Application.SelectOrderDetails()

  $('#select_order_item_inventory_item_id').attr('disabled', true)
  $("#add_menu_item_btn").attr("disabled", "disabled")

  Application.select_orders.controlSubmissionButton()

  $('#cancel_select_order').click (e)->
    if !confirm $(this).attr('message')
      e.preventDefault()

  $('.new-select-order-transaction').click (e)->
    url = $(this).attr('url')
    #url = $('#new-transaction-form').attr('url')
    # Fetch the appropriate transaction form (payment, refund or no transaction)
    $('#new-transaction-form').empty().load url, ->
      Application.select_orders.controlNewPaymentButtons()
      # On submission, encrypt sensitive fields (card, cvv)
      $('#select_order_transaction').submit (e)->
        $('#submit-transaction').val('Please wait...').attr('disabled', true).addClass('disabled')
        braintree = Braintree.create(Application.select_orders.data.cse_key)
        $(this).find(':input').each (index, elem) ->
          encrypt = $(elem).attr('encrypt')
          if encrypt isnt undefined
            val = $(elem).val()
            encrypted_val = braintree.encrypt(val)
            $('#' + encrypt).val(encrypted_val)
            $(elem).val(val.replace(/[0-9]/g,'*'))
          return
        return
      # Hide/show payment options visibility
      $('#select_order_transaction_is_refund').click ->
        if $(this).prop('checked')
          $('.payment-options-visibility').addClass('hidden')
          $('.refund-options-visibility').removeClass('hidden')
        else
          $('.payment-options-visibility').removeClass('hidden')
          $('.refund-options-visibility').addClass('hidden')
        return

  # new vendor selected on add menu item modal
  # --------------------------------------------------------------------------
  $('#select_order_item_vendor_id').change (e)->
    vendor_id = parseInt($(this).val())
    if Application.select_orders.data.inventory_items[vendor_id] isnt undefined
      vendor_options = '<option value="0">-- Choose an Inventory Item --</option>'
      $.each Application.select_orders.data.inventory_items[vendor_id], (id, name)->
        vendor_options += '<option value="'+id+'">'+name+'</option>'+"\n"
      $('#select_order_item_inventory_item_id').empty().append(vendor_options).attr('disabled', false)
      Application.select_orders.sortSelectOptions '#select_order_item_inventory_item_id'
    else
      $('#select_order_item_inventory_item_id').empty().attr('disabled', true)
      $('#inventory-item-details').empty()
      Application.select_orders.setSubmissionButton $('#select_order_item_vendor_id')

  # new inventory item selected on add menu item modal
  # --------------------------------------------------------------------------
  $('#select_order_item_inventory_item_id').change (e)->
    inventory_item_id = $(this).val()
    if inventory_item_id
      $("#add_menu_item_btn").removeAttr("disabled")
      
    select_order_id = $('#select_order_item_select_order_id').val()
    $('#inventory-item-select .ajax-loader').removeClass('hidden')
    $('#inventory-item-details').load '/select/select_orders/'+select_order_id+'/new_inventory_item/'+inventory_item_id, ->
      $('#inventory-item-select .ajax-loader').addClass('hidden')
      Application.select_orders.controlSubmissionButton()
      Application.select_orders.setSubmissionButton $('#select_order_item_inventory_item_id')

    Application.select_orders.controlSubmissionButton()

Application.select_orders.controlSubmissionButton = ()->
  $('.item-qty').keyup (e)->
    Application.select_orders.setSubmissionButton $(this)
  $('.item-qty').change (e)->
    Application.select_orders.setSubmissionButton $(this)


Application.select_orders.setSubmissionButton = (e)->
  qty = parseInt(e.val())
  if (qty > 0)
    e.closest('form').find('input[type=submit]').removeClass('disabled').removeAttr('disabled')
  else
    e.closest('form').find('input[type=submit]').addClass('disabled').attr('disabled', true)

Application.select_orders.sortSelectOptions = (selectElement) ->
  options = $(selectElement + " option")
  options.sort (a, b) ->
    if a.text.toUpperCase() > b.text.toUpperCase()
      1
    else if a.text.toUpperCase() < b.text.toUpperCase()
      -1
    else
      0
  $(selectElement).empty().append options
  return

Application.select_orders.controlNewPaymentButtons = ()->
  $('#show-new-payment-method').click (e)->
    $(this).addClass('hidden')
    $('#new-payment-method-form').removeClass('hidden')
    $('#hide-new-payment-method').removeClass('hidden')
    e.preventDefault()
    return
  $('#hide-new-payment-method').click (e)->
    $(this).addClass('hidden')
    $('#new-payment-method-form').addClass('hidden')
    $('#show-new-payment-method').removeClass('hidden')
    e.preventDefault()
    return
  return


