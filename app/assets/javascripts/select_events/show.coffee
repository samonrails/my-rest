Application.SelectEventDetails = Backbone.View.extend
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
Application.select_events.show = ()->
  window.selectEventDetails = new Application.SelectEventDetails()

show_event_notification_table = (select_event_id)-> 
  
  $("#select_event_notification_table").html("<div><center><img src='/assets/ajax-loader.gif' style='align:center'/></center></div>")

  $.ajax
    type: "Get"
    url: "/select_events/" + select_event_id + "/campaign_table"
    success: (data) ->
      $("#select_event_notification_table").html data
      $("#select_event_notification_table_end").scrollTop()
      false
    error: (e) ->
      console.log e

$(document).on 'click', '#update_select_event_notification_table', (e) ->

  select_event_id = $(this).data('select_event_id')
  $("#select_event_notification_table").html ''
  $("#create_campaign_msg").html ''
  show_event_notification_table( select_event_id )
  e.preventDefault()
  false

$(document).on 'click', '#save_notification', (event) ->


  select_event_id = $("#select_event_id_for_campaign").val()
  $(this).attr("disabled", "disabled");

  $.ajax
    type: "PUT"
    url: "/select_events/" + select_event_id + "/update_campaign"
    data: $('#select_event_notification_form').serialize()
    dataType: "json"
    success: (data) ->
      $("#create_campaign_msg").html data.message
      $("#select_event_notification_table").html("<div><center><img src='/assets/ajax-loader.gif' style='align:center'/></center></div>")

      setTimeout ( -> 
        show_event_notification_table( select_event_id )
        $("#save_notification").removeAttr("disabled")
      ), 3000 

      

    error: (e) ->
      $("#create_campaign_msg").html 'Could not update the table'
      console.log "Error: " + e

  false



