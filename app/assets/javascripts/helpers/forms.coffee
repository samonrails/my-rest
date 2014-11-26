Application.forms ||= {}

# Clears the error state and values of
# all of the control groups nested under
# the passed formElement
Application.forms.clear = (formElement)->
  inputElements           = $('.control-group :input', formElement)
  existingErrorMessaging  = $('.control-group.error .controls .error-message', formElement)

  existingErrorMessaging.remove()
  inputElements.val('')

  # One Suggestion
  #
  # $('.control-group :input', formElement).each ()->
  #   switch @type
  #     when 'password'
  #     when 'select-multiple'
  #     when 'select-one'
  #     when 'text'
  #       $(@).val('')
  #     when 'textarea'
  #       $(@).val('')
  #     when 'checkbox'
  #       $(@).prop('checked', false)
  #     when 'radio'
  #       $(@).prop('checked', false)

Application.forms.removeErrorStateFrom = (controlGroup)->
  controlGroupElement = $(".control-group.#{ controlGroup }")
  inputWrapper        = $(".controls", controlGroupElement)
  existingMessaging   = $('.error-message', inputWrapper)

  controlGroupElement.removeClass(stateClass) for stateClass in ['error','info','warning','success']
  existingMessaging.remove()

# Applies error state and optional messages to the passed
# control group
Application.forms.applyErrorStateTo = (controlGroup, messages)->
  controlGroupElement = $(".control-group.#{ controlGroup }")
  inputWrapper        = $(".controls", controlGroupElement)
  existingMessaging   = $('.error-message', inputWrapper)
  formElement         = $(':input', inputWrapper)

  Application.forms.removeErrorStateFrom(controlGroup)

  controlGroupElement.addClass('error')

  # let the user correct their error
  formElement.on "change", ()-> Application.forms.removeErrorStateFrom(controlGroup)

  for message in messages
    inputWrapper.append "<span class='error-message help-inline'>#{ message }</span>"

# H