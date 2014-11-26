# GLOBAL APPLICATION JAVASCRIPT BEHAVIOR
# --------------------------------------
# Application.onReady will get called on DOM ready for every view that gets rendered
# with the application.html.layout.  This function is responsible for
#
# 1)  Routing to any controller, and action specific javascript functions which follow
#     the naming convention
#
# 2)  Loading any global javascript functions or helpers and configuration
#
window.Application = _.extend({},Backbone.Events)

Application.onReady = ()->
  # The group function gets called on all controller actions that match group.
  # e.g. on the VendorsController#show action view that gets rendered:
  #
  # body.id = 'vendors__show'
  #         = 'select_events__show'
  [group,action] = $('body').attr('id').split('__')

  Application.trigger "before:boot"

  # The group function in this case would be Application.vendors
  # If that exists, call that function:
  Application[group]?.call?(window)

  # The specific action function would be Application.vendors.show
  # If that e function:
  Application[group]?[action]?.call?(window)

  Application.configureBootstrapBehaviors()
  Application.fields.setupCustomFields()

  Application.trigger "after:boot"

