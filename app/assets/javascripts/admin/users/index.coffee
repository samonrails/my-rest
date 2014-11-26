Application.UsersDetails = Backbone.View.extend
  events:
    "click #section-tab-navigation a" : "selectTab"

  initialize: ()->
    @setElement $('#users-details')

    _.bindAll @, "selectTab"

    @delegateEvents()

  selectTab: (e)->
    e.preventDefault()

    target = @$(e.target)
    target.tab('show')

    @$('.section-tab').hide()
    @$(".section-tab#{ target.attr('href') }").show()


Application.users = ()->

Application.users.index = ()->
  window.usersDetails = new Application.UsersDetails()
