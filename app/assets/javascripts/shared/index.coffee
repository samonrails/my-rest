$ ->
  # ------------------- Menu Templates -------------------

  $("#menu_template_pricing_type").on "change", ->
    if $('#menu_template_pricing_type').val() == 'menu_level'
      $(".js-hide-show").show()
      $(".average-sell-price-hide-show").hide()
      $(".menu_template_min_quantity").show()
    else if $('#menu_template_pricing_type').val() == 'item_level'
      $(".average-sell-price-hide-show").show()
      $(".js-hide-show").hide()
      $(".menu_template_min_quantity").hide()
    else
      $(".average-sell-price-hide-show").hide()
      $(".js-hide-show").hide()
      $(".menu_template_min_quantity").hide()

  $("#menu_template_product_type").on "change", ->
    if $('#menu_template_product_type').val() == 'managed_services'
      $(".checkbox-hide-show").show()
    else
      $(".checkbox-hide-show").hide()
      $("#menu_template_is_eligible_for_self_service").attr "checked",false

    if $('#menu_template_product_type').val() == 'perks' or $('#menu_template_product_type').val() == 'select'
      $(".checkbox-hide-show-is_default").show()
    else
      $(".checkbox-hide-show-is_default").hide()
      $("#menu_template_is_default").attr "checked",false


  $("#menu_template_pricing_type").trigger('change')

  # ------------------- Dynamically adding nested fields -------------------

  $(document).on 'click', 'form .remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    fieldset = $(this).closest('fieldset')
    fieldset.hide()
    fieldset.find('._destroy').val('true')
    event.preventDefault()

  $(document).on 'click', 'form .add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    if $(this).data("insertion-point")?
      $($(this).data("insertion-point")).append($(this).data('fields').replace(regexp, time))
    else
      $(this).before($(this).data('fields').replace(regexp, time))

    event.preventDefault()

  # ------------------- Deprecated? -------------------

  $ ->
  menus = $('#menu_template_id').html()
  $('#event_vendor_id').change ->
    vendor = $('#event_vendor_id :selected').text()
    options = $(menus).filter("optgroup[label='#{vendor}']").html()
    console.log(options)
    if options
      $('.js-event-toggle-menu').show()
      $('#event_menu_id').html(options)
    else
      $('#event_menu_id').empty()

  # ------------------- Locations -------------------

  $('#location_location_type').on 'change', ->
    location_type = $('#location_location_type :selected').text()
    $('.js-event-toggle-location-type').show()
    if location_type == 'Spot'
      $('.js-event-toggle-location-type-delivery').hide()
      $('.js-event-toggle-location-type-spot').show()
    if location_type == 'Delivery'
      $('.js-event-toggle-location-type-spot').hide()
      $('.js-event-toggle-location-type-delivery').show()
    if location_type == 'Location Type'
      $('.js-event-toggle-location-type').hide()
      $('.js-event-toggle-location-type-spot').hide()
      $('.js-event-toggle-location-type-delivery').hide()

  $('#location_building_id').on 'change', ->
      building_id = $('#location_building_id :selected').val()
      callback = (response) ->
        $('#building_html_address').html(response.building)
      $.get '/admin/buildings/'+String(building_id), {}, callback, "json"

  $('#toggle_user_new_building_new_location').on 'click', ->
    $('#user_new_building_new_location').show()
    $('#toggle_user_new_building_new_location').hide()

  # ------------------- Event Creation -------------------

  # Have to refactor into a function

  $('#select_event_account_id').on 'change', ->
      callback = (response) ->

        $el = $("#select_event_location_id")
        $el.empty()
        $.each response.locations, (index, location) ->
          $el.append $("<option></option>").attr("value", location.id).text(location.name)

        $el = $("#select_event_contact_id")
        $el.empty()
        $.each response.contacts, (index, contact) ->
          $el.append $("<option></option>").attr("value", contact.id).text(contact.name)

        $("#select_event_location_id").trigger("change")

      $.get '/accounts/'+$('#select_event_account_id :selected').val(), {}, callback, "json"


  $('#select_event_location_id').on 'change', ->

      $.get '/accounts/'+$('#select_event_account_id :selected').val() + '/locations/'+$('#select_event_location_id :selected').val(), {}, callback, "json"


  $('#event_account_id').on 'change', ->
      callback = (response) ->

        $el = $("#event_location_id")
        $el.empty()
        $.each response.locations, (index, location) ->
          $el.append $("<option></option>").attr("value", location.id).text(location.name)

        $el = $("#event_contact_id")
        $el.empty()
        $.each response.contacts, (index, contact) ->
          $el.append $("<option></option>").attr("value", contact.id).text(contact.name)

        $("#event_location_id").trigger("change")

      $.get '/accounts/'+$('#event_account_id :selected').val(), {}, callback, "json"

  $('#event_location_id').on 'change', ->
      callback = (response) ->

        if $("#event_quantity").val() == "0"
          if response.location_type == "spot"
            $("#event_quantity").val(response.expected_participation)
          else
            $("#event_quantity").val(0)

      $.get '/accounts/'+$('#event_account_id :selected').val() + '/locations/'+$('#event_location_id :selected').val(), {}, callback, "json"


  # ------------------- Event Vendors -------------------

  $(document).on 'change', '#event_vendor_cuisine', (event) ->
      cuisine = $('#event_vendor_cuisine :selected').val()

      callback = (response) ->
        $el = $("#event_vendor_vendor")
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

       $.get '/vendors/get_vendors_by_cuisine_and_product_and_market_and_account?cuisine='+cuisine+'&product='+$('#event_vendor_product').val()+'&market='+$('#event_vendor_market').val()+'&account_id='+$('#event_vendor_account_id').val(), {}, callback, "json"
  

   $('#event_vendor_vendor').on 'change', ->
    vendor_id = $('#event_vendor_vendor :selected').val()
    unless vendor_id?
      $el = $("#event_vendor_menu_template")
      $el.empty()
    else
      callback = (response) ->
        $el = $("#event_vendor_menu_template")
        $el.empty()
        $.each response, (index, menu_template) ->
          $el.append $("<option></option>").attr("value", menu_template.id).text(menu_template.name)
      $.get '/vendors/'+vendor_id+'/get_vendor_menu_templates_by_product?product='+$('#event_vendor_product').val(), {}, callback, "json"

  
  # ------------------- Event Schedule -------------------

  getVendorsForEventSchedule = ->
    callback = (response) ->
      $el = $("#event_schedule_vendor_id")
      $el.empty()
      $el.append $("<option></option>")
      for k,v of response
        $newelement = $("<optgroup>");
        $el.append $newelement.attr("label", k)
        $.each v, (index, vendor) ->
          $optionElement = $("<option></option>")
          $optionElement.attr("value", vendor.id).text(vendor.name)
          $optionElement.appendTo $newelement
      $el.trigger("change")

    $.get '/vendors/get_vendors_by_cuisine_and_product_and_location_and_account?cuisine=Any&product='+$('#event_schedule_product :selected').val()+'&location='+$('#event_schedule_location_id :selected').val()+'&account_id='+$('#event_schedule_account_id').val(), {}, callback, "json"


  $('#event_schedule_location_id').on 'change', ->
    getVendorsForEventSchedule()

  $('#event_schedule_product').on 'change', ->
    getVendorsForEventSchedule()

  $('#event_schedule_vendor_id').on 'change', ->
    vendor_id = $('#event_schedule_vendor_id :selected').val()
    unless vendor_id?
      $el = $("#event_schedule_menu_template_id")
      $el.empty()
    else
      callback = (response) ->
        $el = $("#event_schedule_menu_template_id")
        $el.empty()
        $.each response, (index, menu_template) ->
          $el.append $("<option></option>").attr("value", menu_template.id).text(menu_template.name)
      $.get '/vendors/'+vendor_id+'/get_vendor_menu_templates', {}, callback, "json"

  # ------------------- Line Items -------------------

  $('.line_item_type_id').on 'change', ->
    line_item_type = $('option:selected', this).text()

    if line_item_type == "Menu-Fee"
      $('.js-menu-fee-message').show()
      $('.js-non-menu-fee-data').hide()
    else
      $('.js-menu-fee-message').hide()
      $('.js-non-menu-fee-data').show()

    if line_item_type.toLowerCase().indexOf('tax') != -1
      $( '#line_item_tax_rate_expense_'.concat($(this).attr("unique-id"))).val(0)
      $( '#line_item_tax_rate_revenue_'.concat($(this).attr("unique-id"))).val(0)


  $('.line_item_percentage_of_subtotal').on 'change', ->
    if $(this).is(':checked')
      $('#line_item_after_subtotal_'.concat($(this).attr("unique-id"))).prop('checked', true);

  $('.line_item_after_subtotal').on 'change', ->
    if !$(this).is(':checked')
      $('#line_item_percentage_of_subtotal_'.concat($(this).attr("unique-id"))).prop('checked', false);

  # ------------------- Event Financials Transaction Method -------------------

  $('#transaction_method').on 'change', ->
    payment_method = $('#transaction_method :selected').text()
    if payment_method == 'CC'
      $('.js-transaction-method-toggle-extra-info').show()
    else
      $('.js-transaction-method-toggle-extra-info').hide()

  # ------------------- Modal Initialization -------------------

  realWidth = (obj) ->
    clone = obj.clone()
    clone.css("visibility", "hidden")
    $("body").append(clone)
    width = clone.outerWidth()
    clone.remove()
    width

  $(".auto_size_modal").modal(
    show: false
    backdrop: true
    keyboard: true
  ).css
    width: "auto"
    height: "auto"

    "margin-left": ->
      -(realWidth($(this))/2)

  # The following numbers should probably be extracted from CSS, but they'll
  # be hardcoded for now.
  # 50: Header height+padding
  # 60: Bottom height+padding
  # 15: Additional bottom padding
  # 30: Body padding

  $(".auto_size_modal_body").css
    "max-height": ($(window).height()*0.8 - (50+60+15+30))

  # ------------------- DateTimePicker -------------------

  $(".form_datetime").datetimepicker
    format: "dd MM yyyy - HH:ii P"
    showMeridian: true
    autoclose: true
    todayBtn: true
    showOnTextFieldClick: false

  $(".form_date").datetimepicker
    format: "dd MM yyyy"
    showMeridian: true
    autoclose: true
    todayBtn: true
    showOnTextFieldClick: false
    dateOnly: true

  $(".form_date-start").datetimepicker
    format: "dd MM yyyy - HH:ii P"
    showMeridian: true
    autoclose: true
    todayBtn: true
    showOnTextFieldClick: false
    dateOnly: true

  $(".form_date-end").datetimepicker
    format: "dd MM yyyy - HH:ii P"
    showMeridian: true
    autoclose: true
    todayBtn: true
    showOnTextFieldClick: false
    dateOnly: true

  $(".form_time").datetimepicker
    format: "HH:ii P"
    showMeridian: true
    autoclose: true
    todayBtn: true
    showOnTextFieldClick: false
    timeOnly: true

  # ------------------- Confirm Dialog -------------------
  # http://stackoverflow.com/questions/14192009/how-can-i-display-delete-confirm-dialog-with-bootstraps-modal-not-like-brows

  $.rails.allowAction = (link) ->
    return true unless link.attr('data-confirm')
    $.rails.showConfirmDialog(link) # look below for implementations
    false # always stops the action since code runs asynchronously

  $.rails.confirmed = (link) ->
    link.removeAttr('data-confirm')
    link.trigger('click.rails')

  $.rails.showConfirmDialog = (link) ->
    message = link.attr 'data-confirm'
    html = """
           <div class="modal" id="confirmationDialog">
             <div class="modal-header">
               <a class="close" data-dismiss="modal">×</a>
               <h3>#{message}</h3>
             </div>
             <div class="modal-footer">
               <a data-dismiss="modal" class="btn">Cancel</a>
               <a data-dismiss="modal" class="btn btn-primary confirm">OK</a>
             </div>
           </div>
           """
    $(html).modal()
    $('#confirmationDialog .confirm').on 'click', -> $.rails.confirmed(link)

  # ------------------- Multi-select -------------------
  ->
  $(".multiselect").multiselect
    visible: true
    buttonClass: "btn"
    buttonWidth: 250
    buttonContainer: "<div class=\"btn-group\" />"
    maxHeight: false
    buttonText: (options) ->
      if options.length is 0
        "None selected <b class=\"caret\"></b>"
      else if options.length > 2
        options.length + " selected  <b class=\"caret\"></b>"
      else
        selected = ""
        options.each ->
          selected += $(this).text() + ", "

        selected.substr(0, selected.length - 2) + " <b class=\"caret\"></b>"

  # ------------------- SSP Persistence -------------------
  $(".ssp_persistence_update").click ->
    $("#ssp_persistence_action").val("update")
    $("#ssp_persistence_id").val($(this).data("ssp_persistence_id"))
    $("#ssp_form").submit()

  $(".ssp_persistence_delete").click ->
    $("#ssp_persistence_action").val("delete")
    $("#ssp_persistence_id").val($(this).data("ssp_persistence_id"))
    $("#ssp_form").submit()

  $("#ssp_persistence_add").click ->
    $("#ssp_persistence_action").val("add")
    $("#ssp_persistence_name").val($(this).data("ssp_persistence_name"))
    $("#ssp_persistence_type").val($(this).data("ssp_persistence_type"))
    $("#ssp_form").submit()


  # ------------------- Event Cancellation Reason -------------------

  $('#event_status').on 'change', ->
    event_status = $('#event_status :selected').text()
    if event_status == 'Canceled'
      $('.js-event-cancellation-reason').show()
    else
      $('.js-event-cancellation-reason').hide()

  # ------------------- Inventory Items Options -------------------

  $('.inventory_item_option_quantity').on 'change', ->
    row = $(this).closest('.row')

    max = row.find('[name="max_options"]').val()
    required = row.find('[name="required_options"]').val()

    quantities = row.find('.inventory_item_option_quantity')

    new_quantity = 0
    $.each quantities, (index, qty) ->
      new_quantity += parseInt($('option:selected', qty).text(), 10)

    quantities.css("background-color","");

    if (new_quantity > max)
      $(this).find('option:selected').removeAttr('selected');
      $('option[value="0"]', this).attr('selected', true)
      $(this).css("background-color","yellow");

  # ------------------------- Assets -------------------------

  $(document).on 'click', ".remove-asset", (event) ->
    event.preventDefault()
    $remove_btn = $(this)
    $element = $(this).parent()
    $checked = $(this).siblings("input").prop("checked")
    $.ajax
      async: false
      type: "DELETE"
      url: $(this).attr("href")
      dataType: "json"
      contentType: "application/json; charset=utf-8"
      success: ->
        $remove_btn.removeClass("disabled")
        $element.fadeOut ->
          $element.remove()
        $next_default = $('.set-default-image').first()
        if $checked is true and $('.set-default-image').length > 1
          if $remove_btn.attr('href') isnt $next_default.parent().find('a').attr('href')
            $next_default.prop "checked",true
            $next_default.trigger('change')
          else
            $next_default.parent().next().find('.set-default-image').prop "checked",true
            $next_default.parent().next().find('.set-default-image').trigger('change')
      error: (e) ->
        $remove_btn.removeClass("disabled")
        alert "error"

      beforeSend: ->
        $remove_btn.addClass("disabled")

  $('#new_asset').fileupload
    dataType: "script"
    add: (e, data) ->
      data.context = $(tmpl("template-upload", data.files[0]).trim())
      $('#add_new_image').append(data.context)
      data.submit()
    progress: (e,data) ->
      if data.context
        progress =  parseInt(data.loaded/data.total *100, 10)
        data.context.find('.bar').css('width', progress + '%')
        data.context.find('#upload_status').text(progress + '% completed')
    error: (e,data) ->
      alert "Error Occured In Uploading Image"
      $(this).fadeOut()


  $(document).on 'change', '.set-default-image', (event) ->
    $radio = $(this)
    event.preventDefault()
    path = $(this).parent().find('a').attr('href')
    value = $(this).prop('checked') ? 1 : 0
    $.ajax
      type: "PUT"
      url: path + '/set_default'
      data: '{"asset" : { "is_default" : "' + value + '"} }'
      dataType: "json"
      contentType: "application/json; charset=utf-8"
      success: ->
        $radio.attr('checked', true)
      error: ->
        $radio.attr('checked', false)
        alert("error")

  $(document).on "click", "#save-bio-btn", (event) ->
    $form = $("#edit-bio form")
    valuesToSubmit = $form.serialize()
    $btnToChange = $(this)
    $.ajax
      type: "PUT"
      url: $form.attr("action")
      data: valuesToSubmit
      dataType: "script"
      success: (data) ->
        $('#profile').load location.href + " #edit-bio"
      error: (e) ->
        alert("error")

  $(document).on "click", "#edit-bio-btn", (event) ->
    $('#vendor_website').removeAttr('disabled')
    $('#vendor_bio').removeAttr('disabled')
    $('#vendor_yelp_id').removeAttr('disabled')
    $(this).text('Save')
    $(this).attr('id', 'save-bio-btn')

  fileupload_call = (fileupload) ->
    $("."+fileupload).fileupload
      replaceFileInput: false
      add: (e, data) ->
        params_name = $('#file-fields input').attr "name"
        $('#file-fields input').removeClass "active"
        $('#file-fields input').appendTo("#hidden-fields")
        $("#file-fields").append("<input type='file' class='active' name="+params_name+" multiple='multiple'>")
        fileupload_call "active"
        $.each data.files, (index, file) ->
          file_size = Math.round(file.size / 1024 * 100) / 100
          oFReader = new FileReader()
          oFReader.readAsDataURL file
          oFReader.onload = (oFREvent) ->
            $("#uploadFilesBox").append($("<tr><td></td><td><img src=" + oFREvent.target.result + " style='width: 50px; height: 50px;'/></td><td>" + file.name + "</td><td>"+ file_size + " KB</td></tr>"))

  fileupload_call "active"

  # ------------------------- Infinite Scroll -------------------------

  $("#infinite_items").infinitescroll
    navSelector: ".pagination" # selector for the paged navigation (it will be hidden)
    nextSelector: ".pagination a[rel=next]" # selector for the NEXT link (to page 2)
    itemSelector: "#infinite_items tr.infinite_item" # selector for all items you'll retrieve

  # ------------------- Account Finance -------------------

  $("#account_credit_status").on "change", (event)->
    event.preventDefault()
    value = $(this).val()
    $(this).addClass('disabled')
    if value is "on_account"
      $(".credit-limit-hide-show").show()
      $("#account_credit_status").attr "value", value
      $("#prepay").removeClass('disabled')
    else
      $(".credit-limit-hide-show").hide()
      $("#account_credit_status").attr "value", value
      $("#on_account").removeClass('disabled')

  # ----------------------------Account Roles----------------------------------------------

  $(document).on "click", "#save_users", ->
    $this = $(this)
    j = 0
    k = 0
    add_users = []
    remove_users = []
    $.each $(".add-or-remove-from-account"), ->
      if @checked
        add_users[j] = $(this).attr("id")
        $(this).attr "value", $(this).attr("id")
        j++
      else
        remove_users[k] = $(this).attr("id")
        $(this).attr "name", "remove_users[]"
        $(this).attr "value", $(this).attr("id")
        k++
    $("#add_users").attr "value", add_users
    $("#remove_users").attr "value", remove_users

  $(document).on "click", "#search-parameter", ->
    account_id = $('#account_id').val()
    search_parameter = $('#search-parameter').val()
    search_string = $('#search-string').val()
    $.ajax
      type: "Get"
      url: "/accounts/"+account_id+"?search_parameter="+search_parameter+"&search_string="+search_string
      success: (data) ->
        $("#users").html data
      error: (e) ->
        alert "error"

  $("#select-search-param li a").on "click", (event) ->
    event.preventDefault()
    selText = $(this).text()
    value = $(this).attr "value"
    $(this).parents(".btn-group").find("#search-parameter").html selText
    $(this).parents(".btn-group").find("#search-parameter").attr "value", value

  # ------------------------- Upload CSV -------------------------

  $(document).on "click", "#upload_csv", (event) ->
    if $('#csv_file')[0].files.length is 0
      event.preventDefault()
      $('#error_note').html("*File field can't be blank.")
    else unless $("#csv_file")[0].files[0].name.split(".").pop() is "csv"
      event.preventDefault()
      $('#error_note').html("*Filename is invalid, only CSV file is allowed.")

  # ---------------------------- Rating and Reviews----------------------------------------------

  $(".star").raty
    width: 150
    targetType: 'number'
    score: ->
      $(this).attr "data-rating"
    number: 5
    path: "/assets/"
    hints: ['poor', 'fair', 'average', 'good', 'excellent']
    scoreName: ->
      $(this).attr "data-name"

  call_raty = () ->
    $(".inventory_rating").raty
      width: 100
      targetType: 'number'
      score: ->
        $(this).attr "data-rating"
      readOnly: true
      number: 5
      path: "/assets/"
      hints: ['poor', 'fair', 'average', 'good', 'excellent']

  call_raty()

  call_tablesorter = () ->
    $(".Grid").tablesorter()

  call_tablesorter()

  $(document).on "click", ".trigger-link", ->

    # set sorting column and direction, this will sort on the date and rating basis
    sorting = [ [ $(this).attr("data-column"), $(this).attr("data-order") ] ]

    $("#Grid#{$(this).attr "data-index"}").trigger "sorton", [ sorting ]

    # return false to stop default link action
    false

  $(".btn-set-vendor").click ->
    $(".div_charts").hide()
    $(".div_admin_charts").hide()
    $(".btn-set-vendor").removeClass("btn-primary")
    $(this).addClass("btn-primary")
    $(".category_#{$(this).attr "id"}").show();
    $("#Presentation_#{$(this).attr "id"}").trigger("click");
    $("#refresh_#{$(this).attr "id"}_Event").trigger("click");

  $(".btn-set-gratuity").click ->
      $(".btn-set-gratuity").removeClass("btn-primary")
      $('#gratuity_payer_hidden').val( $(this).val() );
      $(this).addClass("btn-primary")

  $(".btn-set-tax").click ->
      $(".btn-set-tax").removeClass("btn-primary")
      $('#tax_payer_hidden').val( $(this).val() );
      $(this).addClass("btn-primary")

  $(".btn-set-delivery").click ->
      $(".btn-set-delivery").removeClass("btn-primary")
      $('#select_event[subsidy_payer_hidden]').val( $(this).val() );
      $('#delivery_fee_payer_hidden').val( $(this).val() );
      $(this).addClass("btn-primary")

  $(".btn-set-subsidy").click ->
      $(".btn-set-subsidy").removeClass("btn-primary")

      if ( $(this).val() == 'percentage' )
          $("#cap_options_for_percentage").show()
          $('#subsidy_fixed_amount_option').hide()
      else if ( $(this).val() == 'fixed_amount' )
          $("#cap_options_for_percentage").hide();
          $('#subsidy_fixed_amount_option').show();
      else
          $("#cap_options_for_percentage").hide()
          $('#subsidy_fixed_amount_option').hide();

      if ( $(this).val() != 'none' )
          $("#minimum_user_contribution").show()
      else
          $("#minimum_user_contribution").hide()
                
      $('#subsidy_payer_hidden').val( $(this).val() );
      $(this).addClass("btn-primary")

  $("#select_event_is_subsidy_percentage_capped_false").click ->
      $("#subsidy_percentage_fixed_amount_cap_span").hide()

  $("#select_event_is_subsidy_percentage_capped_true").click ->
      $("#subsidy_percentage_fixed_amount_cap_span").show()

  $("#select_event_schedule_is_subsidy_percentage_capped_false").click ->
      $("#subsidy_percentage_fixed_amount_cap_span").hide()

  $("#select_event_schedule_is_subsidy_percentage_capped_true").click ->
      $("#subsidy_percentage_fixed_amount_cap_span").show()

  $("#user_contribution_cents").change -> 
    user_contribution_cents = parseInt($("#user_contribution_cents").val() )
    if user_contribution_cents > 0 
      $("#user_contribution_checkbox").attr "checked",true
    else
      $("#user_contribution_checkbox").attr "checked",false

  $("#user_contribution_checkbox").click ->
    if !$(this).is(':checked')
      $("#user_contribution_cents").val(0)
      $("#user_contribution_div").hide()
    else
      $("#user_contribution_div").show()
      
  $(document).on "click", ".reviews_tab", ->
    $("#managed_services").trigger("click");

  $(document).on "click", ".admin_reviews_tab", ->
    $("#Presentation_managed_services").trigger("click");

  $(".btn-set-event").click ->
    $(".div_charts").hide()
    $(".btn-set-event").removeClass("btn-primary")
    $(this).addClass("btn-primary")
    $(".#{$(this).attr "id"}").show();
    $(".#{$(this).attr "id"}_refresh").trigger("click");

  $(".bar_graph_title").click ->
    div_charts = $(".barcharts_"+$(this).attr('data-product'))
    current_chart = $("#barchart"+$(this).attr('data-index'))
    a = 0
    while a < div_charts.length
      chart_obj = $("#" + div_charts[a].id).highcharts()
      chart_obj.chartBackground.css color: "#FFFFFF"
      i = 0
      while i < 4
        chart_obj.series[0].data[i].update
          borderColor: null,
          true,
          false
        i++
      a++
    unless current_chart.length is 0
      $("#barchart"+$(this).attr('data-index')).highcharts().chartBackground.css color: "#FCFFC5"
    href = $(this).attr('href')
    if href.length > 1
      $.fetch_reviews_data(href, $(this).attr('data-product'))
    false

  $(".admin_bar_graph_title").click ->
    $.fetch_reviews_data($(this).attr('href'), $(this).attr('data-level'));
    current_chart = $("#barchart#{$(this).attr('data-index')}_#{$(this).attr('data-product')}")
    unless current_chart.length is 0
      chart_obj = current_chart.highcharts()
      i = 0
      while i < 4
        chart_obj.series[0].data[i].update
          borderColor: null,
          true,
          false
        i++
    false

  $.change_params = (url, params, i) ->
    url = url
    url = (if url.match(/\?/) then url else url + "?")
    for key of params
      re = RegExp(";?" + key + "=?[^&;]*", "g")
      url = url.replace(re, "")
      url += ";" + key + "=" + params[key]

    # cleanup url
    url = url.replace(/[;&]$/, "")
    url = url.replace(/\?[;&]/, "?")
    url = url.replace(/[;&]{2}/g, ";")

    $(".export#{i}").attr('href', url);

  $.fetch_reviews_data = (url, product_type) ->
    $.ajax
      type: "GET"
      url: url
      success: (data) ->
        $("#data_pane_#{product_type}").html(data);
        call_raty()
        call_tablesorter()
      error: (e) ->
        alert("error")
      beforeSend: ->
        $("#data_pane_#{product_type}").html("<img src='/assets/loaddata.gif' width='400px' style='float:right;margin-top:40px'/>")
    false

  $.validate_form = () ->
    $.validator.addClassRules({
      cc_number:  { required: true, digits: true, minlength: 15, maxlength: 16},
      cc_cvv:     { required: true, digits: true, minlength: 3, maxlength: 4}
    })
    $('.jqvalidate').validate({
      ignore: ".jqvalidate_ignore"
      errorClass: "invalid"

    })
