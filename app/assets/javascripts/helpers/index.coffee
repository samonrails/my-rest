Application.configureBootstrapBehaviors = ()->
  $('.alert-container .close').on "click", ()->
    $(@).parents('.alert-container').fadeOut()

  $('.toggle-modal[data-target]').on "click", (e)->
    button        = $(e.target)
    modalElement  = $(button.data('target'))
    modalElement.modal('show')


Application.successMessage = (displayInElement, message="Success", clearAfterDelay=25000)->
  $(displayInElement).prepend "<div class='alert-container'><div class='alert alert-success'>#{ message }</div></div>"
  box = $(".alert-container", displayInElement)
  box.fadeOut(2400)

# Helper for requesting content from a URL and then doing something
# with the response.  Chainable like:
#
# Application.request("/vendors/1.html?partial=table_row").andAppendTo(domElement)
Application.request = (url, options={})->
  performRequest = (handler, domElement)->
    ajaxOptions =
      url: url
      type: "GET"
      success: (response)->
        $(domElement)[handler](response)

    _.extend(ajaxOptions, options)

    $.ajax(ajaxOptions)

  chain =
    andAppendTo: (domElement)->
      performRequest("append", domElement)

    andPrependTo: (domElement)->
      performRequest("prepend", domElement)

    # Replaces the HTML of domElement with whatever is returned
    andUpdate: (domElement)->
      performRequest("html", domElement)

# helper for taking a standard active record error object
# and rendering it somewhere in the DOM.  Returns an
Application.displayModelErrors = (errorData, options={})->
  {model} = options

  if _.isString(errorData)
    errorData = JSON.parse(_.unescape(errorData))

  chain =
    in: (domElement)->
      $('.error-messages', domElement).remove()

      domElement.prepend("<ul class='error-messages' />")
      list = $('ul.error-messages', domElement)

      for field, messages of errorData
        for message in messages
          list.append("<li>#{ messages}</li>")


    onForm: (formElement)->
      for field, messages of errorData
        Application.forms.applyErrorStateTo("#{ model }_#{ field }", messages)
