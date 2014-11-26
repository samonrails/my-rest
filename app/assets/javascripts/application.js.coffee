#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap
#= require underscore-min
#= require underscore-string.min
#= require backbone-min
#= require select2
#= require bootstrap-datetimepicker
#= require bootbox.min
#= require bootstrap-multiselect
#= require bootstrap-tooltip
#= require recurring_select
#= require jquery-fileupload/basic
#= require jquery-fileupload/vendor/tmpl
#= require jquery.infinitescroll
#= require jquery.ui.core
#= require jquery.ui.widget
#= require jquery.ui.mouse
#= require jquery.ui.position
#= require jquery.ui.draggable
#= require jquery.ui.droppable
#= require jquery.ui.sortable
#= require jquery.raty
#= require jquery.tablesorter
#= require jquery.validate.min
#= require jQRangeSlider-min
#= require highcharts
#= require highcharts/highcharts-more
#= require handlebars

# Kicks aff the global Backbone Application
#= require shared/app

#= require_tree ./shared
#= require_tree ./helpers
#= require_tree ./vendors
#= require_tree ./accounts
#= require_tree ./events
#= require_tree ./select_events
#= require_tree ./select_event_schedules
#= require_tree ./select_orders
#= require_tree ./billing_references
#= require_tree ./admin
#= require_self

$.ajaxSetup
  headers:
    'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')

$ ->
  # Clear shared modal if triggered more than once on a page load.
  $('#app-modal').on 'hidden', -> $(this).removeData('modal')

  $("*").on "ajax:beforeSend", (e, xhr, settings)->
    xhr.setRequestHeader("X-CSRF-Token", $('meta[name="csrf-token"]').attr('content'))

  $(Application.onReady)
